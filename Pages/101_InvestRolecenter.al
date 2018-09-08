page 70101 "Investment Rolecenter"
{
    Caption='Investment Rolecenter';
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
                Caption='Entries';
                action(Handler)
                {
                    Caption='Trades';
                    RunObject = Page 50102;
                }
                action(Udbytte)
                {
                    Caption='Returns';
                    RunObject = Page 50103;
                }
                action(Kurser)
                {
                    Caption='Rates';
                    RunObject = Page 50104;
                }
            }
            group()
            {
                action("ROI Grafer")
                {
                    Caption='ROI Charts';
                    RunObject = Page 50300;
                }
            }
        }
        area(processing)
        {
            group(Opgaver)
            {
                Caption='Tasks';
                action("BuySell")
                {
                    Caption'Buy/Sell';
                    Image = Bank;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page 50200;
                }
                action("UpdateRates")
                {
                    Caption='Update Rates';
                    Image = NewExchangeRate;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page 50202;
                }
                action("RegisterReturn")
                {
                    Caption='Register Return';
                    Image = CalculateDiscount;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page 50201;
                }
            }
            group("Setup")
            {
                Caption='Setup';
                action("Setup")
                {
                    Caption='Setup';
                    Image = Setup;
                    RunObject = Page 50000;
                }
            }
        }
    }
}

