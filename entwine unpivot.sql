
If(OBJECT_ID('tempdb..#TempR') Is Not Null)
Begin
    Drop Table #TempR
End
If(OBJECT_ID('tempdb..#TempQ') Is Not Null)
Begin
    Drop Table #TempQ
End

SELECT y.UserId,y.LastUpdate, y.LastSubmit, y.Seq, y.Result into #TempR
from [tbl_EntwineAssessmentUserEntry] x 
unpivot
(
  Result
  for Seq in ([1.1]
      ,[1.2]
      ,[1.3]
      ,[1.4]
      ,[1.5]
      ,[2.1]
      ,[2.2]
      ,[2.3]
      ,[2.4]
      ,[2.5]
      ,[2.6]
      ,[2.7]
      ,[2.8]
      ,[2.9]
      ,[2.10]
      ,[2.11]
      ,[2.12]
      ,[2.13]
      ,[3.1]
      ,[3.2]
      ,[3.2.1]
      ,[3.3]
      ,[3.3.1]
      ,[3.3.2]
      ,[3.3.3]
      ,[3.4]
      ,[4.1]
      ,[4.2]
      ,[4.3]
      ,[4.4]
      ,[4.5]
      ,[4.6]
      ,[4.7])
) y where [userid] = 'Kent State University'


SELECT CONVERT(varchar(10), [SECTION]) + '.' + CONVERT(varchar(10), [LISTORDER]) + IIF(FollowUp is null,'','.' + CONVERT(varchar(10), FollowUp)) as [Seq],
	[QuestionHeading], [Type], [Units] into #TempQ
	From [dbWeb].[dbo].[tbl_EntwineAssessmentQuestion]


SELECT t2.[UserID]
	,t2.[LastUpdate]
	,t2.[LastSubmit]
    ,t1.[Seq]
	,t1.[QuestionHeading]
	,t1.[Type]
	,t2.[Result]
	,IIF(t1.[Units] is NULL, '',t1.[Units]) as [Units]
FROM [#TempQ] t1
	 LEFT JOIN 
     (Select * from [#TempR]) t2  on t1.[Seq] = t2.[Seq] order by t1.Seq


