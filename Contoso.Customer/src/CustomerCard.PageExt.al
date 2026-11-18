pageextension 50150 "CTS Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("CTS Region"; Rec."CTS Region")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Contoso sales region.';
            }
            field("CTS Loyalty Tier"; Rec."CTS Loyalty Tier")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the loyalty tier, calculated from points.';
            }
            field("CTS Loyalty Points"; Rec."CTS Loyalty Points")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the loyalty points earned.';
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action(CTSRecalcTier)
            {
                ApplicationArea = All;
                Caption = 'Recalculate Loyalty Tier';
                Image = Recalculate;
                ToolTip = 'Recalculates the loyalty tier from the current points.';

                trigger OnAction()
                var
                    LoyaltyMgt: Codeunit "CTS Customer Loyalty Mgt";
                begin
                    LoyaltyMgt.AddPoints(Rec, 0);
                end;
            }
        }
    }
}
