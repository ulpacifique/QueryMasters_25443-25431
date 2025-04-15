
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE sales CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE products CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE employees CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE regions CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE categories CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    category_id INT,
    region_id INT,
    employee_id INT,
    sale_date DATE,
    amount DECIMAL(10,2)
);

-- Create lookup tables
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    hire_date DATE
);

-- Insert sample data into categories
INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Home Goods'),
(4, 'Groceries'),CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INT NOT NULL REFERENCES categories(category_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id),
    category_id INT NOT NULL REFERENCES categories(category_id),
    region_id INT NOT NULL REFERENCES regions(region_id),
    employee_id INT NOT NULL REFERENCES employees(employee_id),
    sale_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);
(5, 'Sporting Goods');

-- Insert sample data into regions
INSERT INTO regions VALUES
(1, 'North'),
(2, 'South'),
(3, 'East'),
(4, 'West'),
(5, 'Central');

-- Insert sample data into employees
INSERT INTO employees VALUES
(101, 'John Smith', '2022-01-15'),
(102, 'Maria Garcia', '2022-02-20'),
(103, 'Robert Johnson', '2022-03-10'),
(104, 'Sarah Lee', '2022-03-22'),
(105, 'David Kim', '2022-04-05'),
(106, 'Lisa Wang', '2022-05-12'),
(107, 'Michael Brown', '2022-06-18'),
(108, 'Emma Wilson', '2022-07-01'),
(109, 'James Davis', '2022-07-15'),
(110, 'Jennifer Taylor', '2022-08-22');

-- Insert sample sales data
INSERT INTO sales VALUES
(1, 101, 1, 1, 101, '2023-01-15', 1250.00),
(2, 102, 1, 1, 102, '2023-01-16', 950.00),
(3, 103, 2, 2, 103, '2023-01-16', 350.00),
(4, 104, 2, 2, 104, '2023-01-17', 425.00),
(5, 105, 3, 3, 105, '2023-01-18', 625.00),
(6, 106, 3, 3, 106, '2023-01-19', 750.00),
(7, 107, 4, 4, 107, '2023-01-20', 185.00),
(8, 108, 4, 4, 108, '2023-01-21', 225.00),
(9, 109, 5, 5, 109, '2023-01-22', 450.00),
(10, 110, 5, 5, 110, '2023-01-23', 550.00),
(11, 111, 1, 2, 101, '2023-01-24', 1100.00),
(12, 112, 1, 2, 102, '2023-01-25', 1300.00),
(13, 113, 2, 3, 103, '2023-01-26', 380.00),
(14, 114, 2, 3, 104, '2023-01-27', 410.00),
(15, 115, 3, 4, 105, '2023-01-28', 675.00),
(16, 116, 3, 4, 106, '2023-01-29', 715.00),
(17, 117, 4, 5, 107, '2023-01-30', 195.00),
(18, 118, 4, 5, 108, '2023-01-31', 210.00),
(19, 119, 5, 1, 109, '2023-02-01', 480.00),
(20, 120, 5, 1, 110, '2023-02-02', 520.00),
(21, 121, 1, 3, 101, '2023-02-03', 1150.00),
(22, 122, 1, 3, 102, '2023-02-04', 1050.00),
(23, 123, 2, 4, 103, '2023-02-05', 340.00),
(24, 124, 2, 4, 104, '2023-02-06', 360.00),
(25, 125, 3, 5, 105, '2023-02-07', 680.00);