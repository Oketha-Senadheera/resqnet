<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Volunteer - ResQnet</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/style.css">
    <style>
        .signup-form {
            max-width: 1000px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .form-layout {
            display: grid;
            gap: 2rem;
            grid-template-columns: 1fr 1fr;
        }
        @media (max-width: 860px) {
            .form-layout {
                grid-template-columns: 1fr;
            }
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
        .two-col-inline {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        .checkbox-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        .checkbox-group label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
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
        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin: 1rem 0 0.5rem 0;
        }
    </style>
</head>
<body>
    <div class="signup-form">
        <h1>Volunteer Registration</h1>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <form method="post" action="${pageContext.request.contextPath}/signup-volunteer">
            <div class="form-layout">
                <div class="col-left">
                    <div class="form-field">
                        <label for="fullName">Name *</label>
                        <input type="text" id="fullName" name="fullName" required>
                    </div>
                    <div class="two-col-inline">
                        <div class="form-field">
                            <label for="age">Age</label>
                            <input type="number" id="age" name="age" min="16">
                        </div>
                        <div class="form-field">
                            <label for="gender">Gender</label>
                            <select id="gender" name="gender">
                                <option value="">Select</option>
                                <option value="male">Male</option>
                                <option value="female">Female</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-field">
                        <label for="contactNo">Contact No *</label>
                        <input type="tel" id="contactNo" name="contactNo" required>
                    </div>
                    
                    <h2 class="section-title">Address</h2>
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
                            <option>Galle</option>
                        </select>
                    </div>
                    <div class="form-field">
                        <label for="gnDivision">Grama Niladhari Division</label>
                        <input type="text" id="gnDivision" name="gnDivision">
                    </div>
                </div>
                
                <div class="col-right">
                    <h2 class="section-title">Volunteer Preferences</h2>
                    <div class="checkbox-group">
                        <label><input type="checkbox" name="preferences" value="Search & Rescue"> Search & Rescue</label>
                        <label><input type="checkbox" name="preferences" value="Medical Aid"> Medical Aid</label>
                        <label><input type="checkbox" name="preferences" value="Logistics Support"> Logistics Support</label>
                        <label><input type="checkbox" name="preferences" value="Technical Support"> Technical Support</label>
                        <label><input type="checkbox" name="preferences" value="Shelter Management"> Shelter Management</label>
                        <label><input type="checkbox" name="preferences" value="Food Preparation & Distribution"> Food Preparation & Distribution</label>
                        <label><input type="checkbox" name="preferences" value="Childcare Support"> Childcare Support</label>
                        <label><input type="checkbox" name="preferences" value="Elderly Assistance"> Elderly Assistance</label>
                    </div>
                    
                    <h2 class="section-title">Specialized Skills</h2>
                    <div class="checkbox-group">
                        <label><input type="checkbox" name="skills" value="First Aid Certified"> First Aid Certified</label>
                        <label><input type="checkbox" name="skills" value="Medical Professional"> Medical Professional</label>
                        <label><input type="checkbox" name="skills" value="Firefighting"> Firefighting</label>
                        <label><input type="checkbox" name="skills" value="Swimming / Lifesaving"> Swimming / Lifesaving</label>
                        <label><input type="checkbox" name="skills" value="Rescue & Handling"> Rescue & Handling</label>
                        <label><input type="checkbox" name="skills" value="Disaster Management Training"> Disaster Management Training</label>
                    </div>
                    
                    <h2 class="section-title">Account Details</h2>
                    <div class="form-field">
                        <label for="username">Username *</label>
                        <input type="text" id="username" name="username" required>
                    </div>
                    <div class="form-field">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" required>
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
            </div>
            
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Register</button>
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
