--Some Select Statements

-- Cities which are located in the state of Karnataka
SELECT * FROM "cities"
WHERE "state" = 'Karnataka';

-- The suppliers in the city of Panaji
SELECT * FROM "suppliers"
WHERE "city_id" = (
    SELECT "id" FROM "cities"
    WHERE "name" = 'Panaji'
);

-- The ingredients supplied by the supplier(s) in the state of Tamil Nadu
SELECT i."name", s."supplier_name" AS 'Supplier'
FROM "ingredients" AS i
JOIN "supplier_ingredients" AS si
ON si.ingredient_id = i.id
JOIN "suppliers" AS s
ON si.supplier_id = s.id
WHERE s.city_id = (
    SELECT "id" FROM "cities"
    WHERE "state" = 'Tamil Nadu'
);

-- All the suppliers who supply the ingredient 'Coffee Powder'
SELECT s."supplier_name"
FROM "suppliers" AS s
JOIN "supplier_ingredients" AS si
ON si.supplier_id = s.id
WHERE si.ingredient_id = (
    SELECT "id"
    FROM "ingredients"
    WHERE "name" = 'Coffee Powder'
);

-- The stores which have more than 7 employees
SELECT "address", "email", "opening_date"
FROM "stores"
WHERE "total_employees" > 7;

-- All the stores in the city of Mumbai
SELECT * FROM "stores"
WHERE "address" LIKE '%Mumbai%';

-- The stores which have been recently opened
SELECT * FROM "stores"
WHERE "total_employees" = 0;

-- The 5 most recent stores which are currently operating
SELECT "id","address","opening_date"
FROM "stores"
WHERE "total_employees" != 0
ORDER BY "opening_date" DESC
LIMIT 5;

-- Select all the products in the 'Snacks' category
SELECT * FROM "products"
WHERE "category" = 'Snacks';

-- Select the 5 most expensive products
SELECT "product_name" AS 'Name', "price"
FROM "products"
ORDER BY "price" DESC
LIMIT 5;

-- Products sold in one of the stores in Mangalore
SELECT s.address, p.product_name, p.price
FROM "stores" AS s
JOIN "product_stores" AS ps
ON ps.store_id = s.id
JOIN "products" AS p
ON ps.product_id = p.id
WHERE s.id = (
    SELECT "id"
    FROM "stores"
    WHERE "city_id" = (
        SELECT "id" FROM "cities"
        WHERE "name" = 'Mangalore'
    )
    LIMIT 1
);

-- The positions which the employees can be assigned to
SELECT * FROM "positions";

-- The number of male and female employees
SELECT COUNT("first_name") AS 'Number of Employees', "gender"
FROM "employees"
GROUP BY "gender";

-- Employees who work in Bangalore and Mysore
SELECT e.first_name, e.last_name, c.name
FROM "employees" AS e
JOIN "stores" AS s
ON s.id = e.working_store_id
JOIN "cities" AS c
ON s.city_id = c.id
WHERE c.name = 'Bangalore' OR c.name = 'Mysore';

-- The employees who are managers
SELECT e.first_name, e.last_name, p.position
FROM "employees" AS e
JOIN "positions" AS p
ON p.id = e.position_id
WHERE p.position = 'Manager';

-- The employees who have not been assigned a store
SELECT "first_name", "last_name"
FROM "employees"
WHERE "working_store_id" IS NULL;

-- Top 5 stores which made the most revenue in the year 2024
SELECT s.id, s.address, f.yearly_revenue AS 'Revenue',f.year
FROM "stores" AS s
JOIN "finances" AS f
ON f.store_id = s.id
WHERE f.year = 2024
ORDER BY f.yearly_revenue DESC
LIMIT 5;

-- Top 5 stores which made the least expenses in the year 2024
SELECT s.id, s.address, f.yearly_expenses AS 'Expenses',f.year
FROM "stores" AS s
JOIN "finances" AS f
ON f.store_id = s.id
WHERE f.year = 2024
ORDER BY f.yearly_expenses
LIMIT 5;

