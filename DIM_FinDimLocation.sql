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
    a.[name] = 'D003_LOCATION'
    AND EXISTS (
        SELECT 1
        FROM DIMENSIONATTRIBUTEVALUECOMBINATION vc
        WHERE vc.D003_LOCATION = v.entityinstance
    )