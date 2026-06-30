package dto;

public class StatusStatisticDTO {
    private String status;
    private int total;

    public StatusStatisticDTO() {
    }

    public StatusStatisticDTO(String status, int total) {
        this.status = status;
        this.total = total;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }
}
