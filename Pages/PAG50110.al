page 50110 "Investment Firms"
{
    CaptionML = DAN='Investeringsselskaber',
                ENU='Investment Firms';
    PageType = List;
    SourceTable = Table50110;

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

    actions
    {
    }
}

