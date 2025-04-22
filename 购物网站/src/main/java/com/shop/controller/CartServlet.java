package com.shop.controller;

import com.shop.model.CartItem;
import com.shop.service.CartService;
import com.shop.util.ApiResponse;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/cart/*")
public class CartServlet extends HttpServlet {
    private CartService cartService = new CartService();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String username = (String) request.getSession().getAttribute("user");
        List<CartItem> cartItems = cartService.getCartItems(username);
        
        response.getWriter().write(gson.toJson(ApiResponse.success(cartItems)));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String username = (String) request.getSession().getAttribute("user");
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // 添加到购物车
                Long productId = Long.parseLong(request.getParameter("productId"));
                Integer quantity = Integer.parseInt(request.getParameter("quantity"));
                cartService.addToCart(username, productId, quantity);
                response.getWriter().write(gson.toJson(ApiResponse.success(null)));
            } else if (pathInfo.equals("/update")) {
                // 更新购物车
                Long itemId = Long.parseLong(request.getParameter("itemId"));
                Integer quantity = Integer.parseInt(request.getParameter("quantity"));
                cartService.updateQuantity(username, itemId, quantity);
                response.getWriter().write(gson.toJson(ApiResponse.success(null)));
            } else if (pathInfo.equals("/remove")) {
                // 从购物车删除
                Long itemId = Long.parseLong(request.getParameter("itemId"));
                cartService.removeFromCart(username, itemId);
                response.getWriter().write(gson.toJson(ApiResponse.success(null)));
            }
        } catch (Exception e) {
            response.getWriter().write(gson.toJson(ApiResponse.error(e.getMessage())));
        }
    }
} 