table 50101 "CTS Log Entry"
{
    Caption = 'Contoso Log Entry';
    DataClassification = SystemMetadata;
    LookupPageId = "CTS Log Entries";
    DrillDownPageId = "CTS Log Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; Source; Text[100])
        {
            Caption = 'Source';
        }
        field(20; Message; Text[250])
        {
            Caption = 'Message';
        }
        field(30; "Created At"; DateTime)
        {
            Caption = 'Created At';
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
