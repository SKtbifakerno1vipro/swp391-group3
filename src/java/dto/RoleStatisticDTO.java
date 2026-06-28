package dto;

public class RoleStatisticDTO {
    private String roleName;
    private int total;

    public RoleStatisticDTO() {
    }

    public RoleStatisticDTO(String roleName, int total) {
        this.roleName = roleName;
        this.total = total;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }
}
