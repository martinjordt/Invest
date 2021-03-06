codeunit 70400 "Drop Area Management"
{
    // version DropArea


    trigger OnRun();
    begin
    end;

    var
        ReadAsDataUrlHeader : Label 'data:';
        ProgressText : Label 'File upload in progress...\#1########################################\@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        CurrentFilename : Text;
        FromMemoryStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
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

    procedure FileDropEnd();
    var
        ToMemoryStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
        FileStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
        FileMode : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
        FileAccess : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileAccess";
        DropAreaFile : Record "50400";
        OStream : OutStream;
    begin
        ToMemoryStream := ToMemoryStream.MemoryStream();

        Base64Decode(FromMemoryStream, ToMemoryStream);

        DropAreaFile."Entry No." := 0;
        DropAreaFile."File Name" := CurrentFilename;
        DropAreaFile."File Content".CREATEOUTSTREAM(OStream);
        ToMemoryStream.WriteTo(OStream);
        DropAreaFile.INSERT(TRUE);

        ToMemoryStream.Close();
        FromMemoryStream.Close();

        CLEAR(OStream);
        CLEAR(CurrentFilename);

        FileDropInProgress := FALSE;
    end;

    procedure IsFileDropInProgress() : Boolean;
    begin
        EXIT(FileDropInProgress);
    end;

    procedure GetCurrentFilename() : Text;
    begin
        EXIT(CurrentFilename);
    end;

    procedure Download(DropAreaFile : Record "Drop Area File");
    var
        FileMgt : Codeunit "File Management";
        TempBlob : Record "TempBlob";
    begin
        IF NOT DropAreaFile."File Content".HASVALUE THEN
          EXIT;

        DropAreaFile.CALCFIELDS("File Content");
        TempBlob.Blob := DropAreaFile."File Content";
        FileMgt.BLOBExport(TempBlob,DropAreaFile."File Name",TRUE);
    end;
}

