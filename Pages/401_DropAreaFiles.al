page 70401 "Drop Area Files"
{
    // version DropArea

    PageType = List;
    SourceTable = "Drop Area File";

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
            part(DropArea;"Drop Area")
            {
                SubPageLink = "Entry No."=FIELD("Entry No.");
                SubPageView = SORTING("Entry No.");
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
        DropAreaMgt : Codeunit "Drop Area Management";
}

