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

--------------------------------------------


--������� ������� � �����������
create table positions (
	position_id serial primary key,
	position_name text not null
)

--������� ������� � �������� ������� � ������
create table access_levels (
	level_id serial primary key,
	level_name text not null,
	finance_data bool, --��� �������
	logistic_data bool, --������ �� �������
	sales_data bool, --������ ��� �������
	purchase_data bool --������ ��� ������ � ������������
)

--������� ��������� � ������� �������
alter table workers add column 
	position int references positions(position_id);

alter table workers add column
	access_level int references access_levels(level_id);

--������� ������� � ��������
--�� ����� ������������ �����, ������ ��� � ��� ����. ��������� ������� ���������, �������� �������� � �������� ������ ������
create table addresses (
	address_id serial primary key,
	street text not null,
	house_num text not null, -- �������, �����, �����, �� � �����
	room_num text, -- ����� ���������
	store int, --����
	notes text --���������� �� ������
);

alter table workers 
	alter column address type int using address::integer;

