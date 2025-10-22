package com.resqnet.controller.general;

import com.resqnet.model.DisasterReport;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DisasterReportDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/general/disaster-reports/submit")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class DisasterReportSubmitServlet extends HttpServlet {
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
        
        // Check if user has GENERAL role
        if (user.getRole() != Role.GENERAL) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            // Get form parameters
            String reporterName = req.getParameter("reporterName");
            String contactNumber = req.getParameter("contactNumber");
            String disasterType = req.getParameter("disasterType");
            String otherDisasterType = req.getParameter("otherDisaster");
            String datetimeStr = req.getParameter("datetime");
            String location = req.getParameter("location");
            String confirmation = req.getParameter("confirmation");
            String description = req.getParameter("description");

            // Validate required fields
            if (reporterName == null || reporterName.trim().isEmpty() ||
                contactNumber == null || contactNumber.trim().isEmpty() ||
                disasterType == null || disasterType.trim().isEmpty() ||
                datetimeStr == null || datetimeStr.trim().isEmpty() ||
                location == null || location.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/general/disaster-reports/form?error=required");
                return;
            }

            // Validate confirmation checkbox
            if (confirmation == null || !confirmation.equals("on")) {
                resp.sendRedirect(req.getContextPath() + "/general/disaster-reports/form?error=confirmation");
                return;
            }

            // Parse datetime
            LocalDateTime disasterDatetime = LocalDateTime.parse(datetimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

            // Handle file upload
            String proofImagePath = null;
            Part filePart = req.getPart("proofImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadDir = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "disaster-reports";
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                
                // Generate unique filename
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadDir + File.separator + uniqueFileName;
                filePart.write(filePath);
                proofImagePath = "uploads/disaster-reports/" + uniqueFileName;
            }

            // Create disaster report
            DisasterReport report = new DisasterReport();
            report.setUserId(user.getId());
            report.setReporterName(reporterName.trim());
            report.setContactNumber(contactNumber.trim());
            report.setDisasterType(disasterType.trim());
            report.setOtherDisasterType(disasterType.equals("Other") && otherDisasterType != null ? otherDisasterType.trim() : null);
            report.setDisasterDatetime(Timestamp.valueOf(disasterDatetime));
            report.setLocation(location.trim());
            report.setProofImagePath(proofImagePath);
            report.setConfirmation(true);
            report.setStatus("Pending");
            report.setDescription(description != null ? description.trim() : null);

            reportDAO.create(report);

            // Redirect with success message
            resp.sendRedirect(req.getContextPath() + "/general/dashboard?success=disaster_report_submitted");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/general/disaster-reports/form?error=submit");
        }
    }
}
