package model;

public class Room {

    private String roomID, status, houseID;

    public Room() {
    }

    public Room(String roomID, String status, String houseID) {
        this.roomID = roomID;
        this.status = status;
        this.houseID = houseID;
    }

    public String getRoomID() {
        return roomID;
    }

    public void setRoomID(String roomID) {
        this.roomID = roomID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getHouseID() {
        return houseID;
    }

    public void setHouseID(String houseID) {
        this.houseID = houseID;
    }

}
