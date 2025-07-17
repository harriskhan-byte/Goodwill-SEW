-- CREATE VIEW DIM_PurchaseOrder AS
SELECT
    pt.RECID AS PurchaseOrderKey,
    pt.PurchId AS PurchaseOrderNumber,
    pt.CREATEDDATETIME AS CreatedDate,
    pt.PURCHSTATUS AS POStatus,
    pt.REQUESTEDSHIPDATE AS RequestedReceiptDate,
    lpa.ADDRESS AS DeliveryAddress
    --lpa. AS AttentionInformation -- Could not find this
FROM PURCHTABLE pt
LEFT JOIN LOGISTICSPOSTALADDRESS lpa ON pt.DeliveryPostalAddress = lpa.RecId;