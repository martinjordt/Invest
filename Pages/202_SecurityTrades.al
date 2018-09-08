page 70202 "Security Trades"
{
    Caption='Security Trades';
    Editable = false;
    PageType = List;
    SourceTable = "Security Trade";
    SourceTableView = SORTING("Posting Date")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(HasAttachment;HasAttachment)
                {
                    Caption='Has Attachemnt';
                    Editable = false;
                }
                field("posting Date";"Posting Date")
                {
                }
                field("Account No.";"Account No.")
                {
                }
                field("ISIN Code";"ISIN Code")
                {
                }
                field("Security Name";"Security Name")
                {
                }
                field("Entry Type";"Entry Type")
                {
                }
                field("Trade Rate";"Trade Rate")
                {
                }
                field("No. of Shares";"No. of Shares")
                {
                }
                field("Trade Amount";"Trade Amount")
                {
                }
                field("Current Rate";"Current Rate")
                {
                    BlankZero = true;
                }
                field("Current Amt.";"Current Amt.")
                {
                    BlankZero = true;
                }
            }
        }
        area(factboxes)
        {
            part(;50211)
            {
                SubPageLink = "Entry No."=FIELD("Entry No.");
                SubPageView = SORTING("Posting Date");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("OpenAttachment")
            {
                Caption='Open Attachment';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    DropAreaMgt : Codeunit "Drop Area Mgt. Trade";
                begin
                    DropAreaMgt.Download(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        CALCFIELDS(Attachment);
        HasAttachment := Attachment.HASVALUE;
    end;

    var
        HasAttachment : Boolean;
}

