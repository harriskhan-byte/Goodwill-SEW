SELECT 
	ec.RECID AS ProcurmentCategoryKey,
	ec.Name AS ProcurementCategory,
	ect.DESCRIPTION AS ProcurementCategoryDescription
FROM ECORESCATEGORY ec
LEFT JOIN ECORESCATEGORYTRANSLATION ect on ect.CATEGORY = ec.RECID