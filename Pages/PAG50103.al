page 50103 "Security Returns"
{
    CaptionML = DAN='Værdipapirudbetalinger',
                ENU='Security Returns';
    Editable = false;
    PageType = List;
    SourceTable = Table50103;
    SourceTableView = SORTING(Date)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(HasAttachment;HasAttachment)
                {
                    CaptionML = DAN='Vedhæftet fil',
                                ENU='Has Attachemnt';
                    Editable = false;
                }
                field(Date;Date)
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
                SubPageView = SORTING(Date);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Åben vedhæftning")
            {
                CaptionML = DAN='Åben vedhæftning',
                            ENU='Open Attachment';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    DropAreaMgt : Codeunit "50012";
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

