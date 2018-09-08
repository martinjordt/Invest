page 50303 "ROI Charts - Risk"
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
    }

    var
        ROICharts : Codeunit "50300";
        Text001 : TextConst DAN='Periode',ENU='Period';

    procedure UpdateChart();
    begin
        ROICharts.UpdateChartDataRisk(Rec);
        Update(CurrPage.BusinessChart);
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
        UpdateChart();
        */
    //end;

    //event BusinessChart();
    //begin
        /*
        */
    //end;
}

