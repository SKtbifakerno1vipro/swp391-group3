package controller.user;

import service.*;
import utils.Validation;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;
import utils.PasswordUtils;
import java.sql.Date;

@WebServlet(name = "EditUserController", urlPatterns = {"/edit-user"})
public class EditUserController extends HttpServlet {

    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String idStr = request.getParameter("id");
        request.setAttribute("roles", roleService.getAllRolesForCreateUser());

        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int targetId = Integer.parseInt(idStr);
                // Security check: Admin (1) and Manager (2) can view other users. Others only view themselves.
                if (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2 && targetId != currentUser.getUserId()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to view this profile.");
                    return;
                }

                User u = userService.getUserById(targetId);
                if (u != null) {
                    if ("1".equals(request.getParameter("success"))) {
                        request.setAttribute("successMsg", "Cập nhật thông tin thành công!");
                    }
                    request.setAttribute("u", u);
                    request.setAttribute("mode", "edit");
                    request.setAttribute("userService", userService);
                    request.getRequestDispatcher("/views/user/detail.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found.");
                }
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid User ID.");
            }
        } else {
            // Security check: Only Admin (Role 1) can create users
            if (currentUser.getRoleId() != 1) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to create users.");
                return;
            }

            request.setAttribute("mode", "create");
            request.getRequestDispatcher("/views/user/create.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String idStr = request.getParameter("id");
        boolean isEdit = (idStr != null && !idStr.isEmpty());

        if (isEdit) {
            int targetId = Integer.parseInt(idStr);
            // Security check: Only Admin (Role 1) can edit other users and each user can edit their profile
            if (currentUser.getRoleId() != 1 && targetId != currentUser.getUserId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to edit this profile.");
                return;
            }
        } else {
            // Security check: Only Admin (Role 1) can create users
            if (currentUser.getRoleId() != 1) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to create users.");
                return;
            }
        }

        String action = request.getParameter("action");
        if ("resetPassword".equals(action) && isEdit) {
            try {
                User changePassUser = userService.getUserById(Integer.parseInt(idStr));
                String newPassword = "123456";
                userService.changePassword(changePassUser.getUserId(), null, newPassword);
                service.AuditLogService.log(currentUser.getUserId(), "UPDATE", "User", "Reset password for User ID: " + idStr);
                request.setAttribute("successMsg", "Đã khôi phục mật khẩu về mặc định!");
                userService.notificationForStaff(changePassUser, newPassword);
                request.setAttribute("u", changePassUser);
                request.setAttribute("mode", "edit");
                request.setAttribute("userService", userService);
                request.setAttribute("roles", roleService.getAllRolesForCreateUser());
                request.getRequestDispatcher("/views/user/detail.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }

        User u = isEdit ? userService.getUserById(Integer.parseInt(idStr)) : new User();
        if (isEdit) {
            u.setUserId(Integer.parseInt(idStr));
        }

        String rawUserName = request.getParameter("userName");
        if (rawUserName != null) {
            u.setUserName(rawUserName.trim());
        }

        String rawEmail = request.getParameter("email");
        if (rawEmail != null) {
            u.setEmail(rawEmail.trim());
        }

        String rawFullName = request.getParameter("fullName");
        if (rawFullName != null) {
            u.setFullName(rawFullName.trim());
        }

        String rawPhone = request.getParameter("phone");
        if (rawPhone != null) {
            u.setPhone(rawPhone.trim());
        }

        String rawGender = request.getParameter("gender");
        if (rawGender != null && !rawGender.trim().isEmpty()) {
            u.setGender(rawGender.trim());
        }

        String rawAddress = request.getParameter("address");
        if (rawAddress != null) {
            u.setAddress(rawAddress.trim());
        }

        String rawDob = request.getParameter("dateBirth");
        if (rawDob != null && !rawDob.trim().isEmpty()) {
            try {
                u.setDateBirth(Date.valueOf(rawDob.trim()));
            } catch (Exception e) {
            }
        }

        // Security Check: Only Admin can change Status and Role
        if (currentUser.getRoleId() == 1) {
            String rawStatus = request.getParameter("status");
            if (rawStatus != null && !rawStatus.trim().isEmpty()) {
                u.setStatus(rawStatus.trim());
            }

            String rawRoleId = request.getParameter("roleId");
            if (rawRoleId != null && !rawRoleId.trim().isEmpty()) {
                try {
                    u.setRoleId(Integer.parseInt(rawRoleId.trim()));
                } catch (Exception e) {
                }
            }
        }

        // 3. Validation Logic
        String error = Validation.validateEmpty(u.getFullName(), "Full Name");
        if (error == null) {
            error = Validation.validateUsername(u.getUserName());
        }
        if (error == null) {
            error = Validation.validateEmail(u.getEmail());
        }
        if (error == null) {
            error = Validation.validatePhone(u.getPhone());
        }

        if (error == null) {
            if (userService.isEmailDuplicate(u.getEmail(), u.getUserId())) {
                error = "Email duplicated!";
            }
            if (userService.isPhoneDuplicate(u.getPhone(), u.getUserId())) {
                error = "Phone duplicated!";
            }
            if (userService.isUsernameDuplicate(u.getUserName(), u.getUserId())) {
                error = "Username duplicated!";
            }
        }

        String password = PasswordUtils.generateRandomText();
        if (!isEdit && error == null) {
            if (password == null || password.trim().isEmpty()) {
                error = "Password is required!";
            } else {
                u.setPassword(password);
            }
        }
        
        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("u", u);
            request.setAttribute("roles", roleService.getAllRolesForCreateUser());
            String targetJSP = isEdit ? "/views/user/detail.jsp" : "/views/user/create.jsp";
            request.getRequestDispatcher(targetJSP).forward(request, response);
            return;
        }

        if (isEdit) {
            u.setUpdatedBy(currentUser.getUserId());
        } else {
            u.setCreatedBy(currentUser.getUserId());
            u.setUpdatedBy(currentUser.getUserId());
        }

        boolean success = isEdit ? userService.updateUser(u) : userService.createUser(u);

        if (success) {
            if (isEdit) {
                service.AuditLogService.log(currentUser.getUserId(), "UPDATE", "User", "Cập nhật thông tin tài khoản: " + u.getUserName() + " (ID: " + u.getUserId() + ", Tên: " + u.getFullName() + ")");
                //validate when change role ID for yourself to other role
                if (currentUser.getUserId() == u.getUserId()) {
                    User freshUser = userService.getUserById(u.getUserId());
                    session.setAttribute("user", freshUser);
                }
                response.sendRedirect(request.getContextPath() + "/edit-user?id=" + u.getUserId() + "&success=1");
            } else {
                service.AuditLogService.log(currentUser.getUserId(), "CREATE", "User", "Tạo tài khoản mới: " + u.getUserName() + " (Email: " + u.getEmail() + ", Tên: " + u.getFullName() + ")");
                userService.notificationForStaff(u, password);
                response.sendRedirect(request.getContextPath() + "/user-list");
            }
        } else {
            request.setAttribute("error", "Database error!");
            request.setAttribute("u", u);
            request.setAttribute("roles", roleService.getAllRolesForCreateUser());
            String targetJSP = isEdit ? "/views/user/detail.jsp" : "/views/user/create.jsp";
            request.getRequestDispatcher(targetJSP).forward(request, response);
        }
    }
}
