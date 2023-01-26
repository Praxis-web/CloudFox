* COPYCLASS.PRG by Ben Creighton
* libraryC:     File name of source library, will be forced to a VCX extension
* classC:       Class name from source library
* targetlibC:   File name of target library, will be forced to a VCX or SCX extension
* targetclassC: New Class name in target library OR .T. to create a SCX file

Lparameters libraryC, classC, targetlibC, targetclassC
Local copyobj

copyobj = Newobject( "copyvcx", "copyclass.prg", "", m.libraryC, m.classC, m.targetlibC, m.targetclassC)
Return

* Session Class Definition
Define Class copyvcx As Session
    DataSession = 2
    Procedure Init
        Lparameters libraryC, classC, targetlibC, targetclassC
        Local tempfileC, formsA[1]
        Set Deleted On

        * Process parameters
        libraryC = Forceext(m.libraryC, "VCX")
        classC = Lower(m.classC)
        If Vartype(m.targetclassC)="L" And m.targetclassC
            m.targetclassC=""
            targetlibC = Forceext(m.targetlibC, "SCX")
        Else
            targetclassC = Iif(Empty(m.targetclassC), m.classC, Lower(m.targetclassC))
            targetlibC = Forceext(m.targetlibC, "VCX")
        Endif

        * Create a cursor from libraryC that contains the selected class
        Select * From (m.libraryC);
            Where Parent==m.classC Or (objname==m.classC And Empty(Parent)) Or uniqueid="Class";
            into Cursor Source Readwrite
        Update Source;
            Where Parent==m.classC;
            Set Parent=m.targetclassC
        Update Source;
            Where objname==m.classC And Empty(Parent);
            Set objname=m.targetclassC

        * Copy source cursor into target library
        Do Case
            Case Empty(m.targetclassC)
                * Create a SCX file
                Select * From Source Where Empty(Parent) And BaseClass="form" Into Array formsA
                If _Tally>0
                    Update Source;
                        Where uniqueid=="Class";
                        Set uniqueid="Screen"
                    Copy To (m.targetlibC)
                Else
                    Messagebox(m.classC + " is not a baseclass of FORM", 0, "Cannot Copy")
                Endif
            Case File(m.targetlibC)
                * Copy into existing target library
                Select * From (m.targetlibC);
                    Where objname==m.targetclassC And Empty(Parent);
                    Into Cursor destination
                If _Tally>0
     .               Messagebox(m.targetclassC + " ALREADY EXISTS IN " + m.targetlibC, 0, "Cannot Copy")
                    Return
                Endif
                Insert Into (targetlibC);
                    Select * From Source Where uniqueid<>"Class"
            Otherwise
                * Create a brand new library
                Copy To (m.targetlibC)
        Endcase
        Return
    Endproc
Enddefine
