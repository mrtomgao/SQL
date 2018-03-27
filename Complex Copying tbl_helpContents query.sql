DECLARE @VersionID int,
		@NewVersionID int

SET @VersionID = 11

INSERT INTO [tbl_HelpVersion] (FKHelpID, [Version], CreatedBy, ListOrder) 
SELECT FKHelpID,
	   [Version] + ' *copy',
	   SYSTEM_USER,
	   (SELECT TOP 1 ListOrder FROM [tbl_HelpVersion] thvi WHERE thvi.FKHelpID = thv.FKHelpID ORDER BY ListOrder DESC) + 1 
FROM [tbl_HelpVersion] thv WHERE thv.PKVersionID = @VersionID

SET @NewVersionID = (SELECT SCOPE_IDENTITY())

INSERT INTO [tbl_HelpContents] (FKVersionID, FKHelpTitleID, FKParentContentsID, SortOrder)
SELECT @NewVersionID, FKHelpTitleID, FKParentContentsID, SortOrder FROM [tbl_HelpContents] where FKVersionID = @VersionID


SELECT t1.PKHelpContentsID AS OLD_PK, t2.PKHelpContentsID AS NEW_PK INTO #PKREF_TEMP
FROM
    (SELECT 
         PKHelpContentsID, 
         ROW_NUMBER() OVER (ORDER BY PKHelpContentsID) 'RowNumber'
     FROM tbl_HelpContents Where FKVersionID = @VersionID
    ) AS t1
    FULL OUTER JOIN
    (SELECT 
         PKHelpContentsID, 
         ROW_NUMBER() OVER (ORDER BY PKHelpContentsID) 'RowNumber'
     FROM tbl_HelpContents Where FKVersionID = @NewVersionID
    ) AS t2
    ON t1.RowNumber = t2.RowNumber

UPDATE
    [tbl_HelpContents]
SET
    FKParentContentsID = pkref.NEW_PK
FROM
    [tbl_HelpContents] AS thc
    INNER JOIN #PKREF_TEMP AS pkref
        ON thc.FKParentContentsID = pkref.OLD_PK
WHERE
    thc.FKVersionID = @NewVersionID

INSERT INTO [tbl_HelpTopic] (FKHelpContentsID, FKLangID, HelpTopicHandle, Body, CreatedBy)
SELECT ref.NEW_PK, tpc.FKLangID, tpc.HelpTopicHandle + ' *new', tpc.Body, SYSTEM_USER FROM [tbl_HelpContents] thc RIGHT JOIN [tbl_HelpTopic] tpc ON tpc.FKHelpContentsID = thc.PKHelpContentsID LEFT JOIN #PKREF_TEMP AS ref ON ref.OLD_PK = tpc.FKHelpContentsID WHERE thc.FKVersionID = @VersionID 

DROP TABLE #PKREF_TEMP

SELECT * FROM [tbl_HelpContents] WHERE FKVersionID = 11

SELECT * FROM [tbl_HelpContents] WHERE FKVersionID = 52

SELECT tpc.* FROM [tbl_HelpContents] thc RIGHT JOIN [tbl_HelpTopic] tpc ON tpc.FKHelpContentsID = thc.PKHelpContentsID WHERE thc.FKVersionID = 52 


SELECT * FROM [tbl_HelpVersion] WHERE FKHelpID = 9


