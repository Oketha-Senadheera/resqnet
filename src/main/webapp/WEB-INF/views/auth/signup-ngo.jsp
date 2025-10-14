<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - NGO - ResQnet</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/style.css">
    <style>
        .signup-form {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .form-grid {
            display: grid;
            gap: 1rem;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        }
        .form-field {
            margin-bottom: 1rem;
        }
        .form-field.wide {
            grid-column: 1 / -1;
        }
        .form-field label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }
        .form-field input, .form-field select {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .error-message {
            color: #d32f2f;
            padding: 1rem;
            margin-bottom: 1rem;
            background: #ffebee;
            border-radius: 4px;
        }
        .form-actions {
            margin-top: 1.5rem;
            display: flex;
            gap: 1rem;
        }
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
        }
        .btn-primary {
            background: #1976d2;
            color: white;
        }
        .btn-secondary {
            background: #666;
            color: white;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="signup-form">
        <h1>Sign up your organization</h1>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <form method="post" action="${pageContext.request.contextPath}/signup-ngo">
            <div class="form-grid">
                <div class="form-field wide">
                    <label for="orgName">Organization Name *</label>
                    <input type="text" id="orgName" name="orgName" required>
                </div>
                <div class="form-field">
                    <label for="regNo">Registration No. *</label>
                    <input type="text" id="regNo" name="regNo" required>
                </div>
                <div class="form-field">
                    <label for="years">Years of Operation</label>
                    <input type="number" id="years" name="years" min="0">
                </div>
                <div class="form-field">
                    <label for="contactPerson">Contact Person Name *</label>
                    <input type="text" id="contactPerson" name="contactPerson" required>
                </div>
                <div class="form-field">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-field">
                    <label for="telephone">Telephone *</label>
                    <input type="tel" id="telephone" name="telephone" required>
                </div>
                <div class="form-field wide">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address">
                </div>
                <div class="form-field">
                    <label for="username">Username *</label>
                    <input type="text" id="username" name="username" minlength="3" required>
                </div>
                <div class="form-field">
                    <!-- Placeholder for layout -->
                </div>
                <div class="form-field">
                    <label for="password">Password *</label>
                    <input type="password" id="password" name="password" minlength="8" required>
                    <small>Minimum 8 characters</small>
                </div>
                <div class="form-field">
                    <label for="confirmPassword">Confirm Password *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" minlength="8" required>
                </div>
            </div>
            
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Sign Up</button>
            </div>
        </form>
    </div>
    
    <script>
        // Password confirmation validation
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        
        confirmPassword.addEventListener('input', function() {
            if (password.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity('Passwords do not match');
            } else {
                confirmPassword.setCustomValidity('');
            }
        });
    </script>
</body>
</html>
