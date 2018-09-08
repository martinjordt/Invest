page 50100 "Account Card"
{
    CaptionML = DAN='Depotkort',
                ENU='Account Card';
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Table50100;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Name;Name)
                {
                }
                field("Bank Name";"Bank Name")
                {
                }
                field("Bank Branch No.";"Bank Branch No.")
                {
                }
                field("Bank Account No.";"Bank Account No.")
                {
                }
                field("Current Account Value";"Current Account Value")
                {
                }
                field("Current Profit/Loss";"Current Profit/Loss")
                {
                }
                field("Security Return LY";"Security Return LY")
                {
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

