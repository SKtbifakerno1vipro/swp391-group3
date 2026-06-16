package model;

public class ContractRevisionItem {

    private int revisionItemId, historyId, contractId;
    private String revisionType, revisionDetail;

    public ContractRevisionItem() {
    }

    public int getRevisionItemId() {
        return revisionItemId;
    }

    public void setRevisionItemId(int revisionItemId) {
        this.revisionItemId = revisionItemId;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public String getRevisionType() {
        return revisionType;
    }

    public void setRevisionType(String revisionType) {
        this.revisionType = revisionType;
    }

    public String getRevisionDetail() {
        return revisionDetail;
    }

    public void setRevisionDetail(String revisionDetail) {
        this.revisionDetail = revisionDetail;
    }

}
