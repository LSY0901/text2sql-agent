# AGENTS.md

## Build & Run

```bash
# Build (skip tests — none exist)
./mvnw clean package -DskipTests

# Compile only
./mvnw clean compile

# Run locally
./mvnw spring-boot:run

# Run packaged jar
java -jar target/firstAiDemo-0.0.1-SNAPSHOT.jar
```

## Prerequisites

- **Java 21** (`java.version=21` in pom.xml)
- **PostgreSQL** on `localhost:5432`, database `agent_db`, schema `agent`
  - User: `agent_user`, Password: `12345611`
  - Required tables: `orders`, `price_ai`, `ai_table_metadata`, `ai_column_metadata`, `vector_store`
  - **pgvector extension** required (`CREATE EXTENSION IF NOT EXISTS vector`) — auto-created by `AiChatServiceImpl.initVectorStore()`
- **Embedding service** on `localhost:8082` (model: `bge-m3-Q4_K_M.gguf`) — OpenAI-compatible API
- **Rerank service** on `localhost:8083` (model: `bge-reranker-base`)
- **LLM backend**: DeepSeek API (`https://api.deepseek.com`, model `deepseek-v4-pro`) active in `application.yml`. Ollama config commented out for local dev.

## Architecture

```
Controller (@RestController) → Service (Interface + Impl) → Tool (@Tool) / Mapper (MyBatis-Plus)
```

### Layers

- **Controller** — REST on port 8081, all under `/aiChat`
- **Service** — Business logic; see interaction patterns below
- **Tool** — Spring AI `@Tool`-annotated beans; grouped into `ToolCallback[]` beans via `ToolConfig`
- **Mapper** — MyBatis-Plus `BaseMapper` + XML mappers in `src/main/resources/mapper/`

### AI Interaction Patterns

| Pattern | Endpoint | Method | How it works |
|---------|----------|--------|-------------|
| Plain chat | `/chat` | `chat()` | LLM pass-through |
| Streaming | `/chatStream` | `chatStream()` | SSE Flux |
| Tool-augmented | `/chatRealPgData` | `chatRealPgData()` | LLM calls `OrderTool`/`PriceTool` |
| Fixed workflow | `/workFlowAiAgent` | `workFlowAiAgent()` | getSchema → LLM generates SQL → execute → return JSON |
| Autonomous agent | `/sqlAgentNotWorkFlow` | `sqlAgentNotWorkFlow()` | LLM gets `SchemaTool` + `SqlExecuteTool`, decides when to call |
| Memory chat | `/memoryChat` | `memoryChat()` | `MessageChatMemoryAdvisor` (20-message window) |
| Memory streaming | `/memoryStreamingChat` | `memoryStreamingChat()` | Memory + SSE |
| Memory + tools | `/memoryStreamingUseToolChat` | `memoryStreamingUseToolChat()` | Memory + `OrderTool` + SSE |
| **Enterprise Text2SQL** | `/enterpriseSqlAgentWorkflow` | `enterpriseSqlAgentWorkflow()` | 4-stage pipeline: discover tables → filter by question → load columns → generate+execute SQL (with retry) |
| Enterprise Text2SQL (tools) | `/enterpriseSqlAgentTools` | `enterpriseSqlAgentTools()` | LLM autonomously calls `DynamicSchemaTool`/`DynamicColumnTool`/`FilterTableByQuestionTool`/`SqlExecuteTool` |
| **RAG SQL Agent** | `/ragSqlAgent` | `ragSqlAgent()` | Vector search tables → load columns → generate SQL → execute |
| RAG Agent (tools) | `/ragAgentTools` | `ragAgentTools()` | LLM autonomously calls `ragTools` callback group |
| **RAG Rerank** | `/ragRerankWorkflow` | `ragRerankAgent()` | Vector search → load columns → rerank → generate SQL → execute |
| RAG Rerank (tools) | `/ragRerankAgentTools` | `ragRerankAgentTools()` | LLM autonomously calls `rerankTools` callback group |
| **RAG Rerank Column Stream** | `/ragRerankColumnAgentStream` | `ragRerankColumnAgentStream()` | Full pipeline with column-level rerank + SQL retry (3 attempts) + streaming natural language answer |
| Embedding store | `/embedding/store` | `embeddingStore()` | Store text as vector in `agent.vector_store` |
| Embedding search | `/embedding/search` | `embeddingSearch()` | Cosine similarity search |
| Seed embeddings | `/embedding/seedMetadata` | `seedMetadataEmbeddings()` | Re-generate all table/column embeddings |

