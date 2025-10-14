<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - ResQnet</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/style.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        .signup-selector {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            padding: 3rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        .signup-selector h1 {
            text-align: center;
            color: #333;
            margin-bottom: 1rem;
        }
        .signup-selector p {
            text-align: center;
            color: #666;
            margin-bottom: 3rem;
        }
        .signup-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }
        .signup-card {
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .signup-card:hover {
            border-color: #667eea;
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
        }
        .signup-card-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        .signup-card h2 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: #333;
        }
        .signup-card p {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
        }
        .signup-card .btn {
            background: #667eea;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            transition: background 0.3s ease;
        }
        .signup-card:hover .btn {
            background: #5568d3;
        }
        .login-link {
            text-align: center;
            margin-top: 2rem;
            color: #666;
        }
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="signup-selector">
        <h1>Join ResQnet</h1>
        <p>Choose your role to get started with disaster response and community support</p>
        
        <div class="signup-options">
            <a href="${pageContext.request.contextPath}/signup-general" class="signup-card">
                <div class="signup-card-icon">👤</div>
                <h2>General User</h2>
                <p>Access disaster information, receive alerts, and stay informed about safety resources</p>
                <button class="btn">Sign Up as General User</button>
            </a>
            
            <a href="${pageContext.request.contextPath}/signup-volunteer" class="signup-card">
                <div class="signup-card-icon">🤝</div>
                <h2>Volunteer</h2>
                <p>Contribute your skills and time to help communities during disaster response efforts</p>
                <button class="btn">Sign Up as Volunteer</button>
            </a>
            
            <a href="${pageContext.request.contextPath}/signup-ngo" class="signup-card">
                <div class="signup-card-icon">🏢</div>
                <h2>NGO/Organization</h2>
                <p>Register your organization to coordinate relief efforts and manage resources</p>
                <button class="btn">Sign Up as NGO</button>
            </a>
        </div>
        
        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
        </div>
    </div>
</body>
</html>
