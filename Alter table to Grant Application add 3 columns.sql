begin tran

ALTER TABLE dbo.tbl_GrantApplications ADD Ideal21Desc VARCHAR(max) NULL, Ideal21Upload1 varchar(60) NULL, Ideal21Upload2 varchar(60) NULL, Ideal21Upload3 varchar(60) NULL ;  


select * from dbo.tbl_grantapplications

commit tran

rollback tran

