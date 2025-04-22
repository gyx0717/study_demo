package com.shop.service;

import com.shop.dao.ProductDao;
import com.shop.model.Product;
import java.util.List;

public class ProductService {
    private ProductDao productDao = new ProductDao();
    
    public List<Product> getAllProducts() {
        return productDao.findAll();
    }
    
    public List<Product> getProductsByCategory(String category) {
        return productDao.findByCategory(category);
    }
    
    public Product getProductById(Long id) {
        return productDao.findById(id);
    }
    
    public List<String> getAllCategories() {
        return productDao.findAllCategories();
    }
    
    public void saveProduct(Product product) {
        productDao.save(product);
    }
    
    public void updateProduct(Product product) {
        productDao.update(product);
    }
    
    public void deleteProduct(Long id) {
        productDao.delete(id);
    }
} 