### Key Tools

**Core SQL tools:**
- `SchemaTool` — Reads `pg_catalog`/`information_schema` for all tables in `agent` schema
- `SqlExecuteTool` — Executes SELECT via `JdbcTemplate` (validates SELECT prefix only)
- `SqlGenerateTool` — Delegates to `SqlGenerateServiceImpl` (LLM translates NL + schema → SQL)

**RAG/Enterprise tools:**
- `RagTableSearchTool` — Vector similarity search on `ai_table_metadata.embedding` to find relevant tables
- `DynamicSchemaTool` — Loads all table names + comments from metadata tables
- `DynamicColumnTool` — Loads column metadata for given table list
- `FilterTableByQuestionTool` — LLM-based filtering: selects up to 3 most relevant tables for a question
- `RerankTool` — Calls external rerank service (`localhost:8083`) for relevance re-scoring

**Domain tools:**
- `OrderTool` / `PriceTool` — Query orders and prices by known parameters

### Tool Callback Groups (ToolConfig)

Tools are assembled into named `ToolCallback[]` beans for different pipelines:
- `sqlTools` — `DynamicSchemaTool` + `DynamicColumnTool` + `SqlExecuteTool`
- `ragTools` — `RagTableSearchTool` + `DynamicColumnTool` + `SqlExecuteTool`
- `rerankTools` — `RagTableSearchTool` + `RerankTool` + `DynamicColumnTool` + `SqlExecuteTool`
- `columnRerankTools` — same as rerankTools (different ordering for column-level rerank flow)

### Data Flow (RAG Rerank Column Stream — most complex)

```
Request → AiChatController.ragRerankColumnAgentStream
  → RagTableSearchTool.searchRelevantTables()   [pgvector cosine similarity]
  → DynamicColumnTool.loadColumnMetadata()       [reads ai_column_metadata]
  → RerankTool.rerankWithColumns()               [external rerank service]
  → buildSchemaForTables()                       [filter column text to top tables]
  → SqlGenerateTool.generateSql()                [LLM generates SQL]
  → SqlExecuteTool.executeSql()                  [retry up to 3x on failure]
  → LLM stream (natural language answer)         [SSE Flux]
```

### Metadata Tables

The app manages its own metadata for RAG:
- `agent.ai_table_metadata` — table name, comment, business domain/desc, alias, embedding vector
- `agent.ai_column_metadata` — table name, column name/type, comment, business meaning, value examples, embedding vector
- `agent.vector_store` — generic embedding store (content, embedding, metadata JSONB)

Embeddings are auto-seeded on startup via `@PostConstruct initVectorStore()`.

## Error Handling Patterns

A `@RestControllerAdvice` (`GlobalExceptionHandler`) catches unhandled exceptions from all endpoints and returns structured JSON `{"status", "error", "message", "timestamp"}` responses. SSE/Flux endpoints handle their own errors internally (e.g. `ragRerankColumnAgentStream` catches and emits error strings) and are not affected by the global handler.

Per-method patterns that still exist:

- **`SqlExecuteTool.executeSql()`** — validates SELECT prefix (returns error map otherwise); catches SQL exceptions and re-throws as `RuntimeException` with the original message
- **`ragRerankColumnAgentStream`** — SQL retry loop (up to 3 attempts): on failure, feeds the error message back to the LLM via `regenerateSqlWithError()` for correction; wraps the entire pipeline in try-catch returning the error as a `Flux.just()` string
- **`enterpriseSqlAgentWorkflow`** — single retry: catches SQL execution failure, calls `generateSqlWithError()` with the error, retries once
- **`FilterTableByQuestionTool`** — uses `assert` for null-checking LLM response (will silently pass in production with `-ea` not set)

## Known Issues

- **API keys hardcoded** in `application.yml` (DeepSeek key) and `VectorStoreConfig.java` — use env vars for production
- **No tests** — zero test dependencies in pom.xml, no test directory
- **ChatClient rebuilt per request** — every service method calls `chatClientBuilder.build()` instead of reusing a bean
- **Schema hardcoded** to `agent` in both `application.yml` and tool queries
- **Mixed injection** — `AiChatController` and `AiChatServiceImpl` use `@Autowired` field injection; most services use `@RequiredArgsConstructor`
- **Dead code** — `Assistant`/`AssistantStreaming` interfaces (no implementations), `PriceController` (empty), `PriceEntity` (unused)
- **`UpgradeSqlExecuteTool`** — functionally identical to `SqlExecuteTool` with extra Markdown-cleaning, currently unused
