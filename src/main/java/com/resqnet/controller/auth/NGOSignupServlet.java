package com.resqnet.controller.auth;

import com.resqnet.model.NGO;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.NGODAO;
import com.resqnet.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet(name = "ngoSignup", urlPatterns = "/signup/ngo")
public class NGOSignupServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final NGODAO ngoDAO = new NGODAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/ngo/signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Get user account details
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            
            // Get NGO details
            String orgName = req.getParameter("orgName");
            String regNo = req.getParameter("regNo");
            String yearsStr = req.getParameter("years");
            String address = req.getParameter("address");
            String contactPerson = req.getParameter("contactPerson");
            String telephone = req.getParameter("telephone");
            String contactEmail = req.getParameter("contactEmail");

            // Validate required fields
            if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                orgName == null || orgName.trim().isEmpty() ||
                regNo == null || regNo.trim().isEmpty()) {
                req.setAttribute("error", "Required fields are missing");
                req.getRequestDispatcher("/WEB-INF/views/ngo/signup.jsp").forward(req, resp);
                return;
            }

            // Create user account
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setRole(Role.NGO);
            
            int userId = userDAO.create(user);

            // Create NGO profile
            NGO ngo = new NGO();
            ngo.setUserId(userId);
            ngo.setOrganizationName(orgName);
            ngo.setRegistrationNumber(regNo);
            if (yearsStr != null && !yearsStr.trim().isEmpty()) {
                try {
                    ngo.setYearsOfOperation(Integer.parseInt(yearsStr));
                } catch (NumberFormatException e) {
                    // Ignore invalid years
                }
            }
            ngo.setAddress(address);
            ngo.setContactPersonName(contactPerson);
            ngo.setContactPersonTelephone(telephone);
            ngo.setContactPersonEmail(contactEmail);
            
            ngoDAO.create(ngo);

            // Redirect to login
            resp.sendRedirect(req.getContextPath() + "/login?registered=1");
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/ngo/signup.jsp").forward(req, resp);
        }
    }
}
