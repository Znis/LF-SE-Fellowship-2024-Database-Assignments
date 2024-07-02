create schema bookstore;

create table Authors (
author_id int primary key,
author_name varchar(100),
birth_date date,
nationality varchar(50)
);

create table Publishers (
publisher_id int primary key,
publisher_name varchar(100),
country varchar(50)
);


create table Customers (
customer_id int primary key,
customer_name varchar(100),
email varchar(100),
address varchar(100)
);

create table Books (
book_id int primary key,
title varchar(100),
genre varchar(50),
publisher_id int,
publication_year date,
foreign key (publisher_id) references Publishers(publisher_id)
);

create table Orders (
order_id int primary key,
order_date date,
customer_id int,
total_amount decimal,
foreign key (customer_id) references Customers(customer_id)
);

create table Book_Authors (
book_id int,
author_id int,
foreign key (book_id) references Books(book_id),
foreign key (author_id) references Authors(author_id)
);

create table Order_Items(
order_id int,
book_id int,
foreign key (order_id) references Orders(order_id),
foreign key (book_id) references Books(book_id)
);




