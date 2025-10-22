package com.resqnet.controller.ngo;

import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.InventoryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ngo/inventory/update")
public class InventoryUpdateServlet extends HttpServlet {

    private final InventoryDAO inventoryDAO = new InventoryDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        
        // Check if user has NGO role
        if (user.getRole() != Role.NGO) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            int inventoryId = Integer.parseInt(req.getParameter("inventoryId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            
            if (quantity < 0) {
                session.setAttribute("errorMessage", "Quantity cannot be negative!");
            } else {
                inventoryDAO.updateQuantity(inventoryId, quantity);
                session.setAttribute("successMessage", "Inventory updated successfully!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error updating inventory: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/ngo/manage-inventory");
    }
}
