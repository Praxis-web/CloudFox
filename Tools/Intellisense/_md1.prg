LPARAMETERS oFoxcode

IF oFoxcode.Location #1
   RETURN "_MD"
ENDIF

oFoxcode.valuetype = "V"

Set Path To "v:\Praxis\Comun\prg\" Additive

LOCAL  cName 	as String	,;
 		cDisplay as String 	,;
		cType	as String 	,;
		llOk	as Boolean	,;
		lcText	as String,;
		cInitialValue as String,;
		cDescription as String
						
	  	
cName 	= INPUTBOX( "Nombre del miembro", "_MemberData" )
cDisplay = PROPER(cName)
cName 	=  LOWER(STRTRAN(cName," ","") )
cDisplay = STRTRAN(cDisplay," ","") 

llOk = .F.
lcText =	"P = PROPIEDAD" + CHR(13) + ;
       		"E = EVENTO" + CHR(13) + ;
       		"M = METODO"

DO WHILE !llOk

	WAIT lcText WINDOW NOWAIT 
	
	cType = INPUTBOX( "Type", "_MemberData" )
	cType = Lower(Substr(cType,1,1))
	llOk = .T.
	
	DO CASE
	CASE "p"=cType
		cType="property"
		
	CASE "e"=cType
		cType="event"
		
	CASE "m"=cType
		cType="method"
		
	Otherwise
		llOk = .F.

	ENDCASE
	
	If !llOk
		= MESSAGEBOX(lctext,16)
	Endif
	
ENDDO

cDisplay	= INPUTBOX( "Display", "_MemberData", cDisplay )
cInitialValue = INPUTBOX( "Valor Inicial", "_MemberData" )
cDescription = INPUTBOX( "Descripción", "_MemberData" )

TEXT TO myvar TEXTMERGE NOSHOW

*!* <<cDescription>>
<<cDisplay>> = <<cInitialValue>>

_memberdata = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
	[<VFPData>] + ;
	[<memberdata name="<<cName>>" type="<<cType>>" display="<<cDisplay>>" />] + ;
	[</VFPData>]
ENDTEXT

RETURN myvar
