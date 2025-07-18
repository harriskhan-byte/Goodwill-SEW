-- CREATE VIEW ProcurementReporting.DIM_FinDimCostCenter AS

/*  DIM SQL Script Creation - Fin Dim - Cost Center
    Only select statement - view creation will be done by client
    Name: DIM_FinDimCostCenter
    Location: ProcurementReporting

    Fields:
      FinDimCostCenterKey   (entityinstance)
      CostCenter            (displayvalue)
      CostCenterName        (description)
*/

SELECT
    v.entityinstance    AS FinDimCostCenterKey,       -- Surrogate key for Cost Center dimension
    v.displayvalue      AS CostCenter,                -- Cost Center code/value
    ft.[description]    AS CostCenterName             -- Cost Center name/description
FROM DIMENSIONATTRIBUTE a
JOIN DIMENSIONATTRIBUTEVALUE v
  ON v.dimensionattribute = a.recid
JOIN DIMENSIONFINANCIALTAG ft
  ON ft.recid = v.entityinstance
WHERE
    a.[name] = 'D002_COSTCENTER'
    AND EXISTS (
        SELECT 1
        FROM DIMENSIONATTRIBUTEVALUECOMBINATION vc
        WHERE vc.D002_COSTCENTER = v.entityinstance
    );