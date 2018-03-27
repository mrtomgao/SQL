USE [dbWeb]
GO

/****** Object:  View [dbo].[vw_HelpVersionList]    Script Date: 10/31/2017 11:52:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_HelpVersionList] WITH SCHEMABINDING
AS

SELECT         thv.PKVersionID, th.Name + ' ' + thv.Version AS HelpTitleVersion
FROM            dbo.tbl_Help AS th INNER JOIN
                         dbo.tbl_HelpVersion AS thv ON th.PKHelpID = thv.FKHelpID



GO

CREATE UNIQUE CLUSTERED INDEX idx_1 ON [vw_HelpVersionList] (PKVersionID)