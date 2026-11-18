tableextension 50150 "CTS Customer" extends Customer
{
    fields
    {
        field(50150; "CTS Region"; Enum "CTS Region")
        {
            Caption = 'Region';
            DataClassification = CustomerContent;
        }
        field(50151; "CTS Loyalty Tier"; Enum "CTS Loyalty Tier")
        {
            Caption = 'Loyalty Tier';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50152; "CTS Loyalty Points"; Integer)
        {
            Caption = 'Loyalty Points';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
