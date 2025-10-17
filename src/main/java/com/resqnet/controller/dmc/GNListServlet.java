package com.resqnet.controller.dmc;

import com.resqnet.model.GramaNiladhari;
import com.resqnet.model.GramaNiladhariWithUser;
import com.resqnet.model.User;
import com.resqnet.model.dao.GramaNiladhariDAO;
import com.resqnet.model.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dmc/gn-registry")
public class GNListServlet extends HttpServlet {
    private final GramaNiladhariDAO gnDAO = new GramaNiladhariDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check if user is DMC admin
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        if (!user.isDMC()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        // Get all Grama Niladharis
        List<GramaNiladhari> gnList = gnDAO.findAll();
        List<GramaNiladhariWithUser> gnWithUserList = new ArrayList<>();

        for (GramaNiladhari gn : gnList) {
            User gnUser = userDAO.findById(gn.getUserId()).orElse(null);
            if (gnUser != null) {
                gnWithUserList.add(new GramaNiladhariWithUser(gnUser, gn));
            }
        }

        req.setAttribute("gnList", gnWithUserList);
        req.getRequestDispatcher("/WEB-INF/views/dmc/gn/list.jsp").forward(req, resp);
    }
}
