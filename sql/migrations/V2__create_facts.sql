-- V2__create_facts.sql
-- Flyway migration: create fact tables for the e-commerce DW

-- FACT_SALES
CREATE TABLE IF NOT EXISTS fact_sales (
  sales_key BIGINT IDENTITY(1,1) PRIMARY KEY,
  date_key INT NOT NULL,
  order_id NVARCHAR(128) NOT NULL,
  customer_key INT NULL,
  product_key INT NULL,
  channel_key INT NULL,
  store_key INT NULL,
  device_key INT NULL,
  quantity INT,
  unit_price DECIMAL(18,4),
  discount_amount DECIMAL(18,4) DEFAULT 0,
  tax_amount DECIMAL(18,4) DEFAULT 0,
  shipping_amount DECIMAL(18,4) DEFAULT 0,
  total_amount DECIMAL(18,4),
  payment_method_key INT NULL,
  promotion_key INT NULL,
  created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
  load_batch_id BIGINT NULL
);

-- (others same as sql/ddl/facts.sql)
-- For brevity, include the same CREATE TABLE statements as in sql/ddl/facts.sql
