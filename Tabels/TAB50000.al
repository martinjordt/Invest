table 50000 "Investment Setup"
{
    CaptionML = DAN='Investeringsopsætning',
                ENU='Investment Setup';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            CaptionML = DAN='Primærnøgle',
                        ENU='Primary Key';
        }
        field(10;"Account Nos.";Code[10])
        {
            CaptionML = DAN='Depotnumre',
                        ENU='Account Nos.';
            TableRelation = "No. Series";
        }
        field(11;"Security Nos.";Code[10])
        {
            CaptionML = DAN='Værdipapirnumre',
                        ENU='Security Nos.';
            TableRelation = "No. Series";
        }
        field(12;"Invest. Firm Nos.";Code[10])
        {
            CaptionML = DAN='Investeringsselskabsnumre',
                        ENU='Invest. Firm Nos.';
            TableRelation = "No. Series";
        }
        field(20;"Import folder - Rates";Text[100])
        {
            CaptionML = DAN='Indlæsningsfolder - Kurser',
                        ENU='Import folder - Rates';
        }
        field(21;"Backup folder - Rates";Text[100])
        {
            CaptionML = DAN='Backupfolder - Kurser',
                        ENU='Backup folder - Rates';
        }
        field(22;"Import BLOB";BLOB)
        {
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

