package model;

import java.sql.Timestamp;

public class EmailLog {
    private int logId;
    private String recipient;
    private String subject;
    private String content;
    private Timestamp sentAt;
    private String status;

    public EmailLog() {
    }

    public EmailLog(int logId, String recipient, String subject, String content, Timestamp sentAt, String status) {
        this.logId = logId;
        this.recipient = recipient;
        this.subject = subject;
        this.content = content;
        this.sentAt = sentAt;
        this.status = status;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public String getRecipient() {
        return recipient;
    }

    public void setRecipient(String recipient) {
        this.recipient = recipient;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getSentAt() {
        return sentAt;
    }

    public void setSentAt(Timestamp sentAt) {
        this.sentAt = sentAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
