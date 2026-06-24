package com.example.firstaidemo.service;

import reactor.core.publisher.Flux;

public interface IAgentService {

    String memoryChat(String message);


    Flux<String> memoryStreamingChat(String message);


    Flux<String> memoryStreamingUseToolChat(String message);

}
