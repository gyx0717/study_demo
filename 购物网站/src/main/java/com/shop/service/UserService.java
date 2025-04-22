package com.shop.service;

import com.shop.dao.UserDao;
import com.shop.model.User;
import com.shop.util.ApiException;

public class UserService {
    private final UserDao userDao = new UserDao();
    
    /**
     * 用户登录
     */
    public boolean login(String username, String password) {
        try {
            // 验证参数
            if (username == null || password == null || 
                username.trim().isEmpty() || password.trim().isEmpty()) {
                System.out.println("Login failed: empty username or password");
                return false;
            }

            System.out.println("Attempting login for username: " + username);
            
            // 从数据库获取用户信息
            User user = userDao.findByUsername(username.trim());
            
            // 用户不存在
            if (user == null) {
                System.out.println("Login failed: user not found - " + username);
                return false;
            }
            
            // 验证密码
            boolean isMatch = password.equals(user.getPassword());
            if (isMatch) {
                System.out.println("Login successful for user: " + username);
            } else {
                System.out.println("Login failed: incorrect password for user - " + username);
            }
            
            return isMatch;
        } catch (Exception e) {
            System.out.println("Login error for " + username + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 用户注册
     */
    public void register(User user) {
        try {
            // 检查用户名是否已存在
            if (userDao.findByUsername(user.getUsername()) != null) {
                throw new ApiException("用户名已存在", 400);
            }
            
            // 密码加密 (实际项目中应该使用加密算法)
            // user.setPassword(passwordEncoder.encode(user.getPassword()));
            
            // 保存用户
            userDao.save(user);
            System.out.println("User registered successfully: " + user.getUsername());
        } catch (ApiException e) {
            System.out.println("Registration failed for user " + user.getUsername() + ": " + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.out.println("Unexpected error during registration: " + e.getMessage());
            e.printStackTrace();
            throw new ApiException("注册失败：" + e.getMessage());
        }
    }
    
    /**
     * 获取用户信息
     */
    public User getUserInfo(String username) {
        try {
            User user = userDao.findByUsername(username);
            if (user == null) {
                throw new ApiException("用户不存在", 404);
            }
            // 清除敏感信息
            user.setPassword(null);
            return user;
        } catch (ApiException e) {
            throw e;
        } catch (Exception e) {
            System.out.println("Error getting user info: " + e.getMessage());
            e.printStackTrace();
            throw new ApiException("获取用户信息失败");
        }
    }
    
    /**
     * 验证用户登录
     */
    public boolean validateUser(String username, String password) {
        try {
            System.out.println("Validating user: " + username);
            
            // 从数据库获取用户信息
            User user = userDao.findByUsername(username);
            
            // 用户不存在
            if (user == null) {
                System.out.println("User not found: " + username);
                return false;
            }
            
            // 验证密码 (实际项目中应该使用加密算法比较)
            // return passwordEncoder.matches(password, user.getPassword());
            boolean isMatch = password.equals(user.getPassword());
            
            if (isMatch) {
                System.out.println("Login successful for user: " + username);
            } else {
                System.out.println("Login failed: incorrect password for user - " + username);
            }
            
            return isMatch;
        } catch (Exception e) {
            System.out.println("Error validating user: " + e.getMessage());
            e.printStackTrace();
            throw new ApiException("验证用户失败");
        }
    }
    
    /**
     * 验证登录参数
     */
    private void validateLoginParams(String username, String password) {
        if (username == null || password == null || 
            username.trim().isEmpty() || password.trim().isEmpty()) {
            System.out.println("Login failed: empty username or password");
            throw new ApiException("用户名和密码不能为空", 400);
        }
    }
} 