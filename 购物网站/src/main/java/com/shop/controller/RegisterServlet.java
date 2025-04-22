package com.shop.controller;

import com.shop.model.User;
import com.shop.service.UserService;
import com.shop.util.ApiException;
import com.google.gson.Gson;
import com.shop.util.ApiResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/user/register")
public class RegisterServlet extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // 获取表单参数
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            // 打印接收到的参数用于调试
            System.out.println("Received registration request:");
            System.out.println("Username: " + username);
            System.out.println("Email: " + email);
            System.out.println("Phone: " + phone);
            
            // 创建用户对象
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            
            // 验证用户数据
            validateUser(user);
            
            // 注册用户
            userService.register(user);
            
            // 返回成功响应
            ApiResponse<Void> successResponse = ApiResponse.success(null);
            response.getWriter().write(gson.toJson(successResponse));
            
        } catch (ApiException e) {
            System.out.println("API Exception: " + e.getMessage());
            response.setStatus(e.getStatusCode());
            ApiResponse<Void> errorResponse = ApiResponse.error(e.getMessage());
            response.getWriter().write(gson.toJson(errorResponse));
        } catch (Exception e) {
            System.out.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            ApiResponse<Void> errorResponse = ApiResponse.error("注册失败，请稍后重试");
            response.getWriter().write(gson.toJson(errorResponse));
        }
    }
    
    private void validateUser(User user) {
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new ApiException("用户名不能为空", 400);
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new ApiException("密码不能为空", 400);
        }
        if (user.getUsername().length() < 3 || user.getUsername().length() > 20) {
            throw new ApiException("用户名长度必须在3-20个字符之间", 400);
        }
        if (user.getPassword().length() < 6) {
            throw new ApiException("密码长度不能少于6个字符", 400);
        }
    }
} 