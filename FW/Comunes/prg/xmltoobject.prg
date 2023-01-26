*!* ///////////////////////////////////////////////////////
*!* Procedure.....: XmlToObject
*!* Description...: Recibe un XML, previamente serializado por ObjectToXML(), y lo convierte en el objeto original
*!* Date..........: Viernes 20 de Octubre de 2006 (16:55:04)
*!* Author........: Ricardo Aidelman
*!* Project.......: CMSI
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Lparameters cXML As String
Local loObj As Object


Try

	Local loXA As prxXMLAdapter Of "prxXMLAdapter.prg"
	loXA = Newobject("prxXMLAdapter","prxXMLAdapter.prg")

	loXA.LoadXML( cXML )
	loObj = loXA.ToObject()

Catch To oErr


Finally
	loXA = .F.

Endtry


Return loObj


