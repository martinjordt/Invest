table 50104 "Security Rate"
{
    CaptionML = DAN='Værdipapirkurs',
                ENU='Security Rate';
    DataCaptionFields = Field50104;
    DrillDownPageID = 50104;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;Date;Date)
        {
        }
        field(3;Type;Option)
        {
            OptionCaptionML = DAN='Åbningspost,Kurs,Gns.kurs',
                              ENU='Initial Entry,Rate,Avgr. Rate';
            OptionMembers = "Initial Entry",Rate,"Avgr. Rate";
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
        field(11;Rate;Decimal)
        {
            CaptionML = DAN='Kurs',
                        ENU='Rate';
        }
        field(12;"Avgr. Rate Calculated";Boolean)
        {
            CaptionML = DAN='Gns.kurs beregnet',
                        ENU='Avgr. Rate Calculated';
            Editable = false;
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

