codeunit 50400 "CTS Core Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "Library Assert";
        CoreMgt: Codeunit "CTS Core Mgt";

    [Test]
    procedure GoldTierReturnsConfiguredDiscount()
    begin
        // [GIVEN] Gold discount is 15
        SetupDiscounts(5, 10, 15);
        // [THEN] Gold returns 15
        Assert.AreEqual(15, CoreMgt.GetTierDiscountPct("CTS Loyalty Tier"::Gold), 'Gold discount mismatch');
    end;

    [Test]
    procedure NoneTierReturnsZero()
    begin
        SetupDiscounts(5, 10, 15);
        Assert.AreEqual(0, CoreMgt.GetTierDiscountPct("CTS Loyalty Tier"::None), 'None tier must have no discount');
    end;

    [Test]
    procedure LogWritesEntryWhenEnabled()
    var
        CoreSetup: Record "CTS Core Setup";
        LogEntry: Record "CTS Log Entry";
        CountBefore: Integer;
    begin
        CoreSetup.InsertIfNotExists();
        CoreSetup."Enable Logging" := true;
        CoreSetup.Modify();
        CountBefore := LogEntry.Count();

        CoreMgt.Log('Test', 'Hello');

        Assert.AreEqual(CountBefore + 1, LogEntry.Count(), 'Log entry not written');
    end;

    [Test]
    procedure LogSkippedWhenDisabled()
    var
        CoreSetup: Record "CTS Core Setup";
        LogEntry: Record "CTS Log Entry";
        CountBefore: Integer;
    begin
        CoreSetup.InsertIfNotExists();
        CoreSetup."Enable Logging" := false;
        CoreSetup.Modify();
        CountBefore := LogEntry.Count();

        CoreMgt.Log('Test', 'Hello');

        Assert.AreEqual(CountBefore, LogEntry.Count(), 'Log entry written while disabled');
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
}
