SELECT
    vij.RecId AS VendorInvoiceKey, -- using this from vend invoice jour rather than vend
    vij.InvoiceId AS InvoiceId,
    vij.DocumentDate AS InvoiceDate,
    vij.PurchaseType AS PurchaseType
FROM VendInvoiceJour vij;