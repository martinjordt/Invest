report 70100 "Import Rate from file"
{
    Caption='Import Rate from file';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem1161021000;Integer)
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
                    Caption='Options';
                    field(FileName;FileName)
                    {
                        Caption='File Name';

                        trigger OnAssistEdit();
                        var
                            FileManagement : Codeunit "File Management";
                        begin
                            FileName := FileManagement.OpenFileDialog(Text002,FileName,FileManagement.GetToFilterText('','.txt'));
                        end;
                    }
                }
            }
        }
    }

    trigger OnPreReport();
    begin
        IF FileName = '' THEN
          ERROR(Text001);
    end;

    var
        FileName : Text;
        Text001 : label 'You must enter a filename';
        Text002 : label 'Import from Text File';
}

