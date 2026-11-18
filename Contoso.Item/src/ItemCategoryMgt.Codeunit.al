codeunit 50200 "CTS Item Category Mgt"
{
    procedure GetExtraDiscountPct(ItemNo: Code[20]): Decimal
    var
        Item: Record Item;
        ItemCategory: Record "CTS Item Category";
    begin
        if not Item.Get(ItemNo) then
            exit(0);
        if Item."CTS Category Code" = '' then
            exit(0);
        if not ItemCategory.Get(Item."CTS Category Code") then
            exit(0);
        exit(ItemCategory."Extra Discount %");
    end;
}
