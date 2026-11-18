codeunit 50450 "CTS Sales Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "Library Assert";

    [Test]
    procedure CalcTierThresholds()
    var
        LoyaltyMgt: Codeunit "CTS Customer Loyalty Mgt";
    begin
        Assert.AreEqual("CTS Loyalty Tier"::None, LoyaltyMgt.CalcTier(99), '99 points');
        Assert.AreEqual("CTS Loyalty Tier"::Bronze, LoyaltyMgt.CalcTier(100), '100 points');
        Assert.AreEqual("CTS Loyalty Tier"::Silver, LoyaltyMgt.CalcTier(500), '500 points');
        Assert.AreEqual("CTS Loyalty Tier"::Gold, LoyaltyMgt.CalcTier(1000), '1000 points');
    end;

    [Test]
    procedure DiscountCombinesTierAndCategory()
    var
        SalesDiscountMgt: Codeunit "CTS Sales Discount Mgt";
        ItemNo: Code[20];
    begin
        // [GIVEN] Silver = 10%, item category extra = 5%
        SetupDiscounts(5, 10, 15);
        ItemNo := CreateItemWithCategory('CTSTEST', 5);

        // [THEN] Silver customer buying that item gets 15%
        Assert.AreEqual(15, SalesDiscountMgt.CalcDiscountPct("CTS Loyalty Tier"::Silver, ItemNo), 'Combined discount');
    end;

    [Test]
    procedure DiscountIsCappedAt100()
    var
        SalesDiscountMgt: Codeunit "CTS Sales Discount Mgt";
        ItemNo: Code[20];
    begin
        SetupDiscounts(5, 10, 90);
        ItemNo := CreateItemWithCategory('CTSCAP', 50);

        Assert.AreEqual(100, SalesDiscountMgt.CalcDiscountPct("CTS Loyalty Tier"::Gold, ItemNo), 'Discount must cap at 100');
    end;

    local procedure SetupDiscounts(Bronze: Decimal; Silver: Decimal; Gold: Decimal)
    var
        CoreSetup: Record "CTS Core Setup";
    begin
        CoreSetup.InsertIfNotExists();
        CoreSetup."Bronze Discount %" := Bronze;
        CoreSetup."Silver Discount %" := Silver;
        CoreSetup."Gold Discount %" := Gold;
        CoreSetup.Modify();
    end;

    local procedure CreateItemWithCategory(CategoryCode: Code[20]; ExtraPct: Decimal): Code[20]
    var
        ItemCategory: Record "CTS Item Category";
        Item: Record Item;
    begin
        if not ItemCategory.Get(CategoryCode) then begin
            ItemCategory.Init();
            ItemCategory.Code := CategoryCode;
            ItemCategory.Insert();
        end;
        ItemCategory."Extra Discount %" := ExtraPct;
        ItemCategory.Modify();

        Item.Init();
        Item."No." := CopyStr(CategoryCode + '-ITEM', 1, MaxStrLen(Item."No."));
        if not Item.Insert() then;
        Item."CTS Category Code" := CategoryCode;
        Item.Modify();
        exit(Item."No.");
    end;
}
