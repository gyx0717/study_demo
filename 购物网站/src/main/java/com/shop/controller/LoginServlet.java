package com.shop.controller;

import com.shop.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/user/login")
public class LoginServlet extends HttpServlet {
    private final UserService userService = new UserService();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 设置请求和响应的字符编码
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            // 获取表单参数
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            System.out.println("Login attempt - Username: " + username);

            // 使用UserService验证用户登录
            if (userService.login(username, password)) {
                // 登录成功，设置session
                HttpSession session = request.getSession();
                session.setAttribute("user", username);
                
                System.out.println("Login successful for user: " + username);
                // 重定向到index.jsp
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                // 登录失败
                System.out.println("Login failed for user: " + username);
                request.setAttribute("error", "用户名或密码错误");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // 发生异常
            System.out.println("Login error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "登录失败，请稍后重试");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 重定向GET请求到登录页面
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
