SELECT
    v.entityinstance    AS SYSTEM_KEY,
    v.displayvalue      AS Flex,
    ft.[description]    AS FlexDescription
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
    )