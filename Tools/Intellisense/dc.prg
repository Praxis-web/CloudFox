Lparameters oFoxcode

If oFoxcode.Location #1
	Return "DC"
Endif

#Define CRLF Chr(13)+Chr(10)

#IfNDEF _USER
	#Define _USER ""
#Endif

#IfNDEF _PROJECTENV
	#Define _PROJECTENV ""
#Endif

oFoxcode.valuetype = "V"

*Set Path To "V:\SISTEMAS PRAXIS\FW\ACTUAL\COMUN\PRG\" Additive

Local lcClassName 	As String		,;
	lcParentClass 	As String		,;
	lcBaseClass 	As String 		,;
	lcDescription 	As String,;
	lcFolder As String,;
	lcParentClassLibrary As String,;
	lcName as String 

lcName = Inputbox( "Nombre de la Clase", "DEFINE CLASS" )
lcClassName = Proper( lcName )


If Len( Getwordnum( lcClassName, 1 ) ) = 1
    lcClassName = Substr( lcName, 1, 1 ) + Substr( lcClassName, 2 )
Endif

lcClassName = Strtran( lcClassName, " ", "" )

lcParentClassLibrary = ""

Wait Window NoWait Noclear "Deje vacía si la clase base No es Nativa"
lcParentClass	= Inputbox( "ParentClass", "DEFINE CLASS", "Session" )

If Empty( lcParentClass )
	Wait Window NoWait Noclear "Seleccione la Librería donde está definida la Clase Padre"
	lcParentClassLibrary = Getfile( 'PRG', "Libreria","", 0, "Seleccione la Librería de la Clase Padre" )
	If !Empty( lcParentClassLibrary )
		lcParentClassLibrary = " Of '" + ProperFileName( lcParentClassLibrary ) + "'"
	EndIf
	
	lcParentClassLibrary = InputBox( "ParentClassLibrary", "DEFINE CLASS", lcParentClassLibrary )
	
	Wait Window NoWait Noclear "Escriba el NOMBRE de la Clase Padre"
	lcParentClass	= Inputbox( "Nombre de la Clase", "DEFINE CLASS" )
	
	Wait Window NoWait Noclear "Escriba el NOMBRE de la Clase Nativa de la cual hereda"
	lcBaseClass		= Inputbox( "BaseClass", "DEFINE CLASS", "Session" )

Else
	Wait Window NoWait Noclear "Escriba el NOMBRE de la Clase Nativa de la cual hereda"
	lcBaseClass		= Inputbox( "BaseClass", "DEFINE CLASS", lcParentClass )

Endif

Wait Clear 
lcDescription	= Inputbox( "Descripción", "DEFINE CLASS" )

Wait Window NoWait Noclear "Seleccione la Librería donde se guardará la nueva Clase"
lcFolder = Getfile( 'PRG', "Libreria","", 0, "Seleccione la Libreria" )

lcFolder = ProperFileName( lcFolder)

lcFolder = InputBox( "Library", "DEFINE CLASS", lcFolder )

Wait Clear 

TEXT TO myvar TEXTMERGE NOSHOW
*!* ///////////////////////////////////////////////////////
*!* Class.........: <<lcClassName>>
*!* ParentClass...: <<lcParentClass>><<lcParentClassLibrary>>
*!* BaseClass.....: <<lcBaseClass>>
*!* Description...: <<lcDescription>>
*!* Date..........: <<DateMask(date())>> (<<time()>>)
*!* Author........: <<_USER>>
*!* Project.......: <<_PROJECTENV>>
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

DEFINE CLASS <<lcClassName>> AS <<lcParentClass>><<lcParentClassLibrary>>
~
#IF .F.
	Local this as <<lcClassName>> OF "<<lcFolder>>"
#ENDIF

_memberdata = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
	[<VFPData>] + ;
	[</VFPData>]


ENDDEFINE
*!*
*!* END DEFINE
*!* Class.........: <<lcClassName>>
*!*
*!* ///////////////////////////////////////////////////////

ENDTEXT

Return myvar