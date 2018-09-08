table 70201 Security
{
    Caption='Security';
    DrillDownPageID = 50121;
    LookupPageID = 50121;

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption='Code';
        }
        field(2;Name;Text[80])
        {
            Caption='Name';

            trigger OnValidate();
            begin
                IF (Name <> xRec.Name) AND ("Search Name" = '') THEN
                  "Search Name" := Name;
            end;
        }
        field(3;"Search Name";Text[80])
        {
            Caption='Search Name';
        }
        field(5;"ISIN Code";Text[30])
        {
            Caption='ISIN Code';
        }
        field(9;Status;Option)
        {
            Caption='Status';            
            OptionMembers = Active,Inactive,Ignore;
            OptionCaption = 'Active,Inactive,Ignore';
        }
        field(10;"Security Type";Option)
        {
            Caption='Security Type';
            OptionMembers = "Danish Stock","Forign Stock","Danish Bond","Forign Bond";
            OptionCaption='Danish Stock,Forign Stock,Danish Bond,Forign Bond';
        }
        field(11;Taxation;Option)
        {
            Caption='Taxation';            
            OptionMembers = "Actual capital gain","Notional gain";
            OptionCaption='Actual capital gain,Notional gain';
        }
        field(12;"Investment Firm";Code[20])
        {
            Caption='Investment Firm';
            TableRelation = "Investment Firm";
        }
        field(13;Risk;Integer)
        {
            Caption='Risk';
            MaxValue = 7;
            MinValue = 1;
        }
        field(14;"Morning Star Rating";Integer)
        {
            Caption='Morning Star Rating';
            MaxValue = 5;
            MinValue = 1;
        }
        field(15;"Account No.";Text[30])
        {
            Caption='Account No.';
            TableRelation = Account;
        }
        field(16;"Account Name";Text[30])
        {
            Caption='Account Name';
            CalcFormula = Lookup(Account.Name WHERE ("No."=FIELD("Account No.")));            
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"Bank Account No.";Text[30])
        {
            Caption='Bank Account No.';
            CalcFormula = Lookup(Account."Bank Account No." WHERE ("No."=FIELD("Account No.")));            
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"Investment Firm Name";Text[50])
        {
            Caption='Investment Firm Name';
            CalcFormula = Lookup("Investment Firm".Name WHERE ("No."=FIELD("Investment Firm")));            
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Investment Firm";
        }
        field(20;"Current Share Rate";Decimal)
        {
            Caption='Current Share Rate';
            Editable = false;
        }
        field(21;"No. of Shares";Integer)
        {
            Caption='No. of Shares';
            CalcFormula = Sum("Security Trade"."No. of Shares" WHERE ("Account No."=FIELD("Account No."),
                                                                      "Security No."=FIELD("No.")));            
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;"Current Share Amt.";Decimal)
        {
            Caption='Current Share Amt.';
            Editable = false;
        }
        field(23;"Current Profit/Loss";Decimal)
        {
            Caption='Current Profit/Loss';
            Editable = false;
        }
        field(30;"Total Purchase Amt.";Decimal)
        {
            Caption='Total Purchase Amt.';
            CalcFormula = Sum("Security Trade"."Trade Amount" WHERE ("Security No."=FIELD("No."),
                                                                     "Entry Type"=CONST(Purchase)));            
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"Total Sales Amt.";Decimal)
        {
            Caption='Total Sales Amt.';
            CalcFormula = Sum("Security Trade"."Trade Amount" WHERE ("Security No."=FIELD("No."),
                                                                     "Entry Type"=CONST(Sale)));            
            Editable = false;
            FieldClass = FlowField;
        }
        field(41;"Realised Profit/Loss";Decimal)
        {
            Caption='Realised Profit/Loss';
            Editable = false;
        }
        field(50;"Return Plan";Option)
        {
            Caption='Disbursement Plan';            
            OptionMembers = Annualy,"Half Yearly",Quarterly,Monthly,,,Accumulating;
            OptionCaption='Annualy,Half Yearly,Quarterly,Monthly,,,Accumulating';
        }
        field(51;"Last Return Date";Date)
        {
            Caption='Last Return Date';
            CalcFormula = Max("Security Return".Date WHERE ("Security No."=FIELD("No.")));            
            Editable = false;
            FieldClass = FlowField;
        }
        field(52;"Last Return Amt.";Decimal)
        {
            Caption='Last Return Amt.';
            Editable = false;
        }
        field(53;"Return Amt. YTD";Decimal)
        {
            Caption='Return Amount YTD';
            Editable = false;
        }
        field(54;"Return Amt. LY";Decimal)
        {
            Caption='Return Amount LY';
            Editable = false;
        }
        field(55;"Total Return Amt.";Decimal)
        {
            Caption='Total Return Amt.';
            CalcFormula = Sum("Security Return"."Gros Return Amount" WHERE ("Security No."=FIELD("No.")));            
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"Last ROI per 1000";Decimal)
        {
            Caption='Last ROI per 1000';
            Editable = false;
        }
        field(61;"ROI YTD per 1000";Decimal)
        {
            Caption='ROI YTD per 1000';
            Editable = false;
        }
        field(62;"ROI LY per 1000";Decimal)
        {
            Caption='ROI LY per 1000';
            Editable = false;
        }
        field(63;"Avgr. ROI per Y per 1000";Decimal)
        {
            Caption='Avgr. ROI per Y per 1000';
            Editable = false;
        }
        field(64;"Total ROI per 1000";Decimal)
        {
            Caption='Total ROI per 1000';
            Editable = false;
        }
        field(70;"Share Gain/Loss Latest";Decimal)
        {
            Caption='Share Gain/Loss Latest';
            Editable = false;
        }
        field(71;"Share Gain/Loss Overall";Decimal)
        {
            Caption='Share Gain/Loss Overall';
            Editable = false;
        }
        field(97;"No. Series";Code[10])
        {
            Caption='No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(100;"Date Filter";Date)
        {
            Caption='Date Filter';
            FieldClass = FlowFilter;
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
        key(Key3;Status)
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Name,"Investment Firm","Account No.")
        {}
    }

    trigger OnDelete();
    begin
        CALCFIELDS("No. of Shares");
        TESTFIELD("No. of Shares",0);
    end;

    trigger OnInsert();
    var
        InvSetup : Record "investment setup";
        NoSeriesMgt : Codeunit "NoSeriesManagement";
    begin
        IF "No." = '' THEN BEGIN
          InvSetup.GET;
          InvSetup.TESTFIELD("Security Nos.");
          NoSeriesMgt.InitSeries(InvSetup."Security Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;
    end;

    procedure BuySell();
    var
        SecurityJournalLine : Record "Security Journal Line";
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
        SecurityJournalLine : Record "Security Journal Line";
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
        SecurityJournalLine : Record "Security Journal Line";
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

    local procedure InitSecurityJnlLine(var SecurityJournalLine : Record "Security Journal Line";NextLineNo : Integer);
    begin
        CLEAR(SecurityJournalLine);
        SecurityJournalLine."Line No." := NextLineNo;
        SecurityJournalLine."Posting Date" := WORKDATE;
        SecurityJournalLine.VALIDATE("Security No.","No.");
        SecurityJournalLine."Investment Firm" := "Investment Firm";
        SecurityJournalLine."Account No." := "Account No.";
    end;
}

