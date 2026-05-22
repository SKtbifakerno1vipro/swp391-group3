

package model;

import java.util.Date;

public class Contract {

    private String contractID;
    private String roomID;
    private Date startDate, endDate;
    private String accountID;

    public Contract() {
    }

    public Contract(String contractID, String roomID, Date startDate, Date endDate, String accountID) {
        this.contractID = contractID;
        this.roomID = roomID;
        this.startDate = startDate;
        this.endDate = endDate;
        this.accountID = accountID;
    }

    public String getContractID() {
        return contractID;
    }

    public void setContractID(String contractID) {
        this.contractID = contractID;
    }

    public String getRoomID() {
        return roomID;
    }

    public void setRoomID(String roomID) {
        this.roomID = roomID;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getAccountID() {
        return accountID;
    }

    public void setAccountID(String accountID) {
        this.accountID = accountID;
    }
    
    
}
