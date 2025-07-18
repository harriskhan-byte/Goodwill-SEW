-- CREATE VIEW ProcurementReporting.FACT_VendorPayments AS

/*  FACT SQL Script Creation - Vendor Payments
    Only select statement - view creation will be done by client
    Name: FACT_VendorPayments
    Location: ProcurementReporting

    Fields:
      Amount                   (vendtrans, vendsettlement)
      Quantity                 (vendtrans, vendsettlement)
      CompanyKey
      VendorKey
      ProcurementCategoryKey
      PurchaseRequisitionKey
      PurchaseOrderKey
      VendorInvoiceKey
      PaymentReference         (VendTrans.PaymReference)
      PaymentMode              (VendTrans.PaymentMode)
*/

SELECT
    payvt.AMOUNTCUR                AS Amount,                  -- Payment amount from VendTrans
    1                              AS Quantity,                -- Quantity (not meaningful for payments)
    payvt.PAYMREFERENCE            AS PaymentReference,        -- Payment reference from VendTrans
    payvt.PAYMMODE                 AS PaymentMode,             -- Payment mode from VendTrans
    payvt.DATAAREAID               AS CompanyKey,              -- Company surrogate key
    vend.RECID                     AS VendorKey,               -- Vendor surrogate key
    erc.RECID                      AS ProcurementCategoryKey,  -- Procurement category surrogate key
    prt.RECID                      AS PurchaseRequisitionKey,  -- Purchase requisition surrogate key
    pt.RECID                       AS PurchaseOrderKey,        -- Purchase order surrogate key
    vij.RECID                      AS VendorInvoiceKey         -- Vendor invoice surrogate key

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