-- CREATE VIEW ProcurementReporting.DIM_Vendor AS

/*  DIM SQL Script Creation - Vendor
    Only select statement - view creation will be done by client
    Name: DIM_Vendor
    Location: ProcurementReporting

    Fields:
      VendorKey                   (VendTable.RecId)
      VendorAccountNumber         (VendTable.AccountNum)
      VendorName                  (DirPartyTable.Name)
      OnHold                      (VendTable.Blocked)
      BidOnly                     (VendTable.BidOnly)
      OneTimeSupplier             (VendTable.OneTimeVendor)
      LocallyOwned                (VendTable.LocallyOwned)
      SmallBusiness               (VendTable.SmallBusiness)
      WomanBusinessEnterprise     (VendTable.FemaleOwned)
      MinorityBusinessEnterprise  (VendTable.MinorityOwned)
      EthnicOrigin                (VendTable.EthnicOriginId)
      EthnicOriginDescription     (HcmEthnicOrigin.Description)
      EEOEthnicOrigin             (HcmEthnicOrigin.EcoEthnicOrigin)
      VeterenBusinessEnterprise   (VendTable.GW***)
      DisabledBusiness            (VendTable.GW***)
      LGBTOwnedBusiness           (VendTable.GW***)
      AdditionalIdentifier1       (VendTable.GW***)
      AdditionalIdentifier2       (VendTable.GW***)
      VendorGroup                 (VendTable.VendGroup)
      VendorGroupDescription      (VendGroup.Description)
      BuyerGroup                  (VendTable.ItemBuyerGroupId)
      BuyerGroupDescription       (InventBuyerGroup.Description)
      PaymentTerms                (VendTable.PaymTermId)
      PaymentTermDescription      (PaymTerm.Description)
*/

SELECT 
    vt.RECID AS VendorKey,                                 -- Surrogate key for vendor
    vt.ACCOUNTNUM AS VendorAccountNumber,                  -- Vendor account number
    dpt.NAME AS VendorName,                                -- Vendor name from DirPartyTable
    vt.BLOCKED AS OnHold,                                  -- Vendor on hold status
    vt.BIDONLY AS BidOnly,                                 -- Bid only vendor flag
    vt.ONETIMEVENDOR AS OneTimeSupplier,                   -- One-time supplier flag
    vt.LOCALLYOWNED AS LocallyOwned,                       -- Locally owned flag
    vt.SMALLBUSINESS AS SmallBusiness,                     -- Small business flag
    vt.FEMALEOWNED AS WomanBusinessEnterprise,             -- Woman business enterprise flag
    vt.MINORITYOWNED AS MinorityBusinessEnterprise,        -- Minority business enterprise flag
    vt.ETHNICORIGINID AS EthnicOrigin,                     -- Ethnic origin code
    heo.DESCRIPTION AS EthnicOriginDescription,            -- Ethnic origin description
    heo.EEOETHNICORIGIN AS EEOEthnicOrigin,                -- EEO ethnic origin
    vt.VETERANOWNED AS VeterenBusinessEnterprise,          -- Veteran business enterprise flag
    vt.DISABLEDOWNED AS DisabledBusiness,                  -- Disabled business flag
    -- NULL AS LGBTOwnedBusiness,                          -- LGBTOwnedBusiness not found in VendTable
    vt.ADDITIONALIDENTIFIER1_CUSTOM AS AdditionalIdentifier1, -- Additional identifier 1
    vt.ADDITIONALIDENTIFIER2_CUSTOM AS AdditionalIdentifier2, -- Additional identifier 2
    vt.VENDGROUP AS VendorGroup,                           -- Vendor group code
    vg.NAME AS VendorGroupDescription,                     -- Vendor group description (using NAME field)
    vt.ITEMBUYERGROUPID AS BuyerGroup,                     -- Buyer group code
    ibg.DESCRIPTION AS BuyerGroupDescription,              -- Buyer group description
    vt.PAYMTERMID AS PaymentTerms,                         -- Payment terms code
    pt.DESCRIPTION AS PaymentTermDescription               -- Payment term description

FROM VendTable vt
LEFT JOIN DIRPARTYTABLE dpt ON dpt.RECID = vt.PARTY
LEFT JOIN HCMETHNICORIGIN heo ON heo.ETHNICORIGINID = vt.ETHNICORIGINID
LEFT JOIN VENDGROUP vg ON vg.VENDGROUP = vt.VENDGROUP AND vg.DATAAREAID = vt.DATAAREAID
LEFT JOIN INVENTBUYERGROUP ibg ON ibg.GROUP_ = vt.ITEMBUYERGROUPID AND ibg.DATAAREAID = vt.DATAAREAID
LEFT JOIN PAYMTERM pt ON pt.PAYMTERMID = vt.PAYMTERMID AND pt.DATAAREAID = vt.DATAAREAID;