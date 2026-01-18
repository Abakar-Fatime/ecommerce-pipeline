-- dimensions.sql
-- Create dimension tables (SCD Type 2 pattern where appropriate)
-- Designed for Microsoft SQL Server.

-- DIM_DATE (seed with calendar)
CREATE TABLE IF NOT EXISTS dim_date (
  date_key INT NOT NULL PRIMARY KEY, -- yyyymmdd
  date_value DATE NOT NULL,
  day INT NOT NULL,
  week INT NOT NULL,
  month INT NOT NULL,
  quarter INT NOT NULL,
  year INT NOT NULL,
  is_weekend BIT NOT NULL
);

-- DIM_CUSTOMER (SCD Type 2)
CREATE TABLE IF NOT EXISTS dim_customer (
  customer_key INT IDENTITY(1,1) PRIMARY KEY,
  customer_nk NVARCHAR(128) NOT NULL, -- natural key (external_id)
  first_name NVARCHAR(128),
  last_name NVARCHAR(128),
  email NVARCHAR(256),
  phone NVARCHAR(64),
  city NVARCHAR(128),
  state NVARCHAR(128),
  country NVARCHAR(64),
  signup_date DATE,
  is_active BIT DEFAULT 1,
  effective_from DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  effective_to DATETIME2 NULL,
  is_current BIT NOT NULL DEFAULT 1,
  load_batch_id BIGINT NULL,
  CONSTRAINT ux_dim_customer_nk UNIQUE (customer_nk, effective_from)
);

-- DIM_PRODUCT (SCD Type 2)
CREATE TABLE IF NOT EXISTS dim_product (
  product_key INT IDENTITY(1,1) PRIMARY KEY,
  product_nk NVARCHAR(128) NOT NULL,
  sku NVARCHAR(64),
  name NVARCHAR(256),
  category NVARCHAR(128),
  brand NVARCHAR(128),
  price DECIMAL(18,4),
  currency CHAR(3),
  is_active BIT DEFAULT 1,
  effective_from DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  effective_to DATETIME2 NULL,
  is_current BIT NOT NULL DEFAULT 1,
  load_batch_id BIGINT NULL,
  CONSTRAINT ux_dim_product_nk UNIQUE (product_nk, effective_from)
);

-- DIM_CHANNEL
CREATE TABLE IF NOT EXISTS dim_channel (
  channel_key INT IDENTITY(1,1) PRIMARY KEY,
  channel_code NVARCHAR(64) NOT NULL UNIQUE, -- e.g., 'web', 'mobile', 'store'
  channel_name NVARCHAR(128),
  description NVARCHAR(256)
);

-- DIM_STORE
CREATE TABLE IF NOT EXISTS dim_store (
  store_key INT IDENTITY(1,1) PRIMARY KEY,
  store_nk NVARCHAR(128) NOT NULL UNIQUE,
  name NVARCHAR(128),
  address NVARCHAR(256),
  city NVARCHAR(128),
  state NVARCHAR(128),
  country NVARCHAR(64),
  open_date DATE
);

-- DIM_DEVICE
CREATE TABLE IF NOT EXISTS dim_device (
  device_key INT IDENTITY(1,1) PRIMARY KEY,
  device_code NVARCHAR(64) NOT NULL UNIQUE, -- e.g., 'iOS', 'Android', 'Web'
  description NVARCHAR(128)
);

-- DIM_REGION
CREATE TABLE IF NOT EXISTS dim_region (
  region_key INT IDENTITY(1,1) PRIMARY KEY,
  region_code NVARCHAR(64) NOT NULL UNIQUE,
  region_name NVARCHAR(128),
  country NVARCHAR(64)
);

-- DIM_PROMOTION
CREATE TABLE IF NOT EXISTS dim_promotion (
  promotion_key INT IDENTITY(1,1) PRIMARY KEY,
  promotion_nk NVARCHAR(128) NOT NULL,
  promo_name NVARCHAR(256),
  promo_type NVARCHAR(64),
  start_date DATE,
  end_date DATE,
  is_active BIT DEFAULT 1
);

-- DIM_PAYMENT_METHOD
CREATE TABLE IF NOT EXISTS dim_payment_method (
  payment_method_key INT IDENTITY(1,1) PRIMARY KEY,
  code NVARCHAR(64) NOT NULL UNIQUE,
  name NVARCHAR(128)
);

-- DIM_INVENTORY_LOCATION
CREATE TABLE IF NOT EXISTS dim_inventory_location (
  inventory_location_key INT IDENTITY(1,1) PRIMARY KEY,
  location_nk NVARCHAR(128) NOT NULL UNIQUE,
  name NVARCHAR(128),
  address NVARCHAR(256)
);

-- DIM_CAMPAIGN
CREATE TABLE IF NOT EXISTS dim_campaign (
  campaign_key INT IDENTITY(1,1) PRIMARY KEY,
  campaign_nk NVARCHAR(128) NOT NULL,
  name NVARCHAR(256),
  start_date DATE,
  end_date DATE
);

-- DIM_PARTNER
CREATE TABLE IF NOT EXISTS dim_partner (
  partner_key INT IDENTITY(1,1) PRIMARY KEY,
  partner_nk NVARCHAR(128) NOT NULL,
  name NVARCHAR(256),
  type NVARCHAR(64)
);
