*!* ///////////////////////////////////////////////////////
*!* Class.........: HdPage
*!* ParentClass...: prxPage
*!* BaseClass.....: Page
*!* Description...: Clase Page personalizada para la clase HeaderDetail
*!* Date..........: Miércoles 18 de Octubre de 2006 (16:59:56)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistema Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -  
*!*
*!*	

DEFINE CLASS HdPage AS prxPage of "FW\Comunes\Prg\prxBaseLibrary.prg"

#IF .F.
	Local this as HdPage OF "HeaderDetail.prg"
#ENDIF  	   

PerformAutoSetUp = .T.
Name = "HdPage"

_memberdata = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
	[<VFPData>] + ;
	[</VFPData>] 


ENDDEFINE
*!* 
*!* END DEFINE
*!* Class.........: HdPage
*!* 
*!* ///////////////////////////////////////////////////////