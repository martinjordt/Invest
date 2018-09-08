codeunit 70113 "Drop Area Mgt. Rate"
{

    trigger OnRun();
    begin
    end;

    var
        ReadAsDataUrlHeader : Label 'data:';
        ProgressText : Label 'File upload in progress...\#1########################################\@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        InvestmentSetup : Record "Investment Setup";
        FromMemoryStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
        CurrentFilename : Text;
        FileDropInProgress : Boolean;

    procedure FromBase64Transform(var SourceMemoryStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";var DestinationMemoryStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream") : Integer;
    var
        FromBase64Transform : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Security.Cryptography.FromBase64Transform";
        FromBase64TransformMode : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Security.Cryptography.FromBase64TransformMode";
        InputBuffer : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
        OutputBuffer : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
        Byte : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Byte";
        BytesRead : Integer;
        BytesWritten : Integer;
        InputLength : Integer;
    begin
        FromBase64Transform := FromBase64Transform.FromBase64Transform(FromBase64TransformMode.IgnoreWhiteSpaces);

        OutputBuffer := OutputBuffer.CreateInstance(GETDOTNETTYPE(Byte), FromBase64Transform.OutputBlockSize);
        InputBuffer := SourceMemoryStream.GetBuffer();

        BytesRead := 0;
        InputLength := SourceMemoryStream.Length();

        WHILE ((InputLength - BytesRead) > 4) DO BEGIN
          BytesWritten := FromBase64Transform.TransformBlock(InputBuffer, BytesRead, 4, OutputBuffer, 0);
          BytesRead += 4;
          DestinationMemoryStream.Write(OutputBuffer, 0, BytesWritten);
        END;

        OutputBuffer := FromBase64Transform.TransformFinalBlock(InputBuffer, BytesRead, InputLength - BytesRead);
        DestinationMemoryStream.Write(OutputBuffer, 0, OutputBuffer.Length);

        FromBase64Transform.Clear();
    end;

    procedure Base64Decode(var SourceMemoryStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";var DestinationMemoryStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream") : Integer;
    var
        Buffer : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
        Convert : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
        Encoding : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
        String : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
        InputLength : Integer;
    begin
        Encoding := Encoding.Default;
        Buffer := SourceMemoryStream.GetBuffer();

        InputLength := SourceMemoryStream.Length;
        String := Encoding.GetString(Buffer, 0, InputLength);

        Buffer := Convert.FromBase64String(String);

        InputLength := Buffer.Length;
        DestinationMemoryStream.Write(Buffer, 0, InputLength);
    end;

    procedure FileDropBegin(Filename : Text);
    begin
        InvestmentSetup.GET;
        InvestmentSetup.TESTFIELD("Import folder - Rates");
        InvestmentSetup.TESTFIELD("Backup folder - Rates");
        InvestmentSetup."Import folder - Rates" := DELCHR(InvestmentSetup."Import folder - Rates",'>','\');
        InvestmentSetup."Import folder - Rates" := InvestmentSetup."Import folder - Rates" + '\';

        FileDropInProgress := TRUE;
        CurrentFilename := Filename;
        FromMemoryStream := FromMemoryStream.MemoryStream();
    end;

    procedure FileDrop(Data : Text);
    var
        Encoding : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
    begin
        IF STRPOS(Data, ReadAsDataUrlHeader) <> 0 THEN
          Data := COPYSTR(Data, STRPOS(Data, ',') + 1);

        Encoding := Encoding.Default;
        FromMemoryStream.Write(Encoding.GetBytes(Data), 0, STRLEN(Data));
    end;

    procedure FileDropEnd(var SecurityJnlRate : Record "Security Journal Line");
    var
        ImportRatesfromFile : Codeunit "50020";
        ToMemoryStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
        FileStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
        FileMode : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
        FileAccess : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileAccess";
        OStream : OutStream;
        RateFile : File;
    begin
        ToMemoryStream := ToMemoryStream.MemoryStream();

        Base64Decode(FromMemoryStream, ToMemoryStream);

        // Copy rate file to server
        RateFile.CREATE(InvestmentSetup."Import folder - Rates" + 'Rates_' + FORMAT(TODAY) + '.txt');
        RateFile.CREATEOUTSTREAM(OStream);
        ToMemoryStream.WriteTo(OStream);
        RateFile.CLOSE;

        ToMemoryStream.Close();
        FromMemoryStream.Close();

        CLEAR(OStream);
        CLEAR(CurrentFilename);

        FileDropInProgress := FALSE;

        // Import rate file to journal
        CLEAR(ImportRatesfromFile);
        ImportRatesfromFile.SetAutoPost(FALSE);
        ImportRatesfromFile.RUN;
    end;

    procedure IsFileDropInProgress() : Boolean;
    begin
        EXIT(FileDropInProgress);
    end;

    procedure GetCurrentFilename() : Text;
    begin
        EXIT(CurrentFilename);
    end;
}

