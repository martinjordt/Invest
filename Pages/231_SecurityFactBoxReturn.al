page 70231 "Security FactBox - Return"
{
    Caption='Returns';
    PageType = CardPart;
    SourceTable = "Security Return";
    SourceTableView = SORTING("Posting Date")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("Posting Date";"Posting Date")
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
}

