-- CREATE VIEW ProcurementReporting.DIM_VendorInvoice AS

/*  DIM SQL Script Creation - Vendor Invoices
    Only select statement - view creation will be done by client
    Name: DIM_VendorInvoice
    Location: ProcurementReporting

    Fields:
      VendorInvoiceKey   (VendInvoiceJour.RecId)
      InvoiceId          (VendInvoiceJour.InvoiceId)
      InvoiceDate        (VendInvoiceJour.DocumentDate)
      PurchaseType       (VendInvoiceJour.PurchaseType)
*/

SELECT
    vij.RECID AS VendorInvoiceKey,         -- Surrogate key for vendor invoice (RecId)
    vij.INVOICEID AS InvoiceId,            -- Vendor invoice number
    vij.DOCUMENTDATE AS InvoiceDate,       -- Invoice document date
    vij.PURCHASETYPE AS PurchaseType       -- Purchase type
FROM VendInvoiceJour vij;