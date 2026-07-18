-- Drop table if exists
IF OBJECT_ID('dbo.import_request', 'U') IS NOT NULL
    DROP TABLE dbo.import_request;
GO

-- Create import_request table
CREATE TABLE import_request (
    import_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    status INT NOT NULL CHECK (status IN (1, 2, 3)), -- 1: Pending, 2: Imported, 3: Cancelled
    created_by INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT GETDATE(),
    imported_by INT NULL,
    imported_date DATETIME NULL,
    note NVARCHAR(MAX) NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id),
    FOREIGN KEY (imported_by) REFERENCES [user](user_id)
);
GO
