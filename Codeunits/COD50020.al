codeunit 50020 "Import Rates from File"
{

    trigger OnRun();
    begin
        Code;
    end;

    var
        InvestmentSetup : Record "50000";
        Window : Dialog;
        Text001 : TextConst DAN='Indlæser kurser: #1###################',ENU='Importing Rates: #1###################';
        WindowOpen : Boolean;
        Text002 : TextConst DAN='Fejl i tekstfilformatet!',ENU='Error in text file format!';
        AutoPost : Boolean;
        DisableAutoPost : Boolean;

    local procedure "Code"();
    begin
        InvestmentSetup.GET;
        InvestmentSetup.TESTFIELD("Import folder - Rates");
        InvestmentSetup.TESTFIELD("Backup folder - Rates");
        InvestmentSetup."Backup folder - Rates" := DELCHR(InvestmentSetup."Backup folder - Rates",'>','\');
        CLEAR(InvestmentSetup."Import BLOB");

        AutoPost := NOT DisableAutoPost;  // Post Journal after import
        HandleFiles; // Read files in folder
    end;

    local procedure HandleFiles();
    var
        dnStrArray : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
        dnDirectory : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Directory";
        dnFile : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.File";
        dnFileInfo : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileInfo";
        CurrFile : Text;
        NewFile : Text;
        IsFile : Boolean;
        i : Integer;
    begin
        IF GUIALLOWED THEN BEGIN
          Window.OPEN(Text001);
          WindowOpen := TRUE;
        END;

        // Files into array
        dnStrArray  := dnDirectory.GetFileSystemEntries(InvestmentSetup."Import folder - Rates");

        // Loop through array
        FOR i := 0 TO (dnStrArray.Length - 1) DO BEGIN
          CurrFile := dnStrArray.GetValue(i);
          IsFile := dnFile.Exists(CurrFile);

          // Import file
          IF IsFile THEN BEGIN
            ImportFile(CurrFile);

            // Commit so we don't loose files in case of later error
            COMMIT;

            // Isolate filename
            NewFile := CurrFile;
            WHILE STRPOS(NewFile,'\') <> 0 DO
              NewFile := COPYSTR(NewFile,STRPOS(NewFile,'\')+1,STRLEN(NewFile));
            NewFile := InvestmentSetup."Backup folder - Rates" + '\' + NewFile;

            // Move the file
            dnFile.Move(CurrFile,NewFile);

          END;
        END;
    end;

    procedure ImportFile(CurrFile : Text);
    var
        Security : Record "50101";
        GenFunc : Codeunit "50005";
        IStream : InStream;
        BigTextVar : BigText;
        BigTextVar2 : BigText;
        Length : Integer;
        Pos : Integer;
        ImportString : Text;
        DateVar : Date;
    begin
        CLEAR(BigTextVar);
        CLEAR(BigTextVar2);

        InvestmentSetup."Import BLOB".IMPORT(CurrFile);
        InvestmentSetup.CALCFIELDS("Import BLOB");
        InvestmentSetup."Import BLOB".CREATEINSTREAM(IStream,TEXTENCODING::UTF8);

        BigTextVar.READ(IStream);
        Length := BigTextVar.LENGTH;

        // Find market date in file
        Pos := BigTextVar.TEXTPOS('Markedsinformation');
        IF Pos = 0 THEN
          ERROR(Text002);
        BigTextVar.GETSUBTEXT(BigTextVar2,Pos + 23,Length);
        Pos := BigTextVar2.TEXTPOS(',') - 1;
        IF Pos = 0 THEN
          ERROR(Text002);
        BigTextVar2.GETSUBTEXT(ImportString,1,Pos);
        ImportString := GenFunc.RemoveBadChars(ImportString);
        EVALUATE(DateVar,ImportString);

        // Loop Securities
        Security.RESET;
        Security.SETFILTER("Search Name",'<>%1','');
        IF Security.FINDFIRST THEN
          REPEAT

            // Find rate string
            Pos := BigTextVar.TEXTPOS(Security."Search Name");
            IF Pos <> 0 THEN BEGIN
              BigTextVar.GETSUBTEXT(BigTextVar2,Pos,Length);
              Pos := BigTextVar2.TEXTPOS('Køb') - 2;
              IF Pos <= 0 THEN
                Pos := Length;
              BigTextVar2.GETSUBTEXT(ImportString,1,Pos);
              ImportString := GenFunc.RemoveBadChars(ImportString);

              // Isolate rate from string
              IF ImportString <> '' THEN
                GetRate(Security,ImportString,DateVar);
            END;
          UNTIL Security.NEXT = 0;
    end;

    local procedure GetRate(Security : Record "50101";ImportString : Text;RateDate : Date);
    var
        FieldArray : array [20] of Text;
        SubString : Text;
        i : Integer;
    begin
        IF GUIALLOWED AND WindowOpen THEN
          Window.UPDATE(1,Security.Name);

        ImportString := DELCHR(ImportString,'<>');
        SubString := ImportString;
        CLEAR(FieldArray);

        FieldArray[1] := Security."No.";
        FieldArray[2] := Security."Search Name";
        FieldArray[3] := Security."Account No.";
        FieldArray[4] := FORMAT(RateDate);
        ImportString := COPYSTR(ImportString,STRLEN(Security."Search Name") + 1,STRLEN(ImportString));
        ImportString := DELCHR(ImportString,'<>');
        i := 4;

        WHILE STRPOS(ImportString,' ') > 0 DO BEGIN
          i := i + 1;
          SubString := COPYSTR(ImportString,1,STRPOS(ImportString,' ') - 1);
          FieldArray[i] := SubString;

          ImportString := COPYSTR(ImportString,STRLEN(SubString) + 1,STRLEN(ImportString));
          ImportString := DELCHR(ImportString,'<>');
        END;
        FieldArray[i + 1] := DELCHR(ImportString,'<>');

        // Insert rate in journal
        CreateJournalLine(FieldArray);
    end;

    local procedure CreateJournalLine(FieldArray : array [20] of Text);
    var
        SecurityJournalLine : Record "50108";
        SecurityJnlLineTMP : Record "50108" temporary;
        InvestJnlMgt : Codeunit "50000";
        NextLineNo : Integer;
        RateVar : Decimal;
        DateVar : Date;
        DateVarTest : Date;
        TimeVarTest : Time;
    begin
        NextLineNo := 10000;
        SecurityJournalLine.RESET;
        // SecurityJournalLine.SETRANGE("Journal Template Name",);
        SecurityJournalLine.SETRANGE("Entry Type",SecurityJournalLine."Entry Type"::"Security Rate");
        IF SecurityJournalLine.FINDLAST THEN
          NextLineNo := SecurityJournalLine."Line No." + 10000;

        // Currency Date & Rate
        EVALUATE(DateVar,FieldArray[4]);
        EVALUATE(RateVar,FieldArray[7]);
        // Currency Time (Just checking)
        IF NOT EVALUATE(TimeVarTest,FieldArray[8]) THEN
          EVALUATE(DateVarTest,FieldArray[8]);

        WITH SecurityJnlLineTMP DO BEGIN
          CLEAR(SecurityJnlLineTMP);
          "Line No." := NextLineNo;
          VALIDATE("Posting Date",DateVar);
          VALIDATE("Entry Type",SecurityJournalLine."Entry Type"::"Security Rate");
          VALIDATE("Security No.",FieldArray[1]);
          VALIDATE("Account No.",FieldArray[3]);
          VALIDATE("Share Price",RateVar);
          IF AutoPost THEN
            InvestJnlMgt.PostJournal(SecurityJnlLineTMP)
          ELSE BEGIN
            SecurityJournalLine := SecurityJnlLineTMP;
            SecurityJournalLine.INSERT(TRUE);
          END;
        END;
    end;

    procedure SetAutoPost(SetAutoPost : Boolean);
    begin
        IF SetAutoPost THEN
          EXIT;
        DisableAutoPost := TRUE;
    end;
}

