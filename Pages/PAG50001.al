page 50001 "Investment Rolecenter"
{
    CaptionML = DAN='Investeringsrollecenter',
                ENU='Investment Rolecenter';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group()
            {
                part(;50002)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            group(Poster)
            {
                CaptionML = DAN='Poster',
                            ENU='Entries';
                action(Handler)
                {
                    CaptionML = DAN='Handler',
                                ENU='Trades';
                    RunObject = Page 50102;
                }
                action(Udbytte)
                {
                    CaptionML = DAN='Udbytte',
                                ENU='Returns';
                    RunObject = Page 50103;
                }
                action(Kurser)
                {
                    CaptionML = DAN='Kurser',
                                ENU='Rates';
                    RunObject = Page 50104;
                }
            }
            group()
            {
                action("ROI Grafer")
                {
                    CaptionML = DAN='ROI Grafer',
                                ENU='ROI Charts';
                    RunObject = Page 50300;
                }
            }
        }
        area(processing)
        {
            group(Opgaver)
            {
                CaptionML = DAN='Opgaver',
                            ENU='Tasks';
                action("Køb/Sælg")
                {
                    CaptionML = DAN='Køb/Sælg',
                                ENU='Buy/Sell';
                    Image = Bank;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page 50200;
                }
                action("Opdater kurser")
                {
                    CaptionML = DAN='Opdater kurser',
                                ENU='Update Rates';
                    Image = NewExchangeRate;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page 50202;
                }
                action("Registrer udbytte")
                {
                    CaptionML = DAN='Registrer udbytte',
                                ENU='Register Return';
                    Image = CalculateDiscount;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page 50201;
                }
            }
            group("Opsætning")
            {
                CaptionML = DAN='Opsætning',
                            ENU='Setup';
                action("Opsætning")
                {
                    CaptionML = DAN='Opsætning',
                                ENU='Setup';
                    Image = Setup;
                    RunObject = Page 50000;
                }
            }
        }
    }
}

