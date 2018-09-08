codeunit 50005 "General Functions"
{

    trigger OnRun();
    begin
    end;

    procedure FindDate(SearchString : Text[3];var Calendar : Record "2000000007";PeriodType : Option Year,Year2,Year3,Year4,Year5) : Boolean;
    var
        Calendar2 : Record "2000000007";
        Found : Boolean;
    begin
        Calendar.SETRANGE("Period Type",Calendar."Period Type"::Year);
        Calendar."Period Type" := Calendar."Period Type"::Year;
        IF Calendar."Period Start" = 0D THEN
          Calendar."Period Start" := WORKDATE;
        IF SearchString IN ['','=><'] THEN
          SearchString := '=<>';
        Found := Calendar.FIND(SearchString);
        IF Found THEN BEGIN
          Calendar2 := Calendar;
          Calendar."Period End" := NORMALDATE(Calendar."Period End");
          CASE PeriodType OF
            PeriodType::Year2:
              Calendar2."Period Start" := CALCDATE('<-1Y>',Calendar."Period Start");
            PeriodType::Year3:
              Calendar2."Period Start" := CALCDATE('<-2Y>',Calendar."Period Start");
            PeriodType::Year4:
              Calendar2."Period Start" := CALCDATE('<-3Y>',Calendar."Period Start");
            PeriodType::Year5:
              Calendar2."Period Start" := CALCDATE('<-4Y>',Calendar."Period Start");
          END;
          Calendar2.FIND('=<>');
          Calendar."Period Start" := Calendar2."Period Start";
        END;
        EXIT(Found);
    end;

    procedure RemoveBadChars(InputText : Text) : Text;
    var
        Ch : Text[3];
    begin
        Ch[1] := 13;  // CR
        Ch[2] := 10;  // LF
        Ch[3] := 9;   // TAB
        EXIT(DELCHR(InputText,'=',Ch));
    end;
}

