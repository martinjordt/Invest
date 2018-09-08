page 50104 "Security Rates"
{
    CaptionML = DAN='Værdipapirkurser',
                ENU='Security Rates';
    Editable = false;
    PageType = List;
    SourceTable = Table50104;
    SourceTableView = SORTING(Date)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date;Date)
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

    actions
    {
    }
}

