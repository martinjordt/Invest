codeunit 70101 "Security Return Chart Mgt."
{

    trigger OnRun();
    begin
    end;

    var
        SecurityGlobal: Record Security;
        Text001: Label 'Return Amount';
        Text002: Label 'Date';
        Text003: Label 'Period Start %1, Period End: %2';
        CalenderGlobal: Record "Date";

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
    begin
        WITH BusinessChartBuffer DO
        BEGIN
            Initialize;

            // Generate Period to be shown
            SetChartPeriod(MovePeriod, PeriodLength);

            // Y-Axis values (Names, Data Types, Chart Type
            AddMeasure(Text001, 1, "Data Type"::Decimal, "Chart Type"::StackedColumn);

            // X-Axis values (Name, Data Type)
            SetXAxis(Text002, "Data Type"::String);

            Stack := 0;

            // Loop through data
            SecurityReturn.RESET;
            SecurityReturn.SETCURRENTKEY("Posting Date");
            SecurityReturn.SETRANGE("Account No.", SecurityGlobal."Account No.");
            SecurityReturn.SETRANGE("Security No.", SecurityGlobal."No.");
            SecurityReturn.SETRANGE("Posting Date", CalenderGlobal."Period Start", CalenderGlobal."Period End");
            IF SecurityReturn.FINDSET THEN
                REPEAT

              // Make a column (X-Axic) for each data record
              AddColumn(FORMAT(SecurityReturn."Posting Date"));
                // Set value for stack (Y-Axis)
                SetValue(Text001, Stack, SecurityReturn."Gros Return Amount");
                // SetValue('Text 2',Stack,Value2);
                // SetValue('Text 3',Stack,Value3);

                Stack := Stack + 1;
                UNTIL SecurityReturn.NEXT = 0;
        END;
    end;
}

