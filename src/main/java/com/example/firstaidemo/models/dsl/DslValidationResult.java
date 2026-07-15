package com.example.firstaidemo.models.dsl;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * DSL 校验结果
 */
@Data
public class DslValidationResult {

    private boolean valid;

    private List<String> errors = new ArrayList<>();

    private List<String> warnings = new ArrayList<>();

    public static DslValidationResult ok() {
        DslValidationResult r = new DslValidationResult();
        r.setValid(true);
        return r;
    }

    public static DslValidationResult fail(String error) {
        DslValidationResult r = new DslValidationResult();
        r.setValid(false);
        r.getErrors().add(error);
        return r;
    }

    public void addError(String error) {
        this.valid = false;
        this.errors.add(error);
    }

    public void addWarning(String warning) {
        this.warnings.add(warning);
    }
}
