*!*	---------------------------------------------------------------------------
*!*	This program try to translate a Visual FoxPro business class into a C#
*!*	language.
*!*	This is not the "Alfa" version yet, so the translation may be not good enough
*!*	---------------------------------------------------------------------------
*!*	Unfinished Stuf:
*!*	- FineTranslate()
*!*	- PersonalTranslate()
*!*	- Agregar la logica para convertir funciones un poco mas complejas que las
*!*	  actuales
*!*	- Si la clase VFP tiene TRY-CATCH, utilizar esto en lugar de forzarlo a mi
*!*	  criterio.
*!*	-
*!*	-
*!*	---------------------------------------------------------------------------
Lparameters lcFilePRG As String

Local lcFilePRG As String
Local lcFileMEM As String
Local lnTotal As Integer
Local lniCount As Integer
Local lcLineFP As String
Local lcLineCS As String
Local lnLevel As Integer
Local lnRecno As Integer

If File( "vfptocs.h" )
    #include vfptocs.h
Else
    #Define _CANT_TRANS		" - CANNOT TRANSLATE"
    #Define _CANT_OPT_PARAM	"You can't use optional parameters in C#, see overload functions"
    *
    #Define _SETENTER		"<#ENTER#>"
    #Define _SETBREAK		"<#BREAK#>"
    #Define _SETUSINGS		"<#USINGS#>"
    #Define _SETDATASET		"<#SETDATASET#>"
    #Define _SETTRY			"<#SETTRY#>"
    #Define _SETCATCH		"<#SETCATCH#>"
    *
    #Define CS			Chr( 13 ) + Chr( 10 )
    #Define _Tab			Chr( 9 )
Endif

* Set Procedure To vfptocs Additive
Set Talk Off
Set Echo Off
Set Safety Off
Set Exact On
Set Memowidth To 1000

If Empty( lcFilePRG )
    lcFilePRG = Getfile( "prg", "Archivo PRG" )
Endif
If ! Empty( lcFilePRG ) And File( lcFilePRG )
    Create Cursor vfptocs ( LineFP C ( 254 ), LineCS C ( 254 ), Level i )
    lcFileMEM	= Filetostr( lcFilePRG )
    lnTotal		= Memlines( lcFileMEM )
    lnLevel		= 0
    For lniCount = 1 To lnTotal
        Wait Window "Procesando la linea " + Transform( lniCount )	;
            + " de " + Transform( lnTotal ) Nowait Noclear
        lcLineFP = Mline( lcFileMEM, lniCount )
        lcLineFP = Strtran( lcLineFP, Chr( 9 ), " " )
        lcLineCS = Alltrim( lcLineFP )

        *!*		Save the new record to the cursor
        NewRecord( lcLineFP, lcLineCS, lnLevel )

        *!*		If it's a block start, encrease the level number
        If BlockStartCommand( lcLineCS ) Or UDFStartCommand( lcLineCS )
            lnLevel = lnLevel + 1
            lnRecno = Recno()
        Endif

        *!*		If it's a block end, decrease the level number
        If BlockFinishCommand( lcLineCS ) Or UDFFinishCommand( lcLineCS )
            lnLevel = lnLevel - 1
            If lnLevel < 0
                lnLevel = 0
            Endif
        Endif

    Next
    Wait Clear
    Goto Bottom
    Replace Level With 0
    GlobalTranslate()
    SetIndent()
    UDFTranslate( Justfname( lcFilePRG ) )
    VariableTranslate()
    FunctionsTranslate()
    SetTryCatch()
    *	FineTranslate()
    *	PersonalTranslate()
    TranslateToFile( lcFilePRG )
Endif



*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Add a new record into the cursor
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Procedure NewRecord( tcLineFP As String, tcLineCS As String, tnLevel As Integer )
    Insert Into vfptocs ( LineFP, LineCS, Level ) Values ( tcLineFP, tcLineCS, tnLevel )
Endproc



