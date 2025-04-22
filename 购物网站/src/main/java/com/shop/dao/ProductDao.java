package com.shop.dao;

import com.shop.model.Product;
import com.shop.service.ProductQueryParams;
import com.shop.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {
    
    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products";
        
        try (Connection conn = DBUtil.getConnection()) {
            System.out.println("Database connection successful");
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                System.out.println("Executing SQL: " + sql);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    System.out.println("Query executed successfully");
                    
                    while (rs.next()) {
                        try {
                            Product product = new Product();
                            product.setId(rs.getLong("id"));
                            product.setName(rs.getString("name"));
                            product.setDescription(rs.getString("description"));
                            product.setPrice(rs.getBigDecimal("price"));
                            product.setStock(rs.getInt("stock"));
                            product.setImageUrl(rs.getString("image_url"));
                            product.setCategory(rs.getString("category"));
                            
                            System.out.println("Mapped product: " + 
                                "ID=" + product.getId() + 
                                ", Name=" + product.getName() + 
                                ", Description=" + product.getDescription() + 
                                ", Price=" + product.getPrice() + 
                                ", Stock=" + product.getStock() + 
                                ", ImageUrl=" + product.getImageUrl() + 
                                ", Category=" + product.getCategory());
                            
                            products.add(product);
                        } catch (SQLException e) {
                            System.out.println("Error mapping product: " + e.getMessage());
                            e.printStackTrace();
                        }
                    }
                    
                    System.out.println("Total products found: " + products.size());
                }
            }
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    public List<Product> findByCategory(String category) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM shop.products WHERE category = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, category);
            System.out.println("Executing SQL: " + sql + " with category: " + category);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getLong("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setStock(rs.getInt("stock"));
                product.setImageUrl(rs.getString("image_url"));
                product.setCategory(rs.getString("category"));
                products.add(product);
            }
            
            System.out.println("Found " + products.size() + " products in category: " + category);
        } catch (SQLException e) {
            System.out.println("Error finding products by category: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    public Product findById(Long id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<String> findAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM shop.products";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
            System.out.println("Found categories: " + categories);
        } catch (SQLException e) {
            System.out.println("Error finding categories: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }
    
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getLong("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStock(rs.getInt("stock"));
        product.setImageUrl(rs.getString("image_url"));
        product.setCategory(rs.getString("category"));
        return product;
    }

    public void save(Product product) {
        String sql = "INSERT INTO products (name, description, price, stock, image_url, category) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setInt(4, product.getStock());
            stmt.setString(5, product.getImageUrl());
            stmt.setString(6, product.getCategory());
            
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    product.setId(rs.getLong(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("保存商品失败");
        }
    }

    public void update(Product product) {
        String sql = "UPDATE products SET name=?, description=?, price=?, stock=?, image_url=?, category=? WHERE id=?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setInt(4, product.getStock());
            stmt.setString(5, product.getImageUrl());
            stmt.setString(6, product.getCategory());
            stmt.setLong(7, product.getId());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("更新商品失败");
        }
    }

    public void delete(Long id) {
        String sql = "DELETE FROM products WHERE id=?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("删除商品失败");
        }
    }

} 