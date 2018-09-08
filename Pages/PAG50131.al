page 50131 "Security FactBox - Return"
{
    CaptionML = DAN='Udbytte',
                ENU='Returns';
    PageType = CardPart;
    SourceTable = Table50103;
    SourceTableView = SORTING(Date)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Date;Date)
                {
                }
                field("No. of Shares";"No. of Shares")
                {
                }
                field("Gros Return Amount";"Gros Return Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

