-- CREATE VIEW ProcurementReporting.FACT_VendorInvoiceHeaderCharges AS

/*  FACT SQL Script Creation - Vendor Invoice Header Charges
    Only select statement - view creation will be done by client
    Name: FACT_VendorInvoiceHeaderCharges
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
    1                              AS Quantity,                -- Quantity (not meaningful for header charges)
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

/* Link markup directly to invoice header */
LEFT JOIN VENDINVOICEJOUR vij
    ON vij.RECID = mt.TRANSRECID
    AND mt.MODULETYPE = 2  -- VendInvoice module type

/* Vendor */
LEFT JOIN VENDTABLE vt
    ON vt.ACCOUNTNUM = vij.ORDERACCOUNT
    AND vt.DATAAREAID = vij.DATAAREAID

/* Purchase Order Header */
LEFT JOIN PURCHTABLE pt
    ON pt.PURCHID = vij.PURCHID
    AND pt.DATAAREAID = vij.DATAAREAID

/* Get first purchase line for category/requisition info */
LEFT JOIN PURCHLINE pl
    ON pl.PURCHID = pt.PURCHID
    AND pl.DATAAREAID = pt.DATAAREAID
    AND pl.LINENUMBER = (SELECT MIN(pl2.LINENUMBER) 
                         FROM PURCHLINE pl2 
                         WHERE pl2.PURCHID = pt.PURCHID 
                         AND pl2.DATAAREAID = pt.DATAAREAID)

/* Requisition origin */
LEFT JOIN PURCHREQLINE prl
    ON prl.LINEREFID = pl.PURCHREQLINEREFID

LEFT JOIN PURCHREQTABLE prt
    ON prt.RECID = prl.PURCHREQTABLE

/* Category via purchase line */
LEFT JOIN ECORESCATEGORY erc
    ON erc.RECID = pl.PROCUREMENTCATEGORY

WHERE mt.MODULETYPE = 2;  -- Filter for VendInvoice module only