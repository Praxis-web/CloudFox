*!* ///////////////////////////////////////////////////////
*!* Class.........: dtHierarchical
*!* ParentClass...: dtArchivo
*!* BaseClass.....: Session
*!* Description...: Template para las MainEntities
*!* Date..........: Miercoles 29 de Julio 2009
*!* Author........: Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\TierAdapter\Include\TA.h"

Define Class dtHierarchical As dtArchivo Of "FW\Tieradapter\DataTier\dtArchivo.prg"

	#If .F.
		Local This As dtHierarchical Of "FW\Tieradapter\DataTier\dtHierarchical.prg"
	#Endif

	*!* Indica si la entidad es Jerarquica
	lIsHierarchical = .T.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: lIsHierarchical_Access
	*!* Date..........: Miércoles 12 de Agosto de 2009 (14:46:30)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure lIsHierarchical_Access()

		This.lIsHierarchical = This.oServiceTier.lIsHierarchical

		Return This.lIsHierarchical

	Endproc && lIsHierarchical_Access

Enddefine && dtHierarchical

