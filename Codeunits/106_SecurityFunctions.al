codeunit 70106 "Security Functions"
{

    trigger OnRun();
    begin
    end;

    procedure SecurityKPI(var Security : Record Security);
    var
        SecurityRate : Record "Security Rate";
        SecurityRate2 : Record "Security Rate";
        SecurityReturn : Record "Security Return";
        DateRec : Record "Date";
        NoOfPeriods : Integer;
        PeriodStart : Date;
        PeriodEnd : Date;
        Diff : Decimal;
    begin
        WITH Security DO BEGIN
          // Current Rate
          SecurityRate.RESET;
          SecurityRate.SETCURRENTKEY("Rate Date");
          SecurityRate.SETRANGE("Security No.","No.");
          IF SecurityRate.FINDLAST THEN BEGIN
            "Current Share Rate" := SecurityRate.Rate;

            // Latest Rate Gain
            SecurityRate2.COPY(SecurityRate);
            IF SecurityRate2.NEXT(-1) <> 0 THEN BEGIN
              Diff := "Current Share Rate" - SecurityRate2.Rate;
              "Share Gain/Loss Latest" := Diff / SecurityRate2.Rate * 100;
            END;

            // Overall Rate Gain
            SecurityRate2.COPY(SecurityRate);
            SecurityRate2.SETRANGE(Type,SecurityRate.Type::"Initial Entry");
            IF SecurityRate2.FINDLAST THEN BEGIN
              Diff := "Current Share Rate" - SecurityRate2.Rate;
              "Share Gain/Loss Overall" := Diff / SecurityRate2.Rate * 100;
            END;
          END;

          // Current Value
          CALCFIELDS("No. of Shares","Total Purchase Amt.","Total Sales Amt.");
          "Current Share Amt." := "Current Share Rate" * "No. of Shares";
          "Current Profit/Loss" := "Current Share Amt." - "Total Purchase Amt.";
          IF ("Total Sales Amt." > 0) AND ("No. of Shares" = 0) THEN
            "Realised Profit/Loss" := "Total Sales Amt." - "Total Purchase Amt.";

          // Latest Return/ROI
          SecurityReturn.RESET;
          SecurityReturn.SETCURRENTKEY("Posting Date");
          SecurityReturn.SETRANGE("Security No.","No.");
          IF SecurityReturn.FINDLAST THEN BEGIN
            "Last Return Amt." := SecurityReturn."Gros Return Amount";
            "Last ROI per 1000" := SecurityReturn."ROI Gross" * 1000;
          END;

          // Total ROI
          SecurityReturn.CALCSUMS("Gros Return Amount",SecurityReturn."ROI Gross");
          "Total ROI per 1000" := SecurityReturn."ROI Gross" * 1000;

          // Return/ROI YTD
          SecurityReturn.RESET;
          SecurityReturn.SETCURRENTKEY("Posting Date");
          SecurityReturn.SETRANGE("Security No.","No.");
          SecurityReturn.SETRANGE("Posting Date",CALCDATE('<CY-1Y+1D>',WORKDATE),WORKDATE);
          SecurityReturn.CALCSUMS("Gros Return Amount",SecurityReturn."ROI Gross");
          "Return Amt. YTD" := SecurityReturn."Gros Return Amount";
          "ROI YTD per 1000" := SecurityReturn."ROI Gross" * 1000;

          // Return/ROI LY
          SecurityReturn.SETRANGE("Posting Date",CALCDATE('<CY-2Y+1D>',WORKDATE),CALCDATE('<CY-1Y>'));
          SecurityReturn.CALCSUMS("Gros Return Amount",SecurityReturn."ROI Gross");
          "Return Amt. LY" := SecurityReturn."Gros Return Amount";
          "ROI LY per 1000" := SecurityReturn."ROI Gross" * 1000;

          // Average ROI per year total
          CALCFIELDS("Total Purchase Amt.","Total Return Amt.");
          SecurityReturn.SETRANGE("Posting Date");
          IF SecurityReturn.FINDFIRST THEN BEGIN
            PeriodStart := CALCDATE('<CY-1Y+1D>',SecurityReturn."Posting Date");
            SecurityReturn.FINDLAST;
            PeriodEnd := CALCDATE('<CY>',SecurityReturn."Posting Date");
            DateRec.RESET;
            DateRec.SETRANGE("Period Type",DateRec."Period Type"::Month);
            DateRec.SETRANGE("Period Start",PeriodStart,PeriodEnd);
            NoOfPeriods := DateRec.COUNT;

            "Avgr. ROI per Y per 1000" := "Total Return Amt." / NoOfPeriods * 12;
            "Avgr. ROI per Y per 1000" := "Avgr. ROI per Y per 1000" / (("Total Purchase Amt." + "Current Share Amt.") / 2) * 1000;
          END;
        END;
    end;

    procedure SecurityTradeKPI(var Security : Record Security);
    var
        SecurityRate : Record "Security Rate";
        SecurityTrade : Record "Security Trade";
    begin
        WITH Security DO BEGIN

          // Current Rate
          SecurityRate.RESET;
          SecurityRate.SETCURRENTKEY("Rate Date");
          SecurityRate.SETRANGE("Security No.","No.");
          IF SecurityRate.FINDLAST THEN BEGIN
            SecurityTrade.RESET;
            SecurityTrade.SETRANGE("Security No.","No.");
            SecurityTrade.SETRANGE("Entry Type",SecurityTrade."Entry Type"::Purchase);
            IF SecurityTrade.FINDFIRST THEN
              REPEAT
                SecurityTrade."Current Rate" := SecurityRate.Rate;
                SecurityTrade."Current Amt." := SecurityTrade."Current Rate" * SecurityTrade."No. of Shares";
                SecurityTrade.MODIFY(TRUE);
              UNTIL SecurityTrade.NEXT = 0;
          END;
        END;
    end;

    procedure SetStyleExpr_Security(Security : Record Security;var Style1 : Text;var Style2 : Text;var Style3 : Text);
    var
        SecurityReturn : Record "Security Return";
        Counter : Integer;
    begin
        Style1 := 'Standard';
        Style2 := 'Standard';
        Style3 := 'Standard';

        // Inactive Securities
        IF Security.Status = Security.Status::Inactive THEN
          Style1 := 'Subordinate';
          Style2 := 'Subordinate';
          Style3 := 'Subordinate';

        // Active Securities
        IF Security.Status = Security.Status::Active THEN BEGIN
          CLEAR(SecurityReturn);
          SecurityReturn.SETCURRENTKEY("Posting Date");
          SecurityReturn.SETRANGE("Security Type",Security."Security Type");
          SecurityReturn.SETRANGE("Account No.",Security."Account No.");
          SecurityReturn.SETRANGE("Posting Date",CALCDATE('<CY+1D-1Y>',WORKDATE),CALCDATE('<CY>',WORKDATE));
          SecurityReturn.CALCSUMS("ROI Gross");
          Counter := SecurityReturn.COUNT;
          IF Counter > 0 THEN BEGIN
            CASE TRUE OF

              // Profit or High ROI
              (Security."ROI YTD per 1000" > SecurityReturn."ROI Gross" * 1000 / Counter) OR
              (Security."Current Profit/Loss" > 0):
                Style1 := 'Favorable';

              // Loss and Low ROI
              (Security."ROI YTD per 1000" > 0) AND (Security."ROI LY per 1000" > 0) AND
              (Security."ROI YTD per 1000" < (SecurityReturn."ROI Gross" * 1000 / Counter) * 0.5) AND
              (Security."Current Profit/Loss" < 0):
                Style1 := 'Unfavorable';

              // Low ROI
              Security."ROI YTD per 1000" < (SecurityReturn."ROI Gross" * 1000 / Counter) * 0.5:
                Style1 := 'Ambiguous';
            END;
          END;

          IF Security."Share Gain/Loss Latest" > 0 THEN
            Style2 := 'Favorable'
          ELSE
            Style2 := 'Unfavorable';

          IF Security."Share Gain/Loss Overall" > 0 THEN
            Style3 := 'Favorable'
          ELSE
            Style3 := 'Unfavorable';
        END;
    end;

    procedure SetStyleExpr_Jnl(SecurityJournalLine : Record "Security Journal Line") : Text;
    var
        SecurityReturn : Record "Security Return";
        Counter : Integer;
    begin
        WITH SecurityJournalLine DO BEGIN
          CASE "Entry Type" OF
            "Entry Type"::"Security Rate":
              BEGIN
                IF "Share Gain/Loss" > 0 THEN
                  EXIT('favorable');
                IF "Share Gain/Loss" < 0 THEN
                  EXIT('Unfavorable');
                EXIT('Standard');
              END;
          END;
        END;
    end;
}

