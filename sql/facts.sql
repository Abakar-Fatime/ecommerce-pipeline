-- facts.sql
-- Create fact tables for the star schema. Partitioning by date_key recommended.

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

-- FACT_RETURNS
CREATE TABLE IF NOT EXISTS fact_returns (
  return_key BIGINT IDENTITY(1,1) PRIMARY KEY,
  date_key INT NOT NULL,
  order_id NVARCHAR(128),
  product_key INT NULL,
  customer_key INT NULL,
  return_quantity INT,
  return_amount DECIMAL(18,4),
  reason NVARCHAR(256),
  created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
  load_batch_id BIGINT NULL
);

-- FACT_INVENTORY_MOVEMENTS
CREATE TABLE IF NOT EXISTS fact_inventory_movements (
  movement_key BIGINT IDENTITY(1,1) PRIMARY KEY,
  date_key INT NOT NULL,
  product_key INT NOT NULL,
  inventory_location_key INT NULL,
  movement_type NVARCHAR(32), -- 'inbound','outbound','adjustment'
  quantity INT,
  unit_cost DECIMAL(18,4),
  created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
  load_batch_id BIGINT NULL
);

-- FACT_SESSIONS (web/mobile)
CREATE TABLE IF NOT EXISTS fact_sessions (
  session_key BIGINT IDENTITY(1,1) PRIMARY KEY,
  date_key INT NOT NULL,
  session_id NVARCHAR(128),
  customer_key INT NULL,
  device_key INT NULL,
  channel_key INT NULL,
  session_duration_seconds INT,
  page_views INT,
  created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
  load_batch_id BIGINT NULL
);

-- FACT_PAYMENTS
CREATE TABLE IF NOT EXISTS fact_payments (
  payment_key BIGINT IDENTITY(1,1) PRIMARY KEY,
  date_key INT NOT NULL,
  payment_id NVARCHAR(128),
  order_id NVARCHAR(128),
  payment_method_key INT NULL,
  amount DECIMAL(18,4),
  currency CHAR(3),
  status NVARCHAR(64),
  created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
  load_batch_id BIGINT NULL
);

-- FACT_PROMOTION_PERFORMANCE
CREATE TABLE IF NOT EXISTS fact_promotion_performance (
  promo_perf_key BIGINT IDENTITY(1,1) PRIMARY KEY,
  date_key INT NOT NULL,
  promotion_key INT NULL,
  impressions BIGINT,
  clicks BIGINT,
  conversions BIGINT,
  revenue DECIMAL(18,4),
  created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
  load_batch_id BIGINT NULL
);
