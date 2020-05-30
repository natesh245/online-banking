create database OnlineBanking

drop database OnlineBanking






create table ACCOUNT_TYPE(
	id int primary key identity(1020,2),
	account_type_name varchar(20) NOT NULL
	);


	insert into ACCOUNT_TYPE
	values ('Savings'),('Salary'),('Rural'),('Fixed')

	select * from ACCOUNT_TYPE

create table BRANCH(
	id varchar(20) primary key,
	branch_name varchar(20) NOT NULL
	);


	insert into BRANCH
	values ('BRANCHID01','BAGALURU CROSS'),('BRANCHID02','DEVANAHALLI'),('BRANCHID03','HEBBALA'),('BRANCHID04','KOGILU CROSS'),
	('BRANCHID05','MALLESHWARAM'),('BRANCHID06','MAJESTIC'),('BRANCHID07','HUNASEMARANAHALLI')

	SELECT * FROM BRANCH

create table CUSTOMER(
	id int primary key identity(1010,1),
	customer_name varchar(20) NOT NULL,
	fathers_name varchar(20) NOT NULL,
	date_of_birth DateTime NOT NULL,
	customer_age int NOT NULL,
	martial_status varchar(10),
	customer_address varchar(100) NOT NULL,
	customer_city varchar(20) NOT NULL,
	customer_state varchar(20) NOT NULL,
	customer_country varchar(20) NOT NULL,
	pincode int NOT NULL,
	phone bigint NOT NULL,
	email_id varchar(50)

);


create table ACCOUNT(
	account_no bigint primary key identity(110010001111,1),
	debit_card_no bigint NOT NULL,
	branch_id varchar(20) NOT NULL,
	foreign key (branch_id) references BRANCH (id),
	account_type_id int NOT NULL ,
	foreign key (account_type_id) references ACCOUNT_TYPE (id),
	customer_id int,
	foreign key (customer_id) references CUSTOMER (id),
	balance bigint NOT NULL,
	check_book_id varchar(10)

	);

create table USER_DETAILS(
	id int primary key identity(100,1),
	user_name varchar(20) NOT NULL,
	user_password varchar(20)  NOT NULL,
	account_no bigint,
	foreign key (account_no) references ACCOUNT (account_no)
	

);



create table TRANSACTION_DETAILS(
		id int primary key identity(1050,1),
		from_account_no bigint NOT NULL ,
		foreign key (from_account_no) references ACCOUNT (account_no),
		to_account_no bigint NOT NULL,
		foreign key (to_account_no) references ACCOUNT (account_no),
		debit_amount int,
		credit_amount int,
		transaction_date DateTime NOT NULL,
		transaction_description varchar(50),
	);


create table FIXED_DEPOSIT(
	account_no bigint,
	foreign key (account_no) references ACCOUNT (account_no),
	balance bigint,
	amount bigint,
	duration Datetime,
	rate_of_interest  int,
	maturity_date datetime NOT NULL,
	maturity_amount bigint,
	transfer_to_account bigint  NOT NULL,
	nominee varchar(50)

);