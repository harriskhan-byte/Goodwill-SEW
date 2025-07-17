SELECT
	vit.LINEAMOUNTMST AS Amount, -- this will get the price in the companys accounting currency, there is also lineamount field that will get the line amount in the transaction currency
	vit.QTY AS Quantity,
	vit.PURCHPRICE AS [Unit Price]
FROM VENDINVOICETRANS vit