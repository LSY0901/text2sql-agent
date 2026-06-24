package com.example.firstaidemo.service;

import java.util.List;

public interface IMetaDataService {


    /**
     * 获取数据库中所有表名
     * @return
     */
    List<String>  getTables();


    /**
     * 获取数据库中所有表名 - meta_data 数据中心维护的表
     * @return
     */
    String  getTableNames();

    /**
     * 获取数据库中指定表名的所有列名
     * @param tables
     * @return
     */
    String getColumnNames(List<String> tables);

}
