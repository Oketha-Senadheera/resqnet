package com.resqnet.controller;

import com.resqnet.model.GeneralUser;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.GeneralUserDAO;
import com.resqnet.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet(name = "generalUserSignup", urlPatterns = "/signup/general")
public class GeneralUserSignupServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final GeneralUserDAO generalUserDAO = new GeneralUserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/general-user/signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Get user account details
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            
            // Get general user details
            String name = req.getParameter("name");
            String contactNumber = req.getParameter("contactNumber");
            String houseNo = req.getParameter("houseNo");
            String street = req.getParameter("street");
            String city = req.getParameter("city");
            String district = req.getParameter("district");
            String gnDivision = req.getParameter("gnDivision");
            boolean smsAlert = "on".equals(req.getParameter("smsAlert"));

            // Validate required fields
            if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                name == null || name.trim().isEmpty()) {
                req.setAttribute("error", "Required fields are missing");
                req.getRequestDispatcher("/WEB-INF/views/general-user/signup.jsp").forward(req, resp);
                return;
            }

            // Create user account
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setRole(Role.GENERAL);
            
            int userId = userDAO.create(user);

            // Create general user profile
            GeneralUser generalUser = new GeneralUser();
            generalUser.setUserId(userId);
            generalUser.setName(name);
            generalUser.setContactNumber(contactNumber);
            generalUser.setHouseNo(houseNo);
            generalUser.setStreet(street);
            generalUser.setCity(city);
            generalUser.setDistrict(district);
            generalUser.setGnDivision(gnDivision);
            generalUser.setSmsAlert(smsAlert);
            
            generalUserDAO.create(generalUser);

            // Redirect to login
            resp.sendRedirect(req.getContextPath() + "/login?registered=1");
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/general-user/signup.jsp").forward(req, resp);
        }
    }
}
