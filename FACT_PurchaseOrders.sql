/*  FACT_PurchaseOrders  – ProcurementReporting schema  */
SELECT
    /* Measures — PurchLine grain */
    pl.LINEAMOUNT                     AS Amount,           -- line net amount
    pl.PURCHQTY                       AS Quantity,
    pl.PURCHPRICE                     AS [Unit Price],

    /* Keys */
    pl.DATAAREAID                     AS CompanyKey, -- More direct way to get CompanyKey
    vt.RECID                          AS VendorKey,
    erc.RECID                         AS ProcurementCategoryKey,
    prt.RECID                         AS PurchaseRequisitionKey,
    pt.RECID                          AS PurchaseOrderKey,
    vij.RecId                         AS VendorInvoiceKey,      -- can be NULL

    /* Financial‑dimension surrogate keys */
    locDim.ENTITYINSTANCE             AS FinDimLocationKey,
    flexDim.ENTITYINSTANCE            AS FinDimFlexKey,
    costDim.ENTITYINSTANCE            AS FinDimCostCenterKey,
    divDim.ENTITYINSTANCE             AS FinDimDivisionKey

FROM  PURCHLINE                pl                                    -- fact grain
/* Vendor */
LEFT JOIN VENDTABLE             vt   ON vt.DATAAREAID = pl.DATAAREAID
                                      AND vt.ACCOUNTNUM = pl.VENDACCOUNT
/* Procurement category (EcoRes) */
LEFT JOIN ECORESCATEGORY        erc  ON erc.RECID = pl.PROCUREMENTCATEGORY
/* Purchase‑order header */
LEFT JOIN PURCHTABLE            pt   ON pt.PURCHID    = pl.PURCHID
                                      AND pt.DATAAREAID = pl.DATAAREAID
/* Requisition header (jump back through PurchReqLine) */
LEFT JOIN PURCHREQLINE          prl  ON prl.LINEREFID     = pl.PURCHREQLINEREFID
LEFT JOIN PURCHREQTABLE         prt  ON prt.RECID     = prl.PURCHREQTABLE
/* Vendor invoice (one‑to‑many handled through invoice line) */
LEFT JOIN VENDINVOICETRANS      vit  ON vit.PURCHID     = pl.PURCHID
                                      AND vit.INVENTTRANSID = pl.INVENTTRANSID
                                      AND vit.DATAAREAID = pl.DATAAREAID
/* Corrected Join to VENDINVOICEJOUR */
LEFT JOIN VENDINVOICEJOUR       vij  ON vij.RECID = vit.SOURCEDOCUMENTLINE
                                      AND vij.DATAAREAID = vit.DATAAREAID
/* Financial‑dimension surrogate keys pulled with DefaultDimensionView */
LEFT JOIN DEFAULTDIMENSIONVIEW  locDim ON locDim.DEFAULTDIMENSION = pl.DEFAULTDIMENSION
                                          AND locDim.NAME = 'D003_Location'
LEFT JOIN DEFAULTDIMENSIONVIEW  flexDim ON flexDim.DEFAULTDIMENSION = pl.DEFAULTDIMENSION
                                          AND flexDim.NAME = 'D004_Flex'
LEFT JOIN DEFAULTDIMENSIONVIEW  costDim ON costDim.DEFAULTDIMENSION = pl.DEFAULTDIMENSION
                                          AND costDim.NAME = 'D002_CostCenter'
LEFT JOIN DEFAULTDIMENSIONVIEW  divDim  ON divDim.DEFAULTDIMENSION = pl.DEFAULTDIMENSION
                                          AND divDim.NAME = 'D001_Division';