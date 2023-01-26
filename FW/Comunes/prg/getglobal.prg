
*
* Devuelve el valor de una propiedad de GlobalSettings
Procedure GetGlobal( cPropiedad as String ) As Variant;
        HELPSTRING "Devuelve el valor de una propiedad de GlobalSettings"
    Local lcCommand As String
    Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
    local luValue as Variant 

    Try

        lcCommand = ""
        loGlobalSettings 	= NewGlobalSettings()
        
        Text To lcCommand NoShow TextMerge Pretext 15
        luValue = loGlobalSettings.<<cPropiedad>>
        EndText

        &lcCommand



    Catch To oErr
        Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

        loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
        loError.cRemark = lcCommand
        loError.Process( oErr )
        Throw loError

    Finally
        loGlobalSettings 	= Null

    EndTry
    
    Return luValue  

Endproc && GetGlobal