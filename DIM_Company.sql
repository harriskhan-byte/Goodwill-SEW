-- CREATE VIEW ProcurementReporting.DIM_Company AS

/*  DIM SQL Script Creation - Company
    Only select statement - view creation will be done by client
    Name: DIM_Company
    Location: ProcurementReporting

    Fields:
      CompanyKey   (CompanyInfo.DataArea)
      CompanyCode  (CompanyInfo.DataArea)
      CompanyName  (DirPartyTable.Name)
*/

SELECT 
    dpt.DATAAREA AS CompanyKey,      -- Surrogate key for company (DataArea)
    dpt.DATAAREA AS CompanyCode,     -- Company code (DataArea)
    dpt.NAME     AS CompanyName      -- Company name from DirPartyTable
FROM DIRPARTYTABLE dpt
-- Filter to only company records (CompanyInfo)
WHERE dpt.INSTANCERELATIONTYPE = (
    SELECT TOP 1 RECID
    FROM TABLEIDTABLE
    WHERE NAME = 'CompanyInfo'
);