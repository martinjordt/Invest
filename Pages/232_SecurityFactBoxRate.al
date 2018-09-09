page 70232 "Security FactBox - Rate"
{
    Caption='Rates';
    PageType = CardPart;
    SourceTable = "Security Rate";
    SourceTableView = SORTING("Rate Date")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("Rate Date";"Rate Date")
                {
                }
                field(Type;Type)
                {
                }
                field(Rate;Rate)
                {
                }
            }
        }
    }
}

