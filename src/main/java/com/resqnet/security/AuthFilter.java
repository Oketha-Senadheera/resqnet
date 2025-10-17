package com.resqnet.security;

import com.resqnet.model.Role;
import com.resqnet.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_PATHS = Arrays.asList("/login", "/", "/signup", "/signup/general", "/signup/volunteer", "/signup/ngo", "/forgot-password", "/reset-password");
    private static final List<String> STATIC_PREFIXES = Arrays.asList("/static/");

    private final Map<String, Set<Role>> roleRules = createRoleRules();

    private Map<String, Set<Role>> createRoleRules() {
        Map<String, Set<Role>> rules = new HashMap<>();
        rules.put("/gn/", Collections.singleton(Role.GRAMA_NILADHARI));
        rules.put("/dmc/", Collections.singleton(Role.DMC));
        rules.put("/ngo/", Collections.singleton(Role.NGO));
        rules.put("/volunteer/", Collections.singleton(Role.VOLUNTEER));
        rules.put("/general/", Collections.singleton(Role.GENERAL));
        return rules;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String ctx = req.getContextPath();
        String path = req.getRequestURI().substring(ctx.length());

        // Allow public paths
        if (PUBLIC_PATHS.contains(path) || STATIC_PREFIXES.stream().anyMatch(path::startsWith)) {
            chain.doFilter(request, response);
            return;
        }

        // Check authentication
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(ctx + "/login");
            return;
        }

        // Check authorization
        for (Map.Entry<String, Set<Role>> entry : roleRules.entrySet()) {
            if (path.startsWith(entry.getKey()) && entry.getValue().stream().noneMatch(user::hasRole)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
