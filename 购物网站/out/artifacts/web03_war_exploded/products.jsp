<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品列表 - 购物网站</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }

        .header {
            background-color: #333;
            padding: 15px 0;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }

        .nav {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
        }

        .nav a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
        }

        .nav a:hover {
            background-color: #444;
            border-radius: 4px;
        }

        .main-container {
            max-width: 1200px;
            margin: 80px auto 20px;
            padding: 20px;
        }

        .welcome-message {
            color: white;
            margin-right: 20px;
        }

        h1 {
            color: #333;
            margin-bottom: 30px;
        }

        .category-filter {
            margin-bottom: 20px;
            padding: 15px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .category-filter select {
            padding: 8px 15px;
            margin-left: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            min-width: 150px;
        }

        .product-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .product-table th, 
        .product-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .product-table th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #333;
        }

        .product-table tr:hover {
            background-color: #f5f5f5;
        }

        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
            display: block;
        }

        .add-to-cart-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 14px;
        }

        .add-to-cart-btn:hover {
            background-color: #0056b3;
        }

        .price {
            color: #e44d26;
            font-weight: bold;
            font-size: 16px;
        }

        .stock {
            color: #28a745;
        }

        .category-badge {
            background-color: #f8f9fa;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            color: #666;
        }

        .action-buttons {
            margin-bottom: 20px;
        }
        
        .add-product-btn {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .edit-btn {
            background-color: #ffc107;
            color: black;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 5px;
        }
        
        .delete-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 20px;
            width: 50%;
            border-radius: 5px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        
        .form-group input, .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .form-control:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
        }
        
        input[type="number"].form-control {
            text-align: right;
            padding-right: 15px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="nav">
            <div>
                <a href="index.jsp">首页</a>
                <a href="products.jsp">商品列表</a>
                <a href="cart.jsp">购物车</a>
                <a href="orders.jsp">我的订单</a>
            </div>
            <div id="userInfo">
                <% 
                String username = (String)session.getAttribute("user");
                if(username != null) {
                %>
                    <span class="welcome-message">欢迎, <%= username %></span>
                    <a href="javascript:void(0)" onclick="logout()">退出</a>
                <% } else { %>
                    <a href="login.jsp">登录</a>
                <% } %>
            </div>
        </div>
    </div>

    <div class="main-container">
        <h1>商品列表</h1>
        
        <div class="action-buttons">
            <button class="add-product-btn" onclick="showAddModal()">添加商品</button>
        </div>
        
        <div class="category-filter">
            分类筛选：
            <select id="categorySelect" onchange="filterByCategory()">
                <option value="">全部商品</option>
            </select>
        </div>

        <table class="product-table">
            <thead>
                <tr>
                    <th>图片</th>
                    <th>商品名称</th>
                    <th>描述</th>
                    <th>价格</th>
                    <th>库存</th>
                    <th>分类</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody id="productList">
                <!-- 商品数据将通过JavaScript动态加载 -->
            </tbody>
        </table>
    </div>

    <!-- 添加商品的模态框 -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <h2>添加商品</h2>
            <form action="<%=request.getContextPath()%>/api/products" method="POST">
                <div class="form-group">
                    <label for="name">商品名称</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="description">商品描述</label>
                    <textarea id="description" name="description" required></textarea>
                </div>
                <div class="form-group">
                    <label for="price">价格</label>
                    <input type="number" id="price" name="price" step="0.01" required>
                </div>
                <div class="form-group">
                    <label for="stock">库存</label>
                    <input type="number" id="stock" name="stock" required>
                </div>
                <div class="form-group">
                    <label for="category">分类</label>
                    <input type="text" id="category" name="category" required>
                </div>
                <div class="form-group">
                    <label for="imageUrl">图片URL</label>
                    <input type="text" id="imageUrl" name="imageUrl" required>
                </div>
                <button type="submit" class="add-product-btn">保存</button>
                <button type="button" onclick="hideAddModal()" style="margin-left: 10px;">取消</button>
            </form>
        </div>
    </div>

    <!-- 编辑商品的模态框 -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <h2>编辑商品</h2>
            <form id="editForm">
                <input type="hidden" id="editId" name="id">
                <div class="form-group">
                    <label for="editName">商品名称</label>
                    <input type="text" id="editName" name="name" required>
                </div>
                <div class="form-group">
                    <label for="editDescription">商品描述</label>
                    <textarea id="editDescription" name="description" required></textarea>
                </div>
                <div class="form-group">
                    <label for="editPrice">价格</label>
                    <input type="number" 
                           id="editPrice" 
                           name="price" 
                           step="0.01" 
                           min="0" 
                           required 
                           class="form-control">
                </div>
                <div class="form-group">
                    <label for="editStock">库存</label>
                    <input type="number" id="editStock" name="stock" min="0" required>
                </div>
                <div class="form-group">
                    <label for="editCategory">分类</label>
                    <input type="text" id="editCategory" name="category" required>
                </div>
                <div class="form-group">
                    <label for="editImageUrl">图片URL</label>
                    <input type="text" id="editImageUrl" name="imageUrl" required>
                </div>
                <button type="submit" class="add-product-btn">保存</button>
                <button type="button" onclick="hideEditModal()" style="margin-left: 10px;">取消</button>
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            loadCategories();
            loadProducts();
            $('#editForm').on('submit', function(e) {
                e.preventDefault();
                console.log('Submitting edit form');
                
                const formData = {
                    id: $('#editId').val(),
                    name: $('#editName').val(),
                    description: $('#editDescription').val(),
                    price: parseFloat($('#editPrice').val()),
                    stock: parseInt($('#editStock').val()),
                    category: $('#editCategory').val(),
                    imageUrl: $('#editImageUrl').val()
                };
                
                console.log('Form data:', formData);
                
                $.ajax({
                    url: '<%=request.getContextPath()%>/api/products',
                    type: 'PUT',
                    contentType: 'application/json',
                    data: JSON.stringify(formData),
                    success: function(response) {
                        console.log('Update response:', response);
                        if (response.success) {
                            alert('商品更新成功！');
                            hideEditModal();
                            loadProducts();
                        } else {
                            alert(response.message || '更新失败，请稍后重试');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('Update error:', error);
                        alert('更新失败，请稍后重试');
                    }
                });
            });
        });

        function loadCategories() {
            $.ajax({
                url: '<%=request.getContextPath()%>/api/categories',
                type: 'GET',
                success: function(response) {
                    if (response.success && response.data) {
                        let html = '<option value="">全部商品</option>';
                        response.data.forEach(category => {
                            html += `<option value="${category}">${category}</option>`;
                        });
                        $('#categorySelect').html(html);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error loading categories:', error);
                }
            });
        }

        function filterByCategory() {
            const category = $('#categorySelect').val();
            loadProducts(category);
        }

        function loadProducts(category) {
            let url = '<%=request.getContextPath()%>/api/products';
            if (category) {
                url += '?category=' + encodeURIComponent(category);
            }

            $.ajax({
                url: url,
                type: 'GET',
                success: function(response) {
                    console.log('Response:', response);
                    let html = '';
                    if (response.success && response.data) {
                        const products = response.data;
                        if (products.length > 0) {
                            products.forEach(product => {
                                const productJson = JSON.stringify(product).replace(/"/g, '&quot;');
                                
                                html += '<tr>' +
                                       '<td>' +
                                       '<img src="' + (product.imageUrl || 'images/default.jpg') + '" ' +
                                       'class="product-image" ' +
                                       'alt="' + (product.name || '未命名商品') + '" ' +
                                       'onerror="this.src=\'images/default.jpg\'" ' +
                                       'style="width: 50px; height: 50px; object-fit: cover;">' +
                                       '</td>' +
                                       '<td>' + (product.name || '未命名商品') + '</td>' +
                                       '<td>' + (product.description || '暂无描述') + '</td>' +
                                       '<td class="price">￥' + (product.price ? product.price.toFixed(2) : '0.00') + '</td>' +
                                       '<td class="stock">' + (product.stock || 0) + '件</td>' +
                                       '<td><span class="category-badge">' + (product.category || '未分类') + '</span></td>' +
                                       '<td>' +
                                       '<button class="edit-btn" onclick="showEditModal(' + productJson + ')">编辑</button> ' +
                                       '<button class="delete-btn" onclick="deleteProduct(' + product.id + ')">删除</button>' +
                                       '</td>' +
                                       '</tr>';
                            });
                        } else {
                            html = '<tr><td colspan="7" style="text-align: center;">暂无商品数据</td></tr>';
                        }
                    } else {
                        html = '<tr><td colspan="7" style="text-align: center;">加载商品失败</td></tr>';
                    }
                    $('#productList').html(html);
                },
                error: function(xhr, status, error) {
                    console.error('Error:', error);
                    $('#productList').html('<tr><td colspan="7" style="text-align: center; color: red;">加载商品失败，请稍后重试</td></tr>');
                }
            });
        }

        function showAddModal() {
            document.getElementById('addModal').style.display = 'block';
        }

        function hideAddModal() {
            document.getElementById('addModal').style.display = 'none';
        }

        function showEditModal(product) {
            console.log('Editing product:', product);
            try {
                document.getElementById('editId').value = product.id || '';
                document.getElementById('editName').value = product.name || '';
                document.getElementById('editDescription').value = product.description || '';
                document.getElementById('editPrice').value = product.price ? parseFloat(product.price).toFixed(2) : '0.00';
                document.getElementById('editStock').value = product.stock || 0;
                document.getElementById('editCategory').value = product.category || '';
                document.getElementById('editImageUrl').value = product.imageUrl || '';
                
                document.getElementById('editModal').style.display = 'block';
            } catch (error) {
                console.error('Error showing edit modal:', error);
            }
        }

        function hideEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        function deleteProduct(id) {
            if (confirm('确定要删除这个商品吗？')) {
                $.ajax({
                    url: '<%=request.getContextPath()%>/api/products',
                    type: 'POST',
                    data: {
                        _method: 'DELETE',
                        id: id
                    },
                    success: function(response) {
                        if (response.success) {
                            alert('商品删除成功！');
                            loadProducts();
                        } else {
                            alert(response.message || '删除失败，请稍后重试');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('Delete error:', error);
                        alert('删除失败，请稍后重试');
                    }
                });
            }
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('addModal')) {
                hideAddModal();
            }
            if (event.target == document.getElementById('editModal')) {
                hideEditModal();
            }
        }
    </script>
</body>
</html>
