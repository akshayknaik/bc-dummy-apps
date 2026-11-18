table 50100 "CTS Core Setup"
{
    Caption = 'Contoso Core Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Enable Logging"; Boolean)
        {
            Caption = 'Enable Logging';
        }
        field(20; "Default Region"; Enum "CTS Region")
        {
            Caption = 'Default Region';
        }
        field(30; "Bronze Discount %"; Decimal)
        {
            Caption = 'Bronze Discount %';
            MinValue = 0;
            MaxValue = 100;
        }
        field(31; "Silver Discount %"; Decimal)
        {
            Caption = 'Silver Discount %';
            MinValue = 0;
            MaxValue = 100;
        }
        field(32; "Gold Discount %"; Decimal)
        {
            Caption = 'Gold Discount %';
            MinValue = 0;
            MaxValue = 100;
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    procedure InsertIfNotExists()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;
}
