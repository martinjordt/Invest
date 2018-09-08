codeunit 50300 "ROI Charts"
{

    trigger OnRun();
    begin
    end;

    var
        Text001 : TextConst DAN='Gns. ROI ÅTD',ENU='Avg. ROI YTD';
        Text002 : TextConst DAN='Gns. ROI sidste år',ENU='Avg. ROI LY';
        AvgROIAll_YTD : Decimal;
        AvgROIAll_LY : Decimal;
        Text003 : TextConst DAN='Risikovurdering %1',ENU='Risk rating %1';

    procedure UpdateChartDataType(var BusinessChartBuffer : Record "485");
    var
        InvestmentFirm : Record "50110";
        SecurityReturn : Record "50103";
        Stack : Integer;
        Counter : Integer;
        i : Integer;
        First : Boolean;
    begin
        InitChart(BusinessChartBuffer);

        WITH BusinessChartBuffer DO BEGIN
          Stack := 0;

          // Calc ROI by Type & Firm
          SecurityReturn.RESET;
          SecurityReturn.SETCURRENTKEY(Date);
          SecurityReturn.SETRANGE(Date,CALCDATE('<CY+1D-1Y>',WORKDATE),CALCDATE('<CY>',WORKDATE));
          FOR i := 1 TO 4 DO BEGIN  // Loop Types
            SecurityReturn.SETRANGE("Security Type",i-1);
            SecurityReturn.FINDFIRST;

            // Loop Inv. Firms
            First := TRUE;
            IF InvestmentFirm.FINDFIRST THEN
              REPEAT
                SecurityReturn.SETRANGE("Investment Firm",InvestmentFirm."No.");
                SecurityReturn.CALCSUMS("ROI Gross");
                Counter := SecurityReturn.COUNT;
                SecurityReturn.SETRANGE("Investment Firm");
                IF Counter > 0 THEN BEGIN

                  // Make a column (X-Axis) for each data record
                  IF First THEN
                    AddColumn(FORMAT(SecurityReturn."Security Type"))
                  ELSE
                    AddColumn('');
                  First := FALSE;

                  // Set value for stack (Y-Axis)
                  SetValue(InvestmentFirm."No.",Stack,SecurityReturn."ROI Gross" / Counter * 1000);
                  SetValue(Text001,Stack,AvgROIAll_YTD);
                  SetValue(Text002,Stack,AvgROIAll_LY);
                  Stack := Stack + 1;
                END;
              UNTIL InvestmentFirm.NEXT = 0;
              AddColumn('');
              SetValue(Text001,Stack,AvgROIAll_YTD);
              SetValue(Text002,Stack,AvgROIAll_LY);
              Stack := Stack + 1;
          END;
        END;
    end;

    procedure UpdateChartDataRisk(var BusinessChartBuffer : Record "485");
    var
        InvestmentFirm : Record "50110";
        SecurityReturn : Record "50103";
        Stack : Integer;
        Counter : Integer;
        i : Integer;
        First : Boolean;
    begin
        InitChart(BusinessChartBuffer);

        WITH BusinessChartBuffer DO BEGIN
          Stack := 0;

          // Calc ROI by Type & Firm
          SecurityReturn.RESET;
          SecurityReturn.SETCURRENTKEY(Date);
          SecurityReturn.SETRANGE(Date,CALCDATE('<CY+1D-1Y>',WORKDATE),CALCDATE('<CY>',WORKDATE));
          FOR i := 1 TO 7 DO BEGIN  // Loop Risk
            SecurityReturn.SETRANGE(Risk,i);
            IF SecurityReturn.FINDFIRST THEN BEGIN

              // Loop Inv. Firms
              First := TRUE;
              IF InvestmentFirm.FINDFIRST THEN
                REPEAT
                  SecurityReturn.SETRANGE("Investment Firm",InvestmentFirm."No.");
                  SecurityReturn.CALCSUMS("ROI Gross");
                  Counter := SecurityReturn.COUNT;
                  SecurityReturn.SETRANGE("Investment Firm");
                  IF Counter > 0 THEN BEGIN

                    // Make a column (X-Axis) for each data record
                    IF First THEN
                      AddColumn(STRSUBSTNO(Text003,i))
                    ELSE
                      AddColumn('');
                    First := FALSE;

                    // Set value for stack (Y-Axis)
                    SetValue(InvestmentFirm."No.",Stack,SecurityReturn."ROI Gross" / Counter * 1000);
                    SetValue(Text001,Stack,AvgROIAll_YTD);
                    SetValue(Text002,Stack,AvgROIAll_LY);
                    Stack := Stack + 1;
                  END;
                UNTIL InvestmentFirm.NEXT = 0;
                AddColumn('');
                SetValue(Text001,Stack,AvgROIAll_YTD);
                SetValue(Text002,Stack,AvgROIAll_LY);
                Stack := Stack + 1;
            END;
          END;
        END;
    end;

    local procedure InitChart(var BusinessChartBuffer : Record "485");
    var
        InvestmentFirm : Record "50110";
    begin
        WITH BusinessChartBuffer DO BEGIN
          Initialize;

          // Y-Axis values (Names, Data Types, Chart Type
          AddMeasure(Text001,1,"Data Type"::Decimal,"Chart Type"::Line);  // Average ROI YTD
          AddMeasure(Text002,1,"Data Type"::Decimal,"Chart Type"::Line);  // Average ROI LY

          // Measure by Inv. Firm
          InvestmentFirm.RESET;
          IF InvestmentFirm.FINDFIRST THEN
            REPEAT
              AddMeasure(InvestmentFirm."No.",1,"Data Type"::Decimal,"Chart Type"::StackedColumn);  // Investment Firm
            UNTIL InvestmentFirm.NEXT = 0;

          // X-Axis values (Name, Data Type)
          SetXAxis('.',"Data Type"::String);

          CalcTotalAverages;
        END;
    end;

    local procedure CalcTotalAverages();
    var
        SecurityReturn : Record "50103";
        Counter : Integer;
    begin
        AvgROIAll_YTD := 0;
        AvgROIAll_LY := 0;

        // Calc Average Total YTD
        CLEAR(SecurityReturn);
        SecurityReturn.SETCURRENTKEY(Date);
        SecurityReturn.SETRANGE(Date,CALCDATE('<CY+1D-1Y>',WORKDATE),CALCDATE('<CY>',WORKDATE));
        SecurityReturn.CALCSUMS("ROI Gross");
        Counter := SecurityReturn.COUNT;
        IF Counter > 0 THEN
          AvgROIAll_YTD := SecurityReturn."ROI Gross" * 1000 / Counter;

        // Calc Average Total LY
        SecurityReturn.SETRANGE(Date,CALCDATE('<CY+1D-2Y>',WORKDATE),CALCDATE('<CY-1Y>',WORKDATE));
        SecurityReturn.CALCSUMS("ROI Gross");
        Counter := SecurityReturn.COUNT;
        IF Counter > 0 THEN
          AvgROIAll_LY := SecurityReturn."ROI Gross" * 1000 / Counter;
    end;
}

