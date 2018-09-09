page 70241 "Security Chart - Rate"
{
    // Copy of P773

    Caption='Security Return';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            field(StatusText;StatusText)
            {
                ApplicationArea = Basic,Suite;
                Caption='Status Text';
                ShowCaption = false;
                ToolTip='Specifies the status of the chart.';
            }
            field(BusinessChart;'')
            {
                ApplicationArea = Basic,Suite;
                Caption='Business Chart';
                //The property ControlAddIn is not yet supported. Please convert manually.
                //ControlAddIn = 'Microsoft.Dynamics.Nav.Client.BusinessChart;PublicKeyToken=31bf3856ad364e35';
                ToolTip='Specifies if the chart is of type Business Chart.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Periode)
            {
                Caption='Period';
                Image = Period;
                action(Year)
                {
                    Caption='Year';

                    trigger OnAction();
                    var
                        MovePeriod : Option " ",Next,Previous;
                    begin
                        PeriodLength := PeriodLength::Year;
                        UpdateChart(MovePeriod::" ");
                    end;
                }
                action("2Years")
                {
                    Caption='2 Years';

                    trigger OnAction();
                    var
                        MovePeriod : Option " ",Next,Previous;
                    begin
                        PeriodLength := PeriodLength::Year2;
                        UpdateChart(MovePeriod::" ");
                    end;
                }
                action("3Years")
                {
                    Caption='3 Years';

                    trigger OnAction();
                    var
                        MovePeriod : Option " ",Next,Previous;
                    begin
                        PeriodLength := PeriodLength::Year3;
                        UpdateChart(MovePeriod::" ");
                    end;
                }
                action("4Years")
                {
                    Caption='4 Years';

                    trigger OnAction();
                    var
                        MovePeriod : Option " ",Next,Previous;
                    begin
                        PeriodLength := PeriodLength::Year4;
                        UpdateChart(MovePeriod::" ");
                    end;
                }
                action("5Years")
                {
                    Caption='5 Years';

                    trigger OnAction();
                    var
                        MovePeriod : Option " ",Next,Previous;
                    begin
                        PeriodLength := PeriodLength::Year5;
                        UpdateChart(MovePeriod::" ");
                    end;
                }
            }
            action(PrevPeriod)
            {
                ApplicationArea = RelationshipMgmt;
                Caption='Previous Period';
                Image = PreviousRecord;
                ToolTip='Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.';

                trigger OnAction();
                var
                    MovePeriod : Option " ",Next,Previous;
                begin
                    UpdateChart(MovePeriod::Previous);
                end;
            }
            action(NextPeriod)
            {
                ApplicationArea = RelationshipMgmt;
                Caption='Next Period';
                Image = NextRecord;
                ToolTip='View the next period.';

                trigger OnAction();
                var
                    MovePeriod : Option " ",Next,Previous;
                begin
                    UpdateChart(MovePeriod::Next);
                end;
            }
        }
    }

    var
        SecurityGlobal : Record Security;
        SecurityRateChartMgt : Codeunit "Security Rate Chart Mgt.";
        StatusText : Text[250];
        Text001 : Label 'Period';
        Period : Option " ",Next,Previous;
        PeriodLength : Option Year,Year2,Year3,Year4,Year5;

    procedure UpdateChart(MovePeriod : Option " ",Next,Previous);
    begin
        SecurityRateChartMgt.SetChartGlobal(SecurityGlobal);
        SecurityRateChartMgt.UpdateChartData(Rec,MovePeriod,PeriodLength);
        Update(CurrPage.BusinessChart);

        StatusText := SecurityRateChartMgt.GetChartStatusText;
    end;

    procedure SetGlobal(Security : Record Security);
    begin
        SecurityGlobal := Security;
        SecurityRateChartMgt.SetChartGlobal(SecurityGlobal);
        PeriodLength := PeriodLength::Year5;
    end;

    //event BusinessChart(point : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
    //begin
        /*
        */
    //end;

    //event BusinessChart(point : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
    //begin
        /*
        */
    //end;

    //event BusinessChart();
    var
        MovePeriod : Option " ",Next,Previous;
    //begin
        /*
        PeriodLength := PeriodLength::Year5;
        UpdateChart(MovePeriod::" ");
        */
    //end;

    //event BusinessChart();
    //begin
        /*
        */
    //end;
}

