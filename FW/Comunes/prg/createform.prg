Lparameters tcFormKeyName As String

Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Local loCreateForm As Object
Try
	loCreateForm = Createobject( 'oCreateForm' )
	loCreateForm.Process( tcFormKeyName )

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )

Finally
	loError = Null

Endtry

Define Class oCreateForm As PrxSession Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"

	Procedure Process( tcFormKeyName As String )

		Local lcCommand As String
		Local loForm As As ABMGenericForm Of FW\Comunes\Vcx\prxMainForm.Vcx
		Local loColTables As ColTables Of "Tools\Sincronizador\colDataBases.prg"
		Local loCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loColFields As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loColHijos As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loDatosEntidad As ccmarco Of controles_varios.Vcx
		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
		Local loIB As IBContainer Of InputBoxes.Vcx
		Local loTableChild As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loPageframe As prxPageFrame Of prxbase.Vcx
		Local loPage As prxPage Of prxbase.Vcx
		Local loABMChild As ABMChildContainer Of prxMainForm.Vcx
		Local i As Integer
		Local lcWhere As String
		Local lcOldClasslib As String
		Local llDoAutosetup As Boolean

		Try
			lcOldClasslib = Set( "Classlib" )
			loError = This.oError

			If ! Empty( tcFormKeyName )

				lcFileTmp = Putfile( 'Selecione donde guradar el formulario', 'ABM' + tcFormKeyName, 'scx' )
				lcFileTmp = Strtran( lcFileTmp, 'abm', 'ABM' )
				lcFileTmp = Strtran( lcFileTmp, Lower( tcFormKeyName ), tcFormKeyName )

				If .T. &&  ! File( lcFileTmp )
					If File( lcFileTmp ) And Messagebox( 'Ya existe el archvi quiere borrarlo y crearlo nuevamente',4+32+256,'',5000 ) = 6
						TEXT To lcCommand NoShow TextMerge Pretext 15
							Delete File '<<lcFileTmp>>'
						ENDTEXT

						loError.cTraceLogin = 'Ejecutando el comando: ' + lcCommand
						&lcCommand

					Endif

					TEXT To lcCommand NoShow TextMerge Pretext 15
						Create Form '<<lcFileTmp>>' As ABMGenericForm From FW\Comunes\Vcx\prxMainForm.vcx nowait save

					ENDTEXT


					loError.cTraceLogin = 'Ejecutando el comando: ' + lcCommand
					&lcCommand

					loForm = This.GetForm()

					If Vartype( loForm ) = 'O'
						* @TODO Damian Eiff 2009-08-18 (01:45:10)
						* Implementar la creación de los controles dinamicamente desde el sincronizador
						loColTables = NewcolTables()
						lcFormKeyName = CamelProperCase( tcFormKeyName )
						loForm.Caption = Printf( 'ABM %s', lcFormKeyName )
						loForm.Name = 'ABM' + Strtran( lcFormKeyName, Space( 1 ), '' )
						loForm.cDataConfigurationKey = Strtran( lcFormKeyName, Space( 1 ), '' )
						loError.cTraceLogin = loError.cTraceLogin + Chr( 13 ) + loForm.Caption

						lcWhere = 'Lower(padre)==' + Any2Char( Lower( Strtran( lcFormKeyName, Space( 1 ), '' ) ), .T. )

						loError.cTraceLogin = loError.cTraceLogin + Chr( 13 ) + 'Filtro: ' + lcWhere
						loColHijos = loColTables.Where ( lcWhere )

						loTable = loColTables.GetItem( tcFormKeyName )
						loColFields = loTable.oColFields.Where ( ' (lIsSystem = .F.) Or (Lower(Name) == "default") ' )
						lnFieldsCount = loColFields.Count
						lnTabIndex = 1

						If lnFieldsCount > 0
							lcContainerName = 'DatosEntidad' + loTable.Name
							This.SetClassLib( 'controles_varios.vcx' )

							loForm.AddObject( lcContainerName, 'ccmarco' )
							loDatosEntidad = loForm.&lcContainerName.
							loDatosEntidad.Visible = .T.
							loDatosEntidad.TabIndex = lnTabIndex
							loDatosEntidad.nFitMode = 5
							loDatosEntidad.lFitToParent = .T.
							loDatosEntidad.lblTitulo.Visible = .F.
							loDatosEntidad.nTopPadding = loDatosEntidad.nBottomPadding
							lnTabIndex = lnTabIndex + 1

							For i = 1 To lnFieldsCount
								loField = loColFields.Item[ i ]
								llOk1 = Empty( loField.References ) Or Lower( loField.References ) # Lower( loTable.Padre )
								llOk2 = Empty( loTable.MainID ) Or Lower( loField.Name ) # Lower( loTable.MainID )

								If llOk1 And llOk2
									lcControlName = 'cnt' + loField.Name
									This.SetClassLib( loField.DisplayClassLibrary )

									loDatosEntidad.AddObject( lcControlName, loField.DisplayClass )
									loIB = loDatosEntidad.&lcControlName.
									loIB.TabIndex = i
									loIB.Visible = .T.
									* loIB.cFieldName = loField.Name
									* loIB.cKeyName = Lower( tcFormKeyName + '.' + loField.Name )
									If ! Empty( loField.References ) ;
											And Pemstatus( loIB, 'cDataConfigurationKey', 5 )
										loIB.cDataConfigurationKey = loField.References

									Endif

								Endif

							Endfor

						Endif

						lnHijosCount = loColHijos.Count
						Do Case
							Case lnHijosCount = 1
								loTableChild = loColHijos.Item[ 1 ]
								lcDataConfigurationKey = CamelProperCase( loTableChild.Name )
								lcContainerName = 'ABM' + Strtran( lcDataConfigurationKey, Space( 1 ), '' )
								If loTableChild.lIsHierarchical
									lcContainerClass = 'ABMChildTree'

								Else
									lcContainerClass  = 'ABMChildGrid'

								Endif

								This.SetClassLib( 'PrxMainForm.vcx' )
								loForm.AddObject( lcContainerName, lcContainerClass )
								loABMChild = loForm.&lcContainerName.

								loABMChild.Visible = .T.
								loABMChild.nFitMode = 5
								loABMChild.lFitToParent = .T.

								loABMChild.cDataConfigurationKey = Strtran( lcDataConfigurationKey, Space( 1 ), '' )
								loABMChild.TabIndex = lnTabIndex
								loABMChild.lblTitulo.Caption = lcDataConfigurationKey
								lnTabIndex = lnTabIndex + 1

							Case lnHijosCount > 1
								lcPageFrameName = 'pgHijos'
								This.SetClassLib( 'prxbase.vcx' )
								loForm.AddObject( lcPageFrameName, 'prxpageframe' )
								loPageframe = loForm.&lcPageFrameName.
								loPageframe.Visible = .T.
								loPageframe.TabIndex = lnTabIndex
								lnTabIndex = lnTabIndex + 1

								* FW
								loPageframe.nFitMode = 5
								loPageframe.lFitToParent = .T.
								loPageframe.PageCount = lnHijosCount
								loPageframe.Tabs = .T.

								This.SetClassLib( 'PrxMainForm.vcx' )
								For i = 1 To lnHijosCount
									loTableChild = loColHijos.Item[ i ]
									* lcContainerName = 'ABM' + loTableChild.Name
									lcDataConfigurationKey = CamelProperCase( loTableChild.Name )
									lcContainerName = 'ABM' + Strtran( lcDataConfigurationKey, Space( 1 ), '' )
									If loTableChild.lIsHierarchical
										lcContainerClass = 'ABMChildTree'

									Else
										lcContainerClass  = 'ABMChildGrid'

									Endif

									loPage = loPageframe.Pages[ i ]
									loPage.AddObject( lcContainerName, lcContainerClass )
									loABMChild = loPage.&lcContainerName.

									loABMChild.Visible = .T.
									loABMChild.nFitMode = 15
									loABMChild.lFitToParent = .T.
									loABMChild.cDataConfigurationKey = Strtran( lcDataConfigurationKey, Space( 1 ), '' ) && loTableChild.Name
									loABMChild.TabIndex = 1
									loABMChild.lblTitulo.Caption = lcDataConfigurationKey && CamelProperCase( loTableChild.Name )

								Endfor

							Otherwise

						Endcase

						loForm.Navigator.TabIndex = lnTabIndex
						lnTabIndex = lnTabIndex + 1

						loForm.Optionpanel.TabIndex = lnTabIndex

						lcMsg = Printf( '¿Desea ejecutar el proceso "Autosetup" para el nuevo formulario ABM %s?', lcFormKeyName )
						llDoAutosetup = ( Messagebox( lcMsg, 4 + 32 + 256, '', 5000 ) = 6 )
						If llDoAutosetup
							Sys( 1500, '_MFI_SAVE', '_MFILE' )
							DoEvents
							Do DoAutosetup

						Endif && llDoAutosetup

						This.SaveAndClose( .T. )

						If Type( '_vfp.ActiveProject' ) = 'O'

							lcMsg = Printf( '¿Desea agregar el nuevo formulario al proyecto %s?', Justfname( _vfp.ActiveProject.Name) )
							llAddToProyect = ( Messagebox( lcMsg, 4 + 32 + 256, '', 5000 ) = 6 )
							If llAddToProyect
								_vfp.ActiveProject.Files.Add( lcFileTmp )

							Endif && llAddToProyect

						Endif && Type( '_vfp.ActiveProject' ) = 'O'

					Endif && Vartype( loForm ) = 'O'

				Endif && ! File( lcFileTmp )

			Endif && ! Empty( tcFormKeyName )

		Catch To oErr
			loError = This.oError
			loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

			loColTables = Null
			loCol = Null
			loColFields = Null
			loColHijos = Null
			loTable = Null
			loError = Null
			loDatosEntidad = Null
			loField = Null
			loIB = Null
			loTableChild = Null
			loPageframe = Null
			loPage = Null
			loABMChild = Null

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Set Classlib To '<<lcOldClasslib>>'
			ENDTEXT
			Try
				&lcCommand
			Catch To oErr
			Endtry

		Endtry

	Endproc && Process

	Protected Procedure GetForm() As ABMGenericForm Of FW\Comunes\Vcx\prxMainForm.Vcx
		Local loForm As ABMGenericForm Of FW\Comunes\Vcx\prxMainForm.Vcx
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local Array laobj[ 1 ] As Variant

		Try
			Aselobj( laobj, 1 )
			loForm = laobj[ 1 ]
			Do While ! Isnull( loForm ) And Lower( loForm.BaseClass ) # 'form'
				loForm = loForm.Parent

			Enddo && GetForm

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

			Store .F. To laobj

		Endtry

		Return loForm

	Endproc

	Protected Procedure SetClassLib( tcClassLib As String )
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			If ! Empty( tcClassLib )
				tcClassLib = Lower( tcClassLib )

				If ! ( tcClassLib $ Lower( Set( 'Classlib' ) ) ) And File( tcClassLib )
					TEXT To lcCommand NoShow TextMerge Pretext 15
						Set Classlib To '<<tcClassLib>>' Additive
					ENDTEXT

					&lcCommand

				Endif

			Endif

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

		Endtry

	Endproc && SetClassLib

	*
	* SaveAndClose
	Protected Procedure SaveAndClose( tlSave As Boolean ) As VOID
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			If tlSave
				* Grabo el archivo
				* Asi evito que me pregunte al cerrar el formulario si lo quiero grabar
				Sys( 1500, '_MFI_SAVE', '_MFILE' )
				DoEvents
			Endif && tlSave

			* Cierro el archivo
			Sys( 1500, '_MFI_CLOSE', '_MFILE' )


		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

		Endtry

	Endproc && SaveAndClose

