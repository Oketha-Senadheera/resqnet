package com.resqnet.controller.dmc;

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

@WebServlet("/dmc/disaster-reports/reject")
public class DisasterReportRejectServlet extends HttpServlet {
    private final DisasterReportDAO reportDAO = new DisasterReportDAO();

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

        try {
            String reportIdStr = req.getParameter("reportId");
            if (reportIdStr == null || reportIdStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/dmc/disaster-reports?error=invalid");
                return;
            }

            int reportId = Integer.parseInt(reportIdStr);
            reportDAO.updateStatus(reportId, "Rejected");

            resp.sendRedirect(req.getContextPath() + "/dmc/disaster-reports?success=rejected");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dmc/disaster-reports?error=reject");
        }
    }
}
