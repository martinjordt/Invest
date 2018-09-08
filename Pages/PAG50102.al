page 50102 "Security Trades"
{
    CaptionML = DAN='Værdipapirhandler',
                ENU='Security Trades';
    Editable = false;
    PageType = List;
    SourceTable = Table50102;
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
                SubPageLink = Entry No.=FIELD(Entry No.);
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
                    DropAreaMgt : Codeunit "50011";
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

