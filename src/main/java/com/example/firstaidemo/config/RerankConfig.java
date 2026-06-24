package com.example.firstaidemo.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class RerankConfig {


    @Bean
    public RestClient rerankRestClient(
            @Value("${rerank.base-url}") String baseUrl,
            @Value("${rerank.model}") String model) {
        return RestClient.builder()
                .baseUrl(baseUrl)
                .defaultHeader("Content-Type", "application/json")
                .build();
    }
}
