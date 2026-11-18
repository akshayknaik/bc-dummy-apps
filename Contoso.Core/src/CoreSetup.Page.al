page 50100 "CTS Core Setup"
{
    Caption = 'Contoso Core Setup';
    PageType = Card;
    SourceTable = "CTS Core Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Enable Logging"; Rec."Enable Logging") { ToolTip = 'Specifies whether Contoso apps write log entries.'; }
                field("Default Region"; Rec."Default Region") { ToolTip = 'Specifies the default region for new customers.'; }
            }
            group(Discounts)
            {
                Caption = 'Loyalty Discounts';
                field("Bronze Discount %"; Rec."Bronze Discount %") { ToolTip = 'Specifies the discount for Bronze customers.'; }
                field("Silver Discount %"; Rec."Silver Discount %") { ToolTip = 'Specifies the discount for Silver customers.'; }
                field("Gold Discount %"; Rec."Gold Discount %") { ToolTip = 'Specifies the discount for Gold customers.'; }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(LogEntries)
            {
                Caption = 'Log Entries';
                Image = Log;
                RunObject = page "CTS Log Entries";
                ToolTip = 'Open the Contoso log.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}
