codeunit 70111 "Drop Area Mgt. Trade"
{

    trigger OnRun();
    begin
    end;

    var
        ReadAsDataUrlHeader : Label 'data:';
        ProgressText : Label 'File upload in progress...\#1########################################\@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
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

    procedure FileDropEnd(var SecurityTrade : Record "Security Trade");
    var
        ToMemoryStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
        FileStream : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
        FileMode : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
        FileAccess : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileAccess";
        OStream : OutStream;
    begin
        ToMemoryStream := ToMemoryStream.MemoryStream();

        Base64Decode(FromMemoryStream, ToMemoryStream);

        SecurityTrade."File Name" := CurrentFilename;;
        SecurityTrade.Attachment.CREATEOUTSTREAM(OStream);
        ToMemoryStream.WriteTo(OStream);
        SecurityTrade.MODIFY;

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

    procedure Download(SecurityTrade : Record "Security Trade");
    var
        FileMgt : Codeunit "File Management";
        TempBlob : Record "TempBlob";
    begin
        IF NOT SecurityTrade.Attachment.HASVALUE THEN
          EXIT;

        SecurityTrade.CALCFIELDS(Attachment);
        TempBlob.Blob := SecurityTrade.Attachment;
        FileMgt.BLOBExport(TempBlob,SecurityTrade."File Name",TRUE);
    end;
}

