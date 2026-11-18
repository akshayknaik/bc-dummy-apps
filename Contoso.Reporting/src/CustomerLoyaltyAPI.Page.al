page 50300 "CTS Customer Loyalty API"
{
    PageType = API;
    Caption = 'customerLoyalty';
    APIPublisher = 'contoso';
    APIGroup = 'loyalty';
    APIVersion = 'v1.0';
    EntityName = 'customerLoyalty';
    EntitySetName = 'customerLoyalties';
    SourceTable = Customer;
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(id; Rec.SystemId) { Caption = 'Id'; }
                field(number; Rec."No.") { Caption = 'No.'; }
                field(displayName; Rec.Name) { Caption = 'Display Name'; }
                field(region; Rec."CTS Region") { Caption = 'Region'; }
                field(loyaltyTier; Rec."CTS Loyalty Tier") { Caption = 'Loyalty Tier'; }
                field(loyaltyPoints; Rec."CTS Loyalty Points") { Caption = 'Loyalty Points'; }
            }
        }
    }
}
