*!* CodeParserSetup @  llAlreadyParsed @ .T.
*!* CodeParserSetup @  llParsePrivate @ .F.


Try

	Set Sysmenu Off
	Do Form "V:\Clipper2Fox\fw\Epson\scx\Utilidades_Epson.scx"

Catch To OERR
	Local LOERROR As ERRORHANDLER Of "TOOLS\ERRORHANDLER\PRG\ERRORHANDLER.PRG"

	LOERROR = Newobject( "ERRORHANDLER", "TOOLS\ERRORHANDLER\PRG\ERRORHANDLER.PRG" )
	LOERROR.Process( OERR )
	Throw LOERROR

Finally
	Close Databases All
	Set Sysmenu Automatic

Endtry

Return
