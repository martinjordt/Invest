page 70203 "Security Returns"
{
    Caption='Security Returns';
    Editable = false;
    PageType = List;
    SourceTable = "Security Return";
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
                field(Date;"Posting Date")
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
                field("No. of Shares";"No. of Shares")
                {
                }
                field("Gros Return Amount";"Gros Return Amount")
                {
                }
                field("Net Return Amount";"Net Return Amount")
                {
                }
                field("Return pr Share Gross";"Return pr Share Gross")
                {
                }
                field("Return pr Share Net";"Return pr Share Net")
                {
                }
                field("ROI Gross";"ROI Gross")
                {
                }
                field("ROI Net";"ROI Net")
                {
                }
            }
        }
        area(factboxes)
        {
            part(;50212)
            {
                SubPageLink = "Entry No."=FIELD("Entry No.");
                SubPageView = SORTING("posting date");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenAttachment)
            {
                Caption='Open Attachment';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    DropAreaMgt : Codeunit "Drop Area Mgt. Return";
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

