DECLARE @searchTerm varchar(250) = 'global';
DECLARE @versionID int = 0;

IF OBJECT_ID('tempdb..#tvt') IS NOT NULL
    DROP TABLE #tvt
BEGIN
IF OBJECT_ID('tempdb..#tresult') IS NOT NULL
    DROP TABLE #tresult

CREATE TABLE #tresult (
	RowNum int IDENTITY,
	RankPoints int,
	TypeRank int,
	PKHelpContentsID int,
	PKVersionID int,
	Highlight varchar(360),
	Title varchar(250),
	HelpName varchar(100),
	[Version] varchar(100),
	HelpHandle varchar(100)
);

IF (@versionID = 0)
	--NO VERSION ID, SEARCH EVERYTHING
	BEGIN
	WITH vt AS
	(
	   SELECT *,
			 ROW_NUMBER() OVER (PARTITION BY FkHelpID ORDER BY ListOrder DESC) AS rn
	   FROM tbl_HelpVersion
	)
	
	SELECT * INTO #tvt
	FROM vt 
	WHERE rn = 1

	--STEP 1: SEARCH PRODUCT NAME 
	INSERT INTO #tresult 
	SELECT * FROM (
	SELECT TOP 1
		ftt.RANK AS [RankPoints],
		0 AS [TypeRank],
		null  AS [PKHelpContentsID],
		thv.[PKVersionID] AS [PKVersionID],
		null AS [Highlight],
		th.Name + ' ' + thv.Version AS [Title],
		th.Name AS [HelpName],
		thv.[Version] AS [Version],
		th.HelpHandle 
	FROM tbl_HelpVersion thv
		LEFT JOIN [tbl_Help] th ON th.PKHelpID = thv.FKHelpID 
		INNER JOIN FREETEXTTABLE(vw_HelpVersionList, HelpTitleVersion, @searchTerm) AS ftt ON ftt.[KEY]= thv.PKVersionID
	WHERE ftt.RANK > 20
	ORDER BY ftt.Rank DESC, thv.ListOrder DESC) dum 

	UNION ALL 

	--STEP 2: SEARCH CATEGORY TITLES
	SELECT 
		ftt.RANK AS [RankPoints],
		1 AS [TypeRank],
		con.PKHelpContentsID  AS [PKHelpContentsID],
		thv.[PKVersionID] AS [PKVersionID],
		LEFT(dbo.udf_StripHTML(tpc.Body), 360) AS [Highlight],
		tht.Title AS [Title],
		th.Name AS [HelpName],
		thv.[Version] AS [Version],
		th.HelpHandle
	FROM tbl_HelpContents con
		LEFT JOIN [tbl_HelpTitle] tht ON con.FKHelpTitleID = tht.PKHelpTitleID 
		LEFT JOIN [tbl_HelpTopic] tpc ON tpc.FKHelpContentsID = con.PKHelpContentsID 
		LEFT JOIN #tvt thv ON thv.PKVersionID = con.FKVersionID 
		LEFT JOIN [tbl_Help] th ON th.PKHelpID = thv.FKHelpID 
		INNER JOIN FREETEXTTABLE(tbl_HelpTitle, Title, @searchTerm) AS ftt ON ftt.[KEY] = con.FKHelpTitleID
		WHERE ftt.RANK > 0 AND thv.PKVersionID IS NOT NULL

	UNION ALL 

	--STEP 3: SEARCH ARTICLE CONTENT
	SELECT 
		ftt.RANK AS [RankPoints],
		2 AS [TypeRank],
		con.PKHelpContentsID  AS [PKHelpContentsID], 
		thv.[PKVersionID] AS [PKVersionID],
		[dbo].fn_HighLightSearch(tpc.Body,@searchTerm, 360) AS [Highlight],
		tht.Title AS [Title],
		th.Name AS [HelpName],
		thv.[Version] AS [Version],
		th.HelpHandle
	FROM 
		[tbl_HelpTopic] tpc 
		LEFT JOIN [tbl_HelpContents] con ON tpc.FKHelpContentsID = con.PKHelpContentsID 
		LEFT JOIN [tbl_HelpTitle] tht ON con.FKHelpTitleID = tht.PKHelpTitleID 
		LEFT JOIN #tvt thv ON thv.PKVersionID = con.FKVersionID 
		LEFT JOIN [tbl_Help] th ON th.PKHelpID = thv.FKHelpID 
		INNER JOIN FREETEXTTABLE(tbl_HelpTopic, Body, @searchTerm) AS ftt ON ftt.[KEY] = tpc.PKHelpTopicID 
		WHERE ftt.RANK > 0 AND thv.PKVersionID IS NOT NULL

	ORDER BY [TypeRank] ASC,[RankPoints] DESC
	
	DROP TABLE #tvt
	END
