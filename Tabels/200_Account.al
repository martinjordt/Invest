table 70200 Account
{
    Caption='Account';
    DrillDownPageID = 50120;
    LookupPageID = 50120;

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
        field(8;"Bank Name";Text[50])
        {
            Caption='Bank Name';
        }
        field(9;"Bank Branch No.";Text[20])
        {
            Caption='Bank Branch No.';

            trigger OnValidate();
            begin
                IF ("Bank Branch No." <> '') AND (STRLEN("Bank Branch No.") < 4) THEN
                  "Bank Branch No." := PADSTR('',4 - STRLEN("Bank Branch No."),'0') + "Bank Branch No.";
            end;
        }
        field(10;"Bank Account No.";Text[30])
        {
            Caption='Bank Account No.';

            trigger OnValidate();
            begin
                IF ("Bank Account No." <> '') AND (STRLEN("Bank Account No.") < 10) THEN
                  "Bank Account No." := PADSTR('',10 - STRLEN("Bank Account No."),'0') + "Bank Account No.";
            end;
        }
        field(97;"No. Series";Code[10])
        {
            Caption='No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(110;"Current Account Value";Decimal)
        {
            Caption='Current Account Value';
            CalcFormula = Sum(Security."Current Share Amt." WHERE ("Account No."=FIELD("No."),
                                                                   Status=CONST(Active)));            
            Editable = false;
            FieldClass = FlowField;
            NotBlank = false;
        }
        field(111;"Current Profit/Loss";Decimal)
        {
            Caption='Current Profit/Loss';
            CalcFormula = Sum(Security."Current Profit/Loss" WHERE (Status=CONST(Active)));            
            Editable = false;
            FieldClass = FlowField;
        }
        field(200;"Security Return LY";Decimal)
        {
            Caption='Security Return LY';
            CalcFormula = Sum(Security."Return Amt. LY");            
            Editable = false;
            FieldClass = FlowField;
        }
        field(201;"Security Return YTD";Decimal)
        {
            Caption='Security Return YTD';
            CalcFormula = Sum(Security."Return Amt. YTD");            
            Editable = false;
            FieldClass = FlowField;
        }
        field(300;"Date Filter";Date)
        {
            Caption='Date Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1;"No.")
        {}
    }

    trigger OnInsert();
    var
        InvSetup : Record "Investment Setup";
        NoSeriesMgt : Codeunit "NoSeriesManagement";
    begin
        IF "No." = '' THEN BEGIN
          InvSetup.GET;
          InvSetup.TESTFIELD("Account Nos.");
          NoSeriesMgt.InitSeries(InvSetup."Account Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;
    end;
}