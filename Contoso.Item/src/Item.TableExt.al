tableextension 50200 "CTS Item" extends Item
{
    fields
    {
        field(50200; "CTS Category Code"; Code[20])
        {
            Caption = 'Contoso Category';
            DataClassification = CustomerContent;
            TableRelation = "CTS Item Category";
        }
    }
}
