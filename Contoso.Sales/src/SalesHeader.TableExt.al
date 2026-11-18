tableextension 50250 "CTS Sales Header" extends "Sales Header"
{
    fields
    {
        field(50250; "CTS Loyalty Tier"; Enum "CTS Loyalty Tier")
        {
            Caption = 'Loyalty Tier';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
