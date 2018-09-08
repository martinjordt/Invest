table 70400 "Drop Area File"
{
    // version DropArea

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"File Name";Text[250])
        {
        }
        field(3;"File Content";BLOB)
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;"File Name")
        {
        }
    }

    fieldgroups
    {
    }
}

