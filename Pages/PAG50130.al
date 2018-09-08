page 50130 "Security FactBox - Trade"
{
    CaptionML = DAN='Handler',
                ENU='Trades';
    PageType = CardPart;
    SourceTable = Table50102;
    SourceTableView = SORTING(Date)
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Date;Date)
                {
                }
                field("Entry Type";"Entry Type")
                {
                }
                field("Trade Rate";"Trade Rate")
                {
                }
                field("Current Rate";"Current Rate")
                {
                    BlankZero = true;
                }
                field("No. of Shares";"No. of Shares")
                {
                }
                field("Trade Amount";"Trade Amount")
                {
                }
                field("Current Amt.";"Current Amt.")
                {
                    BlankZero = true;
                }
            }
        }
    }

    actions
    {
    }
}

