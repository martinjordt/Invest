page 70270 "ROI Charts 1"
{
    Caption='ROI Charts';
    PageType = List;

    layout
    {
        area(content)
        {
            part(ROI_SecurityType;50302)
            {
                Caption='ROI - Security - Type';
            }
            part(ROI_SecurityRisk;50303)
            {
                Caption='ROI - Security - Risk';
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

