page 70252 "Security Journal Rate"
{
    AutoSplitKey = true;
    Caption='Investment Journal';
    DelayedInsert = true;
    PageType = Worksheet;
    PromotedActionCategories='New,Process';
    SaveValues = true;
    SourceTable = "Security Journal Line";
    SourceTableView = WHERE("Entry Type"=CONST("Security Rate"));

    layout
    {
        area(content)
        {
            repeater(lines)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip='Specifies the posting date for the entry.';
                }
                field("Account No.";"Account No.")
                {
                }
                field("Account Name";"Account Name")
                {
                }
                field("Security No.";"Security No.")
                {
                }
                field("Security Name";"Security Name")
                {
                    Editable = false;
                }
                field("ISIN Code";"ISIN Code")
                {
                    Editable = false;
                }
                field("Security Type";"Security Type")
                {
                    Editable = false;
                }
                field("Share Price";"Share Price")
                {
                }
                field(GainLoss;GainLoss)
                {
                    Caption='Gain/Loss';
                    Editable = false;
                    StyleExpr = StyleExprVar;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip='Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip='Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field(ShortcutDimCode[3];ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(3),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode[4];ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(4),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode[5];ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(5),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode[6];ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(6),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode[7];ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(7),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode[8];ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(8),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
            }
            group()
            {
                fixed()
                {
                    group(InvFirm)
                    {
                        Caption='Inv. Firm Name';
                        field(AccName;AccName)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip='Specifies the name of the account.';
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(;50213)
            {
                SubPageLink = "Journal Template Name"=FIELD("Journal Template Name"),
                              "Line No."=FIELD("Line No.");
                SubPageView = SORTING("Journal Template Name","Line No.");
            }
            part(;699)
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Dimension Set ID"=FIELD("Dimension Set ID");
            }
            systempart(Links;Links)
            {
                Visible = false;
            }
            systempart(Notes;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function")
            {
                Caption='Functions';
                Image = "Action";
                action(Post)
                {
                    ApplicationArea = Basic,Suite;
                    Caption='Post';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip='Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction();
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Investment Jnl. Mgt.",Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action(Import)
                {
                    Caption='Import file';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Import Rate from file";
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        CALCFIELDS("Investment Firm Name");
        AccName := "Investment Firm Name";
    end;

    trigger OnAfterGetRecord();
    var
        SecurityFunctions : Codeunit "Security Functions";
    begin
        ShowShortcutDimCode(ShortcutDimCode);

        GainLoss := FORMAT(ROUND("Share Gain/Loss",0.01,'=')) + '%';
        IF "Share Gain/Loss" > 0 THEN
          GainLoss := '+' + GainLoss;

        StyleExprVar := SecurityFunctions.SetStyleExpr_Jnl(Rec);
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        SetUpNewLine(xRec,2);
        CLEAR(ShortcutDimCode);
        CLEAR(AccName);
    end;

    var
        InvestJnlMgt : Codeunit "Investment Jnl. Mgt.";
        AccName : Text[50];
        ShortcutDimCode : array [8] of Code[20];
        Text000 : label 'General Journal lines have been successfully inserted from Standard General Journal %1.';
        Text001 : label 'Standard General Journal %1 has been successfully created.';
        AccTypeNotSupportedErr : label 'You cannot specify a deferral code for this type of account.';
        GainLoss : Text;
        StyleExprVar : Text;
}

