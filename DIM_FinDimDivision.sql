-- CREATE VIEW ProcurementReporting.DIM_FinDimDivision AS

/*  DIM SQL Script Creation - Fin Dim - Division
    Only select statement - view creation will be done by client
    Name: DIM_FinDimDivision
    Location: ProcurementReporting

    Fields:
      FinDimDivisionKey   (entityinstance)
      Division            (displayvalue)
      DivisionName        (description)
*/

SELECT
    v.entityinstance    AS FinDimDivisionKey,         -- Surrogate key for Division dimension
    v.displayvalue      AS Division,                  -- Division code/value
    ft.[description]    AS DivisionName               -- Division name/description
FROM DIMENSIONATTRIBUTE a
JOIN DIMENSIONATTRIBUTEVALUE v
  ON v.dimensionattribute = a.recid
JOIN DIMENSIONFINANCIALTAG ft
  ON ft.recid = v.entityinstance
WHERE
    a.[name] = 'D001_Division'
    AND EXISTS (
        SELECT 1
        FROM DIMENSIONATTRIBUTEVALUECOMBINATION vc
        WHERE vc.D001_DIVISION = v.entityinstance
    );