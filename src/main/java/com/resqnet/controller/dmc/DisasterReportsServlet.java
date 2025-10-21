package com.resqnet.controller.dmc;

import com.resqnet.model.DisasterReport;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DisasterReportDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/dmc/disaster-reports")
public class DisasterReportsServlet extends HttpServlet {
    private final DisasterReportDAO reportDAO = new DisasterReportDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        
        // Check if user has DMC role
        if (user.getRole() != Role.DMC) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            // Get pending and approved reports
            List<DisasterReport> pendingReports = reportDAO.findByStatus("Pending");
            List<DisasterReport> approvedReports = reportDAO.findByStatus("Approved");
            
            req.setAttribute("pendingReports", pendingReports);
            req.setAttribute("approvedReports", approvedReports);
            
            req.getRequestDispatcher("/WEB-INF/views/dmc/disaster-reports.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading disaster reports");
        }
    }
}
