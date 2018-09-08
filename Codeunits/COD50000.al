codeunit 50000 InvestJnlMgt
{
    TableNo = 50108;

    trigger OnRun();
    var
        SecurityJournalLine : Record "50108";
    begin
        IF NOT DIALOG.CONFIRM(Text003) THEN
          EXIT;

        IF GUIALLOWED THEN
          Window.OPEN(Text001 + Text002);

        SecurityJournalLine.COPY(Rec);
        SecurityJournalLine.SETRANGE("Entry Type","Entry Type");

        IF SecurityJournalLine.FINDFIRST THEN
          REPEAT
            IF GUIALLOWED THEN BEGIN
              Window.UPDATE(1,SecurityJournalLine."Entry Type"::"Security Trade");
              Window.UPDATE(2,SecurityJournalLine."Security Name");
            END;
            PostJournal(SecurityJournalLine);
          UNTIL SecurityJournalLine.NEXT = 0;

        Rec := SecurityJournalLine;
    end;

    var
        Window : Dialog;
        Text001 : TextConst DAN='Bogfører: #1#################\',ENU='Posting: #1#################\';
        Text002 : TextConst DAN='Værdipapir: #2######################',ENU='Security: #2######################';
        Text003 : TextConst DAN='Vil du registrere kladden?',ENU='Do You wish to register the journal?';
        Text004 : TextConst DAN='%1 for %2 %3 er mere end 15% forskellig fra sidste %4',ENU='%1 for %2 %3 is more than 15% different from last %4';

    procedure PostJournal(var SecurityJournalLine : Record "50108");
    var
        Security : Record "50101";
        SecurityJournalLine2 : Record "50108";
        SecurityFunctions : Codeunit "50006";
    begin
        // Post line
        CASE SecurityJournalLine."Entry Type" OF
          SecurityJournalLine."Entry Type"::"Security Trade":
            SecurityTrade(SecurityJournalLine);
          SecurityJournalLine."Entry Type"::"Security Return":
            SecurityReturn(SecurityJournalLine);
          SecurityJournalLine."Entry Type"::"Security Rate":
            SecurityRate(SecurityJournalLine);
          ELSE
            SecurityJournalLine.FIELDERROR("Entry Type");
        END;

        // Calculate Security KPI values
        Security.GET(SecurityJournalLine."Security No.");
        SecurityFunctions.SecurityKPI(Security);
        Security.MODIFY;

        // Calculate Security Trade KPI Values
        SecurityFunctions.SecurityTradeKPI(Security);

        // Delete line
        IF SecurityJournalLine2.GET(SecurityJournalLine."Journal Template Name",SecurityJournalLine."Entry Type",SecurityJournalLine."Line No.") THEN
          SecurityJournalLine2.DELETE(TRUE);
    end;

    local procedure SecurityTrade(SecurityJournalLine : Record "50108");
    var
        Security : Record "50101";
    begin
        // Test line
        WITH SecurityJournalLine DO BEGIN
          TESTFIELD("Posting Date");
          TESTFIELD("Account No.");
          TESTFIELD("Investment Firm");
          TESTFIELD("ISIN Code");
          TESTFIELD("Share Price");
          TESTFIELD("No. of Shares");
          TESTFIELD("Trade Amount");
          TESTFIELD("Security Name");

          CLEAR(Security);
          Security.SETRANGE("ISIN Code","ISIN Code");
          IF Security.FINDFIRST THEN BEGIN
            TESTFIELD("Security Name",Security.Name);
            TESTFIELD("Security Type",Security."Security Type");
            TESTFIELD(Taxation,Security.Taxation);
            TESTFIELD("Disbursement Plan",Security."Return Plan");
            IF "Trade Type" = "Trade Type"::Sale THEN BEGIN
              Security.CALCFIELDS("No. of Shares");
              IF Security."No. of Shares" - "No. of Shares" = 0 THEN BEGIN
                Security.VALIDATE(Status,Security.Status::Inactive);
                Security.MODIFY(TRUE);
              END;
            END;
          END ELSE
            CreateSecurity(SecurityJournalLine,Security);  // Insert new Security
          "Security No." := Security."No.";
        END;

        // Insert Security Trade
        CreateTrade(SecurityJournalLine);

        // Insert SecurityRate
        CreateRate(SecurityJournalLine,TRUE);
    end;

    local procedure SecurityReturn(SecurityJournalLine : Record "50108");
    begin
        // Test line
        WITH SecurityJournalLine DO BEGIN
          TESTFIELD("Posting Date");
          TESTFIELD("Account No.");
          TESTFIELD("Security No.");
          TESTFIELD("ISIN Code");
          TESTFIELD("Gros Return Amount");
          TESTFIELD("Net Return Amount");
          TESTFIELD("No. of Shares");
        END;

        // Insert Security Return
        CreateReturn(SecurityJournalLine);
    end;

    local procedure SecurityRate(SecurityJournalLine : Record "50108");
    var
        SecurityRate : Record "50104";
        High : Decimal;
        Low : Decimal;
    begin
        // Test line
        WITH SecurityJournalLine DO BEGIN
          TESTFIELD("Posting Date");
          TESTFIELD("Security No.");
          TESTFIELD("ISIN Code");
          TESTFIELD("Share Price");

          // Sanity Check
          SecurityRate.RESET;
          SecurityRate.SETCURRENTKEY(Date);
          SecurityRate.SETRANGE("Security No.","Security No.");
          IF SecurityRate.FINDLAST THEN BEGIN
            High := SecurityRate.Rate * 1.5;
            Low := SecurityRate.Rate * 0.5;
            IF ("Share Price" > High) OR
              ("Share Price" < Low)
            THEN
              ERROR(STRSUBSTNO(Text004,
                FIELDCAPTION("Share Price"),
                "Security No.",
                "Security Name",
                SecurityRate.FIELDCAPTION(Rate)));
          END;
        END;

        // Insert Security Rate
        CreateRate(SecurityJournalLine,FALSE);
    end;

    local procedure "---"();
    begin
    end;

    local procedure CreateSecurity(SecurityJournalLine : Record "50108";var Security : Record "50101");
    begin
        WITH SecurityJournalLine DO BEGIN
          CLEAR(Security);
          Security.Name := "Security Name";
          Security."ISIN Code" := "ISIN Code";
          Security."Security Type" := "Security Type";
          Security.Taxation := Taxation;
          Security."Investment Firm" := "Investment Firm";
          Security."Account No." := "Account No.";
          Security."Return Plan" := "Disbursement Plan";
          Security.Risk := Risk;
          Security."Morning Star Rating" := "Morning Star Rating";
          Security."Bank Account No." := "Bank Account No.";
          Security.INSERT(TRUE);
        END;
    end;

    local procedure CreateTrade(SecurityJournalLine : Record "50108");
    var
        SecurityTrade : Record "50102";
    begin
        WITH SecurityJournalLine DO BEGIN
          CALCFIELDS(Attachment);

          SecurityTrade.INIT;
          SecurityTrade.Date := "Posting Date";
          SecurityTrade."Account No." := "Account No.";
          SecurityTrade."Security No." := "Security No.";
          SecurityTrade."ISIN Code" := "ISIN Code";
          SecurityTrade."Entry Type" := "Trade Type";
          SecurityTrade."Trade Rate" := "Share Price";
          IF "Trade Type" = "Trade Type"::Purchase THEN BEGIN
            SecurityTrade."No. of Shares" := "No. of Shares";
            SecurityTrade."Trade Amount" := "Trade Amount";
          END ELSE BEGIN
            SecurityTrade."No. of Shares" := -"No. of Shares";
            SecurityTrade."Trade Amount" := -"Trade Amount";
          END;
          SecurityTrade.Attachment := Attachment;
          SecurityTrade."File Name" := "File Name";
          SecurityTrade.INSERT(TRUE);
        END;
    end;

    local procedure CreateRate(SecurityJournalLine : Record "50108";InitialEntry : Boolean);
    var
        SecurityRate : Record "50104";
    begin
        WITH SecurityJournalLine DO BEGIN
          SecurityRate.INIT;
          SecurityRate.Date := "Posting Date";
          SecurityRate."Security No." := "Security No.";
          SecurityRate."ISIN Code" := "ISIN Code";
          SecurityRate.Rate := "Share Price";
          IF InitialEntry THEN
            SecurityRate.Type := SecurityRate.Type::"Initial Entry"
          ELSE
            SecurityRate.Type := SecurityRate.Type::Rate;
          SecurityRate.INSERT(TRUE);
        END;
    end;

    local procedure CreateReturn(SecurityJournalLine : Record "50108");
    var
        SecurityReturn : Record "50103";
    begin
        WITH SecurityJournalLine DO BEGIN
          CALCFIELDS(Attachment);

          SecurityReturn.INIT;
          SecurityReturn.Date := "Posting Date";
          SecurityReturn."Account No." := "Account No.";
          SecurityReturn."Security No." := "Security No.";
          SecurityReturn."Security Type" := "Security Type";
          SecurityReturn."ISIN Code" := "ISIN Code";
          SecurityReturn."Investment Firm" := "Investment Firm";
          SecurityReturn.Risk := Risk;
          SecurityReturn."Gros Return Amount" := "Gros Return Amount";
          SecurityReturn."Net Return Amount" := "Net Return Amount";
          SecurityReturn.VALIDATE("No. of Shares",SecurityJournalLine."No. of Shares");
          SecurityReturn.Attachment := Attachment;
          SecurityReturn."File Name" := "File Name";
          SecurityReturn.INSERT(TRUE);
        END;
    end;
}

