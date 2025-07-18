-- CREATE VIEW ProcurementReporting.FACT_VendorInvoiceLineCharges AS

/*  FACT SQL Script Creation - Vendor Invoice Line Charges
    Only select statement - view creation will be done by client
    Name: FACT_VendorInvoiceLineCharges
    Location: ProcurementReporting

    Fields:
      Amount                   (markuptrans)
      Quantity                 (markuptrans)
      VendorKey
      ProcurementCategoryKey
      PurchaseRequisitionKey
      PurchaseOrderKey
      VendorInvoiceKey
      MarkupCategory           (MarkupTrans.MarkupCategory)
      MarkupCode               (MarkupTrans.MarkupCode)
      ModuleCategory           (MarkupTrans.ModuleCategory)
      ModuleType               (MarkupTrans.ModuleType)
*/

SELECT 
    mt.VALUE                       AS Amount,                  -- Charge amount from MarkupTrans
    1                              AS Quantity,                -- Quantity (not meaningful for charges)
    mt.MARKUPCATEGORY              AS MarkupCategory,          -- Markup category
    mt.MARKUPCODE                  AS MarkupCode,              -- Markup code
    mt.MODULECATEGORY              AS ModuleCategory,          -- Module category
    mt.MODULETYPE                  AS ModuleType,              -- Module type
    
    vt.RECID                       AS VendorKey,               -- Vendor surrogate key
    erc.RECID                      AS ProcurementCategoryKey,  -- Procurement category surrogate key
    prt.RECID                      AS PurchaseRequisitionKey,  -- Purchase requisition surrogate key
    pt.RECID                       AS PurchaseOrderKey,        -- Purchase order surrogate key
    vij.RECID                      AS VendorInvoiceKey         -- Vendor invoice surrogate key

FROM MARKUPTRANS mt

/* Link markup to invoice transaction */
LEFT JOIN VENDINVOICETRANS vit
    ON vit.RECID = mt.TRANSRECID
    AND mt.MODULETYPE = 2  -- VendInvoice module type

/* Invoice → Header */
LEFT JOIN VENDINVOICEJOUR vij
    ON vij.INVOICEID = vit.INVOICEID
    AND vij.DATAAREAID = vit.DATAAREAID

/* Vendor */
LEFT JOIN VENDTABLE vt
    ON vt.ACCOUNTNUM = vij.ORDERACCOUNT
    AND vt.DATAAREAID = vij.DATAAREAID

/* Purchase Order Header and Line */
LEFT JOIN PURCHTABLE pt
    ON pt.PURCHID = vij.PURCHID
    AND pt.DATAAREAID = vij.DATAAREAID

LEFT JOIN PURCHLINE pl
    ON pl.PURCHID = vit.PURCHID
    AND pl.INVENTTRANSID = vit.INVENTTRANSID
    AND pl.DATAAREAID = vit.DATAAREAID

/* Requisition origin */
LEFT JOIN PURCHREQLINE prl
    ON prl.LINEREFID = pl.PURCHREQLINEREFID

LEFT JOIN PURCHREQTABLE prt
    ON prt.RECID = prl.PURCHREQTABLE

/* Category via purchase line */
LEFT JOIN ECORESCATEGORY erc
    ON erc.RECID = pl.PROCUREMENTCATEGORY

WHERE mt.MODULETYPE = 2;  -- Filter for VendInvoice module only