-- Customers who do not have a last name
SELECT "first_name"
FROM "customers"
WHERE "last_name" IS NULL;

-- The number of male and female customers
SELECT COUNT("first_name") AS "Customers", "gender"
FROM "customers"
GROUP BY "gender";

-- Top 5 customers who have saved the most amount
SELECT "first_name", "last_name", "saved_amount"
FROM "customers"
ORDER BY "saved_amount" DESC
LIMIT 5;

-- Customers who have a membership
SELECT "first_name", "last_name"
FROM "customers"
WHERE "membership" = 'Y';

-- Stores which made the 5 most expensive orders for the day
SELECT "store_id","amount"
FROM "orders"
ORDER BY "amount" DESC
LIMIT 5;

-- The customer who ordered the largest quantity
SELECT c.first_name, c.last_name, SUM(op.quantity) AS 'Quantity'
FROM "customers" AS c
JOIN "orders" AS o
ON o.customer_id = c.id
JOIN "ordered_products" AS op
ON op.order_id = o.id
GROUP BY op.order_id
LIMIT 1;

-- The supplier who provides the ingredient to the store from which customer Manish Patel ordered
SELECT s.supplier_name, ct.name AS 'City Name', s.phone_no
FROM "suppliers" AS s
JOIN "cities" AS ct
ON s.city_id = ct.id
JOIN "supplier_stores" AS ss
ON s.id = ss.supplier_id
WHERE ss.store_id IN (
    SELECT "store_id"
    FROM "orders"
    WHERE "customer_id" = (
        SELECT "id"
        FROM "customers"
        WHERE "first_name" = 'Manish' AND "last_name" = 'Patel'
    )
);


--------------------------------------------
-- Data Insertion

INSERT INTO "cities"("name","state")
VALUES
('Bangalore','Karnataka'),
('Mysore', 'Karnataka'),
('Mangalore','Karnataka'),
('Mumbai','Maharasthra'),
('Chennai','Tamil Nadu'),
('Pune','Maharasthra'),
('Kochi','Kerala'),
('Belagavi','Karnataka'),
('Panaji','Goa'),
('Hyderabad','Telangana');


INSERT INTO "suppliers"("supplier_name","address","city_id","phone_no")
VALUES
('Bangalore Coffee Co','12 Market St', 1, '9875623745'),
('Urban Supplies', '45 Bean St', 1, '8765432109'),
('Bangalore Organics','45 Green Rd', 1, '9123581247'),
('Mysore Spices Co.', '32 Heritage Rd', 2, '7654321098'),
('Nature Basket','78 Eco lane', 2, '8123452354'),
('Coastal Ingredients', '78 Sea Ln', 3, '6543210987'),
('City Bean Traders', '23 Maple St', 4, '4321098765'),
('Mumbai Cafe Provisions', '56 Gateway Ln', 4, '3210987654'),
('Urban Harvest', '67 Skyline Rd', 4, '2109876543'),
('Madras Cafe Supplies', '89 Pine Rd', 5, '1098765432'),
('Pune Coffee Traders', '90 Spice Ln', 6, '0987654321'),
('Kochi Cafe Supplies', '56 Backwater Rd', 7, '1090012345'),
('Green Valley Foods', '34 Howrah Rd', 8, '8765012345'),
('Pure Organics', '67 Marina St', 9, '6543012345'),
('Local Roots', '34 Hill Rd', 10, '3210012345');

INSERT INTO "ingredients"("name")
VALUES
('Coffee Powder'),('Tea Leaves'),('Milk Products'),('Chocolate Powder'),('Flour'),('Meat'),('Vegetables'),('Fruits'),
('Rice'),('Spices');

