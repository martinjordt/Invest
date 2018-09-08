page 50300 "ROI Charts 1"
{
    CaptionML = DAN='ROI Grafer',
                ENU='ROI Charts';
    PageType = List;

    layout
    {
        area(content)
        {
            part(ROI_SecurityType;50302)
            {
                CaptionML = DAN='ROI - Værdipapir - Type',
                            ENU='ROI - Security - Type';
            }
            part(ROI_SecurityRisk;50303)
            {
                CaptionML = DAN='ROI - Værdipapir - Risiko',
                            ENU='ROI - Security - Risk';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        // CurrPage.ROI_SecurityType.PAGE.UpdateChart();
        // CurrPage.ROI_SecurityRisk.PAGE.UpdateChart();
    end;
}

