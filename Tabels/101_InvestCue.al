table 70101 "Investment Cue"
{
    Caption='Investment Cue';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption='Primary Key';
        }
        field(2;Accounts;Decimal)
        {
            Caption='Accounts';
            Editable = false;
        }
        field(3;"DK Stock Securities";Decimal)
        {
            CalcFormula = Sum(Security."Current Share Amt." WHERE ("Security Type"=CONST("Danish Stock")));
            Caption='DK Stock Securities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Forign Stock Securities";Decimal)
        {
            CalcFormula = Sum(Security."Current Share Amt." WHERE ("Security Type"=CONST("Forign Stock")));
            Caption='Forign Stock Securities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"DK Bond Securities";Decimal)
        {
            CalcFormula = Sum(Security."Current Share Amt." WHERE ("Security Type"=CONST("Danish Bond")));
            Caption='DK Bond Securities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Forign Bond Securities";Decimal)
        {
            CalcFormula = Sum(Security."Current Share Amt." WHERE ("Security Type"=CONST("Forign Bond")));
            Caption='Forign Bond Securities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"Date Filter";Date)
        {
            Caption='Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(101;"Account Filter";Text[30])
        {
            Caption='Account Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {        }
    }

    procedure CountSecurities(FieldNumber : Integer) : Decimal;
    var
        Security : Record "Security";
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
        Security : Record "Security";
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