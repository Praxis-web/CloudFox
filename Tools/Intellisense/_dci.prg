Lparameters oFoxcode

If oFoxcode.Location #1
	Return "_DC"
Endif

#Define CRLF Chr(13)+Chr(10)

oFoxcode.valuetype = "V"

Local lcClassName 	As String

lcName = Inputbox( "Nombre de la Clase", "DEFINE CLASS" )
lcClassName = Proper( lcName )

If Len( Getwordnum( lcClassName, 1 ) ) = 1
	lcClassName = Substr( lcName, 1, 1 ) + Substr( lcClassName, 2 )
Endif

lcClassName = Strtran( lcClassName, " ", "" )


TEXT TO myvar TEXTMERGE NOSHOW
*!* ///////////////////////////////////////////////////////
*!* Class.........: <<lcClassName>>
*!* Description...:
*!* Date..........: <<DateMask(date())>> (<<time()>>)
*!*
*!*

Define Class <<lcClassName>> As prxIngreso Of "Rutinas\Prg\prxIngreso.prg"
	
	#If .F.
		Local This As <<lcClassName>> Of ""~
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: <<lcClassName>>
*!*
*!* ///////////////////////////////////////////////////////

ENDTEXT

Return myvar
