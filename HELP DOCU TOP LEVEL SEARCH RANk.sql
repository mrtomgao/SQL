Declare @searchTerm varchar(250) = '8.0 global';
Declare @searchTermContains varchar(250);
SET @searchTerm = (SELECT REPLACE (@searchTerm, 'version', ''))
SET @searchTermContains = (SELECT REPLACE (@searchTerm, ' ', ' or '))


SELECT TOP 1
	ftt.RANK AS [RankPoints],
	1 AS [TypeRank],
	'Product' AS [Type],
	null  AS [PKHelpContentsID],
	null AS [PKHelpTitleID],
	null AS [PKHelpTopicID],
	thv.[PKVersionID] AS [PKVersionID],
	null AS [Highlight],
	th.Name + ' ' + thv.Version AS [Title],
	thv.[Version] AS [Version],
	th.Name AS [Help]
FROM tbl_HelpVersion thv
	LEFT JOIN [tbl_Help] th ON th.PKHelpID = thv.FKHelpID 
	INNER JOIN FREETEXTTABLE(vw_HelpVersionList, HelpTitleVersion, @searchTerm) AS ftt ON ftt.[KEY]= thv.PKVersionID
WHERE ftt.RANK > 30
ORDER BY ftt.Rank DESC, thv.ListOrder DESC

