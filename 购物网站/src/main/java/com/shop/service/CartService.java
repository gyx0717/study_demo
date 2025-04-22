package com.shop.service;

import com.shop.dao.CartDao;
import com.shop.model.CartItem;
import com.shop.model.User;
import java.util.List;

public class CartService {
    private CartDao cartDao = new CartDao();
    private UserService userService = new UserService();

    public List<CartItem> getCartItems(String username) {
        User user = userService.getUserInfo(username);
        return cartDao.findByUserId(user.getId());
    }

    public void addToCart(String username, Long productId, Integer quantity) {
        User user = userService.getUserInfo(username);
        cartDao.addToCart(user.getId(), productId, quantity);
    }

    public void updateQuantity(String username, Long itemId, Integer quantity) {
        User user = userService.getUserInfo(username);
        cartDao.updateQuantity(user.getId(), itemId, quantity);
    }

    public void removeFromCart(String username, Long itemId) {
        User user = userService.getUserInfo(username);
        cartDao.removeFromCart(user.getId(), itemId);
    }
} 