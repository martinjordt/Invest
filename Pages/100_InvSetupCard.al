page 70100 "Investment Setup"
{
    Caption = 'Investment Setup';
    PageType = Card;
    SourceTable = "Investment Setup";

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

