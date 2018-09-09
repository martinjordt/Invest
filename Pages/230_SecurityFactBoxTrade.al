page 70230 "Security FactBox - Trade"
{
    Caption='Trades';
    PageType = CardPart;
    SourceTable = "Security Trade";
    SourceTableView = SORTING("Posting Date")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("Posting Date";"Posting Date")
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
}

