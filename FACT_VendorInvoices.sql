-- CREATE VIEW ProcurementReporting.FACT_VendorInvoices AS

/*  FACT SQL Script Creation - Vendor Invoices
    Only select statement - view creation will be done by client
    Name: FACT_VendorInvoices
    Location: ProcurementReporting

    Fields:
      Amount                   (invoice line)
      Quantity                 (invoice line)
      Unit Price               (invoice line)
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
    vit.LINEAMOUNTMST          AS Amount,                -- Line net amount from invoice line
    vit.QTY                    AS Quantity,              -- Quantity from invoice line
    vit.PURCHPRICE             AS [Unit Price],          -- Unit price from invoice line

    vit.DATAAREAID             AS CompanyKey,            -- Company surrogate key
    vt.RECID                   AS VendorKey,             -- Vendor surrogate key
    erc.RECID                  AS ProcurementCategoryKey,-- Procurement category surrogate key
    prt.RECID                  AS PurchaseRequisitionKey,-- Purchase requisition surrogate key
    pt.RECID                   AS PurchaseOrderKey,      -- Purchase order surrogate key
    vij.RECID                  AS VendorInvoiceKey,      -- Vendor invoice surrogate key

    locDim.ENTITYINSTANCE      AS FinDimLocationKey,     -- Financial dimension: Location
    flexDim.ENTITYINSTANCE     AS FinDimFlexKey,         -- Financial dimension: Flex
    costDim.ENTITYINSTANCE     AS FinDimCostCenterKey,   -- Financial dimension: Cost Center
    divDim.ENTITYINSTANCE      AS FinDimDivisionKey      -- Financial dimension: Division

FROM VendInvoiceTrans vit

/* Invoice → Header */
LEFT JOIN VendInvoiceJour vij
    ON vij.INVOICEID     = vit.INVOICEID
   AND vij.DATAAREAID    = vit.DATAAREAID

/* Vendor */
LEFT JOIN VendTable vt
    ON vt.ACCOUNTNUM     = vij.ORDERACCOUNT
   AND vt.DATAAREAID     = vij.DATAAREAID

/* Purchase Order Header and Line */
LEFT JOIN PurchTable pt
    ON pt.PURCHID        = vij.PURCHID
   AND pt.DATAAREAID     = vij.DATAAREAID

LEFT JOIN PurchLine pl
    ON pl.PURCHID        = vit.PURCHID
   AND pl.INVENTTRANSID  = vit.INVENTTRANSID
   AND pl.DATAAREAID     = vit.DATAAREAID

/* Requisition origin */
LEFT JOIN PurchReqLine prl
    ON prl.LINEREFID         = pl.PURCHREQLINEREFID

LEFT JOIN PurchReqTable prt
    ON prt.RECID         = prl.PURCHREQTABLE

/* Category via purchase line */
LEFT JOIN EcoResCategory erc
    ON erc.RECID         = pl.PROCUREMENTCATEGORY

/* Financial dims from invoice line */
LEFT JOIN DefaultDimensionView locDim
    ON locDim.DefaultDimension = vit.DEFAULTDIMENSION
   AND locDim.NAME = 'D003_Location'
LEFT JOIN DefaultDimensionView flexDim
    ON flexDim.DefaultDimension = vit.DEFAULTDIMENSION
   AND flexDim.NAME = 'D004_Flex'
LEFT JOIN DefaultDimensionView costDim
    ON costDim.DefaultDimension = vit.DEFAULTDIMENSION
   AND costDim.NAME = 'D002_CostCenter'
LEFT JOIN DefaultDimensionView divDim
    ON divDim.DefaultDimension = vit.DEFAULTDIMENSION
   AND divDim.NAME = 'D001_Division'
;