tableextension 50251 "CTS Sales Line" extends "Sales Line"
{
    fields
    {
        field(50250; "CTS Loyalty Discount %"; Decimal)
        {
            Caption = 'Loyalty Discount %';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
