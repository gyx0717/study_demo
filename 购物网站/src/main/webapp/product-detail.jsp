<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品详情 - 购物网站</title>
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
            display: flex;
            gap: 30px;
        }
        .product-image {
            width: 400px;
            height: 400px;
            object-fit: cover;
            border-radius: 8px;
        }
        .product-info {
            flex: 1;
        }
        .product-price {
            color: #e44d26;
            font-size: 24px;
            font-weight: bold;
            margin: 20px 0;
        }
        .product-description {
            color: #666;
            line-height: 1.6;
            margin: 20px 0;
        }
        .quantity-section {
            margin: 20px 0;
        }
        .quantity-input {
            width: 60px;
            padding: 5px;
            text-align: center;
            margin-right: 10px;
        }
        .add-to-cart-btn {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .add-to-cart-btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="nav">
            <a href="index.jsp">首页</a>
            <a href="products.jsp">商品列表</a>
            <a href="cart.jsp">购物车</a>
            <a href="orders.jsp">我的订单</a>
            <div class="user-info" id="userInfo"></div>
        </div>
    </div>
    
    <div class="main-container">
        <img id="productImage" class="product-image" src="" alt="">
        <div class="product-info">
            <h1 id="productName"></h1>
            <div class="product-price">￥<span id="productPrice"></span></div>
            <div class="product-description" id="productDescription"></div>
            <div class="quantity-section">
                <input type="number" id="quantity" name="quantity" class="quantity-input" value="1" min="1">
                <button class="add-to-cart-btn" onclick="addToCart()">加入购物车</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            loadUserInfo();
            loadProductDetail();
        });

        function loadUserInfo() {
            $.ajax({
                url: 'api/user/info',
                type: 'GET',
                success: function(response) {
                    if (response.success) {
                        const user = response.data;
                        $('#userInfo').html(`
                            <span>欢迎, ${user.username}</span>
                            <a href="javascript:void(0)" onclick="logout()">退出</a>
                        `);
                    } else {
                        $('#userInfo').html('<a href="login.jsp">登录</a>');
                    }
                }
            });
        }

        function loadProductDetail() {
            const urlParams = new URLSearchParams(window.location.search);
            const productId = urlParams.get('id');
            
            $.ajax({
                url: `api/products/${productId}`,
                type: 'GET',
                success: function(response) {
                    if (response.success) {
                        const product = response.data;
                        $('#productImage').attr('src', product.imageUrl);
                        $('#productName').text(product.name);
                        $('#productPrice').text(product.price);
                        $('#productDescription').text(product.description);
                    } else {
                        alert('商品不存在');
                        window.location.href = 'products.jsp';
                    }
                }
            });
        }

        function addToCart() {
            const urlParams = new URLSearchParams(window.location.search);
            const productId = urlParams.get('id');
            const quantity = $('#quantity').val();
            
            $.ajax({
                url: 'api/cart/add',
                type: 'POST',
                data: {
                    productId: productId,
                    quantity: quantity
                },
                success: function(response) {
                    if (response.success) {
                        alert('添加到购物车成功！');
                    } else {
                        alert(response.message);
                    }
                },
                error: function() {
                    alert('添加失败，请稍后重试');
                }
            });
        }
    </script>
</body>
</html> 