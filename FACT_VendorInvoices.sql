SELECT
  vit.LINEAMOUNTMST          AS Amount,
  vit.QTY                    AS Quantity,
  vit.PURCHPRICE             AS [Unit Price],

  vit.DATAAREAID             AS CompanyKey,
  vt.RECID                   AS VendorKey,
  erc.RECID                  AS ProcurementCategoryKey,
  prt.RECID                  AS PurchaseRequisitionKey,
  pt.RECID                   AS PurchaseOrderKey,
  vij.RECID                  AS VendorInvoiceKey,

  locDim.ENTITYINSTANCE      AS FinDimLocationKey,
  flexDim.ENTITYINSTANCE     AS FinDimFlexKey,
  costDim.ENTITYINSTANCE     AS FinDimCostCenterKey,
  divDim.ENTITYINSTANCE      AS FinDimDivisionKey

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
 AND divDim.NAME = 'D001_Division';
