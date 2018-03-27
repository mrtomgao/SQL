Declare @searchTerm varchar(250) = '';

WITH vt AS
(
   SELECT *,
         ROW_NUMBER() OVER (PARTITION BY FkHelpID ORDER BY ListOrder DESC) AS rn
   FROM tbl_HelpVersion
)
SELECT * into #tvt
FROM vt 
WHERE rn = 1


SELECT 
	ftt.RANK AS [RankPoints],
	1 AS [TypeRank],
	'Title' AS [Type],
	con.PKHelpContentsID  AS [PKHelpContentsID],
	tit.PKHelpTitleID AS [PKHelpTitleID],
	tpc.PKHelpTopicID AS [PKHelpTopicID],
	LEFT(dbo.udf_StripHTML(tpc.Body), 360) AS [Highlight],
	tit.Title AS [Title],
	ver.[Version] AS [Version],
	th.Name AS [Help]
FROM tbl_HelpContents con
	LEFT JOIN [tbl_HelpTitle] tit ON con.FKHelpTitleID = tit.PKHelpTitleID 
	LEFT JOIN [tbl_HelpTopic] tpc ON tpc.FKHelpContentsID = con.PKHelpContentsID 
	LEFT JOIN #tvt ver ON ver.PKVersionID = con.FKVersionID 
	LEFT JOIN [tbl_Help] th ON th.PKHelpID = ver.FKHelpID 
	INNER JOIN FREETEXTTABLE(tbl_HelpTitle, Title, @searchTerm) AS ftt ON ftt.[KEY]= con.FKHelpTitleID

UNION ALL 

SELECT 
	ftl.RANK AS [RankPoints],
	2 AS [TypeRank],
	'Topic' AS [Type],
	con.PKHelpContentsID  AS [PKHelpContentsID], 
	tit.PKHelpTitleID AS [PKHelpTitleID],
	tpc.PKHelpTopicID AS [PKHelpTopicID],
	[dbo].fn_HighLightSearch(tpc.Body,@searchTerm, 360) AS [Highlight],
	tit.Title AS [Title],
	ver.[Version] AS [Version],
	th.Name AS [Help]
FROM 
	[tbl_HelpTopic] tpc 
	LEFT JOIN [tbl_HelpContents] con ON tpc.FKHelpContentsID = con.PKHelpContentsID 
	LEFT JOIN [tbl_HelpTitle] tit ON con.FKHelpTitleID = tit.PKHelpTitleID 
	LEFT JOIN #tvt ver ON ver.PKVersionID = con.FKVersionID 
	LEFT JOIN [tbl_Help] th ON th.PKHelpID = ver.FKHelpID 
	INNER JOIN FREETEXTTABLE(tbl_HelpTopic, Body, @searchTerm) AS ftl ON ftl.[KEY]=tpc.PKHelpTopicID 

ORDER BY [TypeRank] ASC,[RankPoints] DESC
DROP TABLE #tvt