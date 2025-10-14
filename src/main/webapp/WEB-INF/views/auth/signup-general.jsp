<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - General User - ResQnet</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/style.css">
    <style>
        .signup-form {
            max-width: 640px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .form-sections {
            display: grid;
            gap: 1.5rem;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        }
        .form-field {
            margin-bottom: 1rem;
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
        .form-field input[type="checkbox"] {
            width: auto;
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
            flex: 1;
        }
        .btn-primary {
            background: #1976d2;
            color: white;
        }
        .btn-secondary {
            background: #666;
            color: white;
        }
    </style>
</head>
<body>
    <div class="signup-form">
        <h1>Sign up - General User</h1>
        <p>Create your account to access disaster response resources</p>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <form method="post" action="${pageContext.request.contextPath}/signup-general">
            <div class="form-sections">
                <section>
                    <h2>Personal Information</h2>
                    <div class="form-field">
                        <label for="fullName">Name *</label>
                        <input type="text" id="fullName" name="fullName" required>
                    </div>
                    <div class="form-field">
                        <label for="contactNo">Contact No *</label>
                        <input type="tel" id="contactNo" name="contactNo" required>
                    </div>
                    <div class="form-field">
                        <label for="username">Username *</label>
                        <input type="text" id="username" name="username" minlength="3" required>
                    </div>
                    <div class="form-field">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-field">
                        <label for="password">Password *</label>
                        <input type="password" id="password" name="password" minlength="6" required>
                    </div>
                    <div class="form-field">
                        <label for="confirmPassword">Confirm Password *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" minlength="6" required>
                    </div>
                </section>
                
                <section>
                    <h2>Address</h2>
                    <div class="form-field">
                        <label for="houseNo">House No</label>
                        <input type="text" id="houseNo" name="houseNo">
                    </div>
                    <div class="form-field">
                        <label for="street">Street</label>
                        <input type="text" id="street" name="street">
                    </div>
                    <div class="form-field">
                        <label for="city">City</label>
                        <input type="text" id="city" name="city">
                    </div>
                    <div class="form-field">
                        <label for="district">District</label>
                        <select id="district" name="district">
                            <option value="">Select District</option>
                            <option>Colombo</option>
                            <option>Gampaha</option>
                            <option>Kalutara</option>
                            <option>Kandy</option>
                            <option>Matale</option>
                            <option>Nuwara Eliya</option>
                            <option>Galle</option>
                            <option>Matara</option>
                            <option>Hambantota</option>
                        </select>
                    </div>
                    <div class="form-field">
                        <label for="gnDivision">Grama Niladari Division</label>
                        <input type="text" id="gnDivision" name="gnDivision">
                    </div>
                    <div class="form-field">
                        <label>
                            <input type="checkbox" id="smsAlert" name="smsAlert">
                            Enable SMS Alerts
                        </label>
                    </div>
                </section>
            </div>
            
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Back to Login</a>
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
