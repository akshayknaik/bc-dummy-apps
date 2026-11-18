query 50300 "CTS Sales by Loyalty Tier"
{
    Caption = 'Contoso Sales by Loyalty Tier';
    QueryType = Normal;

    elements
    {
        dataitem(SalesHeader; "Sales Header")
        {
            column(LoyaltyTier; "CTS Loyalty Tier") { }
            column(DocumentType; "Document Type") { }

            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Document Type" = SalesHeader."Document Type", "Document No." = SalesHeader."No.";
                SqlJoinType = InnerJoin;

                column(Amount; Amount) { Method = Sum; }
                column(LineCount) { Method = Count; }
            }
        }
    }
}