Enddefine

*!*	Local loFrm As ABMDynamicForm Of prxDynamic.vcx
*!*	Local llShowForm As Boolean
*!*	Local llSaveForm As Boolean
*!*	Local loError As prxErrorHandler Of "FW\ErrorHandler\prxErrorHandler.prg"
*!*	Local lnStyle As Integer
*!*	Try

*!*		If ! Empty( tcFormKeyName )

*!*			If Vartype( toParam ) # 'O'
*!*				toParam = Createobject( 'Empty' )

*!*			Endif && Vartype( toParam ) # 'O'

*!*			llShowForm = ( Pemstatus( toParam, 'lShowForm', 5 ) And toParam.lShowForm )
*!*			llSaveForm = ( Pemstatus( toParam, 'lSaveForm', 5 ) And toParam.lSaveForm )

*!*			lnStyle = 0
*!*			If Pemstatus( toParam, 'WindowType', 5 )
*!*				lnStyle = toParam.WindowType

*!*			Endif

*!*			*!*	If Pemstatus( toParam, 'cFilePath', 5 ) And ! Empty( toParam.cFilePath )
*!*			*!*		lcFileTmp = Forceext( toParam.cFilePath, 'scx' )

*!*			*!*	Else
*!*			*!*		lcFileTmp = Forceext( Addbs( Getenv( "TEMP" ) ) + Alltrim( tcFormKeyName ) + Sys( 2015 ), 'scx' )