INSERT INTO "supplier_ingredients"("supplier_id", "ingredient_id")
VALUES
(1, 1), (1, 2), (1, 4), (1,10), (2, 3), (2, 5), (2, 6), (2, 7), (2, 8),(2, 9),
(3, 1), (3, 3), (3, 6), (3, 7),(3, 8),  (4, 1), (4, 2), (4, 4), (4, 9),(4, 10),
(5, 3), (5, 5),(5, 6), (5, 7), (5, 8),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6), (7, 1), (7, 2), (7, 4), (7, 10),
(8, 3), (8, 5), (8, 6), (8, 7), (8, 8), (8, 9),
(9, 1), (9, 3), (9, 4), (9, 5), (9, 6), (10, 1), (10, 2), (10, 3),
(10, 4), (10, 5), (10, 6), (10, 7), (10, 8),
(11, 1), (11, 2), (11, 3), (11, 4), (11, 5), (11, 6), (11, 7),
(12, 2), (12, 3), (12, 5), (12, 6), (12, 7), (13, 1),
(13, 2), (13, 3), (13, 4), (13, 5), (13, 6), (13, 7), (13, 8), (13, 9), (13, 10),
(14, 1), (14, 3), (14, 4), (14, 5), (14, 7),(14, 8), (14, 9), (14, 10);

INSERT INTO "stores"("address", "email","phone_no","city_id","total_employees","opening_date")
VALUES
('123 MG Road, Bangalore', 'cafecobang1@gmail.com', '9876543210',1,10,'2009-09-11'),
('45 North Street, Bangalore', 'cafecobang2@gmail.com', '8765432190',1,6,'2010-08-09'),
('67 Green View Road, Bangalore', 'cafecobang3@gmail.com', '7654321098',1,7,'2010-08-10'),
('34 Royal Lane, Mysore', 'cafecomysore1@gmail.com', '6543210987',2,5,'2012-05-21'),
('56 Heritage Avenue, Mysore', 'cafecomysore2@gmail.com', '5432109876',2,0,'2024-12-01'),
('78 Beachside Lane, Mangalore', 'cafecomang1@gmail.com', '4321098765',3,9,'2015-01-30'),
('90 Coastal Street, Mangalore', 'cafecomang2@gmail.com', '3210987654',3,8,'2018-10-18'),
('12 Colaba Road, Mumbai', 'cafecomumbai1@gmail.com', '2109876543',4,10,'2017-07-07'),
('34 Marine Drive, Mumbai', 'cafecomumbai2@gmail.com', '1098765432',4,8,'2018-10-08'),
('45 Gateway Lane, Mumbai', 'cafecomumbai3@gmail.com', '0987654321',4,0,'2024-12-02'),
('67 Marina Beach Road, Chennai', 'cafecochennai1@gmail.com', '9876501234',5,6,'2014-05-04'),
('78 Cotton Lane, Chennai', 'cafecochennai2@gmail.com', '8765012345',5,8,'2016-02-06'),
('89 Skyline Avenue, Pune', 'cafecopune1@gmail.com', '7654012345',6,7,'2018-06-07'),
('23 Heritage Boulevard, Pune', 'cafecopune2@gmail.com', '6543012345',6,0,'2024-12-02'),
('45 Backwater Road, Kochi', 'cafecokochi1@gmail.com', '5432012345',7,10,'2016-11-04'),
('12 Cantonment Road, Belagavi', 'cafecobelagavi1@gmail.com', '4321012345',8,0,'2024-11-03'),
('67 Old Goa Road, Panaji', 'cafecogoa1@gmail.com', '3210012345',9,9,'2020-05-04'),
('45 Riverfront Lane, Panaji', 'cafecogoa2@gmail.com', '2100012345',9,8,'2021-06-05'),
('78 Charminar Street, Hyderabad', 'cafecohyder1@gmail.com', '1090012345',10,5,'2023-08-12'),
('90 Jubilee Hills Avenue, Hyderabad', 'cafecohyder2@gmail.com', '0980012345',10,0,'2024-12-05');

