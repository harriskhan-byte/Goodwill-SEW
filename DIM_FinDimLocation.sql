-- CREATE VIEW ProcurementReporting.DIM_FinDimLocation AS

/*  DIM SQL Script Creation - Fin Dim - Location
    Only select statement - view creation will be done by client
    Name: DIM_FinDimLocation
    Location: ProcurementReporting

    Fields:
      FinDimLocationKey   (entityinstance)
      Location            (displayvalue)
      LocationName        (description)
*/

SELECT
    v.entityinstance    AS FinDimLocationKey,         -- Surrogate key for Location dimension
    v.displayvalue      AS Location,                  -- Location code/value
    ft.[description]    AS LocationName               -- Location name/description
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
    );