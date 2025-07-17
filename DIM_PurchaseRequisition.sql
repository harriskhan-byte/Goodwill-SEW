SELECT
    prt.RecId AS PurchaseRequisitionKey,
    prt.PurchReqId AS RequisitionId,
    prt.PurchReqName AS RequisitionName,
    prt.RequisitionStatus AS RequisitionStatus,
    prt.PurchReqType AS RequisitionType,
    prt.SubmittedBy AS SubmittedBy,
    prt.SubmittedDateTime AS SubmittedDate
FROM PurchReqTable prt;