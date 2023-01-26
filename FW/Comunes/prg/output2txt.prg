Lparameters tcType as Character,;
	tcAlias As String,;
	lcFName As String,;
	tcUDF As String,;
	tcExcludedFieldList As String

#INCLUDE "FW\Comunes\Include\Praxis.h"

Local llDone As Boolean
Local loDT As PrxDataTier Of "V:\Clipper2fox\Fw\Tieradapter\Comun\Prxdatatier.prg"
Local lcFieldList As String,;
	lcAlias As String,;
	lcDefault As String,;
	lcCurDir As String,;
	lcSistemFolder as String,;
	lcType as String 

Try
	llDone = .F.
	lcAlias = Sys(2015)
	lcDefault = Set("Default")
	lcCurDir = Curdir()


	Wait Windows Nowait "Generando Archivo de Texto ...."

	If Empty( lcFName )
		lcFName = ""
	Endif

	lcFName = Strtran( lcFName, "/", " " )

	If !Empty( tcExcludedFieldList )
		loDT = NewDT()
		lcFieldList = loDT.GetUpdatableFieldList( tcAlias, tcExcludedFieldList )

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select <<lcFieldList>>
			From <<tcAlias>>
			Into Cursor <<lcAlias>> ReadWrite
		ENDTEXT

		&lcCommand

		tcAlias = lcAlias

	Endif

	TEXT To lcCommand NoShow TextMerge Pretext 15
		Cd '<<GetEnv("HOMEDRIVE")>><<GetEnv("HOMEPATH")>>'
	ENDTEXT

	lcFileName = Putfile( "", lcFName, "TXT" )


	TEXT To lcCommand NoShow TextMerge Pretext 15
		Cd '<<lcDefault>><<lcCurDir>>'
	ENDTEXT

	&lcCommand

	If !Empty( lcFileName )
		Select Alias( tcAlias )
		
		If tcType = S_CSV
			lcType = "CSV"
			 
		Else
			lcType = "SDF"
			
		Endif

		Text To lcCommand NoShow TextMerge Pretext 15
		Copy To '<<lcFileName>>' Type <<lcType>>
		EndText

		&lcCommand

		Locate
		
		lcSistemFolder = Addbs( JustPath( GetEnv("ComSpec") ))
		RunShell( lcSistemFolder + "Notepad.exe", lcFileName )
		
	Endif

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	Wait Clear
	loDT = Null
	Use In Select( lcAlias )

Endtry

Return llDone