*!*			*!*	Endif

*!*			* loParam = createobjParam( 'cDataConfigurationKey', tcFormKeyName, ;
*!*			'lModalWindowType', ( lnStyle = 1 ) )

*!*			loParam = createobjParam( 'cDataConfigurationKey', tcFormKeyName, ;
*!*				'lModalWindowType', .T. )

*!*			Do Form FW\Comunes\scx\ABMDynamic.scx Name loFrm With loParam Noshow

*!*			* loFrm = Newobject( 'ABMDynamicForm', 'prxDynamic.vcx', '', loParam )

*!*			If llShowForm
*!*				loFrm.Show( 1 )

*!*			Endif && llShowForm

*!*			If Vartype( loFrm ) = 'O'
*!*				If ! Pemstatus( toParam, 'lSaveForm', 5 )
*!*					llSaveForm = ( Messagebox( '¿Desea guardar el nuevo formulario?', 4 + 32 + 256, '', 5000 ) = 6 )

*!*				Endif

*!*				If llSaveForm
*!*					lcFileTmp = Putfile( 'Selecione donde guradar el formulario', 'ABM' + tcFormKeyName, 'scx' )
*!*					lcFileTmp = Strtran( lcFileTmp, 'abm', 'ABM' )
*!*					lcFileTmp = Strtran( lcFileTmp, Lower( tcFormKeyName ), tcFormKeyName )

