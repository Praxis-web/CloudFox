Lparameters oParam As Object

#INCLUDE "FW\Comunes\Include\Praxis.h"

Local lcCommand As String

Local loOutputOptions As Object

Local lnProgramId As Integer,;
	lnUserId As Integer,;
	lnTerminalId As Integer,;
	lnCopias as Integer 

Local lcSalidas As String,;
	lcPDF As String,;
	lcMail As String,;
	lcDefault As String

Local llPDF As Boolean


Try

	lcCommand 	= ""
	lcSalidas 	= ""
	lcDefault 	= ""
	lcMail 		= ""
	lcPDF 		= ""  
	lnCopias 	= 1

	If Vartype( oParam ) # "O"
		oParam = Createobject( "Empty" )
	Endif

	Try
		* Verificar que PDFCreator esté Instalado
		loPDF = Createobject("PDFCreator.clsPDFCreator")
		llPDF = .T.
		lcPDF =  S_PDF + ","

	Catch To oErr
		llPDF = .F.
		lcPDF = ""

	Finally


	EndTry
	
	If !Empty( lcPDF ) 
		If GetValue( "SendMail", "ar0Var", "N" ) = "S"
			lcMail = S_MAIL + "," 
		EndIf 
	EndIf

	* Opciones por Default
	*!*		TEXT To lcSalidas NoShow TextMerge Pretext 15
	*!*		<<S_IMPRESORA>>,
	*!*		<<S_VISTA_PREVIA>>,
	*!*		<<S_HOJA_DE_CALCULO>>,
	*!*		<<lcPDF>>
	*!*		<<S_PANTALLA>>,
	*!*		<<S_CSV>>,
	*!*		<<S_SDF>>
	*!*		ENDTEXT



	TEXT To lcSalidas NoShow TextMerge Pretext 15
	<<S_IMPRESORA>>,
	<<S_VISTA_PREVIA>>,
	<<lcPDF>>
	<<lcMail>> 
	<<S_HOJA_DE_CALCULO>>
	ENDTEXT

	If GetValue( "PrintDOS", "ar0Var", "N" ) = "S"
		*lcDefault = S_LISTADO_DOS

		TEXT To lcSalidas NoShow TextMerge Pretext 15 ADDITIVE
		,S_LISTADO_DOS,S_TXT
		ENDTEXT

	Else
		*lcDefault = S_IMPRESORA

	EndIf
	
	lcDefault = S_IMPRESORA


	If Pemstatus( oParam, "cSalidas", 5 )
		lcSalidas = oParam.cSalidas
	Endif

	If Pemstatus( oParam, "cDefault", 5 )
		lcDefault = oParam.cDefault
	Endif

	If Pemstatus( oParam, "nCopias", 5 )
		lnCopias = oParam.nCopias
	Endif

	loOutputOptions = Createobject( "Empty" )
	AddProperty( loOutputOptions, "cSalidas", lcSalidas )
	AddProperty( loOutputOptions, "cDefault", lcDefault )
	AddProperty( loOutputOptions, "nCopias", lnCopias )
	AddProperty( loOutputOptions, "nStatus", 0 )

	If Pemstatus( oParam, "ProgramId", 5 )
		lnProgramId = oParam.ProgramId
	Endif

	If Pemstatus( oParam, "UserId", 5 )
		lnUserId = oParam.Userid
	Endif

	If Pemstatus( oParam, "TerminalId", 5 )
		lnTerminalId = oParam.TerminalId
	Endif

	* RA 2012-11-10(13:11:02)
	* Acá se obtienen las opciones de salida
	* desde los parametros de listados
	* para un programa determinado y un Usuario/Terminal

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.cRemark = lcCommand
	loError.Process( oErr )
	Throw loError

Finally
	loPDF = Null


Endtry

Return loOutputOptions