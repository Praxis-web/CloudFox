* COPYCLASS.PRG by Ben Creighton
* pClasslib: File name of source library, will be forced to a VCX extension
* pClassName: Class name from source library
* pTargetClasslib: File name of target library, will be forced to a VCX or SCX extension
* pTargetClassName: New Class name in target library OR .T. to create a SCX file

Lparameters pClasslib As String, pClassName As String, pTargetClasslib As String, pTargetClassName As String

Local locopyobj As copyvcx Of tools\actual\vcxtools\prg\copyclass.prg

If ! Empty( pClasslib )

	locopyobj = Newobject( 'copyvcx', 'tools\actual\vcxtools\prg\copyclass.prg', '', ;
		m.pClasslib, m.pClassName, m.pTargetClasslib, m.pTargetClassName )

	locopyobj.Run()

Endif

Return

* Session Class Definition
Define Class copyvcx As Session
	DataSession = 2

	cClasslib = ''
	cClassName = ''
	cTargetClasslib = ''
	cTargetClassName = ''

	Procedure Init( pClasslib As String, pClassName As String, ;
			pTargetClasslib As String,;
			pTargetClassName As String )

		This.cClasslib = pClasslib
		This.cClassName = pClassName
		This.cTargetClasslib = pTargetClasslib
		This.cTargetClassName = pTargetClassName

	Endproc

	Procedure Run() As VOID

		Local tempfileC, formsA[1]
		Try

			lcCommand = ""
			
			Set Deleted On

			If Empty( This.cClasslib )

				Error 'No se puede copiar: Falta indicar el parametro pClasslib'

			Endif

			* Process parameters
			This.cClasslib = Forceext( This.cClasslib, 'VCX' )
			This.cClassName = Lower( This.cClassName )
			If Vartype( This.cTargetClassName ) = 'L' And This.cTargetClassName
				This.cTargetClassName = ''
				This.cTargetClasslib = Forceext( This.cTargetClasslib, 'SCX' )
			Else
				This.cTargetClassName = Iif( Empty( This.cTargetClassName ), This.cClassName, Lower( This.cTargetClassName ) )
				This.cTargetClasslib = Forceext( This.cTargetClasslib, 'VCX' )
			Endif

			If File( This.cClasslib )
				* Libero el ClassLib
				Clear Class This.cClassName
				Clear Classlib ( This.cClasslib )
				Clear Classlib ( This.cTargetClasslib )

				* Create a cursor from pClasslib that contains the selected class
				Select * From ( This.cClasslib );
					Where ( Like( This.cClassName + '*', Lower( Parent ) ) ;
					Or ( Lower( objname ) == This.cClassName And Empty( Parent ) ) ;
					Or Lower( uniqueid ) == 'class' );
					And ! Deleted() ;
					into Cursor Source Readwrite

				If _Tally > 0

					Update Source;
						Set Parent = This.cTargetClassName;
						Where Lower( Parent ) == This.cClassName

					Update Source;
						Set objname = This.cTargetClassName;
						Where Lower( objname ) == This.cClassName ;
						And Empty( Parent )

					* Copy source cursor into target library
					Do Case
						Case Empty( This.cTargetClassName )
							* Create a SCX file
							Select * From Source ;
								Where Empty( Parent ) ;
								And Lower( BaseClass ) == 'form' ;
								Into Array formsA

							If _Tally > 0

								Update Source;
									Set uniqueid = 'Screen';
									Where Lower( uniqueid ) == 'Class'

								Copy To ( This.cTargetClasslib )

							Else

								Error 'No se puede copiar: ' + This.cClassName + ' su baseclass no es form'

							Endif

						Case File( This.cTargetClasslib )

							* Copy into existing target library
							Select * From ( This.cTargetClasslib );
								Where Lower( objname ) == This.cTargetClassName ;
								And Empty( Parent );
								Into Cursor destination

							If _Tally = 0

								Insert Into ( This.cTargetClasslib );
									Select * From Source ;
									Where uniqueid <> 'Class'
							Else

								Error 'No se puede copiar: ' + This.cTargetClassName + ' ya existe en ' + This.cTargetClasslib

							Endif

						Otherwise

							* Create a brand new library
							Copy To ( This.cTargetClasslib )

					Endcase

				Else

					Error 'No se puede copiar: ' + This.cClassName + ' no existe en ' + This.cClasslib

				Endif

			Else

				Error 'No se puede copiar: ' + This.cClasslib + ' no existe'

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError
		Finally

			Use In Select( 'Source' )
			Use In Select( 'destination' )

		Endtry

	Endproc
Enddefine

Define Class copyclass As Form

Enddefine
