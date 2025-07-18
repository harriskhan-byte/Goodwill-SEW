-- CREATE VIEW ProcurementReporting.DIM_PurchaseRequisition AS

/*  DIM SQL Script Creation - Purchase Requisitions
    Only select statement - view creation will be done by client
    Name: DIM_PurchaseRequisition
    Location: ProcurementReporting

    Fields:
      PurchaseRequisitionKey   (PurchReqTable.RecId)
      RequisitionId            (PurchReqTable.PurchReqId)
      RequisitionName          (PurchReqTable.PurchReqName)
      RequisitionStatus        (PurchReqTable.RequisitionStatus)
      RequisitionType          (PurchReqTable.PurchReqType)
      SubmittedBy              (PurchReqTable.SubmittedBy)
      SubmittedDate            (PurchReqTable.SubmittedDateTime)
*/

SELECT
    prt.RecId AS PurchaseRequisitionKey,         -- Surrogate key for purchase requisition
    prt.PurchReqId AS RequisitionId,             -- Requisition ID
    prt.PurchReqName AS RequisitionName,         -- Requisition name
    prt.RequisitionStatus AS RequisitionStatus,  -- Requisition status
    prt.PurchReqType AS RequisitionType,         -- Requisition type
    prt.SubmittedBy AS SubmittedBy,              -- User who submitted the requisition
    prt.SubmittedDateTime AS SubmittedDate       -- Date/time submitted
FROM PurchReqTable prt;