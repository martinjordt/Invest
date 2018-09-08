table 50108 "Security Journal Line"
{
    CaptionML = DAN='Værdipapirkladdelinje',
                ENU='Security Journal Line';

    fields
    {
        field(1;"Journal Template Name";Code[10])
        {
            CaptionML = DAN='Kladdetypenavn',
                        ENU='Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(2;"Line No.";Integer)
        {
            CaptionML = DAN='Linjenr.',
                        ENU='Line No.';
        }
        field(3;"Posting Date";Date)
        {
            CaptionML = DAN='Bogføringsdato',
                        ENU='Posting Date';
        }
        field(5;"Entry Type";Option)
        {
            CaptionML = DAN='Posttype',
                        ENU='Entry Type';
            OptionCaptionML = DAN='Værdipapirhandel,Værdipapirudbytte,Værdipapirkurs',
                              ENU='Security Trade,Security Return,Security Rate';
            OptionMembers = "Security Trade","Security Return","Security Rate";
        }
        field(7;"Security No.";Code[20])
        {
            CaptionML = DAN='Værdipapir',
                        ENU='Security No.';
            TableRelation = Security WHERE (Status=FILTER(Active|Inactive));

            trigger OnValidate();
            var
                Security : Record "50101";
            begin
                IF "Security No." <> xRec."Security No." THEN BEGIN
                  "Security Name" := '';
                  "ISIN Code" := '';
                  IF "Security No." <> '' THEN BEGIN
                    Security.GET("Security No.");
                    "Security Name" := Security.Name;
                    "ISIN Code" := Security."ISIN Code";
                    "Security Type" := Security."Security Type";
                    "Investment Firm" := Security."Investment Firm";
                    Taxation:=  Security.Taxation;
                    "Disbursement Plan" := Security."Return Plan";
                    Risk := Security.Risk;
                    "Morning Star Rating" := Security."Morning Star Rating";
                    CASE "Entry Type" OF
                      "Entry Type"::"Security Return":
                        BEGIN
                          Security.CALCFIELDS("No. of Shares");
                          "No. of Shares" := Security."No. of Shares";
                        END;
                      "Entry Type"::"Security Trade":
                        BEGIN
                          IF "Trade Type" = "Trade Type"::Sale THEN BEGIN
                            Security.CALCFIELDS("No. of Shares");
                            "No. of Shares" := Security."No. of Shares";
                          END;
                        END;
                    END;
                  END;
                END;
            end;
        }
        field(8;"Security Name";Text[80])
        {
            CaptionML = DAN='Værdipapirnavn',
                        ENU='Security Name';
        }
        field(9;"ISIN Code";Code[20])
        {
            CaptionML = DAN='ISIN kode',
                        ENU='ISIN Code';

            trigger OnValidate();
            var
                Security : Record "50101";
            begin
                IF "ISIN Code" <> xRec."ISIN Code" THEN
                  IF "ISIN Code" <> '' THEN BEGIN
                    Security.RESET;
                    Security.SETRANGE("ISIN Code","ISIN Code");
                    IF Security.FINDFIRST THEN BEGIN
                      "Security No." := Security."No.";
                      "Security Name" := Security.Name;
                      "Security Type" := Security."Security Type";
                      Taxation := Security.Taxation;
                      "Investment Firm" := Security."Investment Firm";
                    END;
                  END;
            end;
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
        field(13;"Investment Firm Name";Text[50])
        {
            CalcFormula = Lookup("Investment Firm".Name WHERE (No.=FIELD(Investment Firm)));
            CaptionML = DAN='Invest.selsk.navn',
                        ENU='Investment Firm Name';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Investment Firm";
        }
        field(15;"Account No.";Text[30])
        {
            CaptionML = DAN='Depotnr.',
                        ENU='Account No.';
            TableRelation = Account;
        }
        field(16;"Account Name";Text[50])
        {
            CalcFormula = Lookup(Account.Name WHERE (No.=FIELD(Account No.)));
            CaptionML = DAN='Depotnavn',
                        ENU='Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"Trade Type";Option)
        {
            CaptionML = DAN='Handelstype',
                        ENU='Trade Type';
            OptionCaptionML = DAN='Køb,Salg',
                              ENU='Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(20;"Share Price";Decimal)
        {
            CaptionML = DAN='Aktuel kurs',
                        ENU='Current Share Price';

            trigger OnValidate();
            begin
                CalcTradeAmount;
                CalcGainLoss;
            end;
        }
        field(21;"No. of Shares";Integer)
        {
            CaptionML = DAN='Antal',
                        ENU='No. of Shares';

            trigger OnValidate();
            var
                Security : Record "50101";
            begin
                IF ("Entry Type" = "Entry Type"::"Security Trade") AND
                  ("Trade Type" = "Trade Type"::Sale)
                THEN BEGIN
                  Security.GET("Security No.");
                  Security.CALCFIELDS("No. of Shares");
                  IF "No. of Shares" > Security."No. of Shares" THEN
                    ERROR(STRSUBSTNO(Text002,Security."No. of Shares",Security.FIELDCAPTION("No. of Shares")));
                END;

                CalcTradeAmount;
            end;
        }
        field(23;"Trade Amount";Decimal)
        {
            CaptionML = DAN='Handelsbeløb',
                        ENU='Trade Amount';

            trigger OnValidate();
            begin
                IF "No. of Shares" <> 0 THEN
                  "Share Price" := "Trade Amount" / "No. of Shares"
                ELSE
                  "Share Price" := 0;
            end;
        }
        field(24;"Gros Return Amount";Decimal)
        {
            CaptionML = DAN='Brutto udbyttebeløb',
                        ENU='Gros Return Amount';

            trigger OnValidate();
            begin
                "Net Return Amount" := "Gros Return Amount";
            end;
        }
        field(25;"Net Return Amount";Decimal)
        {
            CaptionML = DAN='Netto udbyttebeløb',
                        ENU='Net Return Amount';
        }
        field(27;"Share Gain/Loss";Decimal)
        {
            CaptionML = DAN='Kurs gevinst/tab',
                        ENU='Share Gain/Loss';
            Editable = false;
        }
        field(29;"Bank Branch No.";Text[20])
        {
            CalcFormula = Lookup(Account."Bank Branch No." WHERE (No.=FIELD(Account No.)));
            CaptionML = DAN='Bankregistreringsnr.',
                        ENU='Bank Branch No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30;"Bank Account No.";Text[30])
        {
            CalcFormula = Lookup(Account."Bank Account No." WHERE (No.=FIELD(Account No.)));
            CaptionML = DAN='Bankkontonr.',
                        ENU='Bank Account No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50;"Disbursement Plan";Option)
        {
            CaptionML = DAN='Afkastsplan',
                        ENU='Disbursement Plan';
            OptionCaptionML = DAN='Årlig,Halvårlig,Kvartal,Måned,,,Akkumulerende',
                              ENU='Annualy,Half Yearly,Quarterly,Monthly,,,Accumulating';
            OptionMembers = Annualy,"Half Yearly",Quarterly,Monthly,,,Accumulating;
        }
        field(51;Risk;Integer)
        {
            CaptionML = DAN='Risiko',
                        ENU='Risk';
            MaxValue = 6;
            MinValue = 1;
        }
        field(52;"Morning Star Rating";Integer)
        {
            CaptionML = DAN='Morning Star Rating',
                        ENU='Morning Star Rating';
            MaxValue = 6;
            MinValue = 1;
        }
        field(100;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            CaptionML = DAN='Genvejsdimension 1-kode',
                        ENU='Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(101;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            CaptionML = DAN='Genvejsdimension 2-kode',
                        ENU='Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(200;Attachment;BLOB)
        {
            CaptionML = DAN='Vedhæftning',
                        ENU='Attachment';
        }
        field(201;"File Name";Text[250])
        {
        }
        field(480;"Dimension Set ID";Integer)
        {
            CaptionML = DAN='Dimensionsgruppe-id',
                        ENU='Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDimensions;
            end;
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Entry Type","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SecJnlLine : Record "50108";
        DimMgt : Codeunit "408";
        Text001 : TextConst DAN='Anvend en linje med en vedhæftet fil',ENU='Please use a line with an Attachment';
        Text002 : TextConst DAN='Du kan max. sælge %1 %2',ENU='You can only sell %1 %2';

    procedure SetUpNewLine(LastSecJnlLine : Record "50108";EntryType : Integer);
    begin
        SETRANGE("Entry Type",EntryType);
        "Entry Type" := EntryType;
        IF SecJnlLine.FINDFIRST THEN BEGIN
          "Posting Date" := LastSecJnlLine."Posting Date";
          "Account No." := LastSecJnlLine."Account No.";
        END ELSE BEGIN
          "Posting Date" := WORKDATE;
        END;
    end;

    procedure InitNewLine(PostingDate : Date;ShortcutDim1Code : Code[20];ShortcutDim2Code : Code[20];DimSetID : Integer);
    begin
        INIT;
        "Posting Date" := PostingDate;
        "Shortcut Dimension 1 Code" := ShortcutDim1Code;
        "Shortcut Dimension 2 Code" := ShortcutDim2Code;
        "Dimension Set ID" := DimSetID;
    end;

    procedure CreateDim(Type1 : Integer;No1 : Code[20];Type2 : Integer;No2 : Code[20];Type3 : Integer;No3 : Code[20];Type4 : Integer;No4 : Code[20];Type5 : Integer;No5 : Code[20]);
    var
        TableID : array [10] of Integer;
        No : array [10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,'',"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    end;

    procedure ValidateShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode : array [8] of Code[20]);
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;

    procedure ShowDimensions();
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name",'',"Line No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;

    local procedure CalcTradeAmount();
    begin
        "Trade Amount" := "Share Price" * "No. of Shares";
    end;

    procedure CalcBalance(var TotalBalance : Decimal;var Balance : Decimal);
    var
        SecurityJournalLine : Record "50108";
        TradeAmt : Decimal;
    begin
        TradeAmt := 0;
        SecurityJournalLine.RESET;
        SecurityJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
        SecurityJournalLine.SETRANGE("Entry Type","Entry Type");
        IF "Entry Type" = "Entry Type"::"Security Trade" THEN BEGIN
          IF SecurityJournalLine.FINDFIRST THEN BEGIN
            REPEAT
              IF SecurityJournalLine."Trade Type" = SecurityJournalLine."Trade Type"::Sale THEN
                SecurityJournalLine."Trade Amount" := -SecurityJournalLine."Trade Amount";
              TradeAmt := TradeAmt + SecurityJournalLine."Trade Amount";
            UNTIL SecurityJournalLine.NEXT = 0;
            TotalBalance := TradeAmt;
          END;
        END;
        IF "Entry Type" = "Entry Type"::"Security Return" THEN BEGIN
          SecurityJournalLine.CALCSUMS("Net Return Amount");
          TotalBalance := SecurityJournalLine."Net Return Amount";
        END;

        TradeAmt := 0;
        SecurityJournalLine.SETRANGE("Investment Firm","Investment Firm");
        SecurityJournalLine.CALCSUMS("Net Return Amount");
        IF "Entry Type" = "Entry Type"::"Security Trade" THEN BEGIN
          IF SecurityJournalLine.FINDFIRST THEN BEGIN
            REPEAT
              IF SecurityJournalLine."Trade Type" = SecurityJournalLine."Trade Type"::Sale THEN
                SecurityJournalLine."Trade Amount" := -SecurityJournalLine."Trade Amount";
              TradeAmt := TradeAmt + SecurityJournalLine."Trade Amount";
            UNTIL SecurityJournalLine.NEXT = 0;
            Balance := TradeAmt;
          END;
        END;
        IF "Entry Type" = "Entry Type"::"Security Return" THEN BEGIN
          SecurityJournalLine.CALCSUMS("Net Return Amount");
          Balance := SecurityJournalLine."Net Return Amount";
        END;
    end;

    local procedure CalcGainLoss();
    var
        SecurityRate : Record "50104";
        Diff : Decimal;
    begin
        IF ("Entry Type" <> "Entry Type"::"Security Rate") OR ("Share Price" = 0) THEN BEGIN
          "Share Gain/Loss" := 0;
          EXIT;
        END;

        SecurityRate.RESET;
        SecurityRate.SETCURRENTKEY(Date);
        SecurityRate.SETRANGE("ISIN Code","ISIN Code");
        IF SecurityRate.FINDLAST THEN BEGIN
          Diff := "Share Price" - SecurityRate.Rate;
          "Share Gain/Loss" := Diff / SecurityRate.Rate * 100;
        END;
    end;

    procedure UseSameAttachment(SecurityJournalLine : Record "50108");
    var
        SecurityJournalLine2 : Record "50108";
    begin
        SecurityJournalLine.SETRECFILTER;
        SecurityJournalLine.CALCFIELDS(Attachment);
        IF NOT SecurityJournalLine.Attachment.HASVALUE THEN
          ERROR(Text001);

        SecurityJournalLine2.RESET;
        SecurityJournalLine2.SETRANGE("Journal Template Name",SecurityJournalLine."Journal Template Name");
        SecurityJournalLine2.SETRANGE("Entry Type",SecurityJournalLine."Entry Type");
        SecurityJournalLine2.SETFILTER("Line No.",'<>%1',SecurityJournalLine."Line No.");
        IF SecurityJournalLine2.FINDFIRST THEN
          REPEAT
            SecurityJournalLine2.Attachment := SecurityJournalLine.Attachment;
            SecurityJournalLine2."File Name" := SecurityJournalLine."File Name";
            SecurityJournalLine2.MODIFY;
          UNTIL SecurityJournalLine2.NEXT = 0;
    end;
}

