package dto;

import java.time.LocalDateTime;

public class ActivityDTO {
    private LocalDateTime createdAt;
    private String fullName;
    private String actionType;
    private String affectedObject;
    private String description;

    public ActivityDTO() {
    }

    public ActivityDTO(LocalDateTime createdAt, String fullName, String actionType, String affectedObject, String description) {
        this.createdAt = createdAt;
        this.fullName = fullName;
        this.actionType = actionType;
        this.affectedObject = affectedObject;
        this.description = description;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getAffectedObject() {
        return affectedObject;
    }

    public void setAffectedObject(String affectedObject) {
        this.affectedObject = affectedObject;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
