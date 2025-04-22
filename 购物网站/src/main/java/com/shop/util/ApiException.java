package com.shop.util;

public class ApiException extends RuntimeException {
    private int statusCode;
    
    public ApiException(String message) {
        this(message, 500);
    }
    
    public ApiException(String message, int statusCode) {
        super(message);
        this.statusCode = statusCode;
    }
    
    public int getStatusCode() {
        return statusCode;
    }
} 