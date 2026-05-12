package model;

public class Invoice {

    private String invoiceID;
    private int electric;
    private int water;
    private int roomPrice;
    private int other;
    private String status;
    private String contractID;

    public Invoice() {}

    public Invoice(String invoiceID, int electric, int water,
                   int roomPrice, int other,
                   String status, String contractID) {
        this.invoiceID = invoiceID;
        this.electric = electric;
        this.water = water;
        this.roomPrice = roomPrice;
        this.other = other;
        this.status = status;
        this.contractID = contractID;
    }

    public int getTotal() {
        return electric + water + roomPrice + other;
    }

    // getters & setters

    public String getInvoiceID() {
        return invoiceID;
    }

    public void setInvoiceID(String invoiceID) {
        this.invoiceID = invoiceID;
    }

    public int getElectric() {
        return electric;
    }

    public void setElectric(int electric) {
        this.electric = electric;
    }

    public int getWater() {
        return water;
    }

    public void setWater(int water) {
        this.water = water;
    }

    public int getRoomPrice() {
        return roomPrice;
    }

    public void setRoomPrice(int roomPrice) {
        this.roomPrice = roomPrice;
    }

    public int getOther() {
        return other;
    }

    public void setOther(int other) {
        this.other = other;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getContractID() {
        return contractID;
    }

    public void setContractID(String contractID) {
        this.contractID = contractID;
    }
    
}