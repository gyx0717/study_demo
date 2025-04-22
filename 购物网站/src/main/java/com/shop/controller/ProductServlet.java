package com.shop.controller;

import com.shop.service.ProductService;
import com.shop.model.Product;
import com.shop.util.ApiResponse;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/products")
public class ProductServlet extends HttpServlet {
    private ProductService productService = new ProductService();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String category = request.getParameter("category");
            System.out.println("Received request for products, category: " + category);
            
            List<Product> products;
            if (category != null && !category.isEmpty()) {
                products = productService.getProductsByCategory(category);
            } else {
                products = productService.getAllProducts();
            }
            
            System.out.println("Found " + products.size() + " products");
            String json = gson.toJson(ApiResponse.success(products));
            System.out.println("JSON response: " + json);
            
            response.getWriter().write(json);
        } catch (Exception e) {
            System.out.println("Error processing request: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.error(e.getMessage())));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String method = request.getParameter("_method");
            if ("DELETE".equals(method)) {
                // 处理删除请求
                String id = request.getParameter("id");
                System.out.println("Attempting to delete product with ID: " + id);
                
                if (id == null || id.trim().isEmpty()) {
                    throw new IllegalArgumentException("商品ID不能为空");
                }
                
                productService.deleteProduct(Long.parseLong(id));
                System.out.println("Product deleted successfully");
                
                response.getWriter().write(gson.toJson(ApiResponse.success(null)));
                return;
            }
            
            // 原有的添加商品逻辑
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String price = request.getParameter("price");
            String stock = request.getParameter("stock");
            String category = request.getParameter("category");
            String imageUrl = request.getParameter("imageUrl");
            
            Product product = new Product();
            product.setName(name);
            product.setDescription(description);
            product.setPrice(new java.math.BigDecimal(price));
            product.setStock(Integer.parseInt(stock));
            product.setCategory(category);
            product.setImageUrl(imageUrl);
            
            productService.saveProduct(product);
            
            response.getWriter().write(gson.toJson(ApiResponse.success(product)));
        } catch (Exception e) {
            System.out.println("Error in doPost: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.error(e.getMessage())));
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // 读取JSON数据
            StringBuilder sb = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            
            // 解析JSON数据
            Product product = gson.fromJson(sb.toString(), Product.class);
            
            // 更新商品
            productService.updateProduct(product);
            
            response.getWriter().write(gson.toJson(ApiResponse.success(product)));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.error(e.getMessage())));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String id = request.getParameter("id");
            System.out.println("Attempting to delete product with ID: " + id);
            
            if (id == null || id.trim().isEmpty()) {
                throw new IllegalArgumentException("商品ID不能为空");
            }
            
            productService.deleteProduct(Long.parseLong(id));
            System.out.println("Product deleted successfully");
            
            response.getWriter().write(gson.toJson(ApiResponse.success(null)));
        } catch (Exception e) {
            System.out.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.error(e.getMessage())));
        }
    }
}
