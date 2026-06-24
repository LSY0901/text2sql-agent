package com.example.firstaidemo.service;

public interface IEnterpriseText2SqlService {

    /**
     * 企业级 Text2SQL Agent - workflow
     * 动态发现表 → 动态加载列 → 生成SQL → 执行并回答
     */
    String enterpriseSqlAgentWorkflow(String question);

    /**
     * 企业级 Text2SQL Agent
     * @param question
     * @return
     */
    String enterpriseSqlAgentTools(String question);


}
