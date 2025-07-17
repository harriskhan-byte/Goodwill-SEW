SELECT
	prl.LINEAMOUNT AS Amount,
	prl.PURCHQTY AS Quantity, 
	prl.PURCHPRICE AS [Unit Price], 
	dpt.DATAAREA AS CompanyKey, 
	vt.RECID AS VendorKey, 
	erc.RECID AS ProcurementCategoryKey,
	prt.RECID AS PurchaseRequisitionKey,
	pt.RECID AS PurchaseOrderKey,
	NULL AS VendorInvoiceKey, -- could not figure out how to add this. 
	locDim.ENTITYINSTANCE AS FinDimLocationKey,
	flexDim.ENTITYINSTANCE AS FinDimFlexKey,
	costDim.ENTITYINSTANCE AS FinDimCostCenterKey,
	divDim.ENTITYINSTANCE AS FinDimDivisionKey
FROM PURCHREQLINE prl
LEFT JOIN DIRPARTYTABLE dpt ON dpt.RECID = prl.BUYINGLEGALENTITY -- for CompanyKey
LEFT JOIN VENDTABLE vt ON vt.DATAAREAID = prl.VENDACCOUNTDATAAREA AND vt.ACCOUNTNUM = prl.VENDACCOUNT -- for VendorKey
LEFT JOIN ECORESCATEGORY erc ON erc.RECID = prl.PROCUREMENTCATEGORY -- for PurchaseCategoryKey
LEFT JOIN PURCHREQTABLE prt ON prt.RECID = prl.PURCHREQTABLE -- for PurchaseRequisitionKey
LEFT JOIN PURCHTABLE pt ON pt.PURCHID = prl.PURCHID AND pt.DATAAREAID = prl.PURCHIDDATAAREA -- for PurchaseOrderKey
LEFT JOIN DEFAULTDIMENSIONVIEW locDim ON locDim.DefaultDimension = prl.DEFAULTDIMENSION AND locDim.Name = 'D003_Location' -- for FinDimLocationKey
LEFT JOIN DEFAULTDIMENSIONVIEW flexDim ON flexDim.DefaultDimension = prl.DEFAULTDIMENSION AND flexDim.Name = 'D004_Flex' -- for FinDimFlexKey
LEFT JOIN DEFAULTDIMENSIONVIEW costDim ON costDim.DefaultDimension = prl.DEFAULTDIMENSION AND costDim.Name = 'D002_CostCenter' -- for FinDimcostCenterKey
LEFT JOIN DEFAULTDIMENSIONVIEW divDim ON divDim.DefaultDimension = prl.DEFAULTDIMENSION AND divDim.Name = 'D001_Division' -- for FinDimDivisionKey
