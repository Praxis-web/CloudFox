On Error Do Logerror

Local loColForms As ColForms Of "Tools\Sincronizador\colDataBases.prg"
Local loForm As oForm Of "Tools\Sincronizador\colDataBases.prg"
Local loData As oDataBase Of "Tools\Sincronizador\colDataBases.prg"
Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Local lcFormName As String
Local lcRet As String
Local loColEntities As Object
Local loTier As oECFG Of "Tools\Sincronizador\ColDataBases.prg"
Local lcClassLibrary As String
Local loCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
Local loProj As VisualFoxpro.IFoxProject
Local loFile As VisualFoxpro.IFoxPrjFile
Local i As Integer
Local loForm As Form
Local loEdit As EditBox


Try
	loCol = Newobject( 'Collection' )
	lcRet = ''
	loColForms = NewColForms()
	* For Each loForm In loColForms
	For i = 1 To loColForms.Count
		loForm = loColForms.Item[ 1 ]
		lcFormName = Addbs( loForm.cFolder ) + loForm.Name + "." + loForm.cExt
		Try
			loCol.Add( lcFormName, lcFormName )

		Catch To oErr
		Endtry

	Endfor

	loColEntities = NewEntitiesConfig()
	* For Each loTier In loColEntities
	For i = 1 To loColEntities.Count
		loTier = loColEntities.Item[ 1 ]
		lcClassLibrary = Addbs( Alltrim( loTier.cObjClassLibraryFolder ) ) + Alltrim( loTier.cObjClassLibrary ) + Alltrim( loTier.cObjClass )
		lcClassLibrary = Forceext( lcClassLibrary, 'prg' )
		Try
			loCol.Add( lcClassLibrary, lcClassLibrary )
		Catch To oErr
		Endtry

	Endfor

	loCol.KeySort = 2

	loProj = _vfp.ActiveProject
	* For Each lcStr In loCol
	For i = 1 To loCol.Count
		Try
			lcStr = loCol.Item[ i ]
			Try
				lcFileStr = Set("Default") + Addbs( Curdir() ) + lcStr
				loFile = loProj.Files( lcFileStr )

			Catch To oErr
				If File( lcFileStr )
					loProj.Files.Add( lcFileStr )
				Else
					lcRet = lcRet + lcFileStr + Chr( 13 )
					
				Endif
			Endtry
		Catch To oErr
		Endtry
	Endfor

	If ! Empty( lcRet )
		_Cliptext = lcRet

		loForm = Createobject( "Form" )
		loForm.AddObject( "cntEdit", "EditBox" )
		loForm.Width = 600

		loEdit = loForm.cntEdit
		loEdit.Visible = .T.
		*loEdit.ZOrder()

		loEdit.Top = 10
		loEdit.Left = 10
		loEdit.Width = loForm.Width - 20
		loEdit.Height = loForm.Height - 20
		loEdit.Anchor = 15

		loEdit.Value = lcRet

		loForm.Caption = "Archivos que no se Encontraron"
		loForm.AutoCenter = .T.

		loForm.Show( 1 )

	ENDIF && ! Empty( lcRet )

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )

Finally
	loError = Null
	loColForms = Null
	loColEntities = Null
	loForm = Null
	loEdit = Null
	loTier = Null
	loForm = Null

Endtry

Procedure Logerror()
	Local lcMsgError As String
	lcMsgError = '[P]:' + Program( Program(-1) -1 ) + Chr(13) ;
		+ '[E]' + Transform( Error() ) ;
		+ '[M]' + Message() + Chr(13) ;
		+ '[L]' + Transform( Lineno() ) + Chr(13) ;
		+ '[M1]' + Message(1)

	_Cliptext = lcMsgError
	Messagebox( lcMsgError )
	Strtofile( lcMsgError, 'logerror.txt', 1 )

Endproc && LogError