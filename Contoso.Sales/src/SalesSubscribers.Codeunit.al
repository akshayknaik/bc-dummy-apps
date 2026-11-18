codeunit 50251 "CTS Sales Subscribers"
{
    SingleInstance = false;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure SalesHeaderOnAfterValidateSellToCustomer(var Rec: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Sell-to Customer No.") then
            Rec."CTS Loyalty Tier" := Customer."CTS Loyalty Tier"
        else
            Rec."CTS Loyalty Tier" := Rec."CTS Loyalty Tier"::None;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure SalesLineOnAfterValidateNo(var Rec: Record "Sales Line")
    var
        SalesDiscountMgt: Codeunit "CTS Sales Discount Mgt";
    begin
        SalesDiscountMgt.ApplyLoyaltyDiscount(Rec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure AwardPointsOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        Customer: Record Customer;
        LoyaltyMgt: Codeunit "CTS Customer Loyalty Mgt";
    begin
        if not SalesHeader.Invoice then
            exit;
        if not (SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) then
            exit;
        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;

        LoyaltyMgt.AddPoints(Customer, 10);
    end;
}
