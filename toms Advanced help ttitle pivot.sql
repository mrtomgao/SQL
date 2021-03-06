
--Help TOC Pivot by Tom Gao 6/29/2017

BEGIN 

	IF OBJECT_ID('tempdb..#HCH_Temp') IS NOT NULL
		DROP TABLE #Results


	SET NOCOUNT ON; 

	WITH HelpContentsHierarchy (PKHelpContentsID, FKHelpTitleID, FKParentTitleID, HierarchyLevel, Sort) AS ( 
		-- Base case 
		Select 
			PKHelpContentsID,
			FKHelpTitleID, 
			FKParentTitleID, 
			0 as HierarchyLevel, 
			CAST(SortOrder AS NVARCHAR(MAX)) AS Sort 
		FROM [tbl_HelpContents] 
		WHERE FKParentTitleID IS NULL and FKVersionID = 2
           
		UNION ALL 
		-- Recursive step 
		SELECT 
		    hc.PKHelpContentsID,
			hc.FKHelpTitleID, 
			hc.FKParentTitleID, 
			hch.HierarchyLevel + 1 AS HierarchyLevel, 
			CAST(Sort+'/'+CAST(hc.SortOrder AS NVARCHAR(MAX)) AS NVARCHAR(MAX)) 
		FROM [tbl_HelpContents] hc 
			JOIN HelpContentsHierarchy hch ON hc.FKParentTitleID = hch.FKHelpTitleID and FKVersionID = 2 
	) 

	SELECT tht.Title, thtp.PKHelpTopicID, hch.PKHelpContentsID, hch.FKHelpTitleID, hch.FKParentTitleID, hch.HierarchyLevel, hch.Sort INTO #HCH_Temp FROM HelpContentsHierarchy hch LEFT JOIN tbl_HelpTitle tht on hch.FKHelpTitleID = tht.PKHelpTitleID LEFT JOIN tbl_HelpTopic thtp on hch.PKHelpContentsID = thtp.FKHelpContentsID order by hch.Sort 
	
	DECLARE @cols AS NVARCHAR(MAX), @query  AS NVARCHAR(MAX);

	SET @cols = STUFF((SELECT ',' + QUOTENAME(h.HierarchyLevel) 
				FROM #HCH_Temp h GROUP BY h.HierarchyLevel ORDER BY Min(h.HierarchyLevel)
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
			,1,1,'')

	set @query = 'SELECT PKHelpContentsID, FKHelpTitleID, PKHelpTopicID, ' + @cols + ' from 
				(
					select  PKHelpContentsID
						, Sort 
						, FKHelpTitleID
						, PKHelpTopicID
						, Title
						, HierarchyLevel						
					from #HCH_Temp
			   ) x
				pivot 
				(
					 max(Title)
					for HierarchyLevel in (' + @cols + ')
				) p order by Sort'

	execute(@query)

	Drop table #HCH_Temp

END