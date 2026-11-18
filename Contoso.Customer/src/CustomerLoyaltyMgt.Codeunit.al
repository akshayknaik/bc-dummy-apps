codeunit 50150 "CTS Customer Loyalty Mgt"
{
    var
        PointsLbl: Label 'Customer %1 earned %2 points (tier: %3).', Comment = '%1 = Customer No., %2 = Points, %3 = Tier';

    procedure AddPoints(var Customer: Record Customer; Points: Integer)
    var
        CoreMgt: Codeunit "CTS Core Mgt";
    begin
        Customer."CTS Loyalty Points" += Points;
        Customer."CTS Loyalty Tier" := CalcTier(Customer."CTS Loyalty Points");
        Customer.Modify(true);

        CoreMgt.Log('Contoso Customer', CopyStr(StrSubstNo(PointsLbl, Customer."No.", Points, Customer."CTS Loyalty Tier"), 1, 250));
    end;

    procedure CalcTier(Points: Integer): Enum "CTS Loyalty Tier"
    begin
        case true of
            Points >= 1000:
                exit("CTS Loyalty Tier"::Gold);
            Points >= 500:
                exit("CTS Loyalty Tier"::Silver);
            Points >= 100:
                exit("CTS Loyalty Tier"::Bronze);
        end;
        exit("CTS Loyalty Tier"::None);
    end;
}
