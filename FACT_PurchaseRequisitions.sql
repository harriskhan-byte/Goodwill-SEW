-- CREATE VIEW ProcurementReporting.FACT_PurchaseRequisitions AS

/*  FACT SQL Script Creation - Purchase Reqs
    Only select statement - view creation will be done by client
    Name: FACT_PurchaseRequisitions
    Location: ProcurementReporting

    Fields:
      Amount                   (purch req line)
      Quantity                 (purch req line)
      Unit Price               (purch req line)
      CompanyKey
      VendorKey
      ProcurementCategoryKey
      PurchaseRequisitionKey
      PurchaseOrderKey
      VendorInvoiceKey
      FinDimLocationKey
      FinDimFlexKey
      FinDimCostCenterKey
      FinDimDivisionKey
*/

SELECT
    prl.LINEAMOUNT AS Amount,                                 -- Line net amount from purchase req line
    prl.PURCHQTY AS Quantity,                                 -- Quantity from purchase req line
    prl.PURCHPRICE AS [Unit Price],                           -- Unit price from purchase req line
    dpt.DATAAREA AS CompanyKey,                               -- Company surrogate key
    vt.RECID AS VendorKey,                                    -- Vendor surrogate key
    erc.RECID AS ProcurementCategoryKey,                      -- Procurement category surrogate key
    prt.RECID AS PurchaseRequisitionKey,                      -- Purchase requisition surrogate key
    pt.RECID AS PurchaseOrderKey,                             -- Purchase order surrogate key
    NULL AS VendorInvoiceKey,                                 -- Vendor invoice surrogate key (not available at this stage)
    locDim.ENTITYINSTANCE AS FinDimLocationKey,               -- Financial dimension: Location
    flexDim.ENTITYINSTANCE AS FinDimFlexKey,                  -- Financial dimension: Flex
    costDim.ENTITYINSTANCE AS FinDimCostCenterKey,            -- Financial dimension: Cost Center
    divDim.ENTITYINSTANCE AS FinDimDivisionKey                -- Financial dimension: Division
FROM PURCHREQLINE prl
LEFT JOIN DIRPARTYTABLE dpt 
    ON dpt.RECID = prl.BUYINGLEGALENTITY                     -- Join for CompanyKey
LEFT JOIN VENDTABLE vt 
    ON vt.DATAAREAID = prl.VENDACCOUNTDATAAREA 
    AND vt.ACCOUNTNUM = prl.VENDACCOUNT                      -- Join for VendorKey
LEFT JOIN ECORESCATEGORY erc 
    ON erc.RECID = prl.PROCUREMENTCATEGORY                   -- Join for ProcurementCategoryKey
LEFT JOIN PURCHREQTABLE prt 
    ON prt.RECID = prl.PURCHREQTABLE                         -- Join for PurchaseRequisitionKey
LEFT JOIN PURCHTABLE pt 
    ON pt.PURCHID = prl.PURCHID 
    AND pt.DATAAREAID = prl.PURCHIDDATAAREA                  -- Join for PurchaseOrderKey
LEFT JOIN DEFAULTDIMENSIONVIEW locDim 
    ON locDim.DefaultDimension = prl.DEFAULTDIMENSION 
    AND locDim.Name = 'D003_Location'                        -- Join for FinDimLocationKey
LEFT JOIN DEFAULTDIMENSIONVIEW flexDim 
    ON flexDim.DefaultDimension = prl.DEFAULTDIMENSION 
    AND flexDim.Name = 'D004_Flex'                           -- Join for FinDimFlexKey
LEFT JOIN DEFAULTDIMENSIONVIEW costDim 
    ON costDim.DefaultDimension = prl.DEFAULTDIMENSION 
    AND costDim.Name = 'D002_CostCenter'                     -- Join for FinDimCostCenterKey
LEFT JOIN DEFAULTDIMENSIONVIEW divDim 
    ON divDim.DefaultDimension = prl.DEFAULTDIMENSION 
    AND divDim.Name = 'D001_Division'                        -- Join for FinDimDivisionKey
;