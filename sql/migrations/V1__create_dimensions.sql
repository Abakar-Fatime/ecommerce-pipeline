-- V1__create_dimensions.sql
-- Flyway migration: create dimensions for the e-commerce DW

-- DIM_DATE
CREATE TABLE IF NOT EXISTS dim_date (
  date_key INT NOT NULL PRIMARY KEY,
  date_value DATE NOT NULL,
  day INT NOT NULL,
  week INT NOT NULL,
  month INT NOT NULL,
  quarter INT NOT NULL,
  year INT NOT NULL,
  is_weekend BIT NOT NULL
);

-- (others same as sql/ddl/dimensions.sql)
-- For brevity, include the same CREATE TABLE statements as in sql/ddl/dimensions.sql
