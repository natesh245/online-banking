create database NetBanking

drop database NetBanking

/*-------------ACCOUNT_TYPE TABLE----------------------------*/
create table ACCOUNT_TYPE(
	id int primary key identity(1020,2),
	account_type_name varchar(20) NOT NULL
	);


	insert into ACCOUNT_TYPE
	values ('Savings'),('Salary'),('Rural'),('Fixed')

	select * from ACCOUNT_TYPE

	/*------------BRANCH TABLE-----------------------------*/

create table BRANCH(
	id varchar(20) primary key,
	branch_name varchar(20) NOT NULL
	);


	insert into BRANCH
	values ('BRANCHID01','BAGALURU CROSS'),('BRANCHID02','DEVANAHALLI'),('BRANCHID03','HEBBALA'),('BRANCHID04','KOGILU CROSS'),
	('BRANCHID05','MALLESHWARAM'),('BRANCHID06','MAJESTIC'),('BRANCHID07','HUNASEMARANAHALLI')

	SELECT * FROM BRANCH

	/*-----------CUSTOMER TABLE------------------------------*/

DROP TABLE CUSTOMER
	
create table CUSTOMER(
	id int primary key identity(1010,1),
	customer_first_name varchar(50) NOT NULL,
	customer_last_name varchar(50) NOT NULL,
	customer_gender varchar(10) NOT NULL,
	customer_father_name varchar(50) NOT NULL,
	date_of_birth DateTime NOT NULL,
	customer_age int NOT NULL,
	marital_status varchar(10),
	customer_address varchar(100) NOT NULL,
	customer_city varchar(50) NOT NULL,
	customer_state varchar(50) NOT NULL,
	customer_country varchar(50) NOT NULL,
	pincode int NOT NULL,
	phone bigint NOT NULL,
	email_id varchar(50),
	customer_password varchar(20) ,
	

);

alter table CUSTOMER add  gender varchar(10)

INSERT INTO CUSTOMER 
VALUES ('Mohammad','Shandar','MALE','FATHER','19970625',23,'unmarried','bc road','mangalore'
,'karnataka','India',575056,8050855690,'shandar246@gmail.com','123456'),
('Natesh','m','MALE','fffgfg','19970223',23,'unmarried','trtrtr','trtrt'
,'trtrt','India',575056,8050855610,'natesh246@gmail.com','123456'),
('Sudha','Deshpande','FEMALE','fddgd','19970221',23,'unmarried','ggrgr','ererer'
,'adad','India',575056,8050855620,'sudha246@gmail.com','123456')

select * from CUSTOMER

DELETE from CUSTOMER

/*--------------ACCOUNT TABLE---------------------------*/

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
	VALUES (1234567891011,'BRANCHID01',1020,1011,100000,'CHECK01'),
	(1234567891012,'BRANCHID02',1020,1012,150000,'CHECK02'),
	(1234567891013,'BRANCHID03',1020,1013,1000200,'CHECK03')



	/*---------------TRANSACTION_DETAILS TABLE--------------------------*/


		
	CREATE TABLE TRANSACTION_DETAILS(
		transaction_id int primary key identity(1050,1),
		debit_account_no bigint not null ,
		foreign key (debit_account_no) references ACCOUNT (account_no),
		credit_account_no bigint not null ,
		foreign key (credit_account_no) references ACCOUNT (account_no),
		amount int,
		transaction_date_time datetime not null,
		
	
	)

	DROP TABLE TRANSACTION_DETAILS


	select * from TRANSACTION_DETAILS

	alter table TRANSACTION_DETAILS
	ADD debit_account_balance bigint 

		alter table TRANSACTION_DETAILS
	ADD credit_account_balance bigint 

	select * from TRANSACTION_DETAILS

/*--------------FIXED DEPOSIT TABLE---------------------------*/

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


/*-----------------------------------------*/

SELECT * FROM BRANCH
SELECT * FROM ACCOUNT
SELECT * FROM ACCOUNT_TYPE
SELECT * FROM CUSTOMER


/*-------------TRANSACTION STORED PROCEDURE----------------------------*/


CREATE procedure p_insert_transaction