*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Set the gobal translates, the easy part
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Procedure GlobalTranslate()
    Local lcLineCS As String
    Local lnLastPosition As Integer
    Local lnRecno As Integer
    Local lcVarName As String
    Local lcVarValue As String

    Select vfptocs
    Locate
    Wait Window "Global Translate" Nowait Noclear
    Scan
        *!*	---------------------------------------------------------------------------
        *!*		Translate some logical operators
        *!*	---------------------------------------------------------------------------
        lcLineCS = Alltrim( vfptocs.LineCS )
        lcLineCS = Strtran( lcLineCS, " " + Replicate( "&", 2), "//" )
        lcLineCS = Strtran( lcLineCS, " and ", " " + Replicate( "&", 2) + " ", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, ".and.", Replicate( "&", 2), -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, " or ", " || ", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, ".or.", " || ", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, " not", " !", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, ".not.", "!", -1, -1, 1 )

        *!*	---------------------------------------------------------------------------
        *!*		Translate some starting commands
        *!*	---------------------------------------------------------------------------
        lcLineCS = Strtran( lcLineCS, "hidden ", "<#P#>", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "protected ", "<#P#>", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "function ", "<#F#>", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "procedure ", "<#F#>", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "define ", "<#D#>", -1, -1, 1 )

        *!*		Short version
        lcLineCS = Strtran( lcLineCS, "func ", "<#F#>", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "proc ", "<#F#>", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "defi ", "<#D#>", -1, -1, 1 )

        *!*	---------------------------------------------------------------------------
        *!*		Translate some ending commands
        *!*	---------------------------------------------------------------------------
        lcLineCS = Strtran( lcLineCS, "endcase", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "endif", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "endfor", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "endfunc", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "endproc", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "enddefine", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "enddo", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "endscan", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "else", "}else{", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "othe", "default", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "otherwise", "default", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "return", "return", -1, -1, 1 )
        *!*		Short version
        lcLineCS = Strtran( lcLineCS, "endc", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "endd", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "endf", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "endi", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "endp", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "ends", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "next", "}", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "retu", "return", -1, -1, 1 )
        *!*	---------------------------------------------------------------------------


        *!*	---------------------------------------------------------------------------
        *!*		Some functions
        *!*	---------------------------------------------------------------------------
        If ( "(" $ lcLineCS ) And ( ")" $ lcLineCS )

            *!*				lcFunctions = "abs,alltrim,asc,empty,left,right,str,subs,substr,trim"
            *!*				for lniCount = 1 to occurs( ",", lcFunctions ) + 1
            *!*					lcFuncName = Getwordnum( lcFunctions, ",", lniCount )
            *!*					if not empty( lcFuncName )
            *!*						for njCount = 1 to len( lcFuncName )
            *!*
            *!*						next
            *!*					endif
            *!*				next

            lcLineCS = Strtran( lcLineCS, "abs(", "abs(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "allt(", "alltrim(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "alltrim(", "alltrim(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "asc(", "asc(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "at(", "at(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "at_c(", "at_c(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "atc(", "atc(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "atcc(", "atcc(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "empty(", "empty(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "left(", "left(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "messagebox(", "messagebox(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "MESSAGEBOX(", "messagebox(" )
            lcLineCS = Strtran( lcLineCS, "righ(", "right(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "right(", "right(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "str(", "str(", -1, -1, 1 )
            lcLineCS = Strtran( lcLineCS, "trim(", "trim(", -1, -1, 1 )
        Endif


        *!*	---------------------------------------------------------------------------
        *!*		Others
        *!*	---------------------------------------------------------------------------
        lcLineCS = Strtran( lcLineCS, ".t.", "true", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, ".f.", "false", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "local ", "local ", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "public ", "public ", -1, -1, 1 )
        lcLineCS = Strtran( lcLineCS, "private ", "private ", -1, -1, 1 )

        *!*	---------------------------------------------------------------------------
        *!*		Translate the starting blocks commands
        *!*	---------------------------------------------------------------------------
        If BlockStartCommand( lcLineCS ) Or ( Left( Lower( lcLineCS ), 5 ) == "case " )
            *  Or ( Left( lcLineCS, 5 ) == "Case " ) Or ( Left( lcLineCS, 5 ) == "CASE " )
            lcLineCS = Strtran( lcLineCS, "==", ".eq." )
            lcLineCS = Strtran( lcLineCS, ">=", ".gt." )
            lcLineCS = Strtran( lcLineCS, "=>", ".gt." )
            lcLineCS = Strtran( lcLineCS, "<=", ".lt." )
            lcLineCS = Strtran( lcLineCS, "=<", ".lt." )
            lcLineCS = Strtran( lcLineCS, "!=", ".ne." )
            lcLineCS = Strtran( lcLineCS, "=", "==" )
            lcLineCS = Strtran( lcLineCS, ".eq.", "==" )
            lcLineCS = Strtran( lcLineCS, ".gt.", ">=" )
            lcLineCS = Strtran( lcLineCS, ".lt.", "<=" )
            lcLineCS = Strtran( lcLineCS, ".ne.", "!=" )
        Endif

        If Left( Lower( lcLineCS ), 4 ) == "set "
            lcLineCS = lcLineCS + _CANT_TRANS
        Endif
        Do Case
                *!*			Coments
            Case Left( Lower( lcLineCS ), 3 ) == "*!*"
                lcLineCS = "//" + Substr( lcLineCS, 4 )
            Case Left( lcLineCS, 1 ) == "*"
                lcLineCS = "//" + Substr( lcLineCS, 2 )
                *!*			Command start - medium
            Case Left( Lower( lcLineCS ), 3 ) == "if "
                lcLineCS = Strtran( lcLineCS, "if ", "if(", -1, -1, 1 )
                lcLineCS = Strtran( lcLineCS, "==", "=" )
                lcLineCS = Strtran( lcLineCS, "=", "==" )
                lcLineCS = Strtran( lcLineCS, "<>", "!=" )
                lcLineCS = lcLineCS + "){"
                *!*				Sure is a logical condition, complete with "== true"
                If ( ! "==" $ lcLineCS ) ;
                        And ( ! "!=" $ lcLineCS ) ;
                        And ( ! ">=" $ lcLineCS ) ;
                        And ( ! "<=" $ lcLineCS )
                    If ! "empty(" $ Lower( lcLineCS )
                        lcLineCS = Strtran( lcLineCS, "){", "==true){" )
                    Endif
                Endif
            Case Left( Lower( lcLineCS ), 4 ) == "for " Or Left( Lower( lcLineCS ), 4 ) == "for("
                lcLineCS = Strtran( lcLineCS, "for ", "$", -1, -1, 1 )
                lcLineCS = Strtran( lcLineCS, "for(", "$", -1, -1, 1 )
                lcLineCS = Strtran( lcLineCS, " to ", "&", -1, -1, 1 )
                lc1 = Getwordnum( lcLineCS, 2, "$" )
                lc1 = Getwordnum( lcLineCS, 1, "==" )
                lc2 = Getwordnum( lcLineCS, 2, "==" )
                lc3 = Getwordnum( lcLineCS, 2, "&" )
                lcLineCS = CreateFor( lc1, lc2, lc3 )
            Case Left( Lower( lcLineCS ), 4 ) == "scan"
                lcLineCS = Strtran( lcLineCS, "scan", "", -1, -1, 1 )
                lcLineCS = CreateFor( "", "", "" )
            Case Left( Lower( lcLineCS ), 7 ) == "do case"
                lcLineCS = Strtran( lcLineCS, "do case", "switch(#variablename){", -1, -1, 1 )
            Case Left( Lower( lcLineCS ), 5 ) == "case "
                *!*				Get the Variale name to set the shitch command
                lcVarName = Getwordnum( lcLineCS, 2, " " )
                lcVarName = Getwordnum( lcVarName, 1, " " )
                If ! Empty( lnLastPosition )
                    lnRecno = Recno()
                    Goto lnLastPosition
                    Replace LineCS With Strtran( LineCS, "#variablename", lcVarName, -1, -1, 1 )
                    Goto lnRecno
                Endif
                Do Case
                    Case "!=" $ lcLineCS
                        lcVarValue = Substr( lcLineCS, At( "!=", lcLineCS ) + 2 )
                    Case "==" $ lcLineCS
                        lcVarValue = Substr( lcLineCS, At( "==", lcLineCS ) + 2 )
                    Case ">=" $ lcLineCS
                        lcVarValue = Substr( lcLineCS, At( ">=", lcLineCS ) + 2 )
                    Case "<=" $ lcLineCS
                        lcVarValue = Substr( lcLineCS, At( "<=", lcLineCS ) + 3 )
                    Otherwise
                        lcVarValue = ""
                Endcase
                If ! Empty( lcVarValue )
                    lcLineCS = "case " + lcVarValue + ":"
                    lcLineCS = Strtran( lcLineCS, "  ", " ", -1, -1, 1 )
                Endif
            Case Left( Lower( lcLineCS ), 7 ) == "default"
            Case Left( Lower( lcLineCS ), 8 ) == "do while"
            Case Left( Lower( lcLineCS ), 8 ) == "function"

                *!*			Command end
            Case Left( Lower( lcLineCS ), 4 ) == "endc"
            Case Left( Lower( lcLineCS ), 4 ) == "endd"
            Case Left( Lower( lcLineCS ), 4 ) == "endf"
            Case Left( Lower( lcLineCS ), 4 ) == "endi"
            Case Left( Lower( lcLineCS ), 4 ) == "ends"
            Case Left( Lower( lcLineCS ), 4 ) == "next"
            Otherwise
                If ! Empty( lcLineCS ) And ! Inlist( lcLineCS, "{", "}" )
                    If lcLineCS # "}else{"
                        lcLineCS = lcLineCS + ";"
                    Endif
                Endif
        Endcase

        Replace LineCS With lcLineCS

        If "#variablename" $ lcLineCS
            lnLastPosition = Recno()
        Else
            lnLastPosition = 0
        Endif
    Endscan
    Flush
Endproc



*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Set an extra indent levelm scaning the cursor from eof() until bof()
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Procedure SetIndent()
    Select vfptocs
    Goto Bottom in vfptocs
    *!*	Scan the cursor reversive.
    Do While ! Bof( 'vfptocs' )
        lcLineCS = Alltrim( vfptocs.LineCS )
        llUpdate = .F.
        If ! Empty ( lcLineCS )
            llUpdate = ( lcLineCS # "}" )
        Endif
        If llUpdate
            llUpdate = ( Lower( lcLineCS ) # "}else{" )
        Endif

        If llUpdate
            Replace Level With vfptocs.Level + 1
        Endif
        Skip - 1 in vfptocs
    Enddo
Endproc

*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Translate the UDF's function name, type and parameters
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Procedure UDFTranslate( tcFilePRG As String )
    Local lcVarName As String
    Local lcVarType As String
    Local lcParams As String
    Local lniCount As Integer
    Local lcFuncType As String
    Local lcParLine As String

    If Pcount() = 0
        tcFilePRG = ""
    Endif
    If "." $ tcFilePRG
        tcFilePRG = Left( tcFilePRG, Len( tcFilePRG ) - 4 )
    Endif
    Select vfptocs
    Locate
    Wait Window "UDF's Translate" Nowait Noclear
    Scan
        lcLineCS = Alltrim( LineCS )
        lcParLine = ""
        If ( "<#F#>" $ lcLineCS )
            *!*			Get the parameter's Type and Name
            If ( " as " $ lcLineCS )
                lcParams = Getwordnum( lcLineCS, 2, "(" )
                lcParams = Getwordnum( lcParams, 1, ")" )
                For lniCount = 1 To ( Occurs( ",", lcParams ) + 1 )
                    lcThisPar = Getwordnum( lcParams, lniCount, "," )
                    lcVarName = Getwordnum( lcThisPar, 1, " " )
                    lcVarType = Getwordnum( lcThisPar, 2, " as " )
                    lcVarType = Strtran( lcVarType, "as ", "" )
                    lcVarType = GetVarTypeInC( Alltrim( lcVarType ) )
                    If Not Empty( lcVarName )
                        If Not Empty( lcParLine )
                            lcParLine = lcParLine + ", "
                        Endif
                        lcParLine = lcParLine + lcVarType + " " + lcVarName
                    Endif
                Next
            Endif

            *!*			Get the type function return
            lcFuncType = Alltrim( Getwordnum( lcLineCS, 2, ")" ) )
            If ( Left( lcLineCS, 2 ) == "<#" ) And ( "as " $ lcFuncType )
                lcFuncType = Alltrim( Getwordnum( lcFuncType, 2, " " ) )
                lcFuncType = GetVarTypeInC( Strtran( lcFuncType, ";", "" ) )
                lcLineCS = Strtran( lcLineCS, lcFuncType, "" )
                lcLineCS = Strtran( lcLineCS, " as ", "" )
                lcLineCS = Strtran( lcLineCS, "<#F#>", lcFuncType + " <#F#>" )
                lcLineCS = Strtran( lcLineCS, ";", "" )
            Endif
            *!*			Quit the "function" word
            lcLineCS = Strtran( lcLineCS, "<#F#>", "" )
            *!*			Verify if function is public
            If Left( lcLineCS, 5 ) == "<#P#>"
                lcLineCS = "public " + Strtran( lcLineCS, "<#P#>", "" )
            Else
                lcLineCS = "private " + Strtran( lcLineCS, "<#P#>", "" )
            Endif
            If Not Empty( lcParLine )
                lcLineCS = Getwordnum( lcLineCS, 1 ,"(" )
                lcLineCS = lcLineCS + "( " + lcParLine + " )"
            Endif
            If Right( lcLineCS, 1 ) == ";"
                lcLineCS = Left( lcLineCS, Len( lcLineCS ) - 1 )
            Endif
            If Right( lcLineCS, 1 ) # ")"
                lcLineCS = lcLineCS + "()"
            Endif
            If Right( lcLineCS, 1 ) # "{"
                lcLineCS = lcLineCS + "{"
            Endif
        Endif

        *!*	---------------------------------------------------------------------------
        *!*	define class BizBase as session
        *!*		protected Desarrollo
        *!*		Desarrollo	= .f.	&& Indica si se esta ejecutando el EXE o el PRG.
        *!*		EstaOk		= .t.	&& Indica si no se ha producido ningun error.
        *!*		ArchivoLog	= ""	&& Nombre del archivo de log donde se guarda el log del proceso.
        *!*	---------------------------------------------------------------------------
        *!*	namespace framebizdotnet
        *!*	{
        *!*		/// <summary>
        *!*		/// Summary description for Class2.
        *!*		/// </summary>
        *!*		public class Class2
        *!*		{
        *!*	---------------------------------------------------------------------------
        If ( Left( lcLineCS, 5 ) == "<#D#>" )
            lcClass = Lower( Alltrim( Getwordnum( lcLineCS, 1, " " ) ) )
            If Left( lcClass, 9 )  == "<#d#>clas"
                lcLineCS = Strtran( lcLineCS, "class", "" )
                lcLineCS = Strtran( lcLineCS, "Class", "" )
                lcLineCS = Strtran( lcLineCS, "clas" , "" )
                lcLineCS = Strtran( lcLineCS, "Clas" , "" )
                lcNameSP = Alltrim( Getwordnum( lcLineCS, 2, " " ) )
                lcLineCS = "namespace " + lcNameSP + "{" + _SETENTER
                lcLineCS = lcLineCS + "public class " + tcFilePRG + "{" + _SETENTER
            Endif
        Endif

        If ( Left( lcLineCS, 5 ) == "<#P#>" )
            lcLineCS = Strtran( lcLineCS, "<#P#>", "protected " )
        Endif

        *!*		Update the cursor...
        Replace LineCS With lcLineCS
    Endscan
Endproc



*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Translate the variable declarations, type and inicialization
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Procedure VariableTranslate()
    Local lcVarName As String
    Local lcVarType As String
    Local lniCount As Integer
    Local llLooper As Boolean
    Select vfptocs
    Locate
    Wait Window "Variable Translate" Nowait Noclear
    Scan
        lcLineCS = Alltrim( Lower( vfptocs.LineCS ) )
        *!*		Try to translate the variable declarations
        If ( Left( lcLineCS, 6 ) == "local " ) Or ( Left( lcLineCS, 8 ) == "private " )
            llLooper = .T.
            *!*			It's better that "do while .t."
            Do While llLooper
                lcLineCS = Alltrim( vfptocs.LineCS )
                lcLineCS = Strtran( lcLineCS, "local ", "" )
                lcLineCS = Strtran( lcLineCS, "private ", "" )
                lnTotal = ( Occurs( ",", lcLineCS ) + 1 )
                lcVarTran = ""
                *!*				if not vaiable "type", skip
                If Not ( " as " $ lcLineCS )
                    llLooper = .F.
                Endif
                If llLooper
                    For lniCount = 1 To lnTotal
                        *!*						Get the variable name
                        lcVarName = Getwordnum( lcLineCS, lniCount, "," )
                        lcVarName = Strtran( lcVarName, ";", "" )
                        If Not Empty( lcVarName )
                            *!*							Get the variable type
                            lcVarType = Getwordnum( lcVarName, 3, " " )
                            lcVarType = Strtran( lcVarType, ";", "" )
                            lcVarType = Strtran( lcVarType, ",", "" )
                            lcVarName = Getwordnum( lcVarName, 1, " " )
                            If Not Empty( lcVarTran )
                                lcVarTran = lcVarTran + ", "
                            Endif
                            *!*							Create the final string
                            lcVarTran = lcVarTran + Lower( lcVarType ) + " " + lcVarName
                            lcVarTran = lcVarTran + GetVarValueString( lcVarType, lniCount>1 )
                        Endif
                    Next
                    lcLineCS = lcVarTran
                    Replace vfptocs.LineCS With lcLineCS
                Endif
                Skip
            Enddo
            Skip -1
        Endif
    Endscan
Endproc


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Translate the Visual FoxPro functions to C# propierties
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Procedure FunctionsTranslate()
    Local lcLineCS As String
    Local lcString As String
    Local lcSetStr As String
    Select vfptocs
    Locate
    Wait Window "Functions Translate" Nowait Noclear
    Scan
        lcLineCS = Alltrim( LineCS )
        If ( "(" $ lcLineCS ) And ( ")" $ lcLineCS )
            If ( "str(" $ Lower( lcLineCS ) )
                ConvertStringFunction( @lcLineCS, "str(" )
            Endif

            If ( "allt(" $ Lower( lcLineCS ) )
                ConvertStringFunction( @lcLineCS, "allt(" )
            Endif

            If ( "alltrim(" $ Lower( lcLineCS ) )
                ConvertStringFunction( @lcLineCS, "alltrim(" )
            Endif

            If ( "empty(" $ Lower( lcLineCS ) )
                ConvertStringFunction( @lcLineCS, "empty(" )
            Endif

            If ( "messagebox(" $ Lower( lcLineCS ) )
                ConvertStringFunction( @lcLineCS, "messagebox(" )
            Endif

            lcLineCS = Strtran( lcLineCS, "ToString", "ToString()" )
            lcLineCS = Strtran( lcLineCS, "Trim", "Trim()" )
            Replace LineCS With lcLineCS
        Endif
    Endscan
Endproc


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Insert an structured try-catch error capture
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Procedure SetTryCatch()
    Local lcLineCS As String
    Local lnLevel As Integer
    Local lnRecno As Integer
    Select vfptocs
    Locate
    lnRecno = 0
    llSetCatch = .F.
    lnLevel = 0
    Scan
        lcLineCS = Alltrim( LineCS )
        *		If ( " static " $ lcLineCS ) And Inlist( Left( lcLineCS, 7 ), "public ", "private" )
        If Inlist( Left( lcLineCS, 7 ), "public ", "private" )
            lnLevel = Level
            llUpdate = .F.
        Endif

        *!*		If it's a UDF start, set the try() before first code block
        If ! Empty( lnLevel )
            If ! llSetCatch And BlockStartCommand( lcLineCS )
                lcLineCS = _SETTRY + lcLineCS
                Replace LineCS With lcLineCS
                llSetCatch = .T.
            Endif
            If llSetCatch
                If ( Left( lcLineCS, 6 ) == "return" )
                    llUpdate = .T.
                Endif
                If ( ( Alltrim( lcLineCS ) == "}" ) Or ( Left( Alltrim( lcLineCS ), 4 ) == "retu" ) ) And ( Level = lnLevel )
                    llUpdate = .T.
                Endif
                If llUpdate
                    lcLineCS = _SETCATCH + lcLineCS
                    Replace LineCS With lcLineCS
                    lnLevel = 0
                    llSetCatch = .F.
                Endif
            Endif
        Endif
    Endscan
Endproc


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	TO DO
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Procedure FineTranslate()
    Local lcLineCS As String
    Select vfptocs
    Locate
    Wait Window "Fine Translate" Nowait Noclear
    Scan
        lcLineCS = Alltrim( LineCS )
    Endscan
Endproc


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	TO DO
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Procedure PersonalTranslate()
    Local lcLineCS As String
    Select vfptocs
    Locate
    Wait Window "Personal Translate" Nowait Noclear
    Scan
        lcLineCS = Alltrim( LineCS )
    Endscan
Endproc



*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	This is the final part, this routine make some "touchs" and create the
*!*	fisical file
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Procedure TranslateToFile( tcFilePRG As String )
    Local lcTabs As String
    Local lcFileCS As String
    Local llInsideBlock As Boolean
    lcFileCS = Strtran( Lower( tcFilePRG ), ".prg", ".txt" )
    lcFileMEM = ""
    Select vfptocs
    Locate
    lnCaseLevel	= 0
    llEndWithRet = .F.
    Wait Window "Translate To File" Nowait Noclear
    Scan
        lcLineCS = Alltrim( vfptocs.LineCS )
        llSetBreak = .F.
        lcTabs = ""
        lnLevel = Level
        lnLevel = -1

        *!*		Start a try() block
        If ( _SETTRY $ lcLineCS )
            lcLineCS = CS + "try" + CS + lcTabs + "{" + CS + lcTabs + _Tab + lcLineCS
            lcLineCS = Strtran( lcLineCS, _SETTRY, '' )
            lnLevel = lnLevel + 1
        Endif
        *!*		Start a catch() block
        If ( _SETCATCH $ lcLineCS )
            lcLineCS = SetCatch( .F. ) + lcLineCS
            lcLineCS = Strtran( lcLineCS, _SETCATCH, '' )
            lnLevel = lnLevel - 1
        Endif

        If vfptocs.Level > 0
            lcTabs = Replicate( _Tab, vfptocs.Level + lnLevel )
        Endif

        If Left( lcLineCS, 9 ) == _SETBREAK
            llSetBreak = .T.
            lcLineCS = Substr( lcLineCS, 10 )
        Endif
        lcFileMEM = lcFileMEM + lcTabs + lcLineCS + CS
        If llSetBreak
            lcFileMEM = lcFileMEM + lcTabs + "break;" + CS
        Endif
        If Left( Lower( lcLineCS ), 5 ) == "case "
            lnRecno = Recno()
            Skip
            lnCaseLevel	= vfptocs.Level
            *!*			Set a deeper level inside the case
            Do While Level = lnCaseLevel
                If Left( Lower( Alltrim( vfptocs.LineCS ) ), 5 ) == "case " &&or left( "}",1 ) == alltrim( VFPtoCS.LineCS )
                    Skip - 1
                    Replace LineCS With _SETBREAK + Alltrim( LineCS )
                    Exit
                Else
                    Replace Level With Level + 1
                Endif
                Skip
            Enddo
            *!*			Get the last case in the case structure
            If Level = ( lnCaseLevel - 1 ) And Left( "}",1 ) == Alltrim( vfptocs.LineCS )
                Skip - 1
                Replace LineCS With _SETBREAK + Alltrim( LineCS )
            Endif
            Goto lnRecno
        Endif

        *!*		Set an ENTER
        If ( _SETENTER $ LineCS )
            lcFileMEM = Strtran( lcFileMEM, _SETENTER, CS )
        Endif
    Endscan
    Wait Clear
    Strtofile( lcFileMEM, lcFileCS )
    Modify File ( lcFileCS ) Nowait
Endproc


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Translate a for command from VFP to C#
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Function CreateFor( tcVar As String, tcStart As String, tcFinish As String )
    Local lcFor As String
    lcFor = ""
    If Empty( tcVar ) And Empty( tcStart ) And Empty( tcFinish )
        lcFor = "for(;;){"
    Endif
    If Empty( lcFor )
        If Not Empty( tcVar )
            * lcFor = "int " + Getwordnum( tcVar, 2, "$" ) + "=1"
            lcFor = "int " + Getwordnum( tcVar, 2, "$" ) + "=1"
        Endif
        If Not Empty( tcStart ) And Not Empty( tcFinish )
            If Left( tcStart, 1 ) = "="
                tcStart = Substr( tcStart, 2 )
            Endif
            If ( "//" $ tcFinish )
                tcFinish = Left( tcFinish, At( "//", tcFinish ) - 2 )
            Endif
            tcStart = Alltrim( tcStart )
            tcFinish = Alltrim( tcFinish )
            lcFor = lcFor + ";" + + Getwordnum( tcStart, 1, "&" ) + "<=" + tcFinish + "; i++"
        Endif
        If Not Empty( lcFor )
            lcFor = "for(" + lcFor + "){"
        Endif
    Endif
    Return ( lcFor )
Endfunc


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Get an specific word from some string
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Function Getword( tcString, tnPosition, tcSeparator )
    Local lcWord As String
    Local lnFirst As Integer
    Local lnFinal As Integer
    Local llOk As Boolean
    Local lcReturn As String
    lcWord = ""
    lcReturn = ""
    If Empty( tnPosition )
        tnPosition = 1
    Endif
    llOk = .T.

    If tnPosition = 1
        lnFirst = 0
    Else
        lnFirst = At( tcSeparator, tcString, tnPosition - 1 )
        If lnFirst = 0
            llOk = .F.
        Endif
    Endif

    If llOk
        lnFinal = At( tcSeparator, tcString, tnPosition)
        If lnFinal = 0
            lnFinal = Len( tcString ) + 1			&& Ultima columna
        Endif
        lcWord = Allt( Substr( tcString, lnFirst + 1, ( lnFinal - lnFirst - 1 ) ) )
        lcReturn = lcWord
    Endif

    Return ( lcReturn )
Endproc


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Get the initial value in a C# variable declaration.
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Function GetVarValueString( tcVarType As String, llSetEnter As Boolean ) As String
    Local lcVarValue As String
    lcVarValue = ""
    tcVarType = Lower( tcVarType )
    Do Case
        Case tcVarType == "boolean"
            lcVarValue = 'false'
        Case tcVarType == "string"
            lcVarValue = '""'
        Case tcVarType == "integer"
            lcVarValue = '0'
        Case tcVarType == "date"
            lcVarValue = 'new datetime()'
        Case tcVarType == "datetime"
            lcVarValue = 'new datetime()'
        Otherwise
            lcVarValue = "UNKNOWN VARTYPE"	&&_CANT_TRANS
    Endcase
    If ! Empty( lcVarValue )
        lcVarValue = '=' + lcVarValue + ";" + Iif( llSetEnter, _SETENTER, "" )
    Endif
    Return lcVarValue
Endfunc


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Get the equivalence or variable type
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Function GetVarTypeInC( tcVarType As String, llSetEnter As Boolean ) As String
    Local lcVarTypeC As String
    lcVarTypeC = ""
    tcVarType = Lower( tcVarType )
    Do Case
        Case tcVarType == "boolean"
            lcVarTypeC = "bool"
        Case tcVarType == "string"
            lcVarTypeC = tcVarType
        Case tcVarType == "integer"
            lcVarTypeC = tcVarType
        Case tcVarType == "date"
            lcVarTypeC = "datetime"
        Case tcVarType == "datetime"
            lcVarTypeC = "datetime"
        Otherwise
            lcVarTypeC = "UNKNOWN VARTYPE"	&&_CANT_TRANS
    Endcase

    Return lcVarTypeC
Endfunc


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Get a list of "using" by the class
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Function GetUsings( tcUsings As String ) As String
    Local lcUsing As String	
    Local lniCount As Integer
    If Pcount() = 0
        tcUsings = "System"
    Endif
    lcUsing = ""
    For lniCount = 1 To ( Occurs( ",", tcUsings ) + 1 )
        lcUsing = lcUsing + "using " + Getwordnum( tcUsings, lniCount, "," ) + ";" + CS
    Next
    lcUsing = lcUsing + CS
    Return lcUsing
Endfunc && GetUsings


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Set the tray-catch block
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Function SetCatch( tlSetFinally As Boolean ) As String
    Local lcSetCatch As String
    lcSetCatch = ""
    lcSetCatch = lcSetCatch + CS + "}" + CS
    lcSetCatch = lcSetCatch + "catch(Exception Exc)" + CS
    lcSetCatch = lcSetCatch + "{" + CS
    lcSetCatch = lcSetCatch + _Tab + "Messagebox.Show(Exc.Description);" + CS
    lcSetCatch = lcSetCatch + "}" + CS
    Return lcSetCatch
Endfunc && SetCatch



*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Convert a VFP function into C# code language.
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Function ConvertStringFunction( tcLineCS As String, tcFuncName As String, tlCanCalculate As Boolean ) As String
    Local lcStringFunc As String
    Local lcSetStr As String

    lcStringFunc = ""
    *!*	Get the string inside the funcion.
    lcStringFunc = Substr( tcLineCS, At( tcFuncName,tcLineCS ), At( ")",tcLineCS ) )
    lcStringFunc = Left( lcStringFunc, At( ")", lcStringFunc ) )

    If Not Empty( lcStringFunc ) And Not tlCanCalculate
        *!*		Can't be a math opetation inside...
        If 	( "+" $ lcStringFunc ) Or ;
                ( "-" $ lcStringFunc ) Or ;
                ( "/" $ lcStringFunc ) Or ;
                ( "*" $ lcStringFunc )
            lcStringFunc = ""
        Endif
    Endif

    *!*	Look if there's another function inside ....
    If Occurs( "(", lcStringFunc ) = 0
    Endif

    *!*	Translate some functions
    If ! Empty( lcStringFunc )
        lcSetStr = Substr( lcStringFunc, Len( tcFuncName ) + 1 )
        lcSetStr = Left( lcSetStr, Len( lcSetStr ) - 1 )
        Do Case
            Case tcFuncName == "str("
                lcSetStr = Alltrim( lcSetStr ) + ".ToString"
            Case tcFuncName == "allt("
                lcSetStr = Alltrim( lcSetStr ) + ".Trim "
            Case tcFuncName == "alltrim("
                lcSetStr = Alltrim( lcSetStr ) + ".Trim"
            Case tcFuncName == "empty("
                lcSetStr = Alltrim( lcSetStr ) + '.ToString==""'
            Case tcFuncName == "messagebox("
                lcSetStr = "Messagebox.Show(" + Alltrim( lcSetStr ) + ")"
        Endcase
        tcLineCS = Strtra( tcLineCS, lcStringFunc, lcSetStr )
    Endif

    Return Alltrim( lcStringFunc )
Endfunc



*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Return .T. if the line is a start logic block of code
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Function BlockStartCommand( tcLineCS As String ) As String
    Local lcLineCS As String
    lcLineCS = Lower( Alltrim( tcLineCS ) )
    Return	( Left( lcLineCS, 3 ) == "if " ) ;
        Or ( Left( lcLineCS, 4 ) == "for " ) ;
        Or ( Left( lcLineCS, 4 ) == "scan" ) ;
        Or ( Left( lcLineCS, 7 ) == "do case" )	;
        Or ( Left( lcLineCS, 6 ) == "switch" ) ;
        Or ( Left( lcLineCS, 7 ) == "do whil" )
Endfunc && BlockStartCommand


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Return .T. if the line is a start function or procedure
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Function UDFStartCommand( tcLine As String ) As String
    Local lcLineCS As String
    lcLineCS = Lower( Alltrim( tcLine ) )
    Return ( Left( lcLineCS, 4 ) == "prot" ) ;
        Or ( Left( lcLineCS, 4 ) == "hidd" ) ;
        Or ( Left( lcLineCS, 4 ) == "didd" ) ;
        Or ( Left( lcLineCS, 4 ) == "func" ) ;
        Or ( Left( lcLineCS, 4 ) == "proc" )
Endfunc && UDFStartCommand


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Return .T. if the line is a finish logic block of code
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Function BlockFinishCommand( tcLineCS As String ) As String
    Local lcLineCS As String
    lcLineCS = Lower( Alltrim( tcLineCS ) )
    Return	( Left( lcLineCS, 4 ) == "endc" ) ;
        Or ( Left( lcLineCS, 4 ) == "endd" ) ;
        Or ( Left( lcLineCS, 4 ) == "endf" ) ;
        Or ( Left( lcLineCS, 4 ) == "endi" ) ;
        Or ( Left( lcLineCS, 4 ) == "ends" ) ;
        or ( Left( lcLineCS, 4 ) == "next" )
Endfunc && BlockFinishCommand


*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	Return .T. if the line is a finsih function or procedure
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
*!*	---------------------------------------------------------------------------
Function UDFFinishCommand( tcLineCS As String ) As String
    Local lcLineCS As String
    lcLineCS = Lower( Alltrim( tcLineCS ) )
    Return	( Left( lcLineCS, 4 ) == "endf" ) ;
        Or ( Left( lcLineCS, 4 ) == "endp" ) ;
        Or ( Left( lcLineCS, 4 ) == "endt" ) ;
        Or ( Left( lcLineCS, 4 ) == "retu" )
Endfunc && UDFFinishCommand
