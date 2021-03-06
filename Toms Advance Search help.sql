
    declare @searchTerm nvarchar(100)

	SET @searchTerm = 'global scripter'


SELECT 
	ftt.RANK as [RankPoints],
	'1' as [TypeRank],
	'Title' as [Type],
	PKHelpTitleID as [PKID], 
	[dbWeb].[dbo].HighLightSearch(Title,@searchTerm, 50) AS [HitHighlight],
	Title as [HelpTitle]
FROM tbl_HelpTitle
INNER JOIN 
FREETEXTTABLE(tbl_HelpTitle, Title, @searchTerm) as ftt
ON
ftt.[KEY]=[tbl_HelpTitle].PKHelpTitleID

UNION ALL 

SELECT 
	ftl.RANK as [RankPoints],
	'2' as [TypeRank],
	'Topic' as [Type],
	PKHelpTopicID as [PKID], 
	[dbWeb].[dbo].HighLightSearch(Body,@searchTerm, 50) AS [HitHighlight],
	tit.Title as [HelpTitle]
FROM tbl_HelpTopic tht LEFT JOIN [tbl_HelpContents] thc on tht.FKHelpContentsID = thc.PKHelpContentsID LEFT JOIN [tbl_HelpTitle] tit on thc.FKHelpTitleID = tit.PKHelpTitleID LEFT JOIN [tbl_HelpVersion] thv on thv.PKVersionID = thc.FKVersionID
INNER JOIN 
FREETEXTTABLE(tbl_HelpTopic, Body, @searchTerm) as ftl
ON
ftl.[KEY]=tht.PKHelpTopicID
order by [TypeRank] ASC,[RankPoints] DESC
