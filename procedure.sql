


set serveroutput on;
set verify off;
declare
        Id Account_Information.ID%TYPE := &id;
	BranchName Account_Information.BR_NAME%TYPE  := &branchname;
	AccountHolderName Account_Information.H_NAME%TYPE := &account_holder_name;
	Address Account_Information.ADDRESS%TYPE := &address;
	Contact Account_Information.PHN%TYPE := &contact;
	Nid Account_Information.NID%TYPE := &nid;
	Balance Account_Information.BLNC%TYPE := &initial_balance;
begin
	bank.open_account(Id,BranchName,AccountHolderName,Address,Contact,Nid,Balance);
	
end;

set verify off;
declare 
	AccountId Account_Information.Id%TYPE := &accountnumber;
	Amount Account_Information.BLNC%TYPE := &amount;
begin 
	bank.deposit_money(AccountId,Amount);
end;

set verify off;
declare 
	AccountId Account_Information.Id%TYPE := &accountnumber;
	Amount Account_Information.BLNC%TYPE := &amount;
begin 
	bank.withdraw_money(AccountId,Amount);
end;
set verify off;
declare
    AccountId1 Account_Information.Id%TYPE := &accountnumber;
	AccountId2 Account_Information.Id%TYPE := &accountnumber;
	Amount Account_Information.BLNC%TYPE := &amount;
begin 
	bank.transfer_money(AccountId1,AccountId2,Amount);
end;
    