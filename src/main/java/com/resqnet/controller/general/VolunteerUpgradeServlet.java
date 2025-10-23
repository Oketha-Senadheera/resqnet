package com.resqnet.controller.general;

import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.Volunteer;
import com.resqnet.model.dao.GeneralUserDAO;
import com.resqnet.model.dao.UserDAO;
import com.resqnet.model.dao.VolunteerDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/general/volunteer-upgrade")
public class VolunteerUpgradeServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final VolunteerDAO volunteerDAO = new VolunteerDAO();
    private final GeneralUserDAO generalUserDAO = new GeneralUserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        
        // Check if user has GENERAL role
        if (user.getRole() != Role.GENERAL) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            // Get volunteer details from form
            String name = req.getParameter("name");
            String ageStr = req.getParameter("age");
            String gender = req.getParameter("gender");
            String contactNumber = req.getParameter("contactNumber");
            String houseNo = req.getParameter("houseNo");
            String street = req.getParameter("street");
            String city = req.getParameter("city");
            String district = req.getParameter("district");
            String gnDivision = req.getParameter("gnDivision");

            // Get skills and preferences (multi-select)
            String[] skills = req.getParameterValues("skills");
            String[] preferences = req.getParameterValues("preferences");

            // Validate required fields
            if (name == null || name.trim().isEmpty()) {
                req.setAttribute("error", "Name is required");
                req.getRequestDispatcher("/WEB-INF/views/general-user/be-volunteer.jsp").forward(req, resp);
                return;
            }

            // Create volunteer profile
            Volunteer volunteer = new Volunteer();
            volunteer.setUserId(user.getId());
            volunteer.setName(name);
            if (ageStr != null && !ageStr.trim().isEmpty()) {
                try {
                    volunteer.setAge(Integer.parseInt(ageStr));
                } catch (NumberFormatException e) {
                    // Ignore invalid age
                }
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
                    if (skill != null && !skill.trim().isEmpty()) {
                        volunteerDAO.addSkill(user.getId(), skill);
                    }
                }
            }

            // Add preferences
            if (preferences != null) {
                for (String preference : preferences) {
                    if (preference != null && !preference.trim().isEmpty()) {
                        volunteerDAO.addPreference(user.getId(), preference);
                    }
                }
            }

            // Update user role to VOLUNTEER
            userDAO.updateRole(user.getId(), Role.VOLUNTEER);

            // Delete general user record
            generalUserDAO.delete(user.getId());

            // Update session with new role
            user.setRole(Role.VOLUNTEER);
            session.setAttribute("authUser", user);

            // Redirect to volunteer dashboard
            resp.sendRedirect(req.getContextPath() + "/volunteer/dashboard");
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred during upgrade: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/general-user/be-volunteer.jsp").forward(req, resp);
        }
    }
}
