# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

```bash
# Kill any stale process on 8081 (if previous run didn't exit cleanly)
lsof -ti:8081 | xargs kill -9 2>/dev/null; echo "ok"

# Build the project (skip tests — none exist)
./mvnw clean package -DskipTests

# Compile only
./mvnw clean compile

# Run locally
./mvnw spring-boot:run

# Run the packaged jar
java -jar target/firstAiDemo-0.0.1-SNAPSHOT.jar
```

## Prerequisites

- **Java 21** (project uses `java.version=21` in pom.xml)
- **PostgreSQL** running on `localhost:5432`, database `agent_db`, schema `agent`
  - User: `agent_user`, Password: `123456`
  - Required tables: `orders`, `price_ai`
- **AI backend**: Ollama on `localhost:11434` (default, for dev) with model `Qwen3.5-9B-IQ4_NL.gguf`, or uncomment the DeepSeek config for production

## Architecture

### Layers

```
Controller (@RestController) → Service (Interface + Impl) → Tool (@Tool) / Mapper (MyBatis-Plus)
```

- **Controller** — REST endpoints on port 8081, mounted under `/aiChat`, `/order`, `/price`
- **Service** — Business logic; `AiChatServiceImpl` and `AgentServiceImpl` are the core AI services
- **Tool** — Spring AI `@Tool`-annotated beans that LLMs can invoke autonomously
- **Mapper** — MyBatis-Plus `BaseMapper` extensions + XML mappers under `src/main/resources/mapper/`

### AI Interaction Patterns

There are 5 distinct patterns in `AiChatServiceImpl`:

| Pattern | Method | How it works |
|---------|--------|-------------|
| Plain chat | `chat()` | Pass-through to LLM, no tools |
| Streaming | `chatStream()` | SSE Flux via WebFlux |
| Tool-augmented | `chatRealPgData()` | LLM can call `OrderTool` / `PriceTool` to fetch live DB data |
| Fixed workflow | `workFlowAiAgent()` | Hardcoded pipeline: getSchema() → LLM generates SQL → executeSql() → return JSON |
| Autonomous agent | `sqlAgentNotWorkFlow()` | LLM gets `SchemaTool` + `SqlExecuteTool` and decides when to call each |

`AgentServiceImpl` adds a 20-message `MessageWindowChatMemory` on top for stateful conversations.

### Key Tools (Spring AI @Tool)

- **SchemaTool** — Reads Postgres `pg_catalog` / `information_schema` to produce a text description of all tables in the `agent` schema
- **SqlExecuteTool** — Executes arbitrary SELECT statements via `JdbcTemplate` (only validates `SELECT` prefix)
- **SqlGenerateTool** — Thin wrapper that delegates to `SqlGenerateServiceImpl`, which calls the LLM to translate natural language + schema into SQL
- **OrderTool** / **PriceTool** — Domain-specific tools that query orders and prices by known parameters

### Data Flow (Fixed Workflow Example)

```
Request → AiChatController.workFlowAiAgent
  → SchemaTool.getDatabaseSchema()        [reads Postgres catalog]
  → SqlGenerateTool.generateSql(schema)   [LLM generates SQL from schema + question]
  → SqlExecuteTool.executeSql(sql)        [runs SQL via JdbcTemplate]
  → returns JSON string
```

## Known Codebase Issues

- **API keys hardcoded** in `application.yml` — use env vars for any shared/production work
- **Duplicate tools**: `UpgradeSqlExecuteTool` is functionally identical to `SqlExecuteTool` (with extra Markdown-cleaning) and is unused
- **Dead code**: `Assistant` / `AssistantStreaming` interfaces have no implementations; `PriceController` is empty; `SqlResult` entity is unreferenced
- **No tests**: Zero test dependencies in pom.xml, no test directory
- **Mixed injection**: `OrderServiceImpl` uses `@Autowired` field injection; other services use `@RequiredArgsConstructor` constructor injection
- **No error handling**: No `@ControllerAdvice` or global exception handler
- **ChatClient rebuilt per request**: Every service method calls `chatClientBuilder.build()` instead of reusing a configured bean
- **Schema name hardcoded** to `agent` in both `application.yml` and `SchemaTool` queries
