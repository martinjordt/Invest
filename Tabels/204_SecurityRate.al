table 70204 "Security Rate"
{
    Caption='Security Rate';    
    DrillDownPageID = 50104;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2;"Rate Date";Date)
        {
            Caption = 'Rate Date';
        }
        field(3;Type;Option)
        {
            Caption = 'Type';
            OptionMembers = "Initial Entry",Rate,"Avgr. Rate";
            OptionCaption='Initial Entry,Rate,Avgr. Rate';
        }
        field(5;"Security No.";Code[10])
        {
            Caption='Security No.';
            TableRelation = Security;
        }
        field(8;"Security Name";Text[80])
        {
            Caption='Security Name';
            CalcFormula = Lookup(Security.Name WHERE ("No."=FIELD("Security No.")));            
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"ISIN Code";Code[20])
        {
            Caption='ISIN Code';
        }
        field(11;Rate;Decimal)
        {
            Caption='Rate';
        }
        field(12;"Avgr. Rate Calculated";Boolean)
        {
            Caption='Avgr. Rate Calculated';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {}
        key(Key2;"Rate Date")
        {}
    }
}

