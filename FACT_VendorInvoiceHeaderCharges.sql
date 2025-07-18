SELECT 
    mt.VALUE                       AS Amount,
    1                              AS Quantity, -- quantity doesn't make sense i don't think. 
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