page 50142 "Security Chart - Return ROI"
{
    // Copy of P773

    CaptionML = DAN='Værdipapir udbytte',
                ENU='Security Return';
    PageType = CardPart;
    SourceTable = Table485;

    layout
    {
        area(content)
        {
            field(StatusText;StatusText)
            {
                ApplicationArea = Basic,Suite;
                CaptionML = DAN='Statustekst',
                            ENU='Status Text';
                ShowCaption = false;
                ToolTipML = DAN='Angiver diagrammets status.',
                            ENU='Specifies the status of the chart.';
            }
            field(BusinessChart;'')
            {
                ApplicationArea = Basic,Suite;
                CaptionML = DAN='Virksomhedsdiagram',
                            ENU='Business Chart';
                //The property ControlAddIn is not yet supported. Please convert manually.
                //ControlAddIn = 'Microsoft.Dynamics.Nav.Client.BusinessChart;PublicKeyToken=31bf3856ad364e35';
                ToolTipML = DAN='Angiver, om diagrammet er af typen Virksomhedsdiagram.',
                            ENU='Specifies if the chart is of type Business Chart.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Periode)
            {
                CaptionML = DAN='Periode',
                            ENU='Period';
                Image = Period;
                action(Year)
                {
                    CaptionML = DAN='År',
                                ENU='Year';

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
                    CaptionML = DAN='2 År',
                                ENU='2 Years';

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
                    CaptionML = DAN='3 År',
                                ENU='3 Years';

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
                    CaptionML = DAN='4 År',
                                ENU='4 Years';

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
                    CaptionML = DAN='5 År',
                                ENU='5 Years';

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
                CaptionML = DAN='Forrige periode',
                            ENU='Previous Period';
                Image = PreviousRecord;
                ToolTipML = DAN='Vis oplysningerne baseret på den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen før.',
                            ENU='Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.';

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
                CaptionML = DAN='Næste periode',
                            ENU='Next Period';
                Image = NextRecord;
                ToolTipML = DAN='Få vist den næste periode.',
                            ENU='View the next period.';

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
        SecurityGlobal : Record "50101";
        SecurityReturnChartMgt : Codeunit "50003";
        StatusText : Text[250];
        Text001 : TextConst DAN='Periode',ENU='Period';
        Period : Option " ",Next,Previous;
        PeriodLength : Option Year,Year2,Year3,Year4,Year5;

    procedure UpdateChart(MovePeriod : Option " ",Next,Previous);
    begin
        SecurityReturnChartMgt.SetChartGlobal(SecurityGlobal);
        SecurityReturnChartMgt.UpdateChartData(Rec,MovePeriod,PeriodLength);
        Update(CurrPage.BusinessChart);

        StatusText := SecurityReturnChartMgt.GetChartStatusText;
    end;

    procedure SetGlobal(Security : Record "50101");
    begin
        SecurityGlobal := Security;
        SecurityReturnChartMgt.SetChartGlobal(SecurityGlobal);
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

