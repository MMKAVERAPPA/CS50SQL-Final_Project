-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- Represents the city names
CREATE TABLE "cities" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "state" TEXT NOT NULL
);

-- Represents information about the supplier
CREATE TABLE "suppliers" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "supplier_name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "city_id" INTEGER NOT NULL,
    "phone_no" TEXT NOT NULL UNIQUE,
    FOREIGN KEY ("city_id") REFERENCES "cities" ("id")
);

-- Represents information about the ingredients supplied
CREATE TABLE "ingredients" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL
);

-- Represents the relation between supplier and ingredients
CREATE TABLE "supplier_ingredients" (  
    "supplier_id" INTEGER NOT NULL,
    "ingredient_id" INTEGER NOT NULL,
    FOREIGN KEY ("supplier_id") REFERENCES "suppliers" ("id"),
    FOREIGN KEY ("ingredient_id") REFERENCES "ingredients" ("id")
);

-- Represents the information about the stores
CREATE TABLE "stores" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "address" TEXT NOT NULL UNIQUE,
    "email" TEXT NOT NULL UNIQUE CHECK("email" LIKE '%@%'),
    "phone_no" TEXT NOT NULL UNIQUE,
    "city_id" INTEGER NOT NULL,
    "total_employees" INTEGER DEFAULT 0,
    "opening_date" TEXT NOT NULL,
    FOREIGN KEY ("city_id") REFERENCES "cities" ("id")
);

-- Represents the relation between suppliers and stores
CREATE TABLE "supplier_stores"(
    "supplier_id" INTEGER NOT NULL,
    "store_id" INTEGER NOT NULL,
    FOREIGN KEY ("supplier_id") REFERENCES "suppliers" ("id"),
    FOREIGN KEY ("store_id") REFERENCES "stores" ("id")
);

-- Represents information about the products sold
CREATE TABLE "products" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "product_name" TEXT NOT NULL,
    "price" NUMERIC NOT NULL,
    "category" TEXT NOT NULL
);

-- Represents the relation between stores and products available
CREATE TABLE "product_stores" (
    "store_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    FOREIGN KEY ("store_id") REFERENCES "stores" ("id"),
    FOREIGN KEY ("product_id") REFERENCES "products" ("id")
);

-- Represents the position
CREATE TABLE "positions" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "position" TEXT NOT NULL
);

-- Represents information about employees
CREATE TABLE "employees" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT,
    "dob" TEXT,
    "gender" TEXT NOT NULL,
    "email" TEXT NOT NULL UNIQUE CHECK("email" LIKE '%@%'),
    "phone_no" TEXT NOT NULL UNIQUE,
    "address" TEXT,
    "salary" NUMERIC NOT NULL,
    "working_store_id" INTEGER,
    "position_id" INTEGER,
    "hired_date" TEXT NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY ("working_store_id") REFERENCES "stores" ("id"),
    FOREIGN KEY ("position_id") REFERENCES "positions" ("id")
);

-- Represents the finances of the stores
CREATE TABLE "finances" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "store_id" INTEGER NOT NULL,
    "yearly_revenue" NUMERIC NOT NULL,
    "yearly_expenses" NUMERIC NOT NULL,
    "year" INTEGER NOT NULL,
    FOREIGN KEY ("store_id") REFERENCES "stores" ("id")
);

-- Represents the detailed information about the customers
CREATE TABLE "customers" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT,
    "gender" TEXT,
    "address" TEXT,
    "email" TEXT NOT NULL UNIQUE,
    "phone_no" TEXT UNIQUE,
    "saved_amount" NUMERIC DEFAULT 0.00,
    "membership" TEXT NOT NULL DEFAULT 'N' CHECK ("membership" IN ('Y', 'N'))
);

-- Represents the orders placed
CREATE TABLE "orders" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "store_id" INTEGER NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "amount" NUMERIC NOT NULL,
    "datetime" TEXT DEFAULT CURRENT_TIMESTAMP,
    "order_type" TEXT NOT NULL DEFAULT 'Dine-In' CHECK ("order_type" IN ('Dine-In', 'Takeaway', 'Delivery')),
    FOREIGN KEY ("store_id") REFERENCES "stores" ("id"),
    FOREIGN KEY ("customer_id") REFERENCES "customers" ("id")
);