(@DEBIT_ACCOUNT_NO BIGINT
,@CREDIT_ACCOUNT_NO BIGINT
,@AMOUNT INT)
AS
BEGIN
/*INSERT DATA INTO TRANSACTION TABLES THAT IS CREDIT AND DEBIT TRANSACTION DETAILS*/

	DECLARE @DATE_TIME DATETIME;
	SET @DATE_TIME=GETDATE(); /*VARIABLE STORES CURRENT DATETIME*/

	DECLARE @BALANCE_AMOUNT BIGINT;
	SET @BALANCE_AMOUNT=(SELECT  balance from ACCOUNT  WHERE account_no=@DEBIT_ACCOUNT_NO );

	

	IF @BALANCE_AMOUNT>@AMOUNT and @DEBIT_ACCOUNT_NO!=@CREDIT_ACCOUNT_NO 
	BEGIN
	/*INSERT INTO DEBIT_TRANSACTION_DETAILS*/
	INSERT INTO TRANSACTION_DETAILS(debit_account_no,credit_account_no,amount,transaction_date_time) 
	VALUES(@DEBIT_ACCOUNT_NO,@CREDIT_ACCOUNT_NO,@AMOUNT,@DATE_TIME)

	/*ID VARIABLE GETS THE id from DEBIT_TRANSACTION_DETAILS
	HERE WE ARE ARRANGING THE ROWS IN DESC ORDER w.r.t id and SELECTING TOP 1st id that is it gets the id of recently added row*/
	DECLARE @ID INT;
	SET @ID= (SELECT TOP 1 transaction_id FROM TRANSACTION_DETAILS ORDER BY transaction_id DESC );



	/* update the balance amount in ACCOUNT table based on the transactions*/
		/*In debit account update balance amount by balance-amount
	and in credit amount update balance amount by balance+amount*/
	

		DECLARE @VAR_AMOUNT INT;
	SET @VAR_AMOUNT = (SELECT TOP 1 amount from TRANSACTION_DETAILS ORDER BY transaction_id DESC   );

	

	DECLARE @VAR_DEBITS_ACCOUNT_NO BIGINT;
	SET @VAR_DEBITS_ACCOUNT_NO = (SELECT TOP 1 debit_account_no from TRANSACTION_DETAILS ORDER BY transaction_id DESC);

	DECLARE @VAR_CREDITS_ACCOUNT_NO BIGINT;
	SET @VAR_CREDITS_ACCOUNT_NO=(SELECT TOP 1 credit_account_no from	TRANSACTION_DETAILS ORDER BY transaction_id DESC);

	DECLARE @VAR_BALANCE_CREDIT BIGINT;
	SET @VAR_BALANCE_CREDIT = (SELECT   balance from ACCOUNT   WHERE account_no= @VAR_CREDITS_ACCOUNT_NO);

	DECLARE @VAR_BALANCE_DEBIT BIGINT;
	SET @VAR_BALANCE_DEBIT = (SELECT   balance from ACCOUNT WHERE account_no= @VAR_DEBITS_ACCOUNT_NO);

	DECLARE @TRANSACTION_ID INT ;
	SET @TRANSACTION_ID=(SELECT TOP 1 transaction_id FROM TRANSACTION_DETAILS ORDER BY transaction_id DESC);

	
	
	IF @VAR_AMOUNT>0
	BEGIN
		UPDATE ACCOUNT SET ACCOUNT.balance = @VAR_BALANCE_DEBIT- @VAR_AMOUNT WHERE account_no = @VAR_DEBITS_ACCOUNT_NO;

		UPDATE ACCOUNT SET ACCOUNT.balance = @VAR_BALANCE_CREDIT + @VAR_AMOUNT WHERE account_no = @VAR_CREDITS_ACCOUNT_NO;

		UPDATE TRANSACTION_DETAILS SET credit_account_balance=@VAR_BALANCE_CREDIT + @VAR_AMOUNT
		WHERE transaction_id = @TRANSACTION_ID;

			UPDATE TRANSACTION_DETAILS SET debit_account_balance=@VAR_BALANCE_DEBIT - @VAR_AMOUNT
		WHERE transaction_id = @TRANSACTION_ID;

		
	END
	END
	ELSE
		BEGIN
			RAISERROR ( 'TRANSACTION FAILED AS ENTERED AMOUNT IS GREATER THAN THE AVAILABLE BALANCE',1,1);

	END
	
END

