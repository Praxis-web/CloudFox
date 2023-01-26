Local lcCommand As String,;
	lcUser As String,;
	lcMachine As String,;
	lcWorkingFolder As String,;
	lcMsg As String,;
	lcEmpresa As String

Local llExiste As Boolean
Local lcDeleted As String

Local loXA As Xmladapter

Try

	lcCommand = ""
	Use In Select( "cWorkingFolder" )
	lcDeleted = Set("Deleted")

	Set Deleted On

	lcMachine 	= Sys(0)
	lcUser 		= lcMachine
	lcMachine	= Alltrim( Upper( Substr( lcMachine, 1, At( "#", lcMachine ) - 1 ) ))
	lcUser 		= Alltrim( Upper( Substr( lcUser , At( "#", lcUser ) + 1 ) ) )

	lcWorkingFolder = Set("Default") + Curdir() + "Clientes"

	If FileExist( "WorkingFolder.Cfg" )
		loXA = Newobject("prxXMLAdapter",;
			"Fw\TierAdapter\Comun\prxxmladapter.prg" )

		loXA.LoadXML( "WorkingFolder.Cfg", .T. )
		loXA.Tables(1).ToCursor()

		loXA = Null


	Else
		TEXT To lcCommand NoShow TextMerge Pretext 15
		Create Cursor cWorkingFolder (
			Machine C(30),
			User C(30),
			WorkingFolder M )
		ENDTEXT

		&lcCommand

	Endif

	TEXT To lcCommand NoShow TextMerge Pretext 15
	Select *
		From cWorkingFolder
		Where Alltrim( Upper( Machine ) ) = '<<lcMachine>>'
			And  Alltrim( Upper( User ) ) = '<<lcUser>>'
		Into Cursor cCursor ReadWrite
	ENDTEXT

	&lcCommand

	If Empty( _Tally )
		Insert Into cCursor ( ;
			Machine,;
			User,;
			WorkingFolder ) Values ( ;
			lcMachine,;
			lcUser,;
			lcWorkingFolder )

	Endif

	lcEmpresa = Getwordnum( cCursor.WorkingFolder, Getwordcount( cCursor.WorkingFolder, "\" ), "\" )

	lcWorkingFolder = Getdir( cCursor.WorkingFolder, "Actual: " + lcEmpresa, "Directorio de Trabajo", 16 + 32 + 64 )

	If !Empty( lcWorkingFolder )
		Replace WorkingFolder With lcWorkingFolder In cCursor

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Delete cWorkingFolder From cCursor
			Where cWorkingFolder.Machine = cCursor.Machine
				And cWorkingFolder.User = cCursor.User
		ENDTEXT

		&lcCommand

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Insert Into cWorkingFolder (
			Machine,
			User,
			WorkingFolder ) Values (
			lcMachine,
			lcUser,
			lcWorkingFolder )
		ENDTEXT

		&lcCommand

		loXA = Newobject("prxXMLAdapter",;
			"Fw\TierAdapter\Comun\prxxmladapter.prg" )

		loXA.AddTableSchema( "cWorkingFolder" )
		loXA.PreserveWhiteSpace = .T.
		loXA.ToXML( "WorkingFolder.Cfg", "", .T. )

		loXA = Null

		TEXT To lcMsg NoShow TextMerge Pretext 03
		El nuevo directorio de trabajo es

		<<lcWorkingFolder>>
		ENDTEXT

		Inform( lcMsg, "Directorio de Trabajo" )

	Else
		TEXT To lcMsg NoShow TextMerge Pretext 03
		El directorio de trabajo continúa siendo

		<<cCursor.WorkingFolder>>
		ENDTEXT

		Inform( lcMsg, "Directorio de Trabajo" )

	Endif


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally
	Set Deleted &lcDeleted
	Use In Select( "cWorkingFolder" )

Endtry
