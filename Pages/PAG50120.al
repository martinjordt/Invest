page 50120 "Account List"
{
    CaptionML = DAN='Depoter',
                ENU='Account List';
    CardPageID = "Account Card";
    Editable = false;
    PageType = List;
    SourceTable = Table50100;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Name";"Bank Name")
                {
                }
                field("Bank Branch No.";"Bank Branch No.")
                {
                }
                field("Bank Account No.";"Bank Account No.")
                {
                }
                field(Name;Name)
                {
                }
                field("Current Account Value";"Current Account Value")
                {
                }
                field("Current Profit/Loss";"Current Profit/Loss")
                {
                    CaptionML = DAN='Gevinst/Tab',
                                ENU='Profit/Loss';
                    Editable = false;
                }
                field("Security Return YTD";"Security Return YTD")
                {
                }
            }
        }
    }

    actions
    {
    }
}

