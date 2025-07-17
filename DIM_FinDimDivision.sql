SELECT
    v.entityinstance    AS FinDimDivisionKey,
    v.displayvalue      AS Division,
    ft.[description]    AS DivisionDescription
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
    )