




CREATE procedure p_transaction_details
(@ACCOUNT BIGINT)
AS 
BEGIN
	select * from DEBIT_TRANSACTION_DETAILS as dt  inner join CREDIT_TRANSACTION_DETAILS as ct on id=id_debit
where debit_account_no=@ACCOUNT or credit_account_no=@ACCOUNT order by id  desc ;

END

MERGE DEBIT_TRANSACTION_DETAILS D
    USING CREDIT_TRANSACTION_DETAILS C
ON (D.id = C.id_debit)
    THEN UPDATE SET 
        t.category_name = s.category_name,
        t.amount = s.amount
WHEN NOT MATCHED BY TARGET 
    THEN INSERT (category_id, category_name, amount)
         VALUES (s.category_id, s.category_name, s.amount)
WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;
