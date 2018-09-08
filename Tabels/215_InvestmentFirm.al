table 70215 "Investment Firm"
{
    Caption='Investment Firm';
    DrillDownPageID = 50110;
    LookupPageID = 50110;

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption='No.';
        }
        field(2;Name;Text[50])
        {
            Caption='Name';
        }
        field(97;"No. Series";Code[10])
        {
            Caption='No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1;"No.")
        {}
        key(Key2;Name)
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Name)
        {}
    }

    trigger OnInsert();
    var
        InvSetup : Record "Investment Setup";
        NoSeriesMgt : Codeunit NoSeriesManagement;
    begin
        IF "No." = '' THEN BEGIN
          InvSetup.GET;
          InvSetup.TESTFIELD("Invest. Firm Nos.");
          NoSeriesMgt.InitSeries(InvSetup."Invest. Firm Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;
    end;
}

