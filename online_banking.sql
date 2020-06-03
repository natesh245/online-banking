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
	email_id varchar(50),
	user_password varchar(20) ,

);

INSERT INTO CUSTOMER 
VALUES ('Shandar','FATHER','19970625',23,'unmarried','bc road','mangalore'
,'karnataka','India',575056,8050855690,'shandar246@gmail.com','123456')

select * from CUSTOMER


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

	select * from ACCOUNT_TYPE

	INSERT INTO ACCOUNT 
	VALUES (1234567891011,'BRANCHID01',1020,1010,100000,'CHECK01'),
	(1234567891012,'BRANCHID02',1020,1011,150000,'CHECK02'),
	(1234567891013,'BRANCHID03',1020,1012,1000200,'CHECK03')

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

	DROP TABLE TRANSACTION_DETAILS

	CREATE TABLE DEBIT_TRANSACTION_DETAILS(
		id int primary key identity(1050,1),
		debit_account_no bigint not null ,
		foreign key (debit_account_no) references ACCOUNT (account_no),
		debit_amount int,
		debit_date_time datetime not null,

	);

	select * from DEBIT_TRANSACTION_DETAILS

	alter table DEBIT_TRANSACTION_DETAILS
	ADD debit_account_balance bigint 

		alter table CREDIT_TRANSACTION_DETAILS
	ADD credit_account_balance bigint 

	select * from CREDIT_TRANSACTION_DETAILS

	CREATE TABLE CREDIT_TRANSACTION_DETAILS(
		id_debit int ,
		foreign key (id_debit) references DEBIT_TRANSACTION_DETAILS (id),
		credit_account_no bigint not null ,
		foreign key (credit_account_no) references ACCOUNT (account_no),
		credit_amount int,
		credit_date_time datetime not null,
	);

create table FIXED_DEPOSIT(
	deposit_id int primary key identity(100,1),
	account_no bigint,
	foreign key (account_no) references ACCOUNT (account_no),
	fd_date date,
	fd_amount int,
	duration int,
	rate_of_interest  int,
	maturity_date date ,
	maturity_amount int,
	
	nominee varchar(50)

);

drop table FIXED_DEPOSIT


SELECT * FROM BRANCH
SELECT * FROM ACCOUNT
SELECT * FROM ACCOUNT_TYPE
SELECT * FROM CUSTOMER


SELECT id as customer_id,user_password as password from CUSTOMER


update customer set user_password='shandar123' where id=1012