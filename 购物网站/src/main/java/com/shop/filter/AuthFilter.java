package com.shop.filter;

import com.shop.util.ApiResponse;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(urlPatterns = {"/*"})
public class AuthFilter implements Filter {
    private final Gson gson = new Gson();
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String path = httpRequest.getRequestURI();
        
        // 不需要登录的资源
        if (path.endsWith("/login.jsp") || 
            path.endsWith("/register.jsp") || 
            path.endsWith("/login") || 
            path.endsWith("/register") || 
            path.contains("/products") || 
            path.contains("/categories") ||
            path.contains("/css/") || 
            path.contains("/js/") || 
            path.contains("/images/") || 
            path.endsWith("/index.jsp") ||
            path.endsWith("/orders.jsp")) {  // 添加orders.jsp到不需要登录的列表
            chain.doFilter(request, response);
            return;
        }
        
        // 检查是否登录
        if (httpRequest.getSession().getAttribute("user") == null) {
            // 对于API请求返回JSON响应
            if (path.startsWith(httpRequest.getContextPath() + "/api/")) {
                httpResponse.setContentType("application/json");
                httpResponse.setCharacterEncoding("UTF-8");
                httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                httpResponse.getWriter().write(gson.toJson(ApiResponse.error("请先登录")));
            } else {
                // 对于页面请求重定向到登录页
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            }
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
} 