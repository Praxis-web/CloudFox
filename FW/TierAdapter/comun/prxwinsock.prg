*!* ///////////////////////////////////////////////////////
*!* Class.........: WinsockWrapper
*!* ParentClass...: Form
*!* BaseClass.....: Form
*!* Description...: Envoltura de Winsock para evitar problemas de registro 
*!*                 cuando se instancia desde .prg
*!* Date..........: Jueves 17 de Enero de 2008 (16:47:17)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class WinsockWrapper As Form

	#If .F.
		Local This As WinsockWrapper Of "Fw\comunes\Prg\PrxWinsock.prg"
	#Endif

	Add Object prxWinsock As PrxWinsockContainer With ;
		Top = 8, ;
		Left = 8, ;
		Height = 100, ;
		Width = 100, ;
		Name = "PrxWinsock"

Enddefine
*!*
*!* END DEFINE
*!* Class.........: WinsockWrapper
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxWinsockContainer
*!* ParentClass...: OLEControl
*!* BaseClass.....: OLEControl
*!* Description...:
*!* Date..........: Jueves 17 de Enero de 2008 (16:56:16)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxWinsockContainer As OleControl

	#If .F.
		Local This As prxWinsock Of "Fw\comunes\Prg\PrxWinsock.prg"
	#Endif

	OleClass = 'MSWinsock.Winsock'

Enddefine
*!*
*!* END DEFINE
*!* Class.........: PrxWinsockContainer
*!*
*!* ///////////////////////////////////////////////////////