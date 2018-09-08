page 50000 "Investment Setup"
{
    CaptionML = DAN='Investeringsopsætning',
                ENU='Investment Setup';
    PageType = Card;
    SourceTable = Table50000;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account Nos.";"Account Nos.")
                {
                }
                field("Security Nos.";"Security Nos.")
                {
                }
                field("Invest. Firm Nos.";"Invest. Firm Nos.")
                {
                }
            }
            group("Indlæsninger")
            {
                CaptionML = DAN='Indlæsninger',
                            ENU='Import';
                field("Import folder - Rates";"Import folder - Rates")
                {
                }
                field("Backup folder - Rates";"Backup folder - Rates")
                {
                }
            }
        }
    }

    actions
    {
    }
}

