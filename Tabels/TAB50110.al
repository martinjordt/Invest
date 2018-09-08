table 50110 "Investment Firm"
{
    CaptionML = DAN='Investeringsselskab',
                ENU='Investment Firm';
    DrillDownPageID = 50110;
    LookupPageID = 50110;

    fields
    {
        field(1;"No.";Code[20])
        {
            CaptionML = DAN='Nr.',
                        ENU='No.';
        }
        field(2;Name;Text[50])
        {
            CaptionML = DAN='Navn',
                        ENU='Name';
        }
        field(97;"No. Series";Code[10])
        {
            CaptionML = DAN='Nummerserie',
                        ENU='No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
        key(Key2;Name)
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Name)
        {
        }
    }

    trigger OnInsert();
    var
        InvSetup : Record "50000";
        NoSeriesMgt : Codeunit "396";
    begin
        IF "No." = '' THEN BEGIN
          InvSetup.GET;
          InvSetup.TESTFIELD("Invest. Firm Nos.");
          NoSeriesMgt.InitSeries(InvSetup."Invest. Firm Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;
    end;
}

