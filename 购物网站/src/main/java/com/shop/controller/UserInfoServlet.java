package com.shop.controller;

import com.shop.service.UserService;
import com.shop.model.User;
import com.shop.util.ApiResponse;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/user/info")
public class UserInfoServlet extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String username = (String) request.getSession().getAttribute("user");
        
        if (username != null) {
            try {
                User user = userService.getUserInfo(username);
                // 清除密码等敏感信息
                user.setPassword(null);
                response.getWriter().write(gson.toJson(ApiResponse.success(user)));
            } catch (Exception e) {
                response.getWriter().write(gson.toJson(ApiResponse.error(e.getMessage())));
            }
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(ApiResponse.error("未登录")));
        }
    }
} 