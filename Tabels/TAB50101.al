table 50101 Security
{
    CaptionML = DAN='Værdipapir',
                ENU='Security';
    DrillDownPageID = 50121;
    LookupPageID = 50121;

    fields
    {
        field(1;"No.";Code[20])
        {
            CaptionML = DAN='Kode',
                        ENU='Code';
        }
        field(2;Name;Text[80])
        {
            CaptionML = DAN='Navn',
                        ENU='Name';

            trigger OnValidate();
            begin
                IF (Name <> xRec.Name) AND ("Search Name" = '') THEN
                  "Search Name" := Name;
            end;
        }
        field(3;"Search Name";Text[80])
        {
            CaptionML = DAN='Søgenavn',
                        ENU='Search Name';
        }
        field(5;"ISIN Code";Text[30])
        {
            CaptionML = DAN='ISIN kode',
                        ENU='ISIN Code';
        }
        field(9;Status;Option)
        {
            CaptionML = DAN='Status',
                        ENU='Status';
            OptionCaptionML = DAN='Aktiv,Inaktiv,Ignorer',
                              ENU='Active,Inactive,Ignore';
            OptionMembers = Active,Inactive,Ignore;
        }
        field(10;"Security Type";Option)
        {
            CaptionML = DAN='Værdipapirtype',
                        ENU='Security Type';
            OptionCaptionML = DAN='Danske aktier,Globale aktier,Danske obligationer,Globale obligationer',
                              ENU='Danish Stock,Forign Stock,Danish Bond,Forign Bond';
            OptionMembers = "Danish Stock","Forign Stock","Danish Bond","Forign Bond";
        }
        field(11;Taxation;Option)
        {
            CaptionML = DAN='Beskatning',
                        ENU='Taxation';
            OptionCaptionML = DAN='Realisation,Lager',
                              ENU='Actual capital gain,Notional gain';
            OptionMembers = "Actual capital gain","Notional gain";
        }
        field(12;"Investment Firm";Code[20])
        {
            CaptionML = DAN='Investeringsselskab',
                        ENU='Investment Firm';
            TableRelation = "Investment Firm";
        }
        field(13;Risk;Integer)
        {
            CaptionML = DAN='Risiko',
                        ENU='Risk';
            MaxValue = 7;
            MinValue = 1;
        }
        field(14;"Morning Star Rating";Integer)
        {
            CaptionML = DAN='Morning Star Rating',
                        ENU='Morning Star Rating';
            MaxValue = 5;
            MinValue = 1;
        }
        field(15;"Account No.";Text[30])
        {
            CaptionML = DAN='Depotnr.',
                        ENU='Account No.';
            TableRelation = Account;
        }
        field(16;"Account Name";Text[30])
        {
            CalcFormula = Lookup(Account.Name WHERE (No.=FIELD(Account No.)));
            CaptionML = DAN='Depotnavn',
                        ENU='Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"Bank Account No.";Text[30])
        {
            CalcFormula = Lookup(Account."Bank Account No." WHERE (No.=FIELD(Account No.)));
            CaptionML = DAN='Bankkontonr.',
                        ENU='Bank Account No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"Investment Firm Name";Text[50])
        {
            CalcFormula = Lookup("Investment Firm".Name WHERE (No.=FIELD(Investment Firm)));
            CaptionML = DAN='Invest.selsk.navn',
                        ENU='Investment Firm Name';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Investment Firm";
        }
        field(20;"Current Share Rate";Decimal)
        {
            CaptionML = DAN='Aktuel kurs',
                        ENU='Current Share Rate';
            Editable = false;
        }
        field(21;"No. of Shares";Integer)
        {
            CalcFormula = Sum("Security Trade"."No. of Shares" WHERE (Account No.=FIELD(Account No.),
                                                                      Security No.=FIELD(No.)));
            CaptionML = DAN='Antal',
                        ENU='No. of Shares';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;"Current Share Amt.";Decimal)
        {
            CaptionML = DAN='Aktuel værdi',
                        ENU='Current Share Amt.';
            Editable = false;
        }
        field(23;"Current Profit/Loss";Decimal)
        {
            CaptionML = DAN='Aktuel gevinst/tab',
                        ENU='Current Profit/Loss';
            Editable = false;
        }
        field(30;"Total Purchase Amt.";Decimal)
        {
            CalcFormula = Sum("Security Trade"."Trade Amount" WHERE (Security No.=FIELD(No.),
                                                                     Entry Type=CONST(Purchase)));
            CaptionML = DAN='Købsbeløb',
                        ENU='Total Purchase Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"Total Sales Amt.";Decimal)
        {
            CalcFormula = Sum("Security Trade"."Trade Amount" WHERE (Security No.=FIELD(No.),
                                                                     Entry Type=CONST(Sale)));
            CaptionML = DAN='Salgsbeløb',
                        ENU='Total Sales Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(41;"Realised Profit/Loss";Decimal)
        {
            CaptionML = DAN='Realiseret gevinst/tab',
                        ENU='Realised Profit/Loss';
            Editable = false;
        }
        field(50;"Return Plan";Option)
        {
            CaptionML = DAN='Afkastsplan',
                        ENU='Disbursement Plan';
            OptionCaptionML = DAN='Årlig,Halvårlig,Kvartal,Måned,,,Akkumulerende',
                              ENU='Annualy,Half Yearly,Quarterly,Monthly,,,Accumulating';
            OptionMembers = Annualy,"Half Yearly",Quarterly,Monthly,,,Accumulating;
        }
        field(51;"Last Return Date";Date)
        {
            CalcFormula = Max("Security Return".Date WHERE (Security No.=FIELD(No.)));
            CaptionML = DAN='Sidste udbyttedato',
                        ENU='Last Return Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52;"Last Return Amt.";Decimal)
        {
            CaptionML = DAN='Sidste udbytte',
                        ENU='Last Return Amt.';
            Editable = false;
        }
        field(53;"Return Amt. YTD";Decimal)
        {
            CaptionML = DAN='Udbytte ÅTD',
                        ENU='Return Amount YTD';
            Editable = false;
        }
        field(54;"Return Amt. LY";Decimal)
        {
            CaptionML = DAN='Udbytte sidste år',
                        ENU='Return Amount LY';
            Editable = false;
        }
        field(55;"Total Return Amt.";Decimal)
        {
            CalcFormula = Sum("Security Return"."Gros Return Amount" WHERE (Security No.=FIELD(No.)));
            CaptionML = DAN='Udbytte i alt',
                        ENU='Total Return Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"Last ROI per 1000";Decimal)
        {
            CaptionML = DAN='Sidste ROI per 1000',
                        ENU='Last ROI per 1000';
            Editable = false;
        }
        field(61;"ROI YTD per 1000";Decimal)
        {
            CaptionML = DAN='ROI ÅTD per 1000',
                        ENU='ROI YTD per 1000';
            Editable = false;
        }
        field(62;"ROI LY per 1000";Decimal)
        {
            CaptionML = DAN='ROI sidste år per 1000',
                        ENU='ROI LY per 1000';
            Editable = false;
        }
        field(63;"Avgr. ROI per Y per 1000";Decimal)
        {
            CaptionML = DAN='Gns. ROI per år per 1000',
                        ENU='Avgr. ROI per Y per 1000';
            Editable = false;
        }
        field(64;"Total ROI per 1000";Decimal)
        {
            CaptionML = DAN='Total ROI per 1000',
                        ENU='Total ROI per 1000';
            Editable = false;
        }
        field(70;"Share Gain/Loss Latest";Decimal)
        {
            CaptionML = DAN='Kurs gevinst seneste/tab',
                        ENU='Share Gain/Loss Latest';
            Editable = false;
        }
        field(71;"Share Gain/Loss Overall";Decimal)
        {
            CaptionML = DAN='Kurs gevinst/tab i alt',
                        ENU='Share Gain/Loss Overall';
            Editable = false;
        }
        field(97;"No. Series";Code[10])
        {
            CaptionML = DAN='Nummerserie',
                        ENU='No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(100;"Date Filter";Date)
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
        key(Key2;Name)
        {
            MaintainSQLIndex = false;
        }
        key(Key3;Status)
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Name,"Investment Firm","Account No.")
        {
        }
    }

    trigger OnDelete();
    begin
        CALCFIELDS("No. of Shares");
        TESTFIELD("No. of Shares",0);
    end;

    trigger OnInsert();
    var
        InvSetup : Record "50000";
        NoSeriesMgt : Codeunit "396";
    begin
        IF "No." = '' THEN BEGIN
          InvSetup.GET;
          InvSetup.TESTFIELD("Security Nos.");
          NoSeriesMgt.InitSeries(InvSetup."Security Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;
    end;

    procedure BuySell();
    var
        SecurityJournalLine : Record "50108";
        NextLineNo : Integer;
    begin
        NextLineNo := 10000;
        SecurityJournalLine.RESET;
        SecurityJournalLine.SETRANGE("Entry Type",SecurityJournalLine."Entry Type"::"Security Trade");
        SecurityJournalLine.SETRANGE("Security No.","No.");
        IF SecurityJournalLine.ISEMPTY THEN BEGIN
          SecurityJournalLine.SETRANGE("Security No.");
          IF SecurityJournalLine.FINDLAST THEN
            NextLineNo := SecurityJournalLine."Line No." + 10000;

          InitSecurityJnlLine(SecurityJournalLine,NextLineNo);
          SecurityJournalLine."Entry Type" := SecurityJournalLine."Entry Type"::"Security Trade";
          SecurityJournalLine.INSERT;
          COMMIT;
        END;

        PAGE.RUNMODAL(PAGE::"Security Journal Trade");
    end;

    procedure RegisterReturn();
    var
        SecurityJournalLine : Record "50108";
        NextLineNo : Integer;
    begin
        NextLineNo := 10000;
        SecurityJournalLine.RESET;
        SecurityJournalLine.SETRANGE("Entry Type",SecurityJournalLine."Entry Type"::"Security Return");
        SecurityJournalLine.SETRANGE("Security No.","No.");
        IF SecurityJournalLine.ISEMPTY THEN BEGIN
          SecurityJournalLine.SETRANGE("Security No.");
          IF SecurityJournalLine.FINDLAST THEN
            NextLineNo := SecurityJournalLine."Line No." + 10000;

          InitSecurityJnlLine(SecurityJournalLine,NextLineNo);
          SecurityJournalLine."Entry Type" := SecurityJournalLine."Entry Type"::"Security Return";
          SecurityJournalLine.INSERT;
          COMMIT;
        END;

        PAGE.RUNMODAL(PAGE::"Security Journal Return");
    end;

    procedure UpdateRate();
    var
        SecurityJournalLine : Record "50108";
        NextLineNo : Integer;
    begin
        NextLineNo := 10000;
        SecurityJournalLine.RESET;
        SecurityJournalLine.SETRANGE("Entry Type",SecurityJournalLine."Entry Type"::"Security Rate");
        SecurityJournalLine.SETRANGE("Security No.","No.");
        IF SecurityJournalLine.ISEMPTY THEN BEGIN
          SecurityJournalLine.SETRANGE("Security No.");
          IF SecurityJournalLine.FINDLAST THEN
            NextLineNo := SecurityJournalLine."Line No." + 10000;

          InitSecurityJnlLine(SecurityJournalLine,NextLineNo);
          SecurityJournalLine."Entry Type" := SecurityJournalLine."Entry Type"::"Security Rate";
          SecurityJournalLine.INSERT;
          COMMIT;
        END;

        PAGE.RUNMODAL(PAGE::"Security Journal Rate");
    end;

    local procedure InitSecurityJnlLine(var SecurityJournalLine : Record "50108";NextLineNo : Integer);
    begin
        CLEAR(SecurityJournalLine);
        SecurityJournalLine."Line No." := NextLineNo;
        SecurityJournalLine."Posting Date" := WORKDATE;
        SecurityJournalLine.VALIDATE("Security No.","No.");
        SecurityJournalLine."Investment Firm" := "Investment Firm";
        SecurityJournalLine."Account No." := "Account No.";
    end;
}

