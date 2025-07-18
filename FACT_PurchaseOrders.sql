-- CREATE VIEW ProcurementReporting.FACT_PurchaseOrders AS

/*  FACT SQL Script Creation - Purchase Orders
    Only select statement - view creation will be done by client
    Name: FACT_PurchaseOrders
    Location: ProcurementReporting

    Fields:
      Amount                   (purch line)
      Quantity                 (purch line)
      Unit Price               (req line)
      CompanyKey
      VendorKey
      ProcurementCategoryKey
      PurchaseRequisitionKey
      VendorInvoiceKey
      PurchaseOrderKey
      FinDimLocationKey
      FinDimFlexKey
      FinDimCostCenterKey
      FinDimDivisionKey
*/

SELECT
    pl.LINEAMOUNT                     AS Amount,                -- Line net amount from purchase line
    pl.PURCHQTY                       AS Quantity,              -- Quantity from purchase line
    pl.PURCHPRICE                     AS [Unit Price],          -- Unit price from purchase line

    pl.DATAAREAID                     AS CompanyKey,            -- Company surrogate key
    vt.RECID                          AS VendorKey,             -- Vendor surrogate key
    erc.RECID                         AS ProcurementCategoryKey,-- Procurement category surrogate key
    prt.RECID                         AS PurchaseRequisitionKey,-- Purchase requisition surrogate key
    vij.RecId                         AS VendorInvoiceKey,      -- Vendor invoice surrogate key (can be NULL)
    pt.RECID                          AS PurchaseOrderKey,      -- Purchase order surrogate key

    locDim.ENTITYINSTANCE             AS FinDimLocationKey,     -- Financial dimension: Location
    flexDim.ENTITYINSTANCE            AS FinDimFlexKey,         -- Financial dimension: Flex
    costDim.ENTITYINSTANCE            AS FinDimCostCenterKey,   -- Financial dimension: Cost Center
    divDim.ENTITYINSTANCE             AS FinDimDivisionKey      -- Financial dimension: Division

FROM  PURCHLINE                pl                                    -- Fact grain: purchase line
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
                                          AND divDim.NAME = 'D001_Division'
;