INSERT INTO "supplier_stores"("supplier_id","store_id")
VALUES
(1,1),(1,2),(2,1),(2,3),(3,3),(4,4),(4,5),(5,4),(5,5),(6,7),(6,8),(7,8),(7,9),(7,10),(8,8),
(8,9),(8,10),(9,11),(9,12),(10,13),(10,14),(11,15),(12,16),(13,17),(13,18),(14,19),(14,20);

INSERT INTO "products"("product_name","price","category")
VALUES
('Cappucino',100.00,'Beverage'),
('Latte',120.00,'Beverage'),
('Milk Tea',90.00,'Beverage'),
('Black Tea',80.00,'Beverage'),
('Hot Chocolate',120.00,'Beverage'),
('Apple MilkShake',80.00,'Juice'),
('Mango MilkShake',80.00,'Juice'),
('Banana MilkShake',80.00,'Juice'),
('Watermelon Juice',70.00,'Juice'),
('Orange Juice',70.00,'Juice'),
('Cheese Sandwich',100.00,'Snacks'),
('Paneer Sandwich',120.00,'Snacks'),
('Chicken Sandwich',150.00,'Snacks'),
('Veg Burger',150.00,'Main Dish'),
('Chicken Burger',170.00,'Main Dish'),
('Fruit Salad',60.00,'Sides'),
('French Fries',50.00,'Sides'),
('Veg Fried Rice',100.00,'Main Dish'),
('Chicken Fried Rice',150.00,'Main Dish'),
('Chocolate Cake',200.00,'Sweets'),
('Red Velvet',200.00,'Sweets'),
('Cheesecake',200.00,'Sweets'),
('Pastry',250.00,'Sweets');

INSERT INTO "product_stores"("store_id","product_id")
VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 11), (1, 12), (1, 13), (1, 16), (1, 20), (1, 21),
(2, 1), (2, 7), (2, 8), (2, 9), (2, 10), (2, 6), (2, 13), (2, 15), (2, 18), (2, 19), (2, 22), (2, 23),
(3, 2), (3, 4), (3, 5), (3, 7), (3, 8), (3, 9), (3, 14), (3, 15), (3, 17), (3, 20), (3, 21), (3, 22),
(4, 1), (4, 2), (4, 3), (4, 5), (4, 6), (4, 10), (4, 11), (4, 14), (4, 16), (4, 18), (4, 22), (4, 23),
(5, 2), (5, 3), (5, 4), (5, 7), (5, 8), (5, 12), (5, 13), (5, 15), (5, 19), (5, 20), (5, 21), (5, 23),
(6, 1), (6, 5), (6, 6), (6, 7), (6, 9), (6, 10), (6, 12), (6, 14), (6, 17), (6, 18), (6, 19), (6, 22),
(7, 3), (7, 4), (7, 5), (7, 8), (7, 9), (7, 11), (7, 12), (7, 15), (7, 16), (7, 17), (7, 20), (7, 21),
(8, 1), (8, 2), (8, 6), (8, 7), (8, 8), (8, 9), (8, 10), (8, 14), (8, 16), (8, 17), (8, 19), (8, 21),
(9, 2), (9, 3), (9, 4), (9, 6), (9, 7), (9, 11), (9, 13), (9, 15), (9, 18), (9, 19), (9, 20), (9, 23),
(10, 1), (10, 5), (10, 6), (10, 7), (10, 9), (10, 10), (10, 12), (10, 14), (10, 16), (10, 18), (10, 21), (10, 22),
(11, 2), (11, 4), (11, 5), (11, 6), (11, 8), (11, 10), (11, 12), (11, 13), (11, 15), (11, 17), (11, 18), (11, 22),
(12, 1), (12, 3), (12, 4), (12, 7), (12, 8), (12, 9), (12, 11), (12, 14), (12, 16), (12, 19), (12, 20), (12, 23),
(13, 2), (13, 4), (13, 5), (13, 7), (13, 8), (13, 9), (13, 12), (13, 14), (13, 16), (13, 18), (13, 20), (13, 22),
(14, 1), (14, 3), (14, 6), (14, 7), (14, 8), (14, 10), (14, 11), (14, 13), (14, 15), (14, 17), (14, 19), (14, 23),
(15, 2), (15, 5), (15, 6), (15, 7), (15, 9), (15, 10), (15, 12), (15, 13), (15, 16), (15, 18), (15, 20), (15, 22),
(16, 1), (16, 3), (16, 4), (16, 5), (16, 7), (16, 9), (16, 10), (16, 12), (16, 14), (16, 16), (16, 19), (16, 21),
(17, 2), (17, 3), (17, 5), (17, 6), (17, 7), (17, 8), (17, 11), (17, 13), (17, 15), (17, 17), (17, 20), (17, 23),
(18, 1), (18, 4), (18, 6), (18, 7), (18, 9), (18, 10), (18, 12), (18, 13), (18, 16), (18, 19), (18, 21), (18, 22),
(19, 2), (19, 3), (19, 5), (19, 6), (19, 8), (19, 9), (19, 10), (19, 14), (19, 15), (19, 17), (19, 19), (19, 23),
(20, 1), (20, 3), (20, 5), (20, 6), (20, 7), (20, 8), (20, 10), (20, 12), (20, 14), (20, 16), (20, 18), (20, 21);

