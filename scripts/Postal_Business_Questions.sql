SET SEARCH_PATH TO "Project";

--Query 1: Select all columns and all rows from one table (5 points)
--Qs. List the supplier information for all suppliers

select * from supply_chain;

--Query 2: Select five columns and all rows from one table (5 points)
--Qs. List the supplier, order and item details (order id, order date, item id and quantity) for orders of all suppliers.

select order_id, supply_chain_id, order_date, item_id, quantity from sales_orders;

-- Query 3: Select all columns from all rows from one view (5 points)
-- Qs. Select all initial payment/order information from all records supply_chain_sales_order view

/* Create View */
CREATE VIEW v_supply_chain_sales_order AS
  SELECT sc.supply_chain_name, so.order_date, sc.posting_location as source_location, so.des_zip_code as destination_location, 
  sum(payment_amount) as initial_payment_amount
  FROM supply_chain sc left join sales_orders so
  on sc.supply_chain_id = so.supply_chain_id
  group by sc.supply_chain_name, so.order_date, sc.posting_location,so.des_zip_code;
select * from v_supply_chain_sales_order;

--Query 4: Using a join on 2 tables, select all columns and all rows from the tables without the use of a Cartesian product (5 points)
--Qs. Find the mail piece scan and delivery details, for all mail pieces.

select * from mail_piece_scans mps join delivery del on mps.mail_piece_id = del.mail_piece_id;

--Query 5: Select and order data retrieved from one table (5 points)
--Qs. Find the average weight of all mail pieces for each supplier. Display the supplier id, average weight from highest to lowest.
--Round the result to two decimal places.

SELECT bc_supply_chain_id, ROUND(AVG(actual_weight),2) AS avg_weight
FROM mail_piece_scans
GROUP BY bc_supply_chain_id
ORDER BY avg_weight DESC;

-- Query 6: Using a join on 3 tables, select 5 columns from the 3 tables. Use syntax that would limit the output to 10 rows (5 points)
-- Qs Using supply_chain, mail_piece_scans and delivery table, select 5 relevant columns. Limit the final output to 10 records only

select sc.supply_chain_name, ms.mc_location_id, ms.mail_piece_scan_time, d.delivery_time, d.zip_code
from supply_chain sc left join mail_piece_scans ms
on sc.supply_chain_id=ms.bc_supply_chain_id
left join delivery d
on ms.bc_supply_chain_id=d.bc_supply_chain_id
limit 10;

-- Query 7: Select distinct rows using joins on 3 tables (5 points)
-- Qs Using supply_chain, sales_order and adjustments select distinct supplier's inital amount and quantity as well as 
-- final adjustment amount and quantity while limiting 10 records in output

select sc.supply_chain_name, sum(so.payment_amount) as initial_payment_amount, sum(a.adj_amount) as adjusted_amount, 
sum(so.quantity) as initial_quantity, sum(a.adj_volume) as adjusted_quantity
from supply_chain sc left join sales_orders so
on sc.supply_chain_id = so.supply_chain_id
left join adjustments a
on so.supply_chain_id = a.supply_chain_id
group by sc.supply_chain_name
limit 10;

--Query 8: Use GROUP BY and HAVING in a select statement using one or more tables (5 points)
--Qs. Find the supplier id, name and total amount paid by each supplier whose total payment amount is greater than $25.
--Order the result by supplier id.

SELECT sc.supply_chain_id, sc.supply_chain_name, SUM(so.payment_amount) AS total_payment
FROM supply_chain sc LEFT JOIN sales_orders so ON sc.supply_chain_id = so.supply_chain_id
GROUP BY sc.supply_chain_id, sc.supply_chain_name
HAVING SUM(so.payment_amount) > 25
ORDER BY sc.supply_chain_id;

--Query 9: Use IN clause to select data from one or more tables (5 points)
--Qs. Find the suppliers whose adjustments are in small and large parcel categories.
--Display supplier id, name, adjustment description, code and adjusted volume.

SELECT sc.supply_chain_id, sc.supply_chain_name, adj.adj_desc, adj.adj_code, adj.adj_volume
from supply_chain sc join adjustments adj on sc.supply_chain_id = adj.supply_chain_id
where adj.adj_code IN ('SP2', 'LP3');

--Query 10: Select length of one column from one table (use LENGTH function) (5 points)

SELECT LENGTH(supply_chain_name) AS sc_name_length FROM supply_chain;

-- Query 11: Delete one record from one table. Use select statements to demonstrate the table contents before and after 
-- the DELETE statement. Make sure you use ROLLBACK afterwards so that the data will not be physically removed (5 points)

select * from delivery where delivery_id='25000';
BEGIN;
delete from delivery where delivery_id='25000';
select * from delivery where delivery_id='25000';
ROLLBACK;
select * from delivery where delivery_id='25000';

-- Query 12: Update one record from one table. Use select statements to demonstrate the table contents before and after 
-- the UPDATE statement. Make sure you use ROLLBACK afterwards so that the data will not be physically removed (5 points)

select * from delivery where addressline2='Pearl Apts' and delivery_id='25000';
BEGIN;
update delivery set addressline2='Marquis Apt' where addressline2='Pearl Apts' and delivery_id='25000';
select * from delivery where addressline2='Pearl Apts' and delivery_id='25000';
ROLLBACK;
select * from delivery where addressline2='Pearl Apts' and delivery_id='25000';

--Perform 2 Additional Advanced Queries (40 points)

--1. Write a query to obtain the top 3 most profitable suppliers.

WITH CTE_Top_Suppliers AS (
	select sc.supply_chain_name as Supply_Chain_Name,concat('$ '||sum(so.payment_amount+a.adj_amount)) as Revenue
	from supply_chain sc left join sales_orders so
	on sc.supply_chain_id=so.supply_chain_id
	left join adjustments a
	on so.supply_chain_id=a.supply_chain_id
	group by sc.supply_chain_name
)
select * from CTE_Top_Suppliers
order by revenue desc
limit 3;

--2. Find the 5 slowest performing mail centres.

select ms.mc_location_id as Mail_Centers,concat(AVG(DATE_PART('hour', d.delivery_time - ms.mail_piece_scan_time)) ||' Hours')
as Average_Delivery_Time,sum(so.quantity) as Quantity_Delivered
from mail_piece_scans ms left join delivery d
on ms.bc_supply_chain_id=d.bc_supply_chain_id
left join sales_orders so
on d.bc_supply_chain_id=so.supply_chain_id
where so.quantity > (
	select avg(quantity) from sales_orders
	)
group by ms.mc_location_id
order by Average_Delivery_Time desc
limit 5;
