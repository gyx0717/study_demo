<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>购物车 - 购物网站</title>
    <style>
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
        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .cart-table th, .cart-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .cart-table th {
            background-color: #f8f9fa;
        }
        .quantity-input {
            width: 60px;
            padding: 5px;
            text-align: center;
        }
        .remove-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
        }
        .remove-btn:hover {
            background-color: #c82333;
        }
        .checkout-section {
            margin-top: 20px;
            text-align: right;
        }
        .total-price {
            font-size: 1.2em;
            font-weight: bold;
            margin: 10px 0;
        }
        .checkout-btn {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
        }
        .checkout-btn:hover {
            background-color: #218838;
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
        <h1>我的购物车</h1>
        <table class="cart-table">
            <thead>
                <tr>
                    <th>商品图片</th>
                    <th>商品名称</th>
                    <th>单价</th>
                    <th>数量</th>
                    <th>小计</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody id="cartItems">
                <!-- 购物车内容将通过JavaScript动态加载 -->
            </tbody>
        </table>
        
        <div class="checkout-section">
            <div class="total-price">总计：￥<span id="totalPrice">0.00</span></div>
            <button class="checkout-btn" onclick="checkout()">结算</button>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            loadCartItems();
        });

        function loadCartItems() {
            $.ajax({
                url: 'api/cart',
                type: 'GET',
                success: function(response) {
                    if (response.success) {
                        const items = response.data;
                        let html = '';
                        let total = 0;
                        
                        items.forEach(item => {
                            const subtotal = item.price * item.quantity;
                            total += subtotal;
                            html += `
                                <tr>
                                    <td><img src="${item.imageUrl}" alt="${item.productName}" style="width:50px"></td>
                                    <td>${item.productName}</td>
                                    <td>￥${item.price}</td>
                                    <td>
                                        <input type="number" class="quantity-input" value="${item.quantity}" 
                                            onchange="updateQuantity(${item.id}, this.value)">
                                    </td>
                                    <td>￥${subtotal.toFixed(2)}</td>
                                    <td>
                                        <button class="remove-btn" onclick="removeItem(${item.id})">删除</button>
                                    </td>
                                </tr>
                            `;
                        });
                        
                        $('#cartItems').html(html);
                        $('#totalPrice').text(total.toFixed(2));
                    }
                }
            });
        }

        function updateQuantity(itemId, quantity) {
            $.ajax({
                url: 'api/cart/update',
                type: 'POST',
                data: {
                    itemId: itemId,
                    quantity: quantity
                },
                success: function(response) {
                    if (response.success) {
                        loadCartItems();
                    } else {
                        alert(response.message);
                    }
                }
            });
        }

        function removeItem(itemId) {
            if (confirm('确定要删除这个商品吗？')) {
                $.ajax({
                    url: 'api/cart/remove',
                    type: 'POST',
                    data: { itemId: itemId },
                    success: function(response) {
                        if (response.success) {
                            loadCartItems();
                        } else {
                            alert(response.message);
                        }
                    }
                });
            }
        }

        function checkout() {
            window.location.href = 'checkout.jsp';
        }

        function logout() {
            $.ajax({
                url: 'api/user/logout',
                type: 'POST',
                success: function(response) {
                    window.location.href = 'login.jsp';
                }
            });
        }
    </script>
</body>
</html> 