*!*					loFrm.SaveAs( lcFileTmp )

*!*					If Type( '_vfp.ActiveProject' ) = 'O'

*!*						lcMsg = printf( '¿Desea agregar el nuevo formulario al proyecto %s?', Justfname( _vfp.ActiveProject.Name) )
*!*						llAddToProyect = ( Messagebox( lcMsg, 4 + 32 + 256, '', 5000 ) = 6 )
*!*						If llAddToProyect
*!*							_vfp.ActiveProject.Files.Add( lcFileTmp )

*!*						Endif
*!*					Endif
*!*				Endif

*!*				loFrm.Release()

*!*			Endif

*!*			loFrm = Null

*!*			TEXT To lcCommand NoShow TextMerge Pretext 15
*!*				Use '<<lcFileTmp>>' In 0 Exclusive Alias scx Again
*!*			ENDTEXT

*!*			If File( lcFileTmp )
*!*				&lcCommand

*!*				* ..\..\..\fw\comunes\vcx\prxmainform.vcx
*!*				If Used( 'scx' )
*!*					* Select scx
*!*					Replace Class With 'ABMGenericForm', ;
*!*						ClassLoc With 'FW\Comunes\Vcx\prxMainForm.vcx' ;
*!*						For Lower( BaseClass ) = 'form' ;
*!*						In scx

*!*				Endif && Used( 'scx' )

*!*			Endif

*!*			Use In Select( 'scx' )

*!*		Endif && ! Empty( tcFormKeyName )

*!*	Catch To oErr
*!*		loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
*!*		loError.Process( oErr, .T. )

*!*	Finally
*!*		loError = Null

*!*		Use In Select( 'scx' )

*!*	Endtry