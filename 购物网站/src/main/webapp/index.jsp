<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>首页 - 购物网站</title>
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
        .featured-product {
            text-align: center;
            margin: 40px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .product-image {
            max-width: 300px;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .music-player {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.9);
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }

        .music-player audio {
            width: 250px;
            height: 40px;
        }

        /* 美化音频控件 */
        audio::-webkit-media-controls-panel {
            background-color: #f8f9fa;
        }

        audio::-webkit-media-controls-play-button {
            background-color: #007bff;
            border-radius: 50%;
        }

        audio::-webkit-media-controls-play-button:hover {
            background-color: #0056b3;
        }

        audio::-webkit-media-controls-current-time-display,
        audio::-webkit-media-controls-time-remaining-display {
            color: #333;
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

    <div class="music-player">
        <audio id="bgMusic" controls autoplay loop>
            <source src="music/恭喜发财.mp3" type="audio/mpeg">
            您的浏览器不支持音频播放
        </audio>
    </div>

    <div class="main-container">
        <h1>欢迎来到购物网站</h1>
        
        <div class="featured-product">
            <h2>特色商品</h2>
            <img src="images/iphone13.png" alt="iPhone 13" class="product-image">
            <h3>iPhone 13</h3>
            <p>畅销款iPhone手机，尽享科技魅力</p>
            <p>价格：￥5999.00</p>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function logout() {
            $.ajax({
                url: 'api/user/logout',
                type: 'POST',
                success: function(response) {
                    window.location.href = 'login.jsp';
                }
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            const audio = document.getElementById('bgMusic');
            
            // 设置初始音量
            audio.volume = 0.5;
            
            // 添加音乐自动播放
            audio.play().catch(function(error) {
                console.log("自动播放被阻止：", error);
            });
            
            // 页面可见性改变时控制��乐
            document.addEventListener('visibilitychange', function() {
                if (document.hidden) {
                    audio.pause();
                } else {
                    audio.play().catch(function(error) {
                        console.log("播放被阻止：", error);
                    });
                }
            });
        });
    </script>
</body>
</html> 