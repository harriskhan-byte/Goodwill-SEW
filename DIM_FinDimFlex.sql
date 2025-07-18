-- CREATE VIEW ProcurementReporting.DIM_FinDimFlex AS

/*  DIM SQL Script Creation - Fin Dim - Flex
    Only select statement - view creation will be done by client
    Name: DIM_FinDimFlex
    Location: ProcurementReporting

    Fields:
      FinDimFlexKey   (entityinstance)
      Flex            (displayvalue)
      FlexName        (description)
*/

SELECT
    v.entityinstance    AS FinDimFlexKey,             -- Surrogate key for Flex dimension
    v.displayvalue      AS Flex,                      -- Flex code/value
    ft.[description]    AS FlexName                   -- Flex name/description
FROM DIMENSIONATTRIBUTE a
JOIN DIMENSIONATTRIBUTEVALUE v
  ON v.dimensionattribute = a.recid
JOIN DIMENSIONFINANCIALTAG ft
  ON ft.recid = v.entityinstance
WHERE
    a.[name] = 'D004_FLEX'
    AND EXISTS (
        SELECT 1
        FROM DIMENSIONATTRIBUTEVALUECOMBINATION vc
        WHERE vc.D004_FLEX = v.entityinstance
    );