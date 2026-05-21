/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import model.CustomerDetail;
import model.User;
/**
 *
 * @author ADMIN
 */
public class CustomerDAO extends DBContext{
    PreparedStatement stm;
    ResultSet rs;
    private String lastError;
    public String getLastError() {
        return lastError;
    }
    private void setLastError(Exception e) {
        this.lastError = e.getMessage();
    }
    public Customer getCustomerByCustomerId(int id){
        try {
            String sql = "select * from customer where customer_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            rs = stm.executeQuery();
            while (rs.next()) {
                int customerId = rs.getInt("customer_id");
                int userId = rs.getInt("user_id");
                String taxCode = rs.getString("tax_code");
                String type = rs.getString("type");
                int createBy = rs.getInt("create_by");
                LocalDateTime createAt = rs.getTimestamp("create_at").toLocalDateTime();
                LocalDateTime updateAt = rs.getTimestamp("update_at").toLocalDateTime();
                Customer cus = new Customer(customerId, userId, taxCode, type, createBy, createAt, updateAt);
                return cus;
            }
        } catch (Exception e) {
            System.out.println("getCustomerByCustomerId: " + e.getMessage());
        }
        return null;
    }

    public Integer getRoleIdByName(String roleName) {
        try {
            String sql = "select role_id from role where role_name = ?";
            stm = connection.prepareStatement(sql);
            stm.setString(1, roleName);
            rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("role_id");
            }
        } catch (Exception e) {
            System.out.println("getRoleIdByName: " + e.getMessage());
        }
        return null;
    }

    public User getUserByEmail(String email) {
        try {
            String sql = "select user_id, user_name, password, email, full_name, phone, status, role_id from [user] where email = ?";
            stm = connection.prepareStatement(sql);
            stm.setString(1, email);
            rs = stm.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUserName(rs.getString("user_name"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setStatus(rs.getString("status"));
                user.setRoleId((Integer) rs.getObject("role_id"));
                return user;
            }
        } catch (Exception e) {
            System.out.println("getUserByEmail: " + e.getMessage());
        }
        return null;
    }

    public Customer getCustomerByUserId(int userId) {
        try {
            String sql = "select customer_id, user_id, tax_code, type, create_by, create_at, update_at from customer where user_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, userId);
            rs = stm.executeQuery();
            if (rs.next()) {
                int customerId = rs.getInt("customer_id");
                int uid = rs.getInt("user_id");
                String taxCode = rs.getString("tax_code");
                String type = rs.getString("type");
                int createBy = rs.getInt("create_by");
                LocalDateTime createAt = rs.getTimestamp("create_at").toLocalDateTime();
                LocalDateTime updateAt = rs.getTimestamp("update_at").toLocalDateTime();
                return new Customer(customerId, uid, taxCode, type, createBy, createAt, updateAt);
            }
        } catch (Exception e) {
            System.out.println("getCustomerByUserId: " + e.getMessage());
        }
        return null;
    }

    public CustomerDetail getCustomerDetailByCustomerId(int id){
        try {
            String sql = "select c.customer_id, c.user_id as customer_user_id, c.tax_code, c.type, c.create_by, c.create_at, c.update_at, "
                    + "u.user_id as user_user_id, u.email, u.full_name, u.phone, u.role_id, r.role_name "
                    + "from customer c "
                    + "left join [user] u on c.user_id = u.user_id "
                    + "left join role r on u.role_id = r.role_id "
                    + "where c.customer_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            rs = stm.executeQuery();
            if (rs.next()) {
                CustomerDetail detail = new CustomerDetail();
                detail.setCustomerId(rs.getInt("customer_id"));
                detail.setUserId((Integer) rs.getObject("customer_user_id"));
                detail.setTaxCode(rs.getString("tax_code"));
                detail.setType(rs.getString("type"));
                detail.setCreateBy((Integer) rs.getObject("create_by"));
                if (rs.getTimestamp("create_at") != null) {
                    detail.setCreateAt(rs.getTimestamp("create_at").toLocalDateTime());
                }
                if (rs.getTimestamp("update_at") != null) {
                    detail.setUpdateAt(rs.getTimestamp("update_at").toLocalDateTime());
                }

                if (rs.getObject("user_user_id") != null) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_user_id"));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("full_name"));
                    user.setPhone(rs.getString("phone"));
                    user.setRoleId((Integer) rs.getObject("role_id"));
                    detail.setUser(user);
                    detail.setUserRoleName(rs.getString("role_name"));
                }
                return detail;
            }
        } catch (Exception e) {
            System.out.println("getCustomerDetailByCustomerId: " + e.getMessage());
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        try {
            String sql = "select user_id, user_name, email, full_name, phone, status, role_id from [user] order by user_id";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUserName(rs.getString("user_name"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setStatus(rs.getString("status"));
                user.setRoleId((Integer) rs.getObject("role_id"));
                users.add(user);
            }
        } catch (Exception e) {
            System.out.println("getAllUsers: " + e.getMessage());
        }
        return users;
    }

    public User createUser(User user) {
        try {
            String sql = "insert into [user](user_name, password, email, full_name, phone, status, role_id) output inserted.user_id values (?, ?, ?, ?, ?, ?, ?)";
            stm = connection.prepareStatement(sql);
            stm.setString(1, user.getUserName());
            stm.setString(2, user.getPassword());
            stm.setString(3, user.getEmail());
            stm.setString(4, user.getFullName());
            stm.setString(5, user.getPhone());
            stm.setString(6, user.getStatus());
            if (user.getRoleId() != null) {
                stm.setInt(7, user.getRoleId());
            } else {
                stm.setNull(7, java.sql.Types.INTEGER);
            }
            rs = stm.executeQuery();
            if (rs.next()) {
                user.setUserId(rs.getInt("user_id"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Customer createCustomer(Customer customer) {
        try {
            String sql = "insert into customer(user_id, tax_code, type, create_by) output inserted.customer_id values (?, ?, ?, ?)";
            stm = connection.prepareStatement(sql);
            if (customer.getUserId() != null) {
                stm.setInt(1, customer.getUserId());
            } else {
                stm.setNull(1, java.sql.Types.INTEGER);
            }
            stm.setString(2, customer.getTaxCode());
            stm.setString(3, customer.getType());
            if (customer.getCreateBy() != null) {
                stm.setInt(4, customer.getCreateBy());
            } else {
                stm.setNull(4, java.sql.Types.INTEGER);
            }
            rs = stm.executeQuery();
            if (rs.next()) {
                customer.setCustomerId(rs.getInt("customer_id"));
                return customer;
            }
        } catch (Exception e) {
            setLastError(e);
            e.printStackTrace();
        }
        return null;
    }

    public Customer createUserAndCustomer(User user, Customer customer) {
        try {
            User existingUser = getUserByEmail(user.getEmail());
            if (existingUser != null) {
                setLastError(new Exception("Email already exists."));
                return null;
            }

            connection.setAutoCommit(false);

            String userSql = "insert into [user](user_name, password, email, full_name, phone, status, role_id) output inserted.user_id values (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement userStm = connection.prepareStatement(userSql)) {
                userStm.setString(1, user.getUserName());
                userStm.setString(2, user.getPassword());
                userStm.setString(3, user.getEmail());
                userStm.setString(4, user.getFullName());
                userStm.setString(5, user.getPhone());
                userStm.setString(6, user.getStatus());
                if (user.getRoleId() != null) {
                    userStm.setInt(7, user.getRoleId());
                } else {
                    userStm.setNull(7, java.sql.Types.INTEGER);
                }
                try (ResultSet keyRs = userStm.executeQuery()) {
                    if (keyRs.next()) {
                        user.setUserId(keyRs.getInt("user_id"));
                    } else {
                        connection.rollback();
                        connection.setAutoCommit(true);
                        return null;
                    }
                }
            }

            if (getCustomerByUserId(user.getUserId()) != null) {
                setLastError(new Exception("Customer already exists for this user."));
                connection.rollback();
                connection.setAutoCommit(true);
                return null;
            }

            customer.setUserId(user.getUserId());
            String custSql = "insert into customer(user_id, tax_code, type, create_by) output inserted.customer_id values (?, ?, ?, ?)";
            try (PreparedStatement custStm = connection.prepareStatement(custSql)) {
                custStm.setInt(1, user.getUserId());
                custStm.setString(2, customer.getTaxCode());
                custStm.setString(3, customer.getType());
                if (customer.getCreateBy() != null) {
                    custStm.setInt(4, customer.getCreateBy());
                } else {
                    custStm.setNull(4, java.sql.Types.INTEGER);
                }
                try (ResultSet keyRs = custStm.executeQuery()) {
                    if (keyRs.next()) {
                        customer.setCustomerId(keyRs.getInt("customer_id"));
                    } else {
                        connection.rollback();
                        connection.setAutoCommit(true);
                        return null;
                    }
                }
            }

            connection.commit();
            connection.setAutoCommit(true);
            return customer;
        } catch (Exception e) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            setLastError(e);
            e.printStackTrace();
            return null;
        }
    }

    public User getUserById(int userId) {
        try {
            String sql = "select user_id, user_name, password, email, full_name, phone, status, role_id from [user] where user_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, userId);
            rs = stm.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUserName(rs.getString("user_name"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setStatus(rs.getString("status"));
                user.setRoleId((Integer) rs.getObject("role_id"));
                return user;
            }
        } catch (Exception e) {
            System.out.println("getUserById: " + e.getMessage());
        }
        return null;
    }

    public boolean updateUser(User user) {
        try {
            String sql = "update [user] set user_name = ?, password = ?, email = ?, full_name = ?, status = ? where user_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setString(1, user.getUserName());
            stm.setString(2, user.getPassword());
            stm.setString(3, user.getEmail());
            stm.setString(4, user.getFullName());
            stm.setString(5, user.getStatus());
            stm.setInt(6, user.getUserId());
            int result = stm.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            setLastError(e);
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCustomer(Customer customer) {
        try {
            String sql = "update customer set tax_code = ?, type = ? where customer_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setString(1, customer.getTaxCode());
            stm.setString(2, customer.getType());
            stm.setInt(3, customer.getCustomerId());
            int result = stm.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            setLastError(e);
            e.printStackTrace();
        }
        return false;
    }
}
