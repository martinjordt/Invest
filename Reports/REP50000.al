report 50000 "Import Rate from file"
{
    CaptionML = DAN='Indlæs rate fra fil',
                ENU='Import Rate from file';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem1161021000;Table2000000026)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number=CONST(1));

            trigger OnAfterGetRecord();
            var
                ImportRatesfromFile : Codeunit "50020";
            begin
                ImportRatesfromFile.ImportFile(FileName);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Indstillinger)
                {
                    CaptionML = DAN='Indstillinger',
                                ENU='Options';
                    field(FileName;FileName)
                    {
                        CaptionML = DAN='Filnavn',
                                    ENU='File Name';

                        trigger OnAssistEdit();
                        var
                            FileManagement : Codeunit "419";
                        begin
                            FileName := FileManagement.OpenFileDialog(Text002,FileName,FileManagement.GetToFilterText('','.txt'));
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        IF FileName = '' THEN
          ERROR(Text001);
    end;

    var
        FileName : Text;
        Text001 : TextConst DAN='Du skal angive et filnavn',ENU='You must enter a filename';
        Text002 : TextConst DAN='Indlæs fra tekstfil',ENU='Import from Text File';
}

