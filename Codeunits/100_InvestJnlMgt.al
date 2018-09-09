codeunit 70100 "Invest Jnl. Mgt."
{
    TableNo = "Security Journal Line";

    trigger OnRun();
    var
        SecurityJournalLine : Record "Security Journal Line";
    begin
        IF NOT DIALOG.CONFIRM(Text003) THEN
          EXIT;

        Window.OPEN(Text001 + Text002);

        SecurityJournalLine.COPY(Rec);
        SecurityJournalLine.SETRANGE("Entry Type","Entry Type");

        IF SecurityJournalLine.FINDFIRST THEN
          REPEAT
                      Window.UPDATE(1,SecurityJournalLine."Entry Type"::"Security Trade");
              Window.UPDATE(2,SecurityJournalLine."Security Name");
                    PostJournal(SecurityJournalLine);
          UNTIL SecurityJournalLine.NEXT = 0;

        Rec := SecurityJournalLine;
    end;

    var
        Window : Dialog;
        Text001 : label 'Posting: #1#################\';
        Text002 : label 'Security: #2######################';
        Text003 : label 'Do You wish to register the journal?';
        Text004 : label '%1 for %2 %3 is more than 15% different from last %4';

    procedure PostJournal(var SecurityJournalLine : Record "Security Journal Line");
    var
        Security : Record Security;
        SecurityJournalLine2 : Record "Security Journal Line";
        SecurityFunctions : Codeunit "Security Function Mgt.";
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

    local procedure SecurityTrade(SecurityJournalLine : Record "Security Journal Line");
    var
        Security : Record Security;
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

    local procedure SecurityReturn(SecurityJournalLine : Record "Security Journal Line");
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

    local procedure SecurityRate(SecurityJournalLine : Record "Security Journal Line");
    var
        SecurityRate : Record "Security Rate";
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
          SecurityRate.SETCURRENTKEY("Rate Date");
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

    local procedure CreateSecurity(SecurityJournalLine : Record "Security Journal Line";var Security : Record Security);
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

    local procedure CreateTrade(SecurityJournalLine : Record "Security Journal Line");
    var
        SecurityTrade : Record "Security Trade";
    begin
        WITH SecurityJournalLine DO BEGIN
          CALCFIELDS(Attachment);

          SecurityTrade.INIT;
          SecurityTrade."Posting Date" := "Posting Date";
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

    local procedure CreateRate(SecurityJournalLine : Record "Security Journal Line";InitialEntry : Boolean);
    var
        SecurityRate : Record "Security Rate";
    begin
        WITH SecurityJournalLine DO BEGIN
          SecurityRate.INIT;
          SecurityRate."Rate Date" := "Posting Date";
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

    local procedure CreateReturn(SecurityJournalLine : Record "Security Journal Line");
    var
        SecurityReturn : Record "Security Return";
    begin
        WITH SecurityJournalLine DO BEGIN
          CALCFIELDS(Attachment);

          SecurityReturn.INIT;
          SecurityReturn."Posting Date" := "Posting Date";
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

