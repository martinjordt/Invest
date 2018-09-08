page 50002 "Investment Activities"
{
    CaptionML = DAN='Investeringsaktiviteter',
                ENU='Investment Activities';
    PageType = CardPart;
    SourceTable = Table50001;

    layout
    {
        area(content)
        {
            cuegroup(Depoter)
            {
                CaptionML = DAN='Depoter',
                            ENU='Investment Accounts';
                field(Accounts;Accounts)
                {
                    DrillDownPageID = "Account List";
                    Image = Folder;
                }

                actions
                {
                    action("Nyt depot")
                    {
                        CaptionML = DAN='Nyt depot',
                                    ENU='New Account';
                        RunObject = Page 50100;
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup("Værdipapirer")
            {
                CaptionML = DAN='Værdipapirer',
                            ENU='Securities';
                field(DanishStock;"DK Stock Securities")
                {
                    CaptionML = DAN='Danske aktier',
                                ENU='Danish Stock';
                    DrillDownPageID = "Security List";
                    Image = Cash;

                    trigger OnDrillDown();
                    begin
                        ShowSecurities(FIELDNO("DK Stock Securities"));
                    end;
                }
                field(DanishBond;"DK Bond Securities")
                {
                    CaptionML = DAN='Danske obligationer',
                                ENU='Danish Bond';
                    DrillDownPageID = "Security List";
                    Image = Cash;

                    trigger OnDrillDown();
                    begin
                        ShowSecurities(FIELDNO("DK Bond Securities"));
                    end;
                }
                field(ForignStock;"Forign Stock Securities")
                {
                    CaptionML = DAN='Globale aktier',
                                ENU='Forign Stock';
                    DrillDownPageID = "Security List";
                    Image = Cash;

                    trigger OnDrillDown();
                    begin
                        ShowSecurities(FIELDNO("Forign Stock Securities"));
                    end;
                }
                field(ForignBond;"Forign Bond Securities")
                {
                    CaptionML = DAN='Globale obligationer',
                                ENU='Forign Bond';
                    DrillDownPageID = "Security List";
                    Image = Cash;

                    trigger OnDrillDown();
                    begin
                        ShowSecurities(FIELDNO("Forign Bond Securities"));
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                CaptionML = DAN='Konfigurer køindikatorer',
                            ENU='Set Up Cues';
                Image = Setup;

                trigger OnAction();
                var
                    CueRecordRef : RecordRef;
                begin
                    CueRecordRef.GETTABLE(Rec);
                    CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.NUMBER);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        CalculateCueFieldValues;
    end;

    trigger OnOpenPage();
    begin
        RESET;
        IF NOT GET THEN BEGIN
          INIT;
          INSERT;
        END;

        SETFILTER("Date Filter",'>=%1',WORKDATE);
    end;

    var
        CueSetup : Codeunit "9701";

    local procedure CalculateCueFieldValues();
    begin
        IF FIELDACTIVE("DK Stock Securities") THEN
          Accounts := CountSecurities(FIELDNO(Accounts));

        IF FIELDACTIVE("DK Stock Securities") THEN
          "DK Stock Securities" := CountSecurities(FIELDNO("DK Stock Securities"));

        IF FIELDACTIVE("Forign Stock Securities") THEN
          "Forign Stock Securities" := CountSecurities(FIELDNO("Forign Stock Securities"));

        IF FIELDACTIVE("DK Bond Securities") THEN
          "DK Bond Securities" := CountSecurities(FIELDNO("DK Bond Securities"));

        IF FIELDACTIVE("Forign Bond Securities") THEN
          "Forign Bond Securities" := CountSecurities(FIELDNO("Forign Bond Securities"));
    end;
}

