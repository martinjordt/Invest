page 70220 "Account List"
{
    Caption='Account List';
    CardPageID = "Account Card";
    Editable = false;
    PageType = List;
    SourceTable = "Account";

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
                    Caption='Profit/Loss';
                    Editable = false;
                }
                field("Security Return YTD";"Security Return YTD")
                {
                }
            }
        }
    }
}