INSERT INTO "positions" ("position")
VALUES
('Manager'),('Cashier'),('Floor Staff'),('Cook'),('Barista');

INSERT INTO "employees" ("first_name","last_name","dob","gender","email","phone_no", "address", "salary",
"working_store_id", "position_id", "hired_date")
VALUES
('Aarav', 'Sharma', '1990-02-15', 'M', 'aarav.sharma@example.com', '9876543201', '123 MG Road, Bangalore', 60000, 1, 1, '2018-01-15'),
('Isha', 'Patel', '1994-07-10', 'F', 'isha.patel@example.com', '9876543202', '12 Residency Rd, Bangalore', 25000, 1, 2, '2019-03-12'),
('Rahul', 'Mehta', '1992-05-24', 'M', 'rahul.mehta@example.com', '9876543203', '34 Brigade Rd, Bangalore', 20000, 2, 3, '2020-06-01'),
('Rajesh', 'Verma', '1989-03-21', 'M', 'rajesh.verma@example.com', '9876543205', '56 Koramangala, Bangalore', 25000, 2, 4, '2019-11-15'),
('Simran', 'Kaur', '1993-08-12', 'F', 'simran.kaur@example.com', '9876543206', '67 Whitefield, Bangalore', 25000, 3, 4, '2020-12-01'),
('Ravi', 'Sharma', '1989-03-18', 'M', 'ravi.sharma@example.com', '9876543261', '23 Jayalakshmipuram, Mysore', 52000, 3, 1, '2016-07-12'),
('Anjali', 'Iyer', '1993-05-27', 'F', 'anjali.iyer@example.com', '9876543262', '45 Kuvempunagar, Mysore', 34000, 4, 2, '2018-11-05'),
('Arun', 'Patil', '1990-08-11', 'M', 'arun.patil@example.com', '9876543263', '67 Vijayanagar, Mysore', 31000, 4, 3, '2019-06-22'),
('Ramesh', 'Shetty', '1988-04-15', 'M', 'ramesh.shetty@example.com', '9876543271', '12 Kadri Hills, Mangalore', 55000, 6, 1, '2015-03-01'),
('Sneha', 'Pai', '1992-06-10', 'F', 'sneha.pai@example.com', '9876543272', '34 Bejai, Mangalore', 36000, 6, 2, '2016-09-15'),
('Vikram', 'Hegde', '1990-02-25', 'M', 'vikram.hegde@example.com', '9876543273', '56 Pandeshwar, Mangalore', 32000, 6, 3, '2017-07-12'),
('Priya', 'Shenoy', '1993-08-14', 'F', 'priya.shenoy@example.com', '9876543274', '78 Urwa, Mangalore', 31000, 7, 5, '2018-01-18'),
('Arjun', 'Kamath', '1989-11-22', 'M', 'arjun.kamath@example.com', '9876543275', '90 Kankanady, Mangalore', 33000, 7, 4, '2018-11-05'),
('Akshay', 'Mehta', '1990-04-15', 'M', 'akshay.mehta8@example.com', '9876501234', '12 Marine Drive, Mumbai', 40000, 8, 1, '2017-08-10'),
('Rohini', 'Deshmukh', '1994-05-12', 'F', 'rohini.deshmukh8@example.com', '8765409876', '23 Juhu Beach Rd, Mumbai', 28000, 8, 2, '2018-03-15'),
('Pranav', 'Joshi', '1992-06-20', 'M', 'pranav.joshi8@example.com', '9876309875', '45 Andheri West, Mumbai', 22000, 9, 3, '2018-11-05'),
('Sneha', 'Patil', '1996-08-22', 'F', 'sneha.patil8@example.com', '8765308764', '34 Malabar Hill, Mumbai', 25000, 9, 4, '2019-05-20'),
('Karan', 'Kapoor', '1993-10-10', 'M', 'karan.kapoor8@example.com', '9876207654', '67 Colaba Rd, Mumbai', 22000, 9, 5, '2019-10-15'),
('Arun', 'Subramanian', '1990-04-12', 'M', 'arun.subramanian11@example.com', '9876123450', '15 T. Nagar, Chennai', 40000, 11, 1, '2014-06-15'),
('Deepa', 'Ramesh', '1992-07-20', 'F', 'deepa.ramesh11@example.com', '8765432101', '23 Adyar, Chennai', 27000, 11, 2, '2015-01-10'),
('Karthik', 'Rajendran', '1991-09-05', 'M', 'karthik.rajendran11@example.com', '9876223410', '78 Velachery, Chennai', 25000, 11, 3, '2015-08-20'),
('Priya', 'Krishnan', '1993-11-28', 'F', 'priya.krishnan11@example.com', '8765324102', '34 Anna Nagar, Chennai', 26000, 12, 4, '2016-03-15'),
('Suresh', 'Iyer', '1989-12-15', 'M', 'suresh.iyer11@example.com', '9876324012', '56 Besant Nagar, Chennai', 29000, 12, 5, '2017-05-01'),
('Amit', 'Patel', '1990-01-15', 'M', 'amit.patel13@example.com', '9876543210', '123 MG Road, Pune', 35000, 13, 1, '2018-06-10'),
('Pooja', 'Sharma', '1993-07-22', 'F', 'pooja.sharma13@example.com', '8765432109', '45 Kothrud, Pune', 29000, 13, 2, '2018-07-25'),
('Nikhil', 'Deshmukh', '1988-03-09', 'M', 'nikhil.deshmukh13@example.com', '9876325478', '78 Koregaon Park, Pune', 32000, 13, 3, '2019-08-10'),
('Ananya', 'Nair', '1992-04-12', 'F', 'ananya.nair@example.com', '8123456789', '34 Chamundeshwari Rd, Mysore', 31000, NULL, NULL, '2024-12-04'),
('Karan', 'Sharma', '1991-06-15', 'M', 'karan.sharma@example.com', '8456789012', '34 Laxmi Nagar, Pune', 32000, NULL, NULL, '2024-12-06'),
('Neha', 'Iyer', '1993-01-25', 'F', 'neha.iyer@example.com', '8567890123', '78 MG Road, Belagavi', 31000, NULL, NULL, '2024-12-07'),
('Suresh', 'Gupta', '1987-08-30', 'M', 'suresh.gupta@example.com', '8678901234', '45 Vashi, Mumbai', 34000, NULL, NULL, '2024-12-06'),
('Vikas', 'Reddy', '1993-10-10', 'M', 'vikas.reddy@example.com', '9012345678', '34 Kukatpally, Hyderabad', 32000, NULL, NULL, '2024-12-03');

