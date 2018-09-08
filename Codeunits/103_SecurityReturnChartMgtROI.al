codeunit 70103 "Security Return Chart Mgt. ROI"
{

    trigger OnRun();
    begin
    end;

    var
        SecurityGlobal: Record Security;
        CalenderGlobal: Record "Date";
        Text001: Label 'Gross ROI';
        Text002: Label 'Date';
        Text003: Label 'Period Start %1, Period End: %2';
        Text004: Label 'Avg. ROI All';
        Text005: LAbel 'Avg. ROI Security Type';

    procedure SetChartGlobal(Security: Record Security);
    begin
        SecurityGlobal := Security;
    end;

    procedure SetChartPeriod(MovePeriod: Option " ",Next,Previous; PeriodLength: Integer);
    var
        GeneralFunctions: Codeunit "General Functions";
        SearchText: Text;
    begin
        CASE MovePeriod OF
          MovePeriod::Next :
            SearchText := '>=';
        MovePeriod::Previous :
            SearchText := '<=';
        ELSE
        SearchText := '';
        END;
        CLEAR(CalenderGlobal);
        CLEAR(GeneralFunctions);
        GeneralFunctions.FindDate(SearchText, CalenderGlobal, PeriodLength);
    end;

    procedure GetChartStatusText(): Text;
    begin
        EXIT(STRSUBSTNO(Text003, CalenderGlobal."Period Start", CalenderGlobal."Period End"));
    end;

    procedure UpdateChartData(var BusinessChartBuffer: Record "Business Chart Buffer"; MovePeriod: Integer; PeriodLength: Integer);
    var
        SecurityReturn: Record "Security Return";
        Stack: Integer;
        Counter: Integer;
        AvgROIAll: Decimal;
        AvgROIType: Decimal;
    begin
        WITH BusinessChartBuffer DO
        BEGIN
            Initialize;

            IF SecurityGlobal."No." = '' THEN
                EXIT;

            // Generate Period to be shown
            SetChartPeriod(MovePeriod, PeriodLength);

            // Y-Axis values (Names, Data Types, Chart Type
            AddMeasure(Text001, 1, "Data Type"::Decimal, "Chart Type"::StackedColumn);  // Gross ROI
            AddMeasure(Text004, 1, "Data Type"::Decimal, "Chart Type"::Line);  // Avg ROI All YTD
            AddMeasure(Text005, 1, "Data Type"::Decimal, "Chart Type"::Line);  // Avg ROI Security Type YTD

            // X-Axis values (Name, Data Type)
            SetXAxis(Text002, "Data Type"::String);

            Stack := 0;
            AvgROIAll := 0;
            AvgROIType := 0;

            // Calc Average Total
            CLEAR(SecurityReturn);
            SecurityReturn.SETCURRENTKEY("Posting Date");
            SecurityReturn.SETRANGE("Account No.", SecurityGlobal."Account No.");
            SecurityReturn.SETRANGE("Posting Date", CALCDATE('<CY+1D-1Y>', WORKDATE), CALCDATE('<CY>', WORKDATE));
            SecurityReturn.CALCSUMS("ROI Gross");
            Counter := SecurityReturn.COUNT;
            IF Counter > 0 THEN
                AvgROIAll := SecurityReturn."ROI Gross" * 1000 / Counter;

            // Calc Average Type
            SecurityReturn.SETRANGE("Security Type", SecurityGlobal."Security Type");
            SecurityReturn.CALCSUMS("ROI Gross");
            Counter := SecurityReturn.COUNT;
            IF Counter > 0 THEN
                AvgROIType := SecurityReturn."ROI Gross" * 1000 / Counter;

            // Calc Gross ROI by period
            CLEAR(SecurityReturn);
            SecurityReturn.SETCURRENTKEY("Posting Date");
            SecurityReturn.SETRANGE("Account No.", SecurityGlobal."Account No.");
            SecurityReturn.SETRANGE("Security No.", SecurityGlobal."No.");
            SecurityReturn.SETRANGE("Posting Date", CalenderGlobal."Period Start", CalenderGlobal."Period End");
            IF SecurityReturn.FINDSET THEN
                REPEAT

              // Make a column (X-Axic) for each data record
              AddColumn(FORMAT(SecurityReturn."Posting Date"));

                // Set value for stack (Y-Axis)
                SetValue(Text001, Stack, SecurityReturn."ROI Gross" * 1000);
                SetValue(Text004, Stack, AvgROIAll);
                SetValue(Text005, Stack, AvgROIType);

                Stack := Stack + 1;
                UNTIL SecurityReturn.NEXT = 0;
        END;
    end;
}

