package com.example.firstaidemo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@MapperScan("com.example.firstaidemo.mapper")
@SpringBootApplication
public class FirstAiDemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(FirstAiDemoApplication.class, args);
    }

}
