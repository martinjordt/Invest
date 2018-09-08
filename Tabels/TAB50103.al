table 50103 "Security Return"
{
    CaptionML = DAN='Værdipapirudbytte',
                ENU='Security Return';
    DrillDownPageID = 50103;
    LookupPageID = 50103;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
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
        field(6;"Security Type";Option)
        {
            CaptionML = DAN='Værdipapirtype',
                        ENU='Security Type';
            OptionCaptionML = DAN='Danske aktier,Globale aktier,Danske obligationer,Globale obligationer',
                              ENU='Danish Stock,Forign Stock,Danish Bond,Forign Bond';
            OptionMembers = "Danish Stock","Forign Stock","Danish Bond","Forign Bond";
        }
        field(7;Risk;Integer)
        {
            CaptionML = DAN='Risiko',
                        ENU='Risk';
            MaxValue = 7;
            MinValue = 1;
        }
        field(8;"Security Name";Text[80])
        {
            CalcFormula = Lookup(Security.Name WHERE (No.=FIELD(Security No.)));
            CaptionML = DAN='Værdipapirnavn',
                        ENU='Security Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"Investment Firm";Code[20])
        {
            CaptionML = DAN='Investeringsselskab',
                        ENU='Investment Firm';
            TableRelation = "Investment Firm";
        }
        field(10;"ISIN Code";Text[20])
        {
            CaptionML = DAN='ISIN kode',
                        ENU='ISIN Code';
        }
        field(11;"Gros Return Amount";Decimal)
        {
            CaptionML = DAN='Brutto udbyttebeløb',
                        ENU='Gros Return Amount';
        }
        field(12;"Net Return Amount";Decimal)
        {
            CaptionML = DAN='Netto udbyttebeløb',
                        ENU='Net Return Amount';
        }
        field(13;"No. of Shares";Integer)
        {
            CaptionML = DAN='Antal',
                        ENU='No. of Shares';

            trigger OnValidate();
            begin
                Calculate;
            end;
        }
        field(14;"Return pr Share Gross";Decimal)
        {
            CaptionML = DAN='Udbytte pr stk. brutto',
                        ENU='Return pr Share Gross';
        }
        field(15;"Return pr Share Net";Decimal)
        {
            CaptionML = DAN='Udbytte pr stk. netto',
                        ENU='Return pr Share Net';
        }
        field(20;"ROI Gross";Decimal)
        {
            CaptionML = DAN='ROI Brutto',
                        ENU='ROI Gross';
        }
        field(21;"ROI Net";Decimal)
        {
            CaptionML = DAN='ROI Netto',
                        ENU='ROI Net';
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

    procedure Calculate();
    var
        SecurityRate : Record "50104";
    begin
        TESTFIELD(Date);
        TESTFIELD("Gros Return Amount");
        TESTFIELD("Net Return Amount");
        TESTFIELD("No. of Shares");

        // Return pr Share
        "Return pr Share Gross" := "Gros Return Amount" / "No. of Shares";
        "Return pr Share Net" := "Net Return Amount" / "No. of Shares";

        // Return pr invested amount
        SecurityRate.RESET;
        SecurityRate.SETCURRENTKEY(Date);
        SecurityRate.SETRANGE("Security No.","Security No.");
        SecurityRate.SETFILTER(Date,'<=%1',Date);
        IF NOT SecurityRate.FINDLAST THEN BEGIN
          SecurityRate.SETRANGE(Date);
          SecurityRate.FINDFIRST;
        END;

        "ROI Gross" := "Gros Return Amount" / ("No. of Shares" * SecurityRate.Rate);
        "ROI Net" := "Net Return Amount" / ("No. of Shares" * SecurityRate.Rate);
    end;
}

