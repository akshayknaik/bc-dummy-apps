codeunit 50100 "CTS Core Mgt"
{
    procedure Log(Source: Text[100]; Message: Text[250])
    var
        CoreSetup: Record "CTS Core Setup";
        LogEntry: Record "CTS Log Entry";
    begin
        if not CoreSetup.Get() then
            exit;
        if not CoreSetup."Enable Logging" then
            exit;

        LogEntry.Init();
        LogEntry.Source := Source;
        LogEntry.Message := Message;
        LogEntry."Created At" := CurrentDateTime();
        LogEntry.Insert(true);

        OnAfterLog(LogEntry);
    end;

    procedure GetTierDiscountPct(Tier: Enum "CTS Loyalty Tier"): Decimal
    var
        CoreSetup: Record "CTS Core Setup";
    begin
        if not CoreSetup.Get() then
            exit(0);

        case Tier of
            Tier::Bronze:
                exit(CoreSetup."Bronze Discount %");
            Tier::Silver:
                exit(CoreSetup."Silver Discount %");
            Tier::Gold:
                exit(CoreSetup."Gold Discount %");
        end;
        exit(0);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLog(var LogEntry: Record "CTS Log Entry")
    begin
    end;
}