INSERT INTO "finances"("store_id","yearly_revenue","yearly_expenses","year")
VALUES
(1, 19.56, 11.13, 2024),(1, 16.16, 9.63, 2023),(1, 15.14 ,8.13 ,2022),
(2, 10.87 ,7.03 ,2024), (2, 11.26, 9.13, 2023),(2, 9.62 ,6.13 ,2022),
(3, 19.56 ,11.13 ,2024),(3, 15.02, 10.14, 2023),(3, 10.78, 7.54, 2022),
(4, 14.45, 9.95, 2024),(4, 13.56, 8.42, 2023),(4, 12.90, 7.72, 2022),
(6, 13.12, 8.22, 2024),(6, 11.45, 7.64, 2023),(6, 14.30, 9.13, 2022),
(7, 14.50, 9.80, 2024),(7, 15.22, 10.10, 2023),(7, 12.77, 8.56, 2022),
(8, 11.99, 7.98, 2024),(8, 14.66, 9.29, 2023),(8, 13.34, 8.44, 2022),
(9, 12.88, 8.56, 2024),(9, 13.77, 9.06, 2023),(9, 11.52, 7.72, 2022),
(11, 15.00, 9.50, 2024),(11, 14.40, 8.92, 2023),(11, 13.20, 8.03, 2022),
(12, 13.11, 8.21, 2024),(12, 14.05, 9.12, 2023),(12, 12.44, 7.75, 2022),
(13, 14.25, 9.43, 2024),(13, 13.33, 8.01, 2023),(13, 12.60, 7.88, 2022),
(15, 13.80, 9.07, 2024),(15, 12.90, 8.64, 2023),(15, 14.10, 9.01, 2022),
(17, 12.80, 8.35, 2024),(17, 14.50, 9.12, 2023),(17, 13.10, 8.03, 2022),
(18, 13.44, 8.90, 2024),(18, 15.12, 9.50, 2023),(18, 14.60, 9.03, 2022),
(19, 14.33, 9.75, 2024),(19, 12.99, 8.63, 2023),(19, 13.77, 8.50, 2022);

