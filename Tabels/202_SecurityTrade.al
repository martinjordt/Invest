table 70202 "Security Trade"
{
    Caption='Security Trade';
    DrillDownPageID = 50102;
    LookupPageID = 50102;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
            Caption='Entry No.';
        }
        field(2;"Posting Date";Date)
        {
            Caption='Posting Date';
        }
        field(4;"Account No.";Text[30])
        {
            Caption='Account No.';
            TableRelation = Account;
        }
        field(5;"Security No.";Code[10])
        {
            Caption='Security No.';
            TableRelation = Security;
        }
        field(8;"Security Name";Text[80])
        {
            CalcFormula = Lookup(Security.Name WHERE ("No."=FIELD("Security No.")));
            Caption='Security Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"ISIN Code";Code[20])
        {
            Caption='ISIN Code';
        }
        field(20;"Entry Type";Option)
        {
            Caption='Entry Type';            
            OptionMembers = Purchase,Sale;
            OptionCaption='Purchase,Sale';
        }
        field(21;"Trade Rate";Decimal)
        {
            Caption='Trade Rate';
        }
        field(22;"No. of Shares";Integer)
        {
            Caption='No. of Shares';
        }
        field(23;"Trade Amount";Decimal)
        {
            Caption='Trade Amount';
        }
        field(30;"Current Rate";Decimal)
        {
            Caption='Current Rate';
            Editable = false;
        }
        field(31;"Current Amt.";Decimal)
        {
            Caption='Current Share Amt.';
            Editable = false;
        }
        field(200;Attachment;BLOB)
        {
            Caption='Attachment';
        }
        field(201;"File Name";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {}
        key(Key2;"Posting Date")
        {}
    }
}

