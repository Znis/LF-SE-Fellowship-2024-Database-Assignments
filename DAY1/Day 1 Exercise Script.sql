create schema sales;

-- Create Products table
create table
    Products (
        product_id int primary key,
        product_name varchar(50),
        category varchar(50),
        price decimal
    );

-- Create Orders table
create table
    Orders (
        order_id int primary key,
        customer_name varchar(50),
        product_id int,
        quantity int,
        order_date date,
        foreign key (product_id) references Products (product_id) on delete cascade
    );

-- Qno.1 Perform CRUD
-- Insert dummy values into Products table
insert into
    Products (product_id, product_name, category, price)
values
    (1, 'Laptop', 'Electronics', 999.99),
    (2, 'Smartphone', 'Electronics', 599.99),
    (3, 'Headphones', 'Accessories', 199.99),
    (4, 'Office Chair', 'Furniture', 149.99),
    (5, 'Coffee Maker', 'Appliances', 89.99),
    (6, 'Tablet', 'Electronics', 329.99),
    (7, 'Monitor', 'Electronics', 199.99),
    (8, 'Desk Lamp', 'Furniture', 49.99),
    (9, 'Mouse', 'Accessories', 29.99),
    (10, 'Keyboard', 'Accessories', 79.99);

-- Insert dummy values into Orders table
insert into
    Orders (
        order_id,
        customer_name,
        product_id,
        quantity,
        order_date
    )
values
    (1, 'Alice Johnson', 1, 1, '2024-06-01'),
    (2, 'Bob Smith', 2, 2, '2024-06-03'),
    (3, 'Charlie Brown', 3, 1, '2024-06-05'),
    (4, 'Diana Prince', 4, 1, '2024-06-07'),
    (5, 'Ethan Hunt', 5, 1, '2024-06-09'),
    (6, 'Fiona Apple', 6, 1, '2024-06-11'),
    (7, 'George Lucas', 7, 2, '2024-06-13'),
    (8, 'Hannah Montana', 8, 1, '2024-06-15'),
    (9, 'Ian Fleming', 9, 3, '2024-06-17'),
    (10, 'Jack Sparrow', 10, 1, '2024-06-19');

-- Read products that are in Electronics category from Products table
select
    product_name
from
    Products
where
    category = 'Electronics';

-- Read products that are in Electronics category from Products table
select
    customer_name
from
    Orders
where
    order_date between '2024-06-01' and '2024-06-03';

-- Update the price of Laptop from Products table
update Products
set
    price = 899.99
where
    product_name = 'Laptop';

-- Update the quantity of order_id 1 from Orders table
update Orders
set
    quantity = 4
where
    order_id = 1;

-- Delete the Appliances category from Products table
select
    *
from
    Products
where
    category = 'Appliances';

-- verify the records to be deleted
delete from Products
where
    category = 'Appliances';

-- Delete the order_id 4 from Orders table
select
    *
from
    Orders
where
    order_id = 4;

-- verify the records to be deleted
delete from Orders
where
    order_id = 4;

-- Qno.2 Calculate the total quantity ordered for each product category in the Orders table
select
    p.category,
    sum(o.quantity) as totalQuantity
from
    products p
    join orders o on p.product_id = o.product_id
group by
    p.category
order by
    sum(o.quantity) desc;

-- Qno.3 Find categories where the total number of products ordered is greater than 5
select
    p.category,
    count(p.category) as totalProductsOrdered
from
    products p
    join orders o on p.product_id = o.product_id
group by
    p.category
having
    count(p.category) > 5
order by
    count(p.category) desc;