page 70204 "Security Rates"
{
    Caption='Security Rates';
    Editable = false;
    PageType = List;
    SourceTable = "Security Rate";
    SourceTableView = SORTING("Rate Date")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("rate date";"Rate Date")
                {
                }
                field("ISIN Code";"ISIN Code")
                {
                }
                field("Security Name";"Security Name")
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

