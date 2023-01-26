*!* ///////////////////////////////////////////////////////
*!* Procedure.....: SynchronizeObjects
*!* Description...: Sincroniza las propiedades de dos objetos
*!* Date..........: Miércoles 24 de Octubre de 2007 (16:24:29)
*!* Author........: Ricardo Aidelman
*!* Project.......: OOReport Builder
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*


Lparameters oParent As Object, oChild As Object, nFlag As Numeric


Try

	Dimension laMember(1)
	Local lcPropertyName As String
	Local lnI As Integer,;
		lnLen As Integer

	If Empty( nFlag )
		nFlag = 1
	Endif

	lnLen = Amembers( laMember, oParent, 0 )

	For lnI = 1 To lnLen
		lcPropertyName = laMember[lnI]
		Try
			If Pemstatus( oChild, lcPropertyName, 5 )
				If nFlag = 1
					oParent.&lcPropertyName = oChild.&lcPropertyName
				Else
					oChild.&lcPropertyName = oParent.&lcPropertyName
				Endif
			Endif


		Catch To oErr

		Finally

		Endtry

	Endfor



Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError


Finally

Endtry


*!*
*!* END PROCEDURE SynchronizeObjects
*!*
*!* ///////////////////////////////////////////////////////