/*---------------------------------------------------*/

select * from TRANSACTION_DETAILS

SELECT * FROM ACCOUNT
select * from CUSTOMER
select * from ACCOUNT_TYPE
select * from BRANCH

DELETE FROM TRANSACTION_DETAILS


EXEC p_insert_transaction 110010001112,110010001112,996700

EXEC p_insert_transaction 110010001113,110010001114,120


/*------------------CUSTOMER STORED PROCEDURE-----------------------------------*/

CREATE procedure p_update_customer_details
(@ID int,
@FIRST_NAME varchar(50),
@LAST_NAME varchar(50),
@FATHERS_NAME varchar(50),
@DOB DATE,
@AGE INT,
@MARITAL_STATUS varchar(10),
@ADDRESS VARCHAR(100),
@CITY varchar(50),
@STATE varchar(50),
@COUNTRY varchar(50),
@PINCODE INT,
@PHONE BIGINT,
@EMAIL_ID VARCHAR(50))
AS
BEGIN
	UPDATE CUSTOMER SET customer_first_name=@FIRST_NAME, customer_last_name=@LAST_NAME,customer_father_name= @FATHERS_NAME,
	marital_status=@MARITAL_STATUS,customer_address=@ADDRESS,customer_city=@CITY,customer_state=@STATE,
	customer_country=@COUNTRY,pincode=@PINCODE,phone=@PHONE,email_id=@EMAIL_ID WHERE id=@ID;
	

END

select * from CUSTOMER


/*--------------STATEMENT STORED PROCEDURE*/
CREATE procedure p_transaction_details
(@ACCOUNT BIGINT)
AS 
BEGIN
	select * from TRANSACTION_DETAILS 
where debit_account_no=@ACCOUNT or credit_account_no=@ACCOUNT order by transaction_id  desc ;

END

exec p_transaction_details 110010001113

/*--------------FD STORED PROCEDURE---------------*/

create procedure fixed_deposit_sp
 @account_no bigint,
@amount int,
@duration INT,
@nominee varchar(10)

As 
Begin

	Declare @fddate date;
	Set @fddate=convert (date,getdate());

	declare @balance bigint;
	set @balance =(select balance from ACCOUNT where account_no=@account_no);

	Declare @rate_of_interest decimal;
	Declare @maturity_amount decimal;
	Declare @maturity_date Date;
	set @maturity_date=DATEADD(MM,4,@fddate)

	IF ((@BALANCE>@AMOUNT) and (@amount>=5000))
	Begin

		If (@duration <6)
		Begin
			set @Rate_of_interest=4;
			set @maturity_amount=@amount+((@amount*@Rate_of_interest*@duration)/100);

			Insert into FIXED_DEPOSIT(account_no,fd_date,fd_amount,duration,rate_of_interest,maturity_date,maturity_amount,nominee)
			Values(@account_no,GETDATE(),@amount,@duration,@Rate_of_interest,@maturity_date,@maturity_amount,@nominee)
		End

		Else 
			Begin
			set @rate_of_interest =4.25;
			set @maturity_amount=@amount+((@amount*@Rate_of_interest*@duration)/100);
			Insert into FIXED_DEPOSIT (account_no,fd_date,fd_amount,duration,rate_of_interest,maturity_date,maturity_amount,nominee)
			Values(@account_no,@fddate,@amount,@duration,@Rate_of_interest,@maturity_date,@maturity_amount,@nominee);
		end
		UPDATE ACCOUNT SET ACCOUNT.balance = @balance- @AMOUNT WHERE account_no = @account_no;

		UPDATE ACCOUNT SET balance=@balance- @amount
		WHERE account_no =@account_no;
	END	
	Else 
	Begin
		RAISERROR ('YOU NEED TO KEEP MINIMUM AMOUNT OF Rs 5000',1,1);
	END
END


drop procedure fixed_deposit_sp

Exec  fixed_deposit_sp 110010001111,5000,8,'natesh';
exec fixed_deposit_sp 110010001113,5000,5,'shandar';



	select * from ACCOUNT
	select * from CUSTOMER
	SELECT * FROM FIXED_DEPOSIT

	DELETE FROM FIXED_DEPOSIT 

	SELECT * FROM BRANCH
	SELECT * FROM ACCOUNT_TYPE