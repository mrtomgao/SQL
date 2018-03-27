CREATE TABLE tbl_HelpTomsTestPDF(
   id INT IDENTITY(1, 1) NOT NULL,
   content VARBINARY(MAX),
   extension VARCHAR(5),
   title NVARCHAR(255)
);
ALTER TABLE tbl_HelpTomsTestPDF ADD CONSTRAINT PK_tt PRIMARY KEY CLUSTERED (
   id
);


CREATE FULLTEXT CATALOG searchablePDF; 

CREATE FULLTEXT INDEX ON tbl_HelpTomsTestPDF(
   content TYPE COLUMN extension LANGUAGE 1033
)
KEY INDEX PK_tt ON searchablePDF;


INSERT INTO tbl_HelpTomsTestPDF(content, extension, title)
SELECT bulkcolumn, '.pdf', 'ddg_system_designs'
FROM OPENROWSET(BULK 'C:\Temp\ddg_system_designs.pdf', SINGLE_BLOB) as t;

INSERT INTO tbl_HelpTomsTestPDF(content, extension, title)
SELECT bulkcolumn, '.pdf', 'digital_design_guide'
FROM OPENROWSET(BULK 'C:\Temp\digital_design_guide.pdf', SINGLE_BLOB) as t;

INSERT INTO tbl_HelpTomsTestPDF(content, extension, title)
SELECT bulkcolumn, '.pdf', 'digital_design_guide_2nd_revC'
FROM OPENROWSET(BULK 'C:\Temp\digital_design_guide_2nd_revC.pdf', SINGLE_BLOB) as t;

INSERT INTO tbl_HelpTomsTestPDF(content, extension, title)
SELECT bulkcolumn, '.pdf', 'fiber_optic_design_guide'
FROM OPENROWSET(BULK 'C:\Temp\fiber_optic_design_guide.pdf', SINGLE_BLOB) as t;

INSERT INTO tbl_HelpTomsTestPDF(content, extension, title)
SELECT bulkcolumn, '.pdf', 'gui_standards_guide_C'
FROM OPENROWSET(BULK 'C:\Temp\gui_standards_guide_C.pdf', SINGLE_BLOB) as t;

INSERT INTO tbl_HelpTomsTestPDF(content, extension, title)
SELECT bulkcolumn, '.pdf', 'videowallfeatures'
FROM OPENROWSET(BULK 'C:\Temp\videowallfeatures.pdf', SINGLE_BLOB) as t;

EXEC sp_fulltext_service @action='load_os_resources', @value=1;
EXEC sp_fulltext_service @action='verify_signature', @value=0;


SELECT document_type, path
FROM sys.fulltext_document_types



SELECT *
FROM  freetexttable(tbl_HelpTomsTestPDF, content,'once the primary question') ftt 
LEFT JOIN tbl_HelpTomsTestPDF tt ON tt.id = ftt.[KEY] 
WHERE RANK > 0;
