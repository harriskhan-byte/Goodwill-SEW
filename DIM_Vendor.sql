SELECT 
    vt.RECID AS VendorKey, 
    vt.ACCOUNTNUM AS VendorAccountNumber, 
    dpt.NAME AS VendorName, 
    vt.BLOCKED AS OnHold,
    vt.BIDONLY AS BidOnly,
    vt.ONETIMEVENDOR AS OneTimeSupplier,
    vt.LOCALLYOWNED AS LocallyOwned,
    vt.SMALLBUSINESS AS SmallBusiness,
    vt.FEMALEOWNED AS WomanBusinessEnterprise,
    vt.MINORITYOWNED AS MinorityBusinessEnterprise,
    vt.ETHNICORIGINID AS EthnicOrigin,
    heo.DESCRIPTION AS EthnicOriginDescription,
    heo.EEOETHNICORIGIN AS EEOEthnicOrigin,
    vt.VETERANOWNED AS VeterenBusinessEnterprise,
    vt.DISABLEDOWNED AS DisabledBusiness,
    --NULL AS LGBTOwnedBusiness, -- could not be found
    vt.ADDITIONALIDENTIFIER1_CUSTOM AS AdditionalIdentifier1,
    vt.ADDITIONALIDENTIFIER2_CUSTOM AS AdditionalIdentifier2,
    vt.VENDGROUP AS VendorGroup,
    vg.NAME AS VendorGroupDescription, -- used the name field instead of the description field 
    vt.ITEMBUYERGROUPID AS BuyerGroup,
    ibg.DESCRIPTION AS BuyerGroupDescription,
    vt.PAYMTERMID AS PaymentTerms,
    pt.DESCRIPTION AS PaymentTermDescription
FROM VendTable vt
LEFT JOIN DIRPARTYTABLE dpt ON dpt.RECID = vt.PARTY
LEFT JOIN HCMETHNICORIGIN heo ON heo.ETHNICORIGINID = vt.ETHNICORIGINID
LEFT JOIN VENDGROUP vg ON vg.VENDGROUP = vt.VENDGROUP AND vg.DATAAREAID = vt.DATAAREAID
LEFT JOIN INVENTBUYERGROUP ibg ON ibg.GROUP_ = vt.ITEMBUYERGROUPID AND ibg.DATAAREAID = vt.DATAAREAID
LEFT JOIN PAYMTERM pt ON pt.PAYMTERMID = vt.PAYMTERMID AND pt.DATAAREAID = vt.DATAAREAID