INSERT INTO "customers"("first_name", "last_name","gender","address","email","phone_no","saved_amount","membership")
VALUES
('Aarav', 'Sharma', 'M', '12 MG Road, Bangalore', 'aarav.sharma@example.com', '9876543210', 15.50, 'N'),
('Saanvi', 'Patel', 'F', '34 Beach Road, Bangalore', 'saanvi.patel@example.com', '9888776655', 200.75, 'Y'),
('Rahul', 'Bhatia', 'M', '67 Palm Road, Bangalore', 'rahul.bhatia@example.com', '9900112233', 130.30, 'Y'),
('Vivaan', NULL, 'M', NULL, 'vivaan@example.com', '9998887777', 0.00, 'N'),
('Ananya', 'Iyer', 'F', '67 Temple Road, Bangalore', 'ananya.iyer@example.com', '9456677889', 22.40, 'N'),
('Arjun', 'Mehta', 'M', NULL, 'arjun.mehta@example.com', '9812345678', 100.25, 'Y'),
('Diya', 'Nair', 'F', '23 Hilltop Road, Mysore', 'diya.nair@example.com', NULL, 185.60, 'Y'),
('Rohan', NULL, 'M', '56 Riverside Lane, Mangalore', 'rohan@example.com', '9333445566', 13.45, 'N'),
('Isha', 'Verma', 'F', '78 Sunset Boulevard, Mumbai', 'isha.verma@example.com', '9900772211', 170.55, 'Y'),
('Madhuri', 'Gupta', 'F', '34 Palm Grove, Mumbai', 'madhuri.gupta@example.com', '9812334455', 12.50, 'N'),
('Aditya', 'Singh', 'M', NULL, 'aditya.singh@example.com', '9887665544', 95.80, 'N'),
('Priya', 'Choudhury', 'F', '34 Bluebell Road, Chennai', 'priya.choudhury@example.com', '9122334455', 180.90, 'Y'),
('Karthik', NULL, 'M', '45 Sunrise Street, Chennai', 'karthik@example.com', '9344556677', 110.65, 'Y'),
('Neha', 'Joshi', 'F', '67 Greenfield Avenue, Pune', 'neha.joshi@example.com', '9811223344', 25.10, 'N'),
('Manish', 'Patel', 'M', '23 Riverbank Drive, Kochi', 'manish.patel@example.com', NULL, 13.20, 'N'),
('Shivani', 'Rao', 'F', '89 Orchid Lane, Panaji', 'shivani.rao@example.com', '9922334455', 160.80, 'Y'),
('Kabir', 'Yadav', 'M', '12 Vine Street, Panaji', 'kabir.yadav@example.com', '9776554433', 90.70, 'Y'),
('Ayesha', NULL, 'F', '45 Rose Garden, Panaji', 'ayesha@example.com', NULL, 14.60, 'N'),
('Simran', 'Kaur', 'F', NULL, 'simran.kaur@example.com', '9444556677', 170.90, 'N'),
('Vishal', 'Shukla', 'M', '12 Jasmine Street, Hyderabad', 'vishal.shukla@example.com', '9711223344', 110.25, 'Y');

INSERT INTO "orders"("store_id","customer_id","amount","order_type")
VALUES
(1, 1, 310.00,  'Dine-In'), (1, 2, 760.00,  'Takeaway'),
(2, 3, 720.00,  'Delivery'), (3, 4, 200.00 , 'Dine-In'),
(3, 5, 270.00, 'Takeaway'), (4, 6, 400.00 ,'Dine-In'),
(4, 7, 750.00,  'Delivery'), (6, 8, 320.00 ,'Dine-In' ),
(8,9, 330.00,  'Delivery'),(9,10,220.00 ,'Dine-In' ),
(9, 11, 850.00,  'Takeaway'),(11,12,160.00 ,'Dine-In'),
(12, 13, 400.00,  'Takeaway'),(14, 14, 250.00 ,'Delivery'),
(15, 15, 440.00,'Dine-In'  ), (17,16, 360.00, 'Dine-In'),
(17, 17, 390.00,  'Delivery'), (18, 18, 350.00 , 'Takeaway'),
(19, 19, 400.00, 'Takeaway'),(19, 20, 320.00, 'Delivery');

INSERT INTO "ordered_products"("order_id","product_id","quantity")
VALUES
(1,1,2),(1,11,1),(1,16,1),(1,17,1),(2,2,1),(2,12,2),(2,21,2),(3,5,1),(3,20,2),(3,22,1),
(4,6,1),(4,16,2),(5,9,1),(5,20,1),(6,4,1),(6,13,1),(6,15,1),(7,14,1),(7,18,1),(7,23,2),
(8,15,1),(8,19,1),(9,6,1),(9,17,2),(9,19,1),(10,1,1),(10,2,1),(11,21,1),(11,22,2),
(11,23,1),(12,8,2),(13,2,1),(13,8,1),(13,11,2),(14,11,1),(14,13,1),(15,15,2),
(15,17,2),(16,5,3),(17,12,2),(17,17,1),(17,18,1),(18,11,2),(18,17,3),
(19,1,2),(19,21,1),(20,2,1),(20,22,1);


INSERT INTO "employees"("first_name","position_id") VALUES ("name",6);
INSERT INTO "employees"("first_name","hired_date") VALUES("name",'2025-12-29');
INSERT INTO "suppliers"("supplier_name", "city_id") VALUES("hello",24);
INSERT INTO "supplier_ingredients"("supplier_id","ingredient_id") VALUES(30,10);
