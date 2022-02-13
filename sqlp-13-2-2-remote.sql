create table carts (
	cart_id int,
	order_id int,
	product_id int,
	amount int check (amount > 0),
	price numeric(5,2)
)