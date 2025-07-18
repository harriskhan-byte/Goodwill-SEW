SELECT
  payvt.AMOUNTCUR                AS Amount,
  1                              AS Quantity,
  payvt.PAYMREFERENCE            AS PaymentReference,
  payvt.PAYMMODE                 AS PaymentMode,
  payvt.DATAAREAID               AS CompanyKey,
  vend.RECID                     AS VendorKey,
  erc.RECID                      AS ProcurementCategoryKey,
  prt.RECID                      AS PurchaseRequisitionKey,
  pt.RECID                       AS PurchaseOrderKey,
  vij.RECID                      AS VendorInvoiceKey

FROM VENDTRANS AS payvt
/* Settlement links payment to invoice */
LEFT JOIN VENDSETTLEMENT AS vs
  ON vs.TRANSRECID = payvt.RECID
  AND vs.DATAAREAID = payvt.DATAAREAID

/* Get the invoice transaction that was settled */
LEFT JOIN VENDTRANS AS invvt
  ON invvt.RECID = vs.OFFSETRECID
  AND invvt.DATAAREAID = vs.DATAAREAID

/* Link to invoice journal via voucher and account */
LEFT JOIN VENDINVOICEJOUR AS vij
  ON vij.LEDGERVOUCHER = invvt.VOUCHER
  AND vij.INVOICEACCOUNT = invvt.ACCOUNTNUM
  AND vij.DATAAREAID = invvt.DATAAREAID

/* Get vendor from invoice journal */
LEFT JOIN VENDTABLE AS vend
  ON vend.ACCOUNTNUM = vij.INVOICEACCOUNT
  AND vend.DATAAREAID = vij.DATAAREAID

/* Link to invoice transactions to get purchase order info */
LEFT JOIN VENDINVOICETRANS AS vit
  ON vit.INVOICEID = vij.INVOICEID
  AND vit.DATAAREAID = vij.DATAAREAID

/* Link to purchase line via purchase ID and inventory transaction */
LEFT JOIN PURCHLINE AS pl
  ON pl.PURCHID = vit.PURCHID
  AND pl.INVENTTRANSID = vit.INVENTTRANSID
  AND pl.DATAAREAID = vit.DATAAREAID

/* Purchase order header */
LEFT JOIN PURCHTABLE AS pt
  ON pt.PURCHID = pl.PURCHID
  AND pt.DATAAREAID = pl.DATAAREAID

/* Purchase requisition line */
LEFT JOIN PURCHREQLINE AS prl
  ON prl.LINEREFID = pl.PURCHREQLINEREFID

/* Purchase requisition header */
LEFT JOIN PURCHREQTABLE AS prt
  ON prt.RECID = prl.PURCHREQTABLE

/* Procurement category */
LEFT JOIN ECORESCATEGORY AS erc
  ON erc.RECID = pl.PROCUREMENTCATEGORY

WHERE payvt.TRANSTYPE = 15; -- Only payment transactions (not invoices)