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


--добавим таблицу с должностями
create table positions (
	position_id serial primary key,
	position_name text not null
)

--добавим таблицу с уровнями доступа к данным
create table access_levels (
	level_id serial primary key,
	level_name text not null,
	finance_data bool, --все финансы
	logistic_data bool, --данные по адресам
	sales_data bool, --данные для продажи
	purchase_data bool --данные для работы с поставщиками
)

--добавим должность и уровень доступа
alter table workers add column 
	position int references positions(position_id);

alter table workers add column
	access_level int references access_levels(level_id);

--добавим таблицу с адресами
--не будем использовать КЛАДР, потому что я так вижу. цветочный магазин небольшой, доставка работает в пределах одного города
create table addresses (
	address_id serial primary key,
	street text not null,
	house_num text not null, -- корпуса, дроби, буквы, всё в текст
	room_num text, -- номер помещения
	store int, --этаж
	notes text --примечания по адресу
);


--меняем тип столбца, будет не адрес, а ссылка на адрес
alter table workers 
	alter column address type int using address::integer;
alter table workers
	add constraint fk_address foreign key(address) references addresses(address_id);


-- создадим таблицу - корзину, в которой будем хранить количество заказанных продуктов с привязкой к номеру заказа


create table carts (
	cart_id serial primary key,
	order_id int references orders(order_id),
	product_id int references products(product_id),
	amount int check (amount > 0),
	price numeric(5,2)
);
	
-- удалим странный неатомарный столбец order_products из таблицы orders, будем использовать внешний ключ таблицы carts

--свяжем заказы с адресами
alter table orders 
	drop column order_address;
alter table orders 
	add column address_id int references addresses(address_id);

alter table workers
	add constraint fk_address foreign key(address) references addresses(address_id);
	

--добавим столбец с ценой продуктам
alter table products 
	add column product_price numeric(6,2);

--создадим таблицу пользователей интернет-магазина
create table customers (
	customer_id serial primary key,
	login text not null unique,
	pass text not null
);

--свяжем заказы и пользователей
alter table orders 
	add column customer_id int references customers(customer_id);

--свяжем заказы поставщикам и продукты, заказы и расходы, поправим таблицу заказов поставщикам
alter table purchases 
	drop column purchase_name;
alter table purchases 
	drop column purchase_color;
alter table purchases 
	drop column purchase_count;

alter table purchases 
	add column purchase_price numeric(6,2);
alter table purchases 
	add column product_id int references products(product_id);

alter table purchases 
	add column expense_id int references expenses(expense_id);

--свяжем платежи и расходы
alter table payments 
	add column expense_id int references expenses(expense_id);

--создадим таблицу с платежами по заказам покупателей
create table customer_payments (
	customer_payment_id serial primary key,
	order_id int references orders(order_id),
	amount numeric(6,2),
	payment_date timestamp
);

------------
create extension postgres_fdw;

create server remote_flowers
foreign data wrapper postgres_fdw
options 



