set search_path to flower_power;

create table products(
	product_id serial primary key,
	product_name varchar(50) not null unique,
	product_amount decimal(10, 2) not null,
	product_color varchar(30) not null,
	product_count integer not null
);

create table workers(
	worker_id serial primary key,
	last_name varchar(50) not null,
	first_name varchar(30) not null,
	age integer not null,
	salary decimal(10, 2) not null,
	address text not null
);

create table expenses(
	expense_id serial primary key,
	expense_type varchar(50) not null,
	expense_amount decimal(10,2) not null
);

create table purchases(
purchase_id serial primary key,
	purchase_name varchar(50) not null unique,
	purchase_amount decimal(10,2) not null,
	purchase_color varchar(30) not null,
	purchase_count integer not null,
	payment_date timestamp
);

create table orders(
	order_id serial primary key,
	order_product json not null, --{product_id: count}
	order_address text not null
);

create table payments(
	payment_id serial primary key,
	payment_amount decimal(10,2) not null,
	payment_date timestamp default now()
);

--свяжем платежи с расходами
alter table payments add column
	expense_id int references expenses(expense_id);

--добавим таблицу с должностями
create table positions (
	position_id serial primary key,
	position_name text not null,
)

--добавим должность и уровень доступа
alter table workers add columns (
	position int references positions(position_id)
)
