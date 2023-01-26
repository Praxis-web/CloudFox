Try

	Local lcFormName As String
	Local loForm As Form

	lcFormName = Getfile( "scx" )

	If !Empty( lcFormName )
		Do Form (lcFormName) Name loForm With -999999

		RecursiveSetUp( loForm )

		loForm.IdEntidad = -999999
		
		* Blanquear algunas propiedades
		loForm.oColIB = Null
		loForm.oColCombos  = Null
		loForm.oColKeyFinder = Null

		loForm.cUserTierClassLibraryFolder = ""
		loForm.lSaveAsScx = .F.

		loForm.oColObjects = Null
		loForm.oFirstFocus = Null
		loForm.oUserTier = Null
		
		loForm.SetAll( "Anchor", 0 )


		* Obtener el nombre del archivo .scx a crear
		lcFormName = Proper( Putfile( "", Proper(Addbs( Justpath( lcFormName )) + Juststem( lcFormName ) + Sys( 2015 )), "scx" ))

		If !Empty( lcFormName )
			* Crearlo
			loForm.SaveAs( lcFormName )
			Inform( "'" + lcFormName + "' se grabó correctamente" )
		Endif

	Endif

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )


Finally
	loForm.Release()
	loForm = Null

Endtry



*!* ///////////////////////////////////////////////////////
*!* Procedure.....: RecursiveSetUp
*!* Description...:
*!* Date..........: Lunes 3 de Marzo de 2008 (17:03:40)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Procedure RecursiveSetUp( oCtrl As Object ) As Object


	Try

		Local loObj As Object

		For Each loObj In oCtrl.Objects

			If Pemstatus( loObj, "Objects", 5 )
				RecursiveSetUp( loObj )
			Endif

			* BackUp de la propiedad PerformAutoSetup
			If Pemstatus( loObj, "lOldPerformAutoSetup", 5 )
				loObj.PerformAutoSetup = loObj.lOldPerformAutoSetup
			Endif

		Endfor


	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError


	Finally

	Endtry


Endproc
*!*
*!* END PROCEDURE RecursiveSetUp
*!*
*!* ///////////////////////////////////////////////////////