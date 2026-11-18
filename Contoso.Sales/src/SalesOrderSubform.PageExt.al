pageextension 50251 "CTS Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter("Line Discount %")
        {
            field("CTS Loyalty Discount %"; Rec."CTS Loyalty Discount %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the loyalty + category discount applied to this line.';
            }
        }
    }
}
