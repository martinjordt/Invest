page 50132 "Security FactBox - Rate"
{
    CaptionML = DAN='Kurser',
                ENU='Rates';
    PageType = CardPart;
    SourceTable = Table50104;
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
                field(Type;Type)
                {
                }
                field(Rate;Rate)
                {
                }
            }
        }
    }

    actions
    {
    }
}

