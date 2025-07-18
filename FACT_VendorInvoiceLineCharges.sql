SELECT 
    mt.VALUE                       AS Amount,
    1                              AS Quantity, -- quantity doesn't make sense
    mt.MARKUPCATEGORY              AS MarkupCategory,
    mt.MARKUPCODE                  AS MarkupCode,
    mt.MODULECATEGORY              AS ModuleCategory,
    mt.MODULETYPE                  AS ModuleType,
    
    vt.RECID                       AS VendorKey,
    erc.RECID                      AS ProcurementCategoryKey,
    prt.RECID                      AS PurchaseRequisitionKey,
    pt.RECID                       AS PurchaseOrderKey,
    vij.RECID                      AS VendorInvoiceKey

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