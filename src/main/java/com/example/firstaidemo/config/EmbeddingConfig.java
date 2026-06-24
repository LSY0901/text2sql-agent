package com.example.firstaidemo.config;

import org.springframework.ai.document.MetadataMode;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.openai.OpenAiEmbeddingModel;
import org.springframework.ai.openai.OpenAiEmbeddingOptions;
import org.springframework.ai.openai.api.OpenAiApi;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class EmbeddingConfig {


    @Value("${embedding.base-url}")
    private String embeddingBaseUrl;

    @Value("${embedding.model}")
    private String embeddingModel;

    @Bean
    public EmbeddingModel embeddingModel() {
        return new OpenAiEmbeddingModel(
                OpenAiApi.builder()
                        .apiKey("none")
                        .baseUrl(embeddingBaseUrl)
                        .build(),
                MetadataMode.EMBED,
                OpenAiEmbeddingOptions.builder()
                        .model(embeddingModel)
                        .build()
        );
    }


}
