Lparameters oTargetObject As Object, oSourceObject As Object
*!* ///////////////////////////////////////////////////////
*!* Procedure.....: PopulateProperties
*!* Description...: Carga las propiedades del objeto desde un Objeto pasado como parametro
*!* Date..........: Miércoles 11 de Marzo de 2009 (11:50:29)
*!* Author........: Damian Eiff
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Local llOk As Boolean
Local laMembers[1] As String
Local cProperty As String

Try

	llOk = .F.

	If Vartype( oTargetObject ) == "O" And Vartype( oSourceObject ) == "O"

		Amembers( laMembers, oSourceObject )

		For Each cProperty In laMembers
			Try

				Do Case
					Case Inlist( Vartype( oSourceObject.&cProperty ), 'C', 'D', 'G', 'L', 'N', 'Q', 'T', 'Y' )

						oTargetObject.&cProperty = oSourceObject.&cProperty

					Case Inlist( Vartype( oSourceObject.&cProperty ), 'U' )

						oTargetObject.&cProperty = oSourceObject.&cProperty

					Case Inlist( Vartype( oSourceObject.&cProperty ), 'X' )

						oTargetObject.&cProperty = oSourceObject.&cProperty

					Case Inlist( Vartype( oSourceObject.&cProperty ), 'O' )
						If ! Isnull( oTargetObject.&cProperty ) ;
								And Pemstatus( oTargetObject..&cProperty, 'PopulateProperties', 5 )
							oTargetObject.&cProperty..PopulateProperties( oSourceObject.&cProperty )
						Else
							oTargetObject.&cProperty = oSourceObject.&cProperty
						Endif

				Endcase

			Catch To oErr
				* No hago nada
			Endtry

		Endfor

	Endif

	llOk = .T.

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry
Return llOk

*!*
*!* END PROCEDURE PopulateProperties
*!*
*!* ///////////////////////////////////////////////////////