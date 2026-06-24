package com.example.firstaidemo.service.impl;

import com.example.firstaidemo.service.IAgentService;
import com.example.firstaidemo.tools.OrderTool;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

@Slf4j
@Service
@RequiredArgsConstructor
public class AgentServiceImpl implements IAgentService {

    private final ChatClient.Builder chatClientBuilder;

    private final ChatMemory chatMemory;

    private final OrderTool orderTool;


    @Override
    public String memoryChat(String message) {
        ChatClient chatClient = chatClientBuilder
                .defaultAdvisors(
                        MessageChatMemoryAdvisor.builder(chatMemory).build()
                )
                .build();

        return chatClient.prompt()
                .user(message)
                .call()
                .content();
    }

    @Override
    public Flux<String> memoryStreamingChat(String message) {
        ChatClient chatClient = chatClientBuilder
                .defaultAdvisors(
                        MessageChatMemoryAdvisor
                                .builder(chatMemory)
                                .build()
                )
                .build();

        return chatClient.prompt()
                .user(message)
                .stream()
                .content();
    }

    @Override
    public Flux<String> memoryStreamingUseToolChat(String message) {
        ChatClient chatClient = chatClientBuilder
                .defaultAdvisors(
                        MessageChatMemoryAdvisor
                                .builder(chatMemory)
                                .build()
                )
                .defaultTools(orderTool)
                .build();
        log.info("开始访问llm");
        return chatClient.prompt()
                .user(message)
                .stream()
                .content();
    }
}
