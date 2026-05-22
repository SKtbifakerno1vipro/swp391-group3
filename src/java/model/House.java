package model;

public class House {

    private String houseID;
    private String houseName;
    private String address;
    private int roomNum;
    private String accountID;

    public House() {
    }

    public House(String houseID, String houseName,
            String address, int roomNum, String accountID) {
        this.houseID = houseID;
        this.houseName = houseName;
        this.address = address;
        this.roomNum = roomNum;
        this.accountID = accountID;
    }

    public String getHouseID() {
        return houseID;
    }

    public void setHouseID(String houseID) {
        this.houseID = houseID;
    }

    public String getHouseName() {
        return houseName;
    }

    public void setHouseName(String houseName) {
        this.houseName = houseName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getRoomNum() { 
        return roomNum;
    }

    public void setRoomNum(int roomNum) {
        this.roomNum = roomNum;
    }

    public String getAccountID() {
        return accountID;
    }

    public void setAccountID(String accountID) {
        this.accountID = accountID;
    }
}
