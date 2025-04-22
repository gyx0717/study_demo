<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>注册 - 购物网站</title>
    <style>
        .register-container {
            width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group input, .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .form-group textarea {
            min-height: 80px;
            resize: vertical;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .login-link {
            text-align: center;
            margin-top: 15px;
        }
        .login-link a {
            color: #007bff;
            text-decoration: none;
        }
        .form-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>用户注册</h2>
        <form id="registerForm">
            <div class="form-group">
                <input type="text" id="username" name="username" placeholder="用户名" required 
                       minlength="3" maxlength="20">
                <small class="form-text">用户名长度必须在3-20个字符之间</small>
            </div>
            <div class="form-group">
                <input type="password" id="password" name="password" placeholder="密码" required 
                       minlength="6">
                <small class="form-text">密码长度不能少于6个字符</small>
            </div>
            <div class="form-group">
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="确认密码" required>
            </div>
            <div class="form-group">
                <input type="email" id="email" name="email" placeholder="电子邮箱">
            </div>
            <div class="form-group">
                <input type="tel" id="phone" name="phone" placeholder="手机号码">
            </div>
            <div class="form-group">
                <textarea id="address" name="address" placeholder="收货地址"></textarea>
            </div>
            <button type="submit">注册</button>
            <p class="login-link">已有账号？<a href="login.jsp">立即登录</a></p>
        </form>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#registerForm').on('submit', function(e) {
                e.preventDefault();
                
                const password = $('#password').val();
                const confirmPassword = $('#confirmPassword').val();
                
                if (password !== confirmPassword) {
                    alert('两次输入的密码不一致！');
                    return;
                }
                
                $.ajax({
                    url: 'api/user/register',
                    type: 'POST',
                    data: {
                        username: $('#username').val(),
                        password: password,
                        email: $('#email').val(),
                        phone: $('#phone').val(),
                        address: $('#address').val()
                    },
                    success: function(response) {
                        if (response.success) {
                            alert('注册成功！即将跳转到登录页面...');
                            setTimeout(function() {
                                window.location.href = 'login.jsp';
                            }, 1500);
                        } else {
                            alert(response.message || '注册失败，请稍后重试');
                        }
                    },
                    error: function() {
                        alert('注册失败，请稍后重试');
                    }
                });
            });
        });
    </script>
</body>
</html> 