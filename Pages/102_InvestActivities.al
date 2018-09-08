page 70102 "Investment Activities"
{
    Caption='Investment Activities';
    PageType = CardPart;
    SourceTable = "Investment Cue";

    layout
    {
        area(content)
        {
            cuegroup(InvAcc)
            {
                Caption='Investment Accounts';
                field(Accounts;Accounts)
                {
                    DrillDownPageID = "Account List";
                    Image = Folder;
                }

                actions
                {
                    action("NewAccount")
                    {
                        Caption='New Account';
                        RunObject = Page 50100;
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup(Securities)
            {
                Caption='Securities';
                field(DanishStock;"DK Stock Securities")
                {
                    Caption='Danish Stock';
                    DrillDownPageID = "Security List";
                    Image = Cash;

                    trigger OnDrillDown();
                    begin
                        ShowSecurities(FIELDNO("DK Stock Securities"));
                    end;
                }
                field(DanishBond;"DK Bond Securities")
                {
                    Caption='Danish Bond';
                    DrillDownPageID = "Security List";
                    Image = Cash;

                    trigger OnDrillDown();
                    begin
                        ShowSecurities(FIELDNO("DK Bond Securities"));
                    end;
                }
                field(ForignStock;"Forign Stock Securities")
                {
                    Caption='Forign Stock';
                    DrillDownPageID = "Security List";
                    Image = Cash;

                    trigger OnDrillDown();
                    begin
                        ShowSecurities(FIELDNO("Forign Stock Securities"));
                    end;
                }
                field(ForignBond;"Forign Bond Securities")
                {
                    Caption='Forign Bond';
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
                Caption='Set Up Cues';
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
        CueSetup : Codeunit "Cue Setup";

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

