table 50102 "Security Trade"
{
    CaptionML = DAN='Værdipapirhandel',
                ENU='Security Trade';
    DrillDownPageID = 50102;
    LookupPageID = 50102;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
            CaptionML = DAN='Løbenr.',
                        ENU='Entry No.';
        }
        field(2;Date;Date)
        {
            CaptionML = DAN='Dato',
                        ENU='Date';
        }
        field(4;"Account No.";Text[30])
        {
            CaptionML = DAN='Depotnr.',
                        ENU='Account No.';
            TableRelation = Account;
        }
        field(5;"Security No.";Code[10])
        {
            CaptionML = DAN='Værdipapirnummer',
                        ENU='Security No.';
            TableRelation = Security;
        }
        field(8;"Security Name";Text[80])
        {
            CalcFormula = Lookup(Security.Name WHERE (No.=FIELD(Security No.)));
            CaptionML = DAN='Værdipapirnavn',
                        ENU='Security Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"ISIN Code";Code[20])
        {
            CaptionML = DAN='ISIN kode',
                        ENU='ISIN Code';
        }
        field(20;"Entry Type";Option)
        {
            CaptionML = DAN='Posttype',
                        ENU='Entry Type';
            OptionCaptionML = DAN='Køb,Salg',
                              ENU='Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(21;"Trade Rate";Decimal)
        {
            CaptionML = DAN='Handelskurs',
                        ENU='Trade Rate';
        }
        field(22;"No. of Shares";Integer)
        {
            CaptionML = DAN='Antal',
                        ENU='No. of Shares';
        }
        field(23;"Trade Amount";Decimal)
        {
            CaptionML = DAN='Handelsbeløb',
                        ENU='Trade Amount';
        }
        field(30;"Current Rate";Decimal)
        {
            CaptionML = DAN='Aktuel kurs',
                        ENU='Current Rate';
            Editable = false;
        }
        field(31;"Current Amt.";Decimal)
        {
            CaptionML = DAN='Aktuel værdi',
                        ENU='Current Share Amt.';
            Editable = false;
        }
        field(200;Attachment;BLOB)
        {
            CaptionML = DAN='Vedhæftning',
                        ENU='Attachment';
        }
        field(201;"File Name";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;Date)
        {
        }
    }

    fieldgroups
    {
    }
}

