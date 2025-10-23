package com.resqnet.controller.auth;

import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.Volunteer;
import com.resqnet.model.dao.UserDAO;
import com.resqnet.model.dao.VolunteerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet(name = "volunteerSignup", urlPatterns = "/signup/volunteer")
public class VolunteerSignupServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final VolunteerDAO volunteerDAO = new VolunteerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/volunteer/signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int createdUserId = 0;
        try {
            // Get user account details
            String username = trim(req.getParameter("username"));
            String email = trim(req.getParameter("email"));
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");

            // Get volunteer details
            String name = trim(req.getParameter("name"));
            String ageStr = trim(req.getParameter("age"));
            String gender = trim(req.getParameter("gender"));
            String contactNumber = trim(req.getParameter("contactNumber"));
            String houseNo = trim(req.getParameter("houseNo"));
            String street = trim(req.getParameter("street"));
            String city = trim(req.getParameter("city"));
            String district = trim(req.getParameter("district"));
            String gnDivision = trim(req.getParameter("gnDivision"));

            // Get skills and preferences (multi-select)
            String[] skills = req.getParameterValues("skills");
            String[] preferences = req.getParameterValues("preferences");

            // Validate required fields
            if (isBlank(username) || isBlank(email) || isBlank(password) || isBlank(name)) {
                req.setAttribute("error", "Required fields are missing");
                req.getRequestDispatcher("/WEB-INF/views/volunteer/signup.jsp").forward(req, resp);
                return;
            }

            // Confirm password check (only applicable when creating a new account)
            if (confirmPassword != null && !password.equals(confirmPassword)) {
                req.setAttribute("error", "Passwords do not match");
                req.getRequestDispatcher("/WEB-INF/views/volunteer/signup.jsp").forward(req, resp);
                return;
            }

            // Duplicate checks for better UX before hitting DB constraints
            if (userDAO.findByUsername(username).isPresent()) {
                req.setAttribute("error", "Username is already taken");
                req.getRequestDispatcher("/WEB-INF/views/volunteer/signup.jsp").forward(req, resp);
                return;
            }
            if (userDAO.findByEmail(email).isPresent()) {
                req.setAttribute("error", "An account with this email already exists");
                req.getRequestDispatcher("/WEB-INF/views/volunteer/signup.jsp").forward(req, resp);
                return;
            }

            // Normalize gender: empty -> null
            if (gender != null && gender.isEmpty()) gender = null;

            // Create user account
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setRole(Role.VOLUNTEER);

            createdUserId = userDAO.create(user);

            // Create volunteer profile
            Volunteer volunteer = new Volunteer();
            volunteer.setUserId(createdUserId);
            volunteer.setName(name);
            if (!isBlank(ageStr)) {
                try {
                    volunteer.setAge(Integer.parseInt(ageStr));
                } catch (NumberFormatException ignored) { /* ignore invalid age */ }
            }
            volunteer.setGender(gender);
            volunteer.setContactNumber(contactNumber);
            volunteer.setHouseNo(houseNo);
            volunteer.setStreet(street);
            volunteer.setCity(city);
            volunteer.setDistrict(district);
            volunteer.setGnDivision(gnDivision);

            volunteerDAO.create(volunteer);

            // Add skills
            if (skills != null) {
                for (String skill : skills) {
                    if (!isBlank(skill)) {
                        volunteerDAO.addSkill(createdUserId, skill.trim());
                    }
                }
            }

            // Add preferences
            if (preferences != null) {
                for (String preference : preferences) {
                    if (!isBlank(preference)) {
                        volunteerDAO.addPreference(createdUserId, preference.trim());
                    }
                }
            }

            // Redirect to login
            resp.sendRedirect(req.getContextPath() + "/login?registered=1");
        } catch (Exception e) {
            // Best-effort cleanup if user was created but subsequent steps failed
            if (createdUserId > 0) {
                try { userDAO.delete(createdUserId); } catch (Exception ignored) { }
            }
            req.setAttribute("error", "An error occurred during registration: " + (e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName()));
            req.getRequestDispatcher("/WEB-INF/views/volunteer/signup.jsp").forward(req, resp);
        }
    }

    private static String trim(String s) { return s == null ? null : s.trim(); }
    private static boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
}
