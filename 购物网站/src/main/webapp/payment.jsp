<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单支付 - 购物网站</title>
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
        .main-container {
            max-width: 800px;
            margin: 80px auto 20px;
            padding: 20px;
        }
        .payment-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .payment-methods {
            margin: 20px 0;
        }
        .payment-method {
            border: 1px solid #ddd;
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            cursor: pointer;
        }
        .payment-method:hover {
            background-color: #f8f9fa;
        }
        .payment-method.selected {
            border-color: #007bff;
            background-color: #f8f9fa;
        }
        .pay-btn {
            width: 100%;
            padding: 10px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 20px;
        }
        .pay-btn:hover {
            background-color: #218838;
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
        <h2>订单支付</h2>
        <div class="payment-info">
            <h3>订单信息</h3>
            <p>订单号：<span id="orderNumber"></span></p>
            <p>支付金额：￥<span id="payAmount"></span></p>
        </div>
        
        <div class="payment-methods">
            <h3>选择支付方式</h3>
            <div class="payment-method" onclick="selectPaymentMethod('alipay')">
                <input type="radio" name="paymentMethod" value="alipay"> 支付宝支付
            </div>
            <div class="payment-method" onclick="selectPaymentMethod('wechat')">
                <input type="radio" name="paymentMethod" value="wechat"> 微信支付
            </div>
            <div class="payment-method" onclick="selectPaymentMethod('card')">
                <input type="radio" name="paymentMethod" value="card"> 银行卡支付
            </div>
        </div>
        
        <button class="pay-btn" onclick="pay()">确认支付</button>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            loadUserInfo();
            loadOrderInfo();
            
            $('.payment-method').click(function() {
                $('.payment-method').removeClass('selected');
                $(this).addClass('selected');
                $(this).find('input[type="radio"]').prop('checked', true);
            });
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
                        window.location.href = 'login.jsp';
                    }
                }
            });
        }

        function loadOrderInfo() {
            const urlParams = new URLSearchParams(window.location.search);
            const orderId = urlParams.get('orderId');
            
            $.ajax({
                url: `api/orders/${orderId}`,
                type: 'GET',
                success: function(response) {
                    if (response.success) {
                        const order = response.data;
                        $('#orderNumber').text(order.orderNumber);
                        $('#payAmount').text(order.totalAmount.toFixed(2));
                    } else {
                        alert('订单不存在');
                        window.location.href = 'orders.jsp';
                    }
                }
            });
        }

        function selectPaymentMethod(method) {
            $(`input[value="${method}"]`).prop('checked', true);
        }

        function pay() {
            const paymentMethod = $('input[name="paymentMethod"]:checked').val();
            if (!paymentMethod) {
                alert('请选择支付方式');
                return;
            }
            
            const urlParams = new URLSearchParams(window.location.search);
            const orderId = urlParams.get('orderId');
            
            $.ajax({
                url: 'api/orders/pay',
                type: 'POST',
                data: {
                    orderId: orderId,
                    paymentMethod: paymentMethod
                },
                success: function(response) {
                    if (response.success) {
                        alert('支付成功！');
                        window.location.href = 'orders.jsp';
                    } else {
                        alert(response.message);
                    }
                },
                error: function() {
                    alert('支付失败，请稍后重试');
                }
            });
        }
    </script>
</body>
</html> 