ELSE

	--VERSION ID IS PROVIDED, SEARCH ONLY WITHIN VERSION
	BEGIN

	--STEP 1: SEARCH CATEGORY TITLES
	INSERT INTO #tresult 
	SELECT 
		ftt.RANK AS [RankPoints],
		1 AS [TypeRank],
		con.PKHelpContentsID  AS [PKHelpContentsID],
		thv.[PKVersionID] AS [PKVersionID],
		LEFT(dbo.udf_StripHTML(tpc.Body), 360) AS [Highlight],
		tht.Title AS [Title],
		th.Name AS [HelpName],
		thv.[Version] AS [Version],
		th.HelpHandle
	FROM tbl_HelpContents con
		LEFT JOIN [tbl_HelpTitle] tht ON con.FKHelpTitleID = tht.PKHelpTitleID 
		LEFT JOIN [tbl_HelpTopic] tpc ON tpc.FKHelpContentsID = con.PKHelpContentsID 
		LEFT JOIN [tbl_HelpVersion] thv ON thv.PKVersionID = con.FKVersionID 
		LEFT JOIN [tbl_Help] th ON th.PKHelpID = thv.FKHelpID 
		INNER JOIN FREETEXTTABLE(tbl_HelpTitle, Title, @searchTerm) AS ftt ON ftt.[KEY] = con.FKHelpTitleID
		WHERE ftt.RANK > 0 AND thv.PKVersionID IS NOT NULL AND thv.PKVersionID = @versionID

	UNION ALL 

	--STEP 2: SEARCH ARTICLE CONTENT
	SELECT 
		ftt.RANK AS [RankPoints],
		2 AS [TypeRank],
		con.PKHelpContentsID  AS [PKHelpContentsID], 
		thv.[PKVersionID] AS [PKVersionID],
		[dbo].fn_HighLightSearch(tpc.Body,@searchTerm, 360) AS [Highlight],
		tht.Title AS [Title],
		th.Name AS [HelpName],
		thv.[Version] AS [Version],
		th.HelpHandle
	FROM 
		[tbl_HelpTopic] tpc 
		LEFT JOIN [tbl_HelpContents] con ON tpc.FKHelpContentsID = con.PKHelpContentsID 
		LEFT JOIN [tbl_HelpTitle] tht ON con.FKHelpTitleID = tht.PKHelpTitleID 
		LEFT JOIN [tbl_HelpVersion] thv ON thv.PKVersionID = con.FKVersionID 
		LEFT JOIN [tbl_Help] th ON th.PKHelpID = thv.FKHelpID 
		INNER JOIN FREETEXTTABLE(tbl_HelpTopic, Body, @searchTerm) AS ftt ON ftt.[KEY] = tpc.PKHelpTopicID 
		WHERE ftt.RANK > 0 AND thv.PKVersionID IS NOT NULL AND thv.PKVersionID = @versionID

	ORDER BY [TypeRank] ASC,[RankPoints] DESC
	END

	DECLARE @mycursor CURSOR;
	DECLARE @myPKcon int, @myRowNum int, @myTypeRank int, @myVerID int;
	SET @mycursor = CURSOR FOR 
		SELECT RowNum,PKHelpContentsID,TypeRank,PKVersionID FROM #tresult WHERE Highlight is NULL

	OPEN @mycursor
	FETCH NEXT FROM @mycursor into @myRowNum,@myPKcon,@myTypeRank,@myVerID

	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (@myTypeRank != 0)
				BEGIN
					DECLARE @highlightFill1 VARCHAR(500);
					EXEC Qry_F_HelpGetFirstHighlight @ContentsID = @myPKcon, @RetBody = @highlightFill1 OUT
					UPDATE #tresult SET Highlight = @highlightFill1
					WHERE RowNum = @myRowNum
				END
			ELSE
				BEGIN
					DECLARE @highlightFill2 VARCHAR(500);
					EXEC Qry_F_HelpGetFirstHighlight @VersionID = @myVerID, @RetBody = @highlightFill2 OUT
					UPDATE #tresult SET Highlight = @highlightFill2
					WHERE RowNum = @myRowNum
				END

			FETCH NEXT FROM @mycursor into @myRowNum,@myPKcon,@myTypeRank,@myVerID
		END
	CLOSE @mycursor;
	DEALLOCATE @mycursor;

	SELECT * FROM #tresult 
	DROP TABLE #tresult
	
	
END