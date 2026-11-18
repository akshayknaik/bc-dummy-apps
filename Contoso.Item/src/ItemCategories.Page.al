page 50200 "CTS Item Categories"
{
    Caption = 'Contoso Item Categories';
    PageType = List;
    SourceTable = "CTS Item Category";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Code; Rec.Code) { ToolTip = 'Specifies the category code.'; }
                field(Description; Rec.Description) { ToolTip = 'Specifies the category description.'; }
                field("Extra Discount %"; Rec."Extra Discount %") { ToolTip = 'Specifies the extra discount added on top of the loyalty discount.'; }
            }
        }
    }
}
