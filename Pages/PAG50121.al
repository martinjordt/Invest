page 50121 "Security List"
{
    CaptionML = DAN='Værdipapire',
                ENU='Security List';
    CardPageID = "Security Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    PromotedActionCategoriesML = DAN='Ny,Behandl,Rapportér,Værdipapir,Poster',
                                 ENU='New,Process,Report,Security,Entries';
    SourceTable = Table50101;
    SourceTableView = SORTING(Status)
                      WHERE(Status=FILTER(Active|Inactive));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ISIN Code";"ISIN Code")
                {
                    StyleExpr = StyleExprVar;
                }
                field(Name;Name)
                {
                    StyleExpr = StyleExprVar;
                }
                field("Security Type";"Security Type")
                {
                }
                field(Taxation;Taxation)
                {
                }
                field("Investment Firm";"Investment Firm")
                {
                }
                field("Investment Firm Name";"Investment Firm Name")
                {
                }
                field(Risk;Risk)
                {
                    ExtendedDatatype = Ratio;
                }
                field("Morning Star Rating";"Morning Star Rating")
                {
                    ExtendedDatatype = Ratio;
                }
                field("Current Share Rate";"Current Share Rate")
                {
                    Visible = false;
                }
                field("No. of Shares";"No. of Shares")
                {
                }
                field("Current Share Amt.";"Current Share Amt.")
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
                    Visible = false;
                }
                field("ROI LY per 1000";"ROI LY per 1000")
                {
                }
                field("ROI YTD per 1000";"ROI YTD per 1000")
                {
                }
                field(GainLoss1;GainLoss1)
                {
                    CaptionML = DAN='Gevinst/Tab senest',
                                ENU='Gain/Loss Latest';
                    StyleExpr = StyleExprVar2;
                }
                field(GainLoss2;GainLoss2)
                {
                    CaptionML = DAN='Gevinst/Tab i alt',
                                ENU='Gain/Loss Overall';
                    StyleExpr = StyleExprVar3;
                }
            }
        }
        area(factboxes)
        {
            part(;50132)
            {
                SubPageLink = "Security No."=FIELD("No.");
            }
            part(;50131)
            {
                SubPageLink = "Account No."=FIELD("Account No."),
                              "Security No."=FIELD("No.");
            }
            part(;50130)
            {
                SubPageLink = "Account No."=FIELD("Account No."),
                              "Security No."=FIELD("No.");
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
                    RunPageLink = "Security No."=FIELD("No."),
                                  "Account No."=FIELD("Account No.");
                }
                action(Udbytte)
                {
                    CaptionML = DAN='Udbytte',
                                ENU='Returns';
                    Image = CoupledCurrency;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page 50103;
                    RunPageLink = "Security No."=FIELD("No."),
                                  "Account No."=FIELD("Account No.");
                }
                action(Kurser)
                {
                    CaptionML = DAN='Kurser',
                                ENU='Rates';
                    Image = PayrollStatistics;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page 50104;
                    RunPageLink = "Security No."=FIELD("No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        GainLoss1 := FORMAT(ROUND("Share Gain/Loss Latest",0.01,'=')) + '%';
        IF "Share Gain/Loss Latest" > 0 THEN
          GainLoss1 := '+' + GainLoss1;

        GainLoss2 := FORMAT(ROUND("Share Gain/Loss Overall",0.01,'=')) + '%';
        IF "Share Gain/Loss Overall" > 0 THEN
          GainLoss2 := '+' + GainLoss2;

        SecurityFunctions.SetStyleExpr_Security(Rec,StyleExprVar,StyleExprVar2,StyleExprVar3);
    end;

    var
        SecurityFunctions : Codeunit "50006";
        StyleExprVar : Text;
        StyleExprVar2 : Text;
        StyleExprVar3 : Text;
        GainLoss1 : Text;
        GainLoss2 : Text;
}

