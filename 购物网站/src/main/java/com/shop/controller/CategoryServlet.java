package com.shop.controller;

import com.shop.service.ProductService;
import com.google.gson.Gson;
import com.shop.util.ApiResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/categories")
public class CategoryServlet extends HttpServlet {
    private ProductService productService = new ProductService();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            List<String> categories = productService.getAllCategories();
            response.getWriter().write(gson.toJson(ApiResponse.success(categories)));
        } catch (Exception e) {
            response.getWriter().write(gson.toJson(ApiResponse.error(e.getMessage())));
        }
    }
} 