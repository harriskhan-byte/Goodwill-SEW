SELECT
    v.entityinstance    AS SYSTEM_KEY,
    v.displayvalue      AS CostCenter,
    ft.[description]    AS CostCenterDescription
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
    )