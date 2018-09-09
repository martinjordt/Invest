page 70260 "Security Jnl. - Drop Area"
{
    Caption='File Drag and Drop';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    SourceTable = "Security Journal Line";
    SourceTableView = SORTING("Journal Template Name","Line No.");

    layout
    {
        area(content)
        {
            field(DropArea;'')
            {
                //The property ControlAddIn is not yet supported. Please convert manually.
                //ControlAddIn = 'DropAreaControl;PublicKeyToken=b33780e0a1cf8256';
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction : Action) : Boolean;
    begin
        EXIT(NOT DropAreaMgt.IsFileDropInProgress());
    end;

    var
        DropAreaMgt : Codeunit "Drop Area Mgt. Journal Line";

    //event DropArea();
    //begin
        /*
        */
    //end;

    //event DropArea(filename : Text);
    //begin
        /*
        CLEAR(DropAreaMgt);
        DropAreaMgt.FileDropBegin(filename);
        CurrPage.DropArea.ReadyForData(filename);
        */
    //end;

    //event DropArea(data : Text);
    //begin
        /*
        DropAreaMgt.FileDrop(data);
        CurrPage.DropArea.ReadyForData(DropAreaMgt.GetCurrentFilename());
        */
    //end;

    //event DropArea();
    //begin
        /*
        DropAreaMgt.FileDropEnd(Rec);
        CurrPage.UPDATE(FALSE);
        */
    //end;
}

