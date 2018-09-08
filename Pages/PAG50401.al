page 50401 "Drop Area Files"
{
    // version DropArea

    PageType = List;
    SourceTable = Table50400;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    Visible = false;
                }
                field("File Name";"File Name")
                {
                }
                field("File Content";"File Content")
                {
                }
            }
        }
        area(factboxes)
        {
            part(;50400)
            {
                SubPageLink = "Entry No."=FIELD("Entry No.");
                SubPageView = SORTING(Entry No.);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Download)
            {
                Caption = 'Download';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    DropAreaMgt.Download(Rec);
                end;
            }
        }
    }

    var
        DropAreaMgt : Codeunit "50400";
}

