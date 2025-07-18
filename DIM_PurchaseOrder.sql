-- CREATE VIEW ProcurementReporting.DIM_PurchaseOrder AS

/*  DIM SQL Script Creation - Purchase Order
    Only select statement - view creation will be done by client
    Name: DIM_PurchaseOrder
    Location: ProcurementReporting

    Fields:
      PurchaseOrderKey        (PurchTable.RecId)
      PurchaseOrderNumber     (PurchTable.PurchId)
      CreatedDate             (PurchTable.CreatedDateTime)
      POStatus                (PurchTable.PurchStatus)
      RequestedReceiptDate    (PurchTable.ReceiptDateRequested)
      DeliveryAddress         (LogisticsPostalAddress.Address)
      AttentionInformation    from address???
*/

SELECT
    pt.RECID AS PurchaseOrderKey,                  -- Surrogate key for purchase order
    pt.PurchId AS PurchaseOrderNumber,             -- Purchase order number
    pt.CREATEDDATETIME AS CreatedDate,             -- Purchase order creation date/time
    pt.PURCHSTATUS AS POStatus,                    -- Purchase order status
    pt.REQUESTEDSHIPDATE AS RequestedReceiptDate,  -- Requested receipt date
    lpa.ADDRESS AS DeliveryAddress                 -- Delivery address from LogisticsPostalAddress
    -- lpa.[???] AS AttentionInformation           -- AttentionInformation field not found in address table
FROM PURCHTABLE pt
LEFT JOIN LOGISTICSPOSTALADDRESS lpa 
    ON pt.DeliveryPostalAddress = lpa.RecId;