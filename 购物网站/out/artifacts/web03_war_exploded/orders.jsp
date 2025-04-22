<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的订单 - 购物网站</title>
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
        }
        .nav a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
        }
        .nav a.active {
            background-color: #007bff;
            border-radius: 4px;
        }
        .main-container {
            max-width: 1200px;
            margin: 80px auto 20px;
            padding: 20px;
        }
        .order-list {
            list-style: none;
            padding: 0;
        }
        .order-item {
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 20px;
            padding: 20px;
            background: white;
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }
        .order-products {
            margin: 10px 0;
        }
        .product-item {
            display: flex;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .product-image {
            width: 50px;
            height: 50px;
            margin-right: 10px;
            object-fit: cover;
            border-radius: 4px;
        }
        .product-info {
            flex: 1;
        }
        .order-total {
            text-align: right;
            margin-top: 10px;
            font-weight: bold;
            color: #e44d26;
        }
        .status-pending {
            color: #ffc107;
            font-weight: bold;
        }
        .status-paid {
            color: #28a745;
            font-weight: bold;
        }
        .status-shipped {
            color: #17a2b8;
            font-weight: bold;
        }
        .status-completed {
            color: #6c757d;
            font-weight: bold;
        }
        .pay-button {
            padding: 5px 15px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 10px;
        }
        .pay-button:hover {
            background-color: #218838;
        }
        .sample-orders {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        .sample-orders h3 {
            color: #666;
            text-align: center;
            margin-bottom: 20px;
        }
        .sample-orders .order-item {
            opacity: 0.8;
        }
        .sample-orders a {
            color: #007bff;
            text-decoration: none;
        }
        .sample-orders a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="nav">
            <a href="index.jsp">首页</a>
            <a href="products.jsp">商品列表</a>
            <a href="cart.jsp">购物车</a>
            <a href="orders.jsp" class="active">我的订单</a>
            <div class="user-info" id="userInfo"></div>
        </div>
    </div>
    
    <div class="main-container">
        <h2>我的订单</h2>
        <ul class="order-list" id="orderList">
            <!-- 订单列表将通过JavaScript动态加载 -->
        </ul>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            loadUserInfo();
            loadOrders();
        });

        function loadUserInfo() {
            $.ajax({
                url: 'api/user/info',
                type: 'GET',
                success: function(response) {
                    if (response.success) {
                        const user = response.data;
                        $('#userInfo').html(
                            '<span class="welcome-message">欢迎, ' + user.username + '</span>' +
                            '<a href="javascript:void(0)" onclick="logout()">退出</a>'
                        );
                    } else {
                        $('#userInfo').html('<a href="login.jsp">登录</a>');
                    }
                },
                error: function() {
                    $('#userInfo').html('<a href="login.jsp">登录</a>');
                }
            });
        }

        function loadOrders() {
            $.ajax({
                url: 'api/orders',
                type: 'GET',
                success: function(response) {
                    let html = '';
                    if (response.success) {
                        // 用户已登录，显示订单数据
                        const orders = response.data;
                        if (orders && orders.length > 0) {
                            orders.forEach(function(order) {
                                html += '<li class="order-item">' +
                                    '<div class="order-header">' +
                                    '<span>订单号：' + order.orderNumber + '</span>' +
                                    '<span>下单时间：' + order.createTime + '</span>' +
                                    '<span class="status-' + order.status.toLowerCase() + '">' +
                                    getStatusText(order.status) +
                                    '</span>' +
                                    '</div>' +
                                    '<div class="order-products">' +
                                    renderOrderProducts(order.products) +
                                    '</div>' +
                                    '<div class="order-total">' +
                                    '总计：￥' + order.totalAmount.toFixed(2) +
                                    '</div>' +
                                    '</li>';
                            });
                        } else {
                            html = '<p style="text-align: center;">暂无订单数据</p>';
                        }
                    } else {
                        // 用户未登录，显示示例订单
                        html = '<div class="sample-orders">' +
                            '<h3>订单</h3>' +
                            '<li class="order-item">' +
                            '<div class="order-header">' +
                            '<span>订单号：SAMPLE-001</span>' +
                            '<span>下单时间：2024-03-19 10:00:00</span>' +
                            '<span class="status-completed">已完成</span>' +
                            '</div>' +
                            '<div class="order-products">' +
                            '<div class="product-item">' +
                            '<img src="images/iphone13.png" class="product-image" alt="iPhone 13">' +
                            '<div class="product-info">' +
                            '<div>iPhone 13</div>' +
                            '<div>￥5999.00 × 1</div>' +
                            '</div>' +
                            '</div>' +
                            '</div>' +
                            '<div class="order-total">' +
                            '总计：￥5999.00' +
                            '</div>' +
                            '</li>' +
                            '<p style="text-align: center; margin-top: 20px;">' +

                            '</p>' +
                            '</div>';
                    }
                    $('#orderList').html(html);
                },
                error: function() {
                    // 发生错误时也显示示例订单
                    $('#orderList').html(
                        '<div class="sample-orders">' +
                        '<h3>订单</h3>' +
                        '<li class="order-item">' +
                        '<div class="order-header">' +
                        '<span>订单号：SAMPLE-001</span>' +
                        '<span>下单时间：2024-03-19 10:00:00</span>' +
                        '<span class="status-completed">已完成</span>' +
                        '</div>' +
                        '<div class="order-products">' +
                        '<div class="product-item">' +
                        '<img src="images/iphone13.png" class="product-image" alt="iPhone 13">' +
                        '<div class="product-info">' +
                        '<div>iPhone 13</div>' +
                        '<div>￥5999.00 × 1</div>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div class="order-total">' +
                        '总计：￥5999.00' +
                        '</div>' +
                        '</li>' +
                        '<p style="text-align: center; margin-top: 20px;">' +

                        '</p>' +
                        '</div>'
                    );
                }
            });
        }
    </script>
</body>
</html> 