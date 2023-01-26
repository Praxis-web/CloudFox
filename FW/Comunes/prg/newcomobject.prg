Lparameters cComObjectName as String 
Local lcCommand As String,;
lcAlias as String,;
lcServerIP as String,;
lcClassId as String

Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
	loCOMPlusInfo As COMPlusInfo Of "Tools\ComPlusServer\ComPlusInfo\Prg\complusinfo.prg",;
	loComObject as Object 
	
Local llUseComPlus as Boolean 

Try

	lcCommand 			= ""
	lcAlias 			= Alias() 
	loCOMPlusInfo 		= Null
	loComObject 		= Null
	loGlobalSettings 	= NewGlobalSettings()
	
	If Empty( cComObjectName )
		cComObjectName = ""
	EndIf
	
	If loGlobalSettings.lUseComPlus 
		If IsNull( loGlobalSettings.oComPlusInfo )
			
			loGlobalSettings.lUseComPlus = .F.
			
			If .F. && FileExist( Alltrim( drComun ) + "Servidores.dbf" )
				M_Use( 0, Alltrim( drComun ) + "Servidores" )
				Select Servidores
				Locate
				
				lcServerIP 	= Alltrim( ServerIP )
				lcClassId	= Alltrim( ClassId ) 
				
				If .F. && lcServerIP = GetLocalIP()
					lcServerIP = ""  
				EndIf 
				
				Try

					Text To lcCommand NoShow TextMerge Pretext 15
					loCOMPlusInfo = CreateObjectEX( '<<lcClassId>>', '<<lcServerIP>>' ) 	
					EndText

					&lcCommand
					lcCommand = ""
					

				Catch To oErr
					Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
					loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
					loError.cRemark = lcCommand
					loError.Process ( m.oErr, .F., .T. )
					
					*MessageBox( loError.cErrorDescrip )

				Finally

				EndTry
				
				If Vartype( loCOMPlusInfo ) = "O"
					loGlobalSettings.oComPlusInfo 	= loCOMPlusInfo
					loGlobalSettings.lUseComPlus 	= .T.
					
				Else
					*MessageBox( 'Vartype( loCOMPlusInfo ) # "O"' )
						
				EndIf

			Else
				*MessageBox( 'FileExist( Alltrim( drComun ) + "Servidores.dbf" )' )
			EndIf
			
		Else 
			loCOMPlusInfo = loGlobalSettings.oComPlusInfo   	
			
		EndIf 
		
	EndIf
	
	If loGlobalSettings.lUseComPlus
		If loCOMPlusInfo.FullInfo( cComObjectName ) 
			lcClassID = loCOMPlusInfo.cClassID 
			cServerIP = loCOMPlusInfo.cServerIP  
			loComObject = CreateObjectEx( lcClassID, lcServerIP )  
			
		Else
			*MessageBox( 'loCOMPlusInfo.FullInfo( cComObjectName ) = .F.' )	
			
		EndIf
		
		If IsNull( loComObject ) 
			LogError( loCOMPlusInfo.cErrorMsg, 0, "NewComObjec( " + cComObjectName + ")" ) 
		EndIf

	EndIf 

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally
	If !Empty( lcAlias ) 
		Select Alias( lcAlias ) 
	EndIf
	
	loCOMPlusInfo = Null
	loGlobalSettings.oComPlusInfo = Null
	
EndTry

Return loComObject  


*Borrar

*
* 
PROCEDURE xxxM_Use( p1, cFile ) AS Void
	Local lcCommand as String
	
	Try
	
		lcCommand = ""
		Text To lcCommand NoShow TextMerge Pretext 15
		Use <<cFile>> Shared In 0
		EndText

		&lcCommand
		lcCommand = ""

		
		
	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	EndTry

EndProc && M_Use


