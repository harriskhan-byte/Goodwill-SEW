SELECT
	pl.LINEAMOUNT AS Amount, 
	pl.PURCHQTY AS Quantity, 
	pl.PURCHPRICE AS [Unit Price] -- this field is the price. you may want to do the calculation for the unit price 
FROM PURCHLINE pl