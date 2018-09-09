page 70210 "Investment Firms"
{
    Caption='Investment Firms';
    PageType = List;
    SourceTable = "Investment Firm";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field(Name;Name)
                {
                }
            }
        }
    }
}

