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
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

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
            String description = req.getParameter("description");
            String confirmation = req.getParameter("confirmation");

            // Validate required fields
            if (reporterName == null || reporterName.trim().isEmpty() ||
                contactNumber == null || contactNumber.trim().isEmpty() ||
                disasterType == null || disasterType.trim().isEmpty() ||
                datetimeStr == null || datetimeStr.trim().isEmpty() ||
                location == null || location.trim().isEmpty() ||
                confirmation == null) {
                resp.sendRedirect(req.getContextPath() + "/general/disaster-reports/form?error=required");
                return;
            }

            // Handle file upload
            String proofImagePath = null;
            Part filePart = req.getPart("proofImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getFileName(filePart);
                if (fileName != null && !fileName.isEmpty()) {
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "disaster-reports";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    String filePath = uploadPath + File.separator + uniqueFileName;
                    filePart.write(filePath);
                    proofImagePath = "uploads/disaster-reports/" + uniqueFileName;
                }
            }

            // Parse datetime
            Timestamp disasterDatetime = null;
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                disasterDatetime = new Timestamp(dateFormat.parse(datetimeStr).getTime());
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/general/disaster-reports/form?error=datetime");
                return;
            }

            // Create disaster report
            DisasterReport report = new DisasterReport();
            report.setUserId(user.getId());
            report.setReporterName(reporterName.trim());
            report.setContactNumber(contactNumber.trim());
            report.setDisasterType(disasterType);
            report.setOtherDisasterType("Other".equals(disasterType) ? otherDisasterType : null);
            report.setDisasterDatetime(disasterDatetime);
            report.setLocation(location.trim());
            report.setProofImagePath(proofImagePath);
            report.setConfirmation(true);
            report.setStatus("Pending");
            report.setDescription(description != null ? description.trim() : null);

            reportDAO.create(report);

            // Redirect with success message
            resp.sendRedirect(req.getContextPath() + "/general/dashboard?success=disaster-report-submitted");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/general/disaster-reports/form?error=submit");
        }
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String content : contentDisposition.split(";")) {
                if (content.trim().startsWith("filename")) {
                    return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }
}
