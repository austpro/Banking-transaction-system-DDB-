set serveroutput on;


create or replace package bank as
	
	procedure open_account(	
        Id in Account_Information.ID%TYPE,
		BranchName in Account_Information.BR_NAME%TYPE,
		AccountHolderName in Account_Information.H_NAME%TYPE,
		Address in Account_Information.ADDRESS%TYPE,
		Contact in Account_Information.PHN%TYPE,
		Nid in Account_Information.NID%TYPE,
		Balance in Account_Information.BLNC%TYPE);
		
    procedure deposit_money(
		AccountId in Account_Information.ID%TYPE,
		Amount in Account_Information.BLNC%TYPE);
	procedure withdraw_money(
		AccountId in Account_Information.ID%TYPE,
		Amount in Account_Information.BLNC%TYPE);
		
	procedure transfer_money_local(
		AccountId1 in Account_Information.ID%TYPE,
		AccountId2 in Account_Information.ID%TYPE,
		Amount in Account_Information.BLNC%TYPE);
		
	procedure transfer_money_global(
		AccountId1 in Account_Information.ID%TYPE,
		AccountId2 in Account_Information.ID%TYPE,
		Amount in Account_Information.BLNC%TYPE);
		
end bank;   
/
create or replace package body bank as 
	


	procedure open_account(	
        Id in Account_Information.ID%TYPE,
		BranchName in Account_Information.BR_NAME%TYPE,
		AccountHolderName in Account_Information.H_NAME%TYPE,
		Address in Account_Information.ADDRESS%TYPE,
		Contact in Account_Information.PHN%TYPE,
		Nid in Account_Information.NID%TYPE,
		Balance in Account_Information.BLNC%TYPE)	
	IS
	
	
	begin

	
		insert into Account_Information values (Id ,BranchName,AccountHolderName,Address,Contact,Nid,Balance);
		commit;
		dbms_output.put_line('Account created successfully.');
			
	end open_account;

	
    procedure deposit_money(
		AccountId in Account_Information.ID%TYPE,
		Amount in Account_Information.BLNC%TYPE)
	IS
	
	currentbalance Account_Information.BLNC%TYPE;
	newbalance Account_Information.BLNC%TYPE := 0;
	
	begin
		select blnc into currentbalance from Account_Information where Id=AccountId;
		newbalance := currentbalance+Amount;
		update Account_information set blnc=newbalance where Id=AccountId;
		commit;
		dbms_output.put_line(TO_CHAR(Amount)||' Tk have been deposited to AccountId: '||TO_CHAR(AccountId)||' SUCCESSFULLY');
	end deposit_money;
	
	procedure withdraw_money(
		AccountId in Account_Information.ID%TYPE,
		Amount in Account_Information.BLNC%TYPE)
	IS
	
	currentbalance Account_Information.BLNC%TYPE;
	newbalance Account_Information.BLNC%TYPE := 0;
	
	begin
		select blnc into currentbalance from Account_Information where Id=AccountId;
		newbalance := currentbalance-Amount;
		update Account_information set blnc=newbalance where Id=AccountId;
		commit;
		dbms_output.put_line(TO_CHAR(Amount)||' Tk have been withdrawn from Account Id: '||TO_CHAR(AccountId)||'   SUCCESSFULLY');
	end withdraw_money;
	
	
	procedure transfer_money_local(
		AccountId1 in Account_Information.ID%TYPE,
		AccountId2 in Account_Information.ID%TYPE,
		Amount in Account_Information.BLNC%TYPE)
	IS
	
	currentbalance1 Account_Information.BLNC%TYPE;
	currentbalance2 Account_Information.BLNC%TYPE;
	newbalance1 Account_Information.BLNC%TYPE := 0;
	newbalance2 Account_Information.BLNC%TYPE := 0;
	
	begin
		select blnc into currentbalance1 from Account_Information where Id=AccountId1;
		newbalance1 := currentbalance1-Amount;
		update Account_information set blnc=newbalance1 where Id=AccountId1;
		commit;
		
		select blnc into currentbalance2 from Account_Information where Id=AccountId2;
		newbalance2 := currentbalance2+Amount;
		update Account_information set blnc=newbalance2 where Id=AccountId2;
		commit;
		dbms_output.put_line(TO_CHAR(Amount)||' Tk has been transfered from Account Id: '||TO_CHAR(AccountId1)||' to Account Id: '    ||TO_CHAR(AccountId2)||'   SUCCESSFULLY');
	end transfer_money_local;
	
	
	procedure transfer_money_global(
		AccountId1 in Account_Information.ID%TYPE,
		AccountId2 in Account_Information.ID%TYPE,
		Amount in Account_Information.BLNC%TYPE)
	IS
	
	currentbalance1 Account_Information.BLNC%TYPE;
	currentbalance2 Account_Information.BLNC%TYPE;
	newbalance1 Account_Information.BLNC%TYPE := 0;
	newbalance2 Account_Information.BLNC%TYPE := 0;
	
	begin
		select blnc into currentbalance1 from Account_Information where Id=AccountId1;
		newbalance1 := currentbalance1-Amount;
		update Account_information set blnc=newbalance1 where Id=AccountId1;
		commit;
		insert into transaction (transaction_id,Account_id,transaction_type,account_to,amount,prev_balance,balance) values(trans_seq.nextval, AccountId1,'Transfer',AccountId2,Amount,currentbalance1,newbalance1);
		commit;
		select blnc into currentbalance2 from Account_Information @site_link where Id=AccountId2;
		newbalance2 := currentbalance2+Amount;
		update Account_information @site_link set blnc=newbalance2 where Id=AccountId2;
		insert into transaction @site_link (transaction_id,Account_id,transaction_type,account_from,amount,prev_balance,balance) values(tran_seq.nextval, AccountId2,'received',AccountId1,Amount,currentbalance2,newbalance2);
		commit;
		
		dbms_output.put_line(TO_CHAR(Amount)||' Tk has been transfered from Account Id: '||TO_CHAR(AccountId1)||' to Account Id: '    ||TO_CHAR(AccountId2)||'   SUCCESSFULLY');
	end transfer_money_global;
	
end bank;
/