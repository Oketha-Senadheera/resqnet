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

    private static final List<String> PUBLIC_PATHS = Arrays.asList("/login", "/", "/register");
    private static final List<String> STATIC_PREFIXES = Arrays.asList("/static/");

    private final Map<String, Set<Role>> roleRules;
    
    public AuthFilter() {
        Map<String, Set<Role>> rules = new HashMap<>();
        rules.put("/admin/", new HashSet<>(Arrays.asList(Role.ADMIN)));
        rules.put("/manager/", new HashSet<>(Arrays.asList(Role.ADMIN, Role.MANAGER)));
        rules.put("/staff/", new HashSet<>(Arrays.asList(Role.ADMIN, Role.MANAGER, Role.STAFF)));
        roleRules = Collections.unmodifiableMap(rules);
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
