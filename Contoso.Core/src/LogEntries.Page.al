page 50101 "CTS Log Entries"
{
    Caption = 'Contoso Log Entries';
    PageType = List;
    SourceTable = "CTS Log Entry";
    UsageCategory = History;
    ApplicationArea = All;
    Editable = false;
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.") { ToolTip = 'Specifies the entry number.'; }
                field(Source; Rec.Source) { ToolTip = 'Specifies the app or area that wrote the entry.'; }
                field(Message; Rec.Message) { ToolTip = 'Specifies the log message.'; }
                field("Created At"; Rec."Created At") { ToolTip = 'Specifies when the entry was created.'; }
            }
        }
    }
}
