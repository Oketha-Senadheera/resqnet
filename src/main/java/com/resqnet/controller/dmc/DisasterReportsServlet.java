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

        // Fetch pending and approved disaster reports
        List<DisasterReport> pendingReports = reportDAO.findByStatus("Pending");
        List<DisasterReport> approvedReports = reportDAO.findByStatus("Approved");

        req.setAttribute("pendingReports", pendingReports);
        req.setAttribute("approvedReports", approvedReports);

        req.getRequestDispatcher("/WEB-INF/views/dmc/disaster-reports.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        String action = req.getParameter("action");
        String reportIdStr = req.getParameter("reportId");

        if (action == null || reportIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/dmc/disaster-reports?error=invalid");
            return;
        }

        try {
            int reportId = Integer.parseInt(reportIdStr);

            if ("approve".equals(action)) {
                reportDAO.approve(reportId);
            } else if ("reject".equals(action)) {
                reportDAO.reject(reportId);
            } else {
                resp.sendRedirect(req.getContextPath() + "/dmc/disaster-reports?error=invalid_action");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/dmc/disaster-reports?success=" + action);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dmc/disaster-reports?error=action_failed");
        }
    }
}
