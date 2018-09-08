page 50101 "Security Card"
{
    CaptionML = DAN='Værdipapirkort',
                ENU='Security Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategoriesML = DAN='Ny,Behandl,Rapportér,Værdipapir,Poster',
                                 ENU='New,Process,Report,Security,Entries';
    RefreshOnActivate = true;
    SourceTable = Table50101;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Name;Name)
                {
                }
                field("Search Name";"Search Name")
                {
                }
                field("Investment Firm";"Investment Firm")
                {
                }
                field("Investment Firm Name";"Investment Firm Name")
                {
                }
                field("Security Type";"Security Type")
                {
                }
                field("ISIN Code";"ISIN Code")
                {
                }
                field(Taxation;Taxation)
                {
                }
                field("Return Plan";"Return Plan")
                {
                }
                group("Bedømmelse")
                {
                    CaptionML = DAN='Bedømmelse',
                                ENU='Ratings';
                    grid()
                    {
                        GridLayout = Rows;
                        group(Risiko)
                        {
                            CaptionML = DAN='Risiko',
                                        ENU='Risk';
                            field(RiskRatio;Risk)
                            {
                                ColumnSpan = 2;
                                ExtendedDatatype = Ratio;
                                ShowCaption = false;
                            }
                            field(Risk;Risk)
                            {
                                ColumnSpan = 2;
                                ShowCaption = false;
                            }
                        }
                        group("Morning Star")
                        {
                            CaptionML = DAN='Morning Star',
                                        ENU='Morning Star';
                            field(MSRatio;"Morning Star Rating")
                            {
                                ColumnSpan = 2;
                                ExtendedDatatype = Ratio;
                                ShowCaption = false;
                            }
                            field("Morning Star Rating";"Morning Star Rating")
                            {
                                ColumnSpan = 2;
                                ShowCaption = false;
                            }
                        }
                    }
                }
                group(Handel)
                {
                    CaptionML = DAN='Handel',
                                ENU='Trade';
                    grid()
                    {
                        GridLayout = Rows;
                        group()
                        {
                            field("Total Purchase Amt.";"Total Purchase Amt.")
                            {
                            }
                            field("Total Sales Amt.";"Total Sales Amt.")
                            {
                            }
                            field("Realised Profit/Loss";"Realised Profit/Loss")
                            {
                            }
                        }
                    }
                }
                group("Værdi")
                {
                    CaptionML = DAN='Værdi',
                                ENU='Value';
                    grid()
                    {
                        GridLayout = Rows;
                        group()
                        {
                            field("Current Share Rate";"Current Share Rate")
                            {
                            }
                            field("No. of Shares";"No. of Shares")
                            {
                            }
                            field("Current Share Amt.";"Current Share Amt.")
                            {
                            }
                            field("Current Profit/Loss";"Current Profit/Loss")
                            {
                            }
                        }
                    }
                }
                group(Udbytte)
                {
                    CaptionML = DAN='Udbytte',
                                ENU='Returns';
                    grid()
                    {
                        GridLayout = Rows;
                        group()
                        {
                            field("Last Return Date";"Last Return Date")
                            {
                            }
                            field("Last Return Amt.";"Last Return Amt.")
                            {
                            }
                            field("Return Amt. LY";"Return Amt. LY")
                            {
                            }
                            field("Return Amt. YTD";"Return Amt. YTD")
                            {
                            }
                            field("Total Return Amt.";"Total Return Amt.")
                            {
                            }
                        }
                    }
                }
                group(Kurs)
                {
                    CaptionML = DAN='Kurs',
                                ENU='Rate';
                    grid()
                    {
                        GridLayout = Rows;
                        group()
                        {
                            field(GainLoss1;GainLoss1)
                            {
                                CaptionML = DAN='Gevinst/Tab senest',
                                            ENU='Gain/Loss Latest';
                                ColumnSpan = 2;
                                Editable = false;
                            }
                            field(GainLoss2;GainLoss2)
                            {
                                CaptionML = DAN='Gevinst/Tab i alt',
                                            ENU='Gain/Loss Overall';
                                ColumnSpan = 2;
                                Editable = false;
                            }
                        }
                    }
                }
                group(ROI)
                {
                    CaptionML = DAN='ROI',
                                ENU='ROI';
                    grid()
                    {
                        GridLayout = Rows;
                        group()
                        {
                            field("Last ROI per 1000";"Last ROI per 1000")
                            {
                            }
                            field("ROI LY per 1000";"ROI LY per 1000")
                            {
                            }
                            field("ROI YTD per 1000";"ROI YTD per 1000")
                            {
                            }
                            field("Avgr. ROI per Y per 1000";"Avgr. ROI per Y per 1000")
                            {
                            }
                        }
                    }
                }
            }
            part(RatePart;50141)
            {
                CaptionML = DAN='Kurser',
                            ENU='Rates';
            }
        }
        area(factboxes)
        {
            part(ReturnPart;50140)
            {
                CaptionML = DAN='Udbytte',
                            ENU='Returns';
            }
            part(ReturnPart2;50142)
            {
                CaptionML = DAN='ROI',
                            ENU='ROI';
            }
            part(;50131)
            {
                SubPageLink = Account No.=FIELD(Account No.),
                              Security No.=FIELD(No.);
            }
            part(;50130)
            {
                SubPageLink = Account No.=FIELD(Account No.),
                              Security No.=FIELD(No.);
            }
            part(;50132)
            {
                SubPageLink = Security No.=FIELD(No.);
            }
            systempart(;Links)
            {
            }
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Periodiske aktiviteter")
            {
                CaptionML = DAN='Periodiske aktiviteter',
                            ENU='Periodic Activities';
                action("Køb/Sælg")
                {
                    CaptionML = DAN='Køb/Sælg',
                                ENU='Buy/Sell';
                    Image = Bank;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        BuySell();
                    end;
                }
                action("Opdater kurser")
                {
                    CaptionML = DAN='Opdater kurser',
                                ENU='Update Rates';
                    Image = NewExchangeRate;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        UpdateRate();
                    end;
                }
                action("Registrer udbytte")
                {
                    CaptionML = DAN='Registrer udbytte',
                                ENU='Register Return';
                    Image = CalculateDiscount;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        RegisterReturn();
                    end;
                }
            }
            group(Poster)
            {
                CaptionML = DAN='Poster',
                            ENU='Entries';
                action(Handler)
                {
                    CaptionML = DAN='Handler',
                                ENU='Trades';
                    Image = CashFlow;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page 50102;
                    RunPageLink = Security No.=FIELD(No.),
                                  Account No.=FIELD(Account No.);
                }
                action(Udbytte)
                {
                    CaptionML = DAN='Udbytte',
                                ENU='Returns';
                    Image = CoupledCurrency;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page 50103;
                    RunPageLink = Security No.=FIELD(No.),
                                  Account No.=FIELD(Account No.);
                }
                action(Kurser)
                {
                    CaptionML = DAN='Kurser',
                                ENU='Rates';
                    Image = PayrollStatistics;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page 50104;
                    RunPageLink = Security No.=FIELD(No.);
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        CurrPage.RatePart.PAGE.SetGlobal(Rec);
        CurrPage.RatePart.PAGE.UpdateChart(0);
        CurrPage.ReturnPart.PAGE.SetGlobal(Rec);
        CurrPage.ReturnPart.PAGE.UpdateChart(0);
        CurrPage.ReturnPart2.PAGE.SetGlobal(Rec);
        CurrPage.ReturnPart2.PAGE.UpdateChart(0);

        GainLoss1 := FORMAT(ROUND("Share Gain/Loss Latest",0.01,'=')) + '%';
        IF "Share Gain/Loss Latest" > 0 THEN
          GainLoss1 := '+' + GainLoss1;

        GainLoss2 := FORMAT(ROUND("Share Gain/Loss Overall",0.01,'=')) + '%';
        IF "Share Gain/Loss Overall" > 0 THEN
          GainLoss2 := '+' + GainLoss2;
    end;

    var
        GainLoss1 : Text;
        GainLoss2 : Text;
}

