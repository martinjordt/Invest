page 70275 "ROI Charts - Type"
{
    Caption='Security Return';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
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
    }

    var
        ROICharts : Codeunit "ROI Charts";

    procedure UpdateChart();
    begin
        ROICharts.UpdateChartDataType(Rec);
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
        UpdateChart;
        */
    //end;

    //event BusinessChart();
    //begin
        /*
        */
    //end;
}