-- Represents the products which are ordered
CREATE TABLE "ordered_products" (
    "order_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    FOREIGN KEY ("order_id") REFERENCES "orders" ("id"),
    FOREIGN KEY ("product_id") REFERENCES "products" ("id")
);


-- Indexes created
CREATE INDEX "employee_search" ON "employees"("id","first_name","last_name","working_store_id","position_id");
CREATE INDEX "supplier_search" ON "suppliers"("id","supplier_name","city_id");
CREATE INDEX "store_search" ON "stores"("id", "address","city_id");
CREATE INDEX "finances_search" ON "finances"("store_id","year");
CREATE INDEX "financial_data" ON "finances"("yearly_revenue","yearly_expenses");
CREATE INDEX "customer_search" ON "customers"("id","first_name","last_name");
CREATE INDEX "op_search" ON "ordered_products"("order_id","product_id");

----------------------------------------
-- Views created

-- employee related information
CREATE VIEW "employee_work" AS
SELECT
    e.id AS 'Employee ID',
    e.first_name AS 'First Name',
    e.last_name AS 'Last Name',
    e.salary AS 'Salary',
    s.address AS 'Store Address',
    p.position AS 'Position'
FROM "employees" AS e
JOIN "stores" AS s
ON e.working_store_id = s.id
JOIN "positions" AS p
ON e.position_id = p.id
GROUP BY e.id;

-- Information about customer and their orders
CREATE VIEW "customer_orders" AS
SELECT
    c.first_name AS 'First Name',
    c.last_name AS 'Last Name',
    c.membership AS 'Membership',
    SUM(op.quantity) AS 'Number of Products',
    o.amount AS 'Total Cost',
    o.order_type AS 'Order Type'
FROM
    "customers" AS c
JOIN
    "orders" AS o
ON
    o.customer_id = c.id
JOIN
    "ordered_products" AS op
ON
    o.id = op.order_id
GROUP BY
    o.id;

--Suppliers in cities
CREATE VIEW "supplier_cities" AS
SELECT
    "supplier_name" AS 'Supplier Name',
    "name" AS 'City Name',
    s.address AS 'Address',
    s.phone_no AS 'Phone Number'
FROM
    "suppliers" AS s
JOIN
    "cities" AS c
ON s.city_id = c.id
ORDER BY s.city_id;

---------------------------------
-- Triggers

-- If entered position is not valid
CREATE TRIGGER invalid_employee_position
BEFORE INSERT ON employees
FOR EACH ROW
WHEN NEW.position_id NOT IN (SELECT "id" FROM "positions")
BEGIN
    SELECT RAISE (ABORT,'Job Position is not valid.');
END;


-- If entered date is in the future
CREATE TRIGGER invalid_employee_hired_date
BEFORE INSERT ON employees
FOR EACH ROW
WHEN NEW.hired_date > CURRENT_DATE
BEGIN
    SELECT RAISE (ABORT,'Date is not valid.');
END;

-- If city_id of a new supplier is not in available cities
CREATE TRIGGER invalid_supplier_cityid
BEFORE INSERT ON suppliers
FOR EACH ROW
WHEN NEW.city_id NOT IN (SELECT "id" FROM "cities")
BEGIN
    SELECT RAISE(ABORT,'City ID is not available');
END;

-- If the supplier is not available
CREATE TRIGGER invalid_supplier_id
BEFORE INSERT ON supplier_ingredients
FOR EACH ROW
WHEN NEW.supplier_id NOT IN (SELECT "id" FROM "suppliers")
BEGIN
    SELECT RAISE(ABORT, 'Supplier ID not available');
END;


-- If the ingredient is not available
CREATE TRIGGER invalid_ingredient_id
BEFORE INSERT ON supplier_ingredients
FOR EACH ROW
WHEN NEW.ingredient_id NOT IN (SELECT "id" FROM "ingredients")
BEGIN
    SELECT RAISE(ABORT, 'Ingredient ID not available');
END;

-- If entered city_id is invalid in stores
CREATE TRIGGER invalid_store_cityid
BEFORE INSERT ON stores
FOR EACH ROW
WHEN NEW.city_id NOT IN (SELECT "id" FROM "cities")
BEGIN
    SELECT RAISE(ABORT,'City ID is not available');
END;

