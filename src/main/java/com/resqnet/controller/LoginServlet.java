package com.resqnet.controller;

import com.resqnet.model.User;
import com.resqnet.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "login", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        if (email == null || password == null) {
            req.setAttribute("error", "Email and password required");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }
        Optional<User> userOpt = userDAO.findByEmail(email);
        if (!userOpt.isPresent() || !BCrypt.checkpw(password, userOpt.get().getPasswordHash())) {
            req.setAttribute("error", "Invalid credentials");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }
        User user = userOpt.get();
        req.getSession(true).setAttribute("authUser", user);
        // Redirect by role
        if (user.isGramaNiladhari()) {
            resp.sendRedirect(req.getContextPath() + "/gn/dashboard");
        } else if (user.isDMC()) {
            resp.sendRedirect(req.getContextPath() + "/dmc/dashboard");
        } else if (user.isNGO()) {
            resp.sendRedirect(req.getContextPath() + "/ngo/dashboard");
        } else if (user.isVolunteer()) {
            resp.sendRedirect(req.getContextPath() + "/volunteer/dashboard");
        } else {
            // General user
            resp.sendRedirect(req.getContextPath() + "/user/dashboard");
        }
    }
}
