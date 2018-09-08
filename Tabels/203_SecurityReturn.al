table 70203 "Security Return"
{
    Caption='Security Return';
    DrillDownPageID = 50103;
    LookupPageID = 50103;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
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
        field(6;"Security Type";Option)
        {
            Caption='Security Type';            
            OptionMembers = "Danish Stock","Forign Stock","Danish Bond","Forign Bond";
            OptionCaption='Danish Stock,Forign Stock,Danish Bond,Forign Bond';
        }
        field(7;Risk;Integer)
        {
            Caption='Risk';
            MaxValue = 7;
            MinValue = 1;
        }
        field(8;"Security Name";Text[80])
        {
            CalcFormula = Lookup(Security.Name WHERE ("No."=FIELD("Security No.")));
            Caption='Security Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"Investment Firm";Code[20])
        {
            Caption='Investment Firm';
            TableRelation = "Investment Firm";
        }
        field(10;"ISIN Code";Text[20])
        {
            Caption='ISIN Code';
        }
        field(11;"Gros Return Amount";Decimal)
        {
            Caption='Gros Return Amount';
        }
        field(12;"Net Return Amount";Decimal)
        {
            Caption='Net Return Amount';
        }
        field(13;"No. of Shares";Integer)
        {
            Caption='No. of Shares';

            trigger OnValidate();
            begin
                Calculate;
            end;
        }
        field(14;"Return pr Share Gross";Decimal)
        {
            Caption='Return pr Share Gross';
        }
        field(15;"Return pr Share Net";Decimal)
        {
            Caption='Return pr Share Net';
        }
        field(20;"ROI Gross";Decimal)
        {
            Caption='ROI Gross';
        }
        field(21;"ROI Net";Decimal)
        {
            Caption='ROI Net';
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

    procedure Calculate();
    var
        SecurityRate : Record "Security Rate";
    begin
        TESTFIELD("Posting Date");
        TESTFIELD("Gros Return Amount");
        TESTFIELD("Net Return Amount");
        TESTFIELD("No. of Shares");

        // Return pr Share
        "Return pr Share Gross" := "Gros Return Amount" / "No. of Shares";
        "Return pr Share Net" := "Net Return Amount" / "No. of Shares";

        // Return pr invested amount
        SecurityRate.RESET;
        SecurityRate.SETCURRENTKEY("Rate Date");
        SecurityRate.SETRANGE("Security No.","Security No.");
        SecurityRate.SETFILTER("Rate Date",'<=%1',"Posting Date");
        IF NOT SecurityRate.FINDLAST THEN BEGIN
          SecurityRate.SETRANGE("Rate Date");
          SecurityRate.FINDFIRST;
        END;

        "ROI Gross" := "Gros Return Amount" / ("No. of Shares" * SecurityRate.Rate);
        "ROI Net" := "Net Return Amount" / ("No. of Shares" * SecurityRate.Rate);
    end;
}

