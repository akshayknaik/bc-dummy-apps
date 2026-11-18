pageextension 50250 "CTS Sales Order" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("CTS Loyalty Tier"; Rec."CTS Loyalty Tier")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer loyalty tier copied when the customer was selected.';
            }
        }
    }
}
