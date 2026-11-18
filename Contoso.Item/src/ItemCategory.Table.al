table 50200 "CTS Item Category"
{
    Caption = 'Contoso Item Category';
    DataClassification = CustomerContent;
    LookupPageId = "CTS Item Categories";
    DrillDownPageId = "CTS Item Categories";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(20; "Extra Discount %"; Decimal)
        {
            Caption = 'Extra Discount %';
            MinValue = 0;
            MaxValue = 100;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}
