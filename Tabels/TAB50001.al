table 50001 "Investment Cue"
{
    CaptionML = DAN='Investeringskøindikator',
                ENU='Investment Cue';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            CaptionML = DAN='Primærnøgle',
                        ENU='Primary Key';
        }
        field(2;Accounts;Decimal)
        {
            CaptionML = DAN='Depoter',
                        ENU='Accounts';
            Editable = false;
        }
        field(3;"DK Stock Securities";Decimal)
        {
            CalcFormula = Sum(Security."Current Share Amt." WHERE (Security Type=CONST(Danish Stock)));
            CaptionML = DAN='DK Aktier',
                        ENU='DK Stock Securities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Forign Stock Securities";Decimal)
        {
            CalcFormula = Sum(Security."Current Share Amt." WHERE (Security Type=CONST(Forign Stock)));
            CaptionML = DAN='Globale aktier',
                        ENU='Forign Stock Securities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"DK Bond Securities";Decimal)
        {
            AccessByPermission = TableData 6650=R;
            CalcFormula = Sum(Security."Current Share Amt." WHERE (Security Type=CONST(Danish Bond)));
            CaptionML = DAN='DK Obligationer',
                        ENU='DK Bond Securities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Forign Bond Securities";Decimal)
        {
            CalcFormula = Sum(Security."Current Share Amt." WHERE (Security Type=CONST(Forign Bond)));
            CaptionML = DAN='Globale obligationer',
                        ENU='Forign Bond Securities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"Date Filter";Date)
        {
            CaptionML = DAN='Datofilter',
                        ENU='Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(101;"Account Filter";Text[30])
        {
            CaptionML = DAN='Depotfilter',
                        ENU='Account Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    procedure CountSecurities(FieldNumber : Integer) : Decimal;
    var
        Security : Record "50101";
    begin
        CASE FieldNumber OF
          FIELDNO(Accounts):
            BEGIN
            END;
          FIELDNO("DK Stock Securities"):
            BEGIN
              Security.SETRANGE("Security Type",Security."Security Type"::"Danish Stock");
            END;
          FIELDNO("Forign Stock Securities"):
            BEGIN
              Security.SETRANGE("Security Type",Security."Security Type"::"Forign Stock");
            END;
          FIELDNO("DK Bond Securities"):
            BEGIN
              Security.SETRANGE("Security Type",Security."Security Type"::"Danish Bond");
            END;
          FIELDNO("Forign Bond Securities"):
            BEGIN
              Security.SETRANGE("Security Type",Security."Security Type"::"Forign Bond");
            END;
        END;
        FILTERGROUP(2);
        FILTERGROUP(0);
        Security.CALCSUMS("Current Share Amt.");
        EXIT(Security."Current Share Amt.");
    end;

    local procedure ShowAccounts();
    begin
    end;

    procedure ShowSecurities(FieldNumber : Integer);
    var
        Security : Record "50101";
    begin
        CASE FieldNumber OF
          FIELDNO("DK Stock Securities"):
            BEGIN
              Security.SETRANGE("Security Type",Security."Security Type"::"Danish Stock");
            END;
          FIELDNO("Forign Stock Securities"):
            BEGIN
              Security.SETRANGE("Security Type",Security."Security Type"::"Forign Stock");
            END;
          FIELDNO("DK Bond Securities"):
            BEGIN
              Security.SETRANGE("Security Type",Security."Security Type"::"Danish Bond");
            END;
          FIELDNO("Forign Bond Securities"):
            BEGIN
              Security.SETRANGE("Security Type",Security."Security Type"::"Forign Bond");
            END;
        END;
        FILTERGROUP(2);
        FILTERGROUP(0);
        PAGE.RUN(PAGE::"Security List",Security);
    end;
}

