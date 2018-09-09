page 70201 "Security Card"
{
    Caption='Security Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories='New,Process,Report,Security,Entries';
    RefreshOnActivate = true;
    SourceTable = Security;

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
                group(Rating)
                {
                    Caption='Ratings';
                    grid(ratinggrid)
                    {
                        GridLayout = Rows;
                        group(RiskGrp)
                        {
                            Caption='Risk';
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
                            Caption='Morning Star';
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
                    Caption='Trade';
                    grid(tradegrid)
                    {
                        GridLayout = Rows;
                        group(tradegrp)
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
                group(ValueGrp)
                {
                    Caption='Value';
                    grid(valuegrid)
                    {
                        GridLayout = Rows;
                        group(valuegrp2)
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
                group(ReturnGrp)
                {
                    Caption='Returns';
                    grid(ReturnGridGrp)
                    {
                        GridLayout = Rows;
                        group(ReturnGrpGrp2)
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
                group(RateGrp)
                {
                    Caption='Rate';
                    grid(GridGrp)
                    {
                        GridLayout = Rows;
                        group(RateGrid)
                        {
                            field(GainLoss1;GainLoss1)
                            {
                                Caption='Gain/Loss Latest';
                                ColumnSpan = 2;
                                Editable = false;
                            }
                            field(GainLoss2;GainLoss2)
                            {
                                Caption='Gain/Loss Overall';
                                ColumnSpan = 2;
                                Editable = false;
                            }
                        }
                    }
                }
                group(ROIGrp)
                {
                    Caption='ROI';
                    grid(ROIGrid)
                    {
                        GridLayout = Rows;
                        group(GrpRows)
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
                Caption='Rates';
            }
        }
        area(factboxes)
        {
            part(ReturnPart;50140)
            {
                Caption='Returns';
            }
            part(ReturnPart2;50142)
            {
                Caption='ROI';
            }
            part(Return;50131)
            {
                SubPageLink = "Account No."=FIELD("Account No."),
                              "Security No."=FIELD("No.");
            }
            part(Trade;50130)
            {
                SubPageLink = "Account No."=FIELD("Account No."),
                              "Security No."=FIELD("No.");
            }
            part(Rate;50132)
            {
                SubPageLink = "Security No."=FIELD("No.");
            }
            systempart(Links;Links)
            {
            }
            systempart(Notes;Notes)
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
                Caption='Periodic Activities';
                action("BuySell")
                {
                    Caption='Buy/Sell';
                    Image = Bank;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        BuySell();
                    end;
                }
                action("UpdateRates")
                {
                    Caption='Update Rates';
                    Image = NewExchangeRate;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        UpdateRate();
                    end;
                }
                action("RegisterReturn")
                {
                    Caption='Register Return';
                    Image = CalculateDiscount;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        RegisterReturn();
                    end;
                }
            }
            group(EntriesGrp)
            {
                Caption='Entries';
                action(Trades)
                {
                    Caption='Trades';
                    Image = CashFlow;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Security Trades";
                    RunPageLink = "Security No."=FIELD("No."),
                                  "Account No."=FIELD("Account No.");
                }
                action(Returns)
                {
                    Caption='Returns';
                    Image = CoupledCurrency;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Security Returns";
                    RunPageLink = "Security No."=FIELD("No."),
                                  "Account No."=FIELD("Account No.");
                }
                action(Rates)
                {
                    Caption='Rates';
                    Image = PayrollStatistics;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Security Rates";
                    RunPageLink = "Security No."=FIELD("No.");
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

