package com.example.firstaidemo.service;

public interface ISqlGenerateService {

    String generateSql(String question, String schema);

    String generateSqlByPlan(String plan, String schema);

    String generateSqlByErrorReason(String errorReason, String schema);
}
