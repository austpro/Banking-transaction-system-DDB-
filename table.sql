create table transaction(
	transaction_id int,
	account_id int,
	transaction_type varchar2(20),
	account_to int null,
	account_from int null,
	amount number,
	prev_balance number(20),
	balance number,
	primary key(transaction_id)
);