
CREATE TABLE DWHIdx.dbo.DimAccount (
	AccountId int NOT NULL,
	CustomerId int NULL,
	AccountType varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Balance int NULL,
	DateOpened datetime2(0) NULL,
	Status varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PkAccount PRIMARY KEY (AccountId)
);

ALTER TABLE DWHIdx.dbo.DimAccount  ADD CONSTRAINT FkCustomer FOREIGN KEY (CustomerId) REFERENCES DWHIdx.dbo.DimCustomer(CustomerId);

CREATE TABLE DWHIdx.dbo.DimBranch (
	BranchId int NOT NULL,
	BranchName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BranchLocation varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PkBranch PRIMARY KEY (BranchId)
);


CREATE TABLE DWHIdx.dbo.FactTransaction(
	TransactionId int NOT NULL,
	AccountId int NULL,
	TransactionDate datetime2(0) NULL,
	Amount int NULL,
	TransactionType varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BranchId int NULL,
	CONSTRAINT PkTransaction PRIMARY KEY (TransactionId)
);

ALTER TABLE DWHIdx.dbo.FactTransaction ADD CONSTRAINT FkAccount FOREIGN KEY (AccountId) REFERENCES DWHIdx.dbo.DimAccount(AccountId);
ALTER TABLE DWHIdx.dbo.FactTransaction ADD CONSTRAINT FkBranch FOREIGN KEY (BranchId) REFERENCES DWHIdx.dbo.DimBranch(BranchId);


CREATE TABLE DWHIdx.dbo.DimCustomer (
	CustomerId int NOT NULL,
	CustomerName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Address varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Age varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Gender varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Email varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CityName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	StateName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PkCustomer PRIMARY KEY (CustomerId)
);


delete top(1) from DimCustomer 

SELECT AccountId, CustomerId, AccountType, Balance, DateOpened, Status
FROM DWHIdx.dbo.DimAccount;

SELECT BranchId, BranchName, BranchLocation
FROM DWHIdx.dbo.DimBranch;

SELECT CustomerId, CustomerName, Address, Age, Gender, Email, CityName, StateName
FROM DWHIdx.dbo.DimCustomer;

SELECT TransactionId, AccountId, TransactionDate, Amount, TransactionType, BranchId
FROM DWHIdx.dbo.FactTransaction;


--Prototyping Stored Procedure
select cast(TransactionDate as date) as 'Date', count(*) as 'TotalTransactions', sum(Amount) as 'TotalAmount' 
from DWHIdx.dbo.FactTransaction ft 
where TransactionDate >= '2024-01-18' and TransactionDate <= dateadd(dd, 1, '2024-01-20')
group by cast(TransactionDate as date);

CREATE PROCEDURE dbo.DailyTransactions
	@start_date datetime2,
	@end_date datetime2
AS
	select cast(TransactionDate as date) as 'Date', count(*) as 'TotalTransactions', sum(Amount) as 'TotalAmount' 
	from DWHIdx.dbo.FactTransaction ft 
	where TransactionDate >= @start_date and TransactionDate <= dateadd(dd, 1, @end_date)
	group by cast(TransactionDate as date)
GO;

EXEC dbo.DailyTransactions @start_date = '2024-01-18', @end_date = '2024-01-20';

--Prototyping Second Stored Procedure
select CustomerName, AccountType , Balance, Amount,
TransactionType
from DimAccount da 
inner join DimCustomer dc on da.CustomerId = dc.CustomerId 
inner join FactTransaction ft on da.AccountId = ft.AccountId

select CustomerName, AccountType, Balance, Balance + sum(case when TransactionType = 'Deposit' then Amount else -Amount END) as CurrentBalance
from FactTransaction ft 
inner join DimAccount da on ft.AccountId = da.AccountId 
inner join DimCustomer dc on da.CustomerId = dc.CustomerId
where CustomerName LIKE '%j%'
group by CustomerName, AccountType, Balance

CREATE PROCEDURE dbo.BalancePerCustomer
	@name nvarchar(50)
AS
	select CustomerName, AccountType, Balance, Balance + sum(case when TransactionType = 'Deposit' then Amount else -Amount END) as CurrentBalance
	from FactTransaction ft 
	inner join DimAccount da on ft.AccountId = da.AccountId 
	inner join DimCustomer dc on da.CustomerId = dc.CustomerId
	where CustomerName LIKE '%' + @name + '%'
	group by CustomerName, AccountType, Balance
GO;

EXEC dbo.BalancePerCustomer @name = 'shelly'