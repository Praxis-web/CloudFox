*!* ///////////////////////////////////////////////////////
*!* Procedure.....: CopyToObject
*!* Description...: Copia todas las propiedades del objeto de origen en el objeto destino
*!* Date..........: Viernes 17 de Octubre de 2008 (14:27:01)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Lparameters oSourceObject As Object,;
	oTargetObjet As Object,;
	cExcludedPropertiesList as String 
	
External Procedure ;
	IsInlist.prg	

Local lcCommand as String, lcMsg as String 

Try

	lcCommand = ""

	Local llReturn As Boolean

	Local lnLen As Integer,;
		lnI As Integer

	Local lcPropertyName As String
	
	If Empty( cExcludedPropertiesList )
		cExcludedPropertiesList = ""
	EndIf

	Dimension laMember(1)

	llReturn = .T.
	lnLen = Amembers( laMember, oSourceObject, 0 )

	For lnI = 1 To lnLen
		lcPropertyName = laMember[lnI]


		If !IsInlist( lcPropertyName,;
				cExcludedPropertiesList )

			Try

				oTargetObjet.&lcPropertyName = oSourceObject.&lcPropertyName

			Catch To oErr

			Finally

			Endtry
		Endif

	Endfor

Catch To loErr

	llReturn = .F.

*!*		Do While Vartype( loErr.UserValue ) == "O"
*!*			loErr = loErr.UserValue
*!*		Enddo

*!*		lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  METODO   ] " + loErr.Procedure + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  LINEA Nº ] " + Transform(loErr.Lineno) + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  COMANDO  ] " + loErr.LineContents + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  ERROR    ] " + Transform(loErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  MENSAJE  ] " + loErr.Message + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  DETALLE  ] " + loErr.Details + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )

*!*		StrToFile( lcMsg, "ErrorLog9.txt" )

*!*		Messagebox( lcMsg, 16, "Error", -1 )


Finally


EndTry

Return llReturn
*!*
*!* END PROCEDURE CopyToObject
*!*
*!* ///////////////////////////////////////////////////////
