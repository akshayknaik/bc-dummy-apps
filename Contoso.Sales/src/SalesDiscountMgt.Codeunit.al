codeunit 50250 "CTS Sales Discount Mgt"
{
    procedure ApplyLoyaltyDiscount(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        Pct: Decimal;
    begin
        if SalesLine.Type <> SalesLine.Type::Item then
            exit;
        if SalesLine."No." = '' then
            exit;
        if not SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            exit;

        Pct := CalcDiscountPct(SalesHeader."CTS Loyalty Tier", SalesLine."No.");
        SalesLine."CTS Loyalty Discount %" := Pct;
        if Pct <> 0 then
            SalesLine.Validate("Line Discount %", Pct);
    end;

    procedure CalcDiscountPct(Tier: Enum "CTS Loyalty Tier"; ItemNo: Code[20]): Decimal
    var
        CoreMgt: Codeunit "CTS Core Mgt";
        ItemCategoryMgt: Codeunit "CTS Item Category Mgt";
        Pct: Decimal;
    begin
        Pct := CoreMgt.GetTierDiscountPct(Tier) + ItemCategoryMgt.GetExtraDiscountPct(ItemNo);
        if Pct > 100 then
            Pct := 100;
        exit(Pct);
    end;
}
