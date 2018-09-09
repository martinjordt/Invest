table 70100 "Investment Setup"
{
    Caption='Investment Setup';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption='Primary Key';
        }
        field(10;"Account Nos.";Code[10])
        {
            Caption='Account Nos.';            
        //    TableRelation = "No. Series";
        }
        field(11;"Security Nos.";Code[10])
        {
            Caption='Security Nos.';            
//            TableRelation = "No. Series";
        }
        field(12;"Invest. Firm Nos.";Code[10])
        {
            Caption='Invest. Firm Nos.';
          //  TableRelation = "No. Series";
        }
        field(20;"Import folder - Rates";Text[100])
        {
            Caption='Import folder - Rates';
        }
        field(21;"Backup folder - Rates";Text[100])
        {
            Caption='Backup folder - Rates';
        }
        field(22;"Import BLOB";BLOB)
        {
            Caption='Import BLOB';
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {}
    }
}

