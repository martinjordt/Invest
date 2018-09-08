page 50201 "Security Journal Return"
{
    AutoSplitKey = true;
    CaptionML = DAN='Investeringskladde',
                ENU='Security Journal Return';
    DelayedInsert = true;
    PageType = Worksheet;
    PromotedActionCategoriesML = DAN='Ny,Behandl',
                                 ENU='New,Process';
    SaveValues = true;
    SourceTable = Table50108;
    SourceTableView = WHERE(Entry Type=CONST(Security Return));

    layout
    {
        area(content)
        {
            repeater()
            {
                field(HasAttachment;HasAttachment)
                {
                    CaptionML = DAN='Vedhæftet fil',
                                ENU='Has Attachemnt';
                    Editable = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                    ToolTipML = DAN='Angiver bogføringsdatoen for posten.',
                                ENU='Specifies the posting date for the entry.';
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
                field("No. of Shares";"No. of Shares")
                {
                }
                field("Gros Return Amount";"Gros Return Amount")
                {
                }
                field("Net Return Amount";"Net Return Amount")
                {
                }
                field("Investment Firm Name";"Investment Firm Name")
                {
                }
                field("Bank Branch No.";"Bank Branch No.")
                {
                }
                field("Bank Account No.";"Bank Account No.")
                {
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTipML = DAN='Angiver koden for Genvejsdimension 1.',
                                ENU='Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTipML = DAN='Angiver koden for Genvejsdimension 2.',
                                ENU='Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field(ShortcutDimCode[3];ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                                  Dimension Value Type=CONST(Standard),
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
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                                  Dimension Value Type=CONST(Standard),
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
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                                  Dimension Value Type=CONST(Standard),
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
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                                  Dimension Value Type=CONST(Standard),
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
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                                  Dimension Value Type=CONST(Standard),
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
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                                  Dimension Value Type=CONST(Standard),
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
                    group("Inv.selsk.navn")
                    {
                        CaptionML = DAN='Inv.selsk.navn',
                                    ENU='Inv. Firm Name';
                        field(AccName;AccName)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTipML = DAN='Angiver navnet på depotet.',
                                        ENU='Specifies the name of the account.';
                        }
                    }
                    group(Saldo)
                    {
                        CaptionML = DAN='Saldo',
                                    ENU='Balance';
                        field(Balance;Balance)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            CaptionML = DAN='Saldo',
                                        ENU='Balance';
                            Editable = false;
                            ToolTipML = DAN='Angiver den saldo, der er akkumuleret for investeringsselskabet',
                                        ENU='Specifies the balance that has accumulated for the investmentfirm.';
                        }
                    }
                    group("Total balance")
                    {
                        CaptionML = DAN='Total balance',
                                    ENU='Total Balance';
                        field(TotalBalance;TotalBalance)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            CaptionML = DAN='Total balance',
                                        ENU='Total Balance';
                            Editable = false;
                            ToolTipML = DAN='Viser den totale saldo i kladden.',
                                        ENU='Specifies the total balance in the journal.';
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(;50210)
            {
                SubPageLink = Journal Template Name=FIELD(Journal Template Name),
                              Line No.=FIELD(Line No.);
                SubPageView = SORTING(Journal Template Name,Line No.);
            }
            part(;699)
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Dimension Set ID=FIELD(Dimension Set ID);
            }
            systempart(;Links)
            {
                Visible = false;
            }
            systempart(;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Fu&nktion")
            {
                CaptionML = DAN='Fu&nktion',
                            ENU='F&unctions';
                Image = "Action";
                action(Post)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = DAN='B&ogfør',
                                ENU='P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTipML = DAN='Færdiggør bilaget eller kladden ved at bogføre beløb og antal på de relaterede konti i regnskaberne.',
                                ENU='Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction();
                    begin
                        CODEUNIT.RUN(CODEUNIT::InvestJnlMgt,Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action(Attachment)
                {
                    CaptionML = DAN='Anvend samme vedhæftede fil',
                                ENU='Use Same Attachment';
                    Image = ExportAttachment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        UseSameAttachment(Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
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
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        CalcBalance(TotalBalance,Balance);

        CALCFIELDS(Attachment);
        HasAttachment := Attachment.HASVALUE;
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        SetUpNewLine(xRec,1);
        CLEAR(ShortcutDimCode);
        CLEAR(AccName);
        HasAttachment := FALSE;
    end;

    trigger OnOpenPage();
    begin
        CalcBalance(TotalBalance,Balance);
    end;

    var
        SecJnlManagement : Codeunit "50000";
        AccName : Text[50];
        Balance : Decimal;
        TotalBalance : Decimal;
        ShortcutDimCode : array [8] of Code[20];
        Text000 : TextConst DAN='Der er indsat finanskladdelinjer fra standardfinanskladden %1.',ENU='General Journal lines have been successfully inserted from Standard General Journal %1.';
        Text001 : TextConst DAN='Standardfinanskladden %1 er oprettet.',ENU='Standard General Journal %1 has been successfully created.';
        StyleTxt : Text;
        AccTypeNotSupportedErr : TextConst DAN='Du kan ikke angive en periodiseringskode for denne kontotype.',ENU='You cannot specify a deferral code for this type of account.';
        HasAttachment : Boolean;
}

