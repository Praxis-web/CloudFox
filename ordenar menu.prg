#INCLUDE "FW\Comunes\Include\Praxis.h"

Local lcCommand As String,;
	lcMenuFileName As String,;
	lcDefaultFolder As String,;
	lcDefaultDrive As String,;
	lcWorkingFolder As String,;
	lcKeyList As String,;
	lcKey As String,;
	lcGroupsList As String,;
	lcUsersList As String,;
	lcField As String,;
	lcAlias As String,;
	lcStr As String

Local lnKeyCount As Integer,;
	i As Integer,;
	j As Integer,;
	lnLen As Integer

Local Array laFields[1]


Try

	lcCommand = ""
	Close Databases All

	lcDefaultDrive = Set("Default")
	lcDefaultFolder = Curdir()

	lcWorkingFolder = GetWorkingFolder()

	If !Empty( lcWorkingFolder )
		Cd ( lcWorkingFolder + "\Datos" )
	Endif

	lcMenuFileName = Getfile( "dbf", "", "", 0, "Seleccione el Archivo de Menu" )

	If !Empty( lcMenuFileName )
		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select *
			From "<<lcMenuFileName>>"
			Where !Deleted()
			Order By Id
			Into Cursor cMenu ReadWrite
		ENDTEXT

		&lcCommand


		TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From cMenu
				Where !Deleted()
				Into Table "<<lcMenuFileName>>"
		ENDTEXT

		&lcCommand

		Close Databases All

		MessageBox( "Terminado",64, "Ordenamiento del Menú" )

	Endif

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )


Finally
	Close Databases All

	TEXT To lcCommand NoShow TextMerge Pretext 15
	Cd <<lcDefaultDrive>><<lcDefaultFolder>>
	ENDTEXT

	Try

		&lcCommand

	Catch To oErr

	Finally

	Endtry


Endtry



*
*
Procedure GetWorkingFolder(  ) As Void
	Local loXA As Xmladapter

	Local lcCommand As String,;
		lcWorkingFolder As String,;
		lcUser As String,;
		lcMachine As String

	Try

		lcCommand = ""
		lcWorkingFolder = ""

		lcMachine 	= Sys(0)
		lcUser 		= lcMachine
		lcMachine	= Alltrim( Upper( Substr( lcMachine, 1, At( "#", lcMachine ) - 1 ) ))
		lcUser 		= Alltrim( Upper( Substr( lcUser , At( "#", lcUser ) + 1 ) ) )


		Use In Select( "cWorkingFolder" )

		If !FileExist( "WorkingFolder.Cfg" )
			Do 'Tools\Varios\prg\SetearEmpresa.prg'
		Endif

		loXA = Newobject("prxXMLAdapter",;
			"Fw\TierAdapter\Comun\prxxmladapter.prg" )

		loXA.LoadXML( "WorkingFolder.Cfg", .T. )
		loXA.Tables(1).ToCursor()

		loXA = Null
		
		Select cWorkingFolder
		Locate For Alltrim( Upper( Machine ) ) = lcMachine ;
			And  Alltrim( Upper( User ) ) = lcUser
			
		If Found()
			lcWorkingFolder = Alltrim( cWorkingFolder.WorkingFolder )
		EndIf	
		

	Catch To loErr
		Local loError As ErrorHandler Of 'v:\Clipper2Fox\Tools\ErrorHandler\Prg\ErrorHandler.prg'
		DEBUG_EXCEPTION
		loError = Newobject ( 'ErrorHandler', 'v:\Clipper2Fox\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		m.loError.Process ( m.loErr )
		THROW_EXCEPTION

	Finally
		loXA = Null

	Endtry

	Return lcWorkingFolder

Endproc && GetWorkingFolder
