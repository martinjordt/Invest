codeunit 70102 "Security Rate Chart Mgt."
{

    trigger OnRun();
    begin
    end;

    var
        SecurityGlobal : Record Security;
        CalenderGlobal : Record "Date";
        Text001 : Label 'Rate';
        Text002 : Label 'Date';
        Text003 : Label 'Period Start %1, Period End: %2';
        Text004 : Label 'Purchase Rate';
        Text005 : Label 'Overhead';

    procedure SetChartGlobal(Security : Record Security);
    begin
        SecurityGlobal := Security;
    end;

    procedure SetChartPeriod(MovePeriod : Option " ",Next,Previous;PeriodLength : Integer);
    var
        GeneralFunctions : Codeunit "General Functions";
        SearchText : Text;
    begin
        CASE MovePeriod OF
          MovePeriod::Next:
            SearchText := '>=';
          MovePeriod::Previous:
            SearchText := '<=';
          ELSE
            SearchText := '';
        END;
        CLEAR(CalenderGlobal);
        CLEAR(GeneralFunctions);
        GeneralFunctions.FindDate(SearchText,CalenderGlobal,PeriodLength);
    end;

    procedure GetChartStatusText() : Text;
    begin
        EXIT(STRSUBSTNO(Text003,CalenderGlobal."Period Start",CalenderGlobal."Period End"));
    end;

    procedure UpdateChartData(var BusinessChartBuffer : Record "485";MovePeriod : Integer;PeriodLength : Integer);
    var
        SecurityRate : Record "Security Rate";
        SecurityTrade : Record "Security Trade";
        Stack : Integer;
        MeanPurchRate : Decimal;
        PlusRate : Decimal;
    begin
        WITH BusinessChartBuffer DO BEGIN
          Initialize;

          // Generate Period to be shown
          SetChartPeriod(MovePeriod,PeriodLength);

          // Y-Axis values (Names, Data Types, Chart Type
          AddMeasure(Text001,1,"Data Type"::Decimal,"Chart Type"::StackedColumn);  // Current Rate
          AddMeasure(Text004,1,"Data Type"::Decimal,"Chart Type"::Line);           // Purchase Rate
          AddMeasure(Text005,1,"Data Type"::Decimal,"Chart Type"::StackedColumn);  // Overhead

          // X-Axis values (Name, Data Type)
          SetXAxis(Text002,"Data Type"::String);

          MeanPurchRate := 0;
          PlusRate := 0;
          Stack := 0;

          // Calc. Mean Purchase Rate
          SecurityTrade.RESET;
          SecurityTrade.SETRANGE("Account No.",SecurityGlobal."Account No.");
          SecurityTrade.SETRANGE("Security No.",SecurityGlobal."No.");
          SecurityTrade.CALCSUMS("No. of Shares","Trade Amount");
          IF SecurityTrade."No. of Shares" <> 0 THEN
            MeanPurchRate := SecurityTrade."Trade Amount" / SecurityTrade."No. of Shares";

          // Loop through data
          SecurityRate.RESET;
          SecurityRate.SETCURRENTKEY("Rate Date");
          SecurityRate.SETRANGE("Security No.",SecurityGlobal."No.");
          SecurityRate.SETRANGE("Rate Date",CalenderGlobal."Period Start",CalenderGlobal."Period End");
          IF SecurityRate.FINDSET THEN
            REPEAT

              // Make a column (X-Axic) for each data record
              AddColumn(FORMAT(SecurityRate."Rate Date"));

              PlusRate := 0;
              IF MeanPurchRate < SecurityRate.Rate THEN BEGIN
                PlusRate := SecurityRate.Rate - MeanPurchRate;
                SecurityRate.Rate := MeanPurchRate;
              END;

              // Set value for stack (Y-Axis)
              SetValue(Text001,Stack,SecurityRate.Rate);
              SetValue(Text004,Stack,MeanPurchRate);
              SetValue(Text005,Stack,PlusRate);

              Stack := Stack + 1;
            UNTIL SecurityRate.NEXT = 0;
        END;
    end;
}

