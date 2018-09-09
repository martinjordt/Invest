page 70221 "Security List"
{
    Caption='Security List';
    CardPageID = "Security Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    PromotedActionCategories='New,Process,Report,Security,Entries';
    SourceTable = Security;
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
                    Caption='Gain/Loss Latest';
                    StyleExpr = StyleExprVar2;
                }
                field(GainLoss2;GainLoss2)
                {
                    Caption='Gain/Loss Overall';
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
            group(PeriodicActivity)
            {
                Caption='Periodic Activities';
                action(BuySell)
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
                action(UpdateRate)
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
                action(RegisterReturn)
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
            group(Entries)
            {
                Caption='Entries';
                action(Trades)
                {
                    Caption='Trades';
                    Image = CashFlow;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page 50102;
                    RunPageLink = "Security No."=FIELD("No."),
                                  "Account No."=FIELD("Account No.");
                }
                action(Returns)
                {
                    Caption='Returns';
                    Image = CoupledCurrency;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page 50103;
                    RunPageLink = "Security No."=FIELD("No."),
                                  "Account No."=FIELD("Account No.");
                }
                action(Rates)
                {
                    Caption='Rates';
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
        SecurityFunctions : Codeunit "Security Functions";
        StyleExprVar : Text;
        StyleExprVar2 : Text;
        StyleExprVar3 : Text;
        GainLoss1 : Text;
        GainLoss2 : Text;
}

