SELECT
	vt.AMOUNTCUR AS Amount, 
	1 AS Quantity -- not sure why this is set to 1
FROM VENDTRANS vt
LEFT JOIN VENDSETTLEMENT vs ON vs.OFFSETRECID = vt.RECID