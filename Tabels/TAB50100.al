table 50100 Account
{
    CaptionML = DAN='Depot',
                ENU='Account';
    DrillDownPageID = 50120;
    LookupPageID = 50120;

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
        field(8;"Bank Name";Text[50])
        {
            CaptionML = DAN='Banknavn',
                        ENU='Bank Name';
        }
        field(9;"Bank Branch No.";Text[20])
        {
            CaptionML = DAN='Bankregistreringsnr.',
                        ENU='Bank Branch No.';

            trigger OnValidate();
            begin
                IF ("Bank Branch No." <> '') AND (STRLEN("Bank Branch No.") < 4) THEN
                  "Bank Branch No." := PADSTR('',4 - STRLEN("Bank Branch No."),'0') + "Bank Branch No.";
            end;
        }
        field(10;"Bank Account No.";Text[30])
        {
            CaptionML = DAN='Bankkontonr.',
                        ENU='Bank Account No.';

            trigger OnValidate();
            begin
                IF ("Bank Account No." <> '') AND (STRLEN("Bank Account No.") < 10) THEN
                  "Bank Account No." := PADSTR('',10 - STRLEN("Bank Account No."),'0') + "Bank Account No.";
            end;
        }
        field(97;"No. Series";Code[10])
        {
            CaptionML = DAN='Nummerserie',
                        ENU='No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(110;"Current Account Value";Decimal)
        {
            CalcFormula = Sum(Security."Current Share Amt." WHERE (Account No.=FIELD(No.),
                                                                   Status=CONST(Active)));
            CaptionML = DAN='Depot værdi',
                        ENU='Current Account Value';
            Editable = false;
            FieldClass = FlowField;
            NotBlank = false;
        }
        field(111;"Current Profit/Loss";Decimal)
        {
            CalcFormula = Sum(Security."Current Profit/Loss" WHERE (Status=CONST(Active)));
            CaptionML = DAN='Gevinst/Tab',
                        ENU='Current Profit/Loss';
            Editable = false;
            FieldClass = FlowField;
        }
        field(200;"Security Return LY";Decimal)
        {
            CalcFormula = Sum(Security."Return Amt. LY");
            CaptionML = DAN='Udbytte sidate år',
                        ENU='Security Return LY';
            Editable = false;
            FieldClass = FlowField;
        }
        field(201;"Security Return YTD";Decimal)
        {
            CalcFormula = Sum(Security."Return Amt. YTD");
            CaptionML = DAN='Udbytte ÅTD',
                        ENU='Security Return YTD';
            Editable = false;
            FieldClass = FlowField;
        }
        field(300;"Date Filter";Date)
        {
            CaptionML = DAN='Datofilter',
                        ENU='Date Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    var
        InvSetup : Record "50000";
        NoSeriesMgt : Codeunit "396";
    begin
        IF "No." = '' THEN BEGIN
          InvSetup.GET;
          InvSetup.TESTFIELD("Account Nos.");
          NoSeriesMgt.InitSeries(InvSetup."Account Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;
    end;
}

