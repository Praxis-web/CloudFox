*!* ///////////////////////////////////////////////////////
*!* Procedure.....: ObjectToXml
*!* Description...: Recibe un objeto y lo devuelve serializado como un XML
*!* Date..........: Viernes 20 de Octubre de 2006 (16:44:32)
*!* Author........: Ricardo Aidelman
*!* Project.......: CMSI
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Lparameters oObj As Object, lFormattedOutput as Boolean 
Local lcXML As String

Try
	If Vartype( oObj ) <> "O"
		oObj = Createobject( "Empty" )
	Endif

	Local loXA As prxXMLAdapter Of "prxXMLAdapter.prg"
	loXA = Newobject("prxXMLAdapter","prxXMLAdapter.prg")
	
	loXA.FormattedOutput = lFormattedOutput

	loXA.LoadObj( oObj )
	loXA.ToXML( "lcXML" )


Catch To oErr


Finally
	loXA = .F.

EndTry

External Procedure LenNum.prg

Return lcXML
