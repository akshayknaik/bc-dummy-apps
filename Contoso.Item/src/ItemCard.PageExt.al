pageextension 50200 "CTS Item Card" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("CTS Category Code"; Rec."CTS Category Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Contoso item category.';
            }
        }
    }
}
