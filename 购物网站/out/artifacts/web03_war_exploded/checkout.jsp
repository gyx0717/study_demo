<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>结算 - 购物网站</title>
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
        .main-container {
            max-width: 800px;
            margin: 80px auto 20px;
            padding: 20px;
        }
        .checkout-form {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
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
        .order-summary {
            margin-top: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .submit-btn {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            margin-top: 20px;
        }
        .submit-btn:hover {
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
        <h1>订单结算</h1>
        
        <div class="checkout-form">
            <h2>收货信息</h2>
            <form id="checkoutForm">
                <div class="form-group">
                    <label for="name">收货人姓名</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="phone">联系电话</label>
                    <input type="tel" id="phone" name="phone" required>
                </div>
                <div class="form-group">
                    <label for="address">收货地址</label>
                    <textarea id="address" name="address" required></textarea>
                </div>
                <div class="form-group">
                    <label for="note">订单备注</label>
                    <textarea id="note" name="note"></textarea>
                </div>
            </form>
        </div>

        <div class="order-summary">
            <h2>订单明细</h2>
            <div id="orderItems"></div>
            <div class="total">
                总计：￥<span id="totalAmount">0.00</span>
            </div>
        </div>

        <button class="submit-btn" onclick="submitOrder()">提交订单</button>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            loadUserInfo();
            loadCartItems();
        });

        function loadUserInfo() {
            $.ajax({
                url: 'api/user/info',
                type: 'GET',
                success: function(response) {
                    if (response.success) {
                        const user = response.data;
                        $('#name').val(user.username);
                        $('#phone').val(user.phone);
                        $('#address').val(user.address);
                    }
                }
            });
        }

        function loadCartItems() {
            $.ajax({
                url: 'api/cart',
                type: 'GET',
                success: function(response) {
                    if (response.success) {
                        let html = '';
                        let total = 0;
                        
                        response.data.forEach(item => {
                            const subtotal = item.price * item.quantity;
                            total += subtotal;
                            html += `
                                <div class="order-item">
                                    <div>${item.productName}</div>
                                    <div>￥${item.price} × ${item.quantity} = ￥${subtotal.toFixed(2)}</div>
                                </div>
                            `;
                        });
                        
                        $('#orderItems').html(html);
                        $('#totalAmount').text(total.toFixed(2));
                    }
                }
            });
        }

        function submitOrder() {
            const orderData = {
                name: $('#name').val(),
                phone: $('#phone').val(),
                address: $('#address').val(),
                note: $('#note').val()
            };
            
            $.ajax({
                url: 'api/orders/create',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(orderData),
                success: function(response) {
                    if (response.success) {
                        alert('订单提交成功！');
                        window.location.href = 'payment.jsp?orderId=' + response.data.orderId;
                    } else {
                        alert(response.message || '订单提交失败，请稍后重试');
                    }
                },
                error: function() {
                    alert('订单提交失败，请稍后重试');
                }
            });
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