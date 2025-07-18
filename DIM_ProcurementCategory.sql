-- CREATE VIEW ProcurementReporting.DIM_ProcurementCategory AS

/*  DIM SQL Script Creation - Procurement Category
    Only select statement - view creation will be done by client
    Name: DIM_ProcurementCategory
    Location: ProcurementReporting

    Fields:
      ProcurementCategoryKey         (EcoResCategory.RecId)
      ProcurementCategory            (EcoResCategory.Name)
      ProcurementCategoryDescription (EcoResCategoryTranslation.Description)
*/

SELECT 
    ec.RECID AS ProcurementCategoryKey,                -- Surrogate key for procurement category
    ec.NAME AS ProcurementCategory,                    -- Procurement category name
    ect.DESCRIPTION AS ProcurementCategoryDescription  -- Procurement category description (translation)
FROM ECORESCATEGORY ec
LEFT JOIN ECORESCATEGORYTRANSLATION ect 
    ON ect.CATEGORY = ec.RECID;