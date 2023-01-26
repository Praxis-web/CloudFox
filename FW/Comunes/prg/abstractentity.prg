*!* Begin Testing
Local o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg"

Set Path To "v:\praxis\comun\libs\" ADDITIVE 
Set Path To "v:\Visual Praxis Beta 1.0\UserTier\" ADDITIVE 
Set Classlib To "v:\praxis\comun\libs\prxbase" ADDITIVE 

Set Step On 
TRY 
	o = CreateObject("AbstractEntity")

	o.NextTierClassName = "utAbstractEntity"
	o.NextTierClassLibrary = "v:\Visual Praxis Beta 1.0\UserTier\utAbstractEntity.prg"
	
	*!* Crear un registro nuevo
	IF o.Nuevo()
		
	ENDIF


CATCH TO oErr
	o.lIsOk = .F.
	IF Vartype( o.oError )== "O"
		o.oError.Process( oErr )
		
	ENDIF


FINALLY

ENDTRY

IF o.lIsOk 
	=MessageBox("Testing OK")
Else
	=MessageBox("Testing Failed")	
EndIf

o = null
Release o

*!* End Testing
*------------------------------


*!*	///////////////////////////////////////////////////////
*!*	Class.........: AbstractEntity
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!*	Description...: Clase base 
*!*	Date..........: Viernes 11 de Marzo de 2005 (16:09:34)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.0
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -  
*!*
*!*	

DEFINE CLASS AbstractEntity AS Session 

Id = 0
Nombre = ""
PermiteNuevo = .T.
PermiteGrabar = .T.
PermiteEditar = .T.
PermiteBorrar = .T.
PermiteConsultar = .T.
Usuario = ""
oNextTier = null 
NextTierClassName = ""
NextTierClassLibrary = ""
lIsOk = .T.
oError = null
oErrorClass = "prxUserTierError"
oErrorClassLibrary = "v:\praxis\comun\libs\Tools\ErrorHandler\Prg\ErrorHandler.prg"


_memberdata = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
    [<VFPData>] + ;
    [<memberdata name="oerrorclasslibrary" type="property" display="oErrorClassLibrary" />] + ; 
	[<memberdata name="oerrorclass" type="property" display="oErrorClass" />] + ; 
    [<memberdata name="oerror" type="property" display="oError" />] + ; 
    [<memberdata name="lIsOk" type="property" display="lIsOk" />] + ; 
    [<memberdata name="nexttierclasslibrary" type="property" display="NextTierClassLibrary" />] + ; 
    [<memberdata name="nexttierclassname" type="property" display="NextTierClassName" />] + ; 
    [<memberdata name="onexttier" type="property" display="oNextTier" />] + ; 
    [<memberdata name="id" type="property" display="Id" />] + ;    
    [<memberdata name="nombre" type="property" display="Nombre" />] + ; 
    [<memberdata name="permitenuevo" type="property" display="PermiteNuevo" />] + ; 
    [<memberdata name="permitegrabar" type="property" display="PermiteGrabar" />] + ; 
    [<memberdata name="permiteeditar" type="property" display="PermiteEditar" />] + ; 
    [<memberdata name="permiteborrar" type="property" display="PermiteBorrar" />] + ; 
    [<memberdata name="permiteconsultar" type="property" display="PermiteConsultar" />] + ; 
    [<memberdata name="usuario" type="property" display="Usuario" />] + ; 
    [<memberdata name="crearobjeto" type="event" display="CrearObjeto" />] + ; 
    [<memberdata name="nuevo" type="event" display="Nuevo" />] + ; 
    [<memberdata name="grabar" type="event" display="Grabar" />] + ; 
    [<memberdata name="aplicar" type="event" display="Aplicar" />] + ; 
    [<memberdata name="nexttier" type="event" display="NextTier" />] + ; 
    [</VFPData>] 


*!*	///////////////////////////////////////////////////////
*!*	Function......: CrearObjeto
*!*	Description...: Factory Method para encapsular la creación de objetos
*!*	Date..........: Viernes 11 de Marzo de 2005 (16:20:42)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.0
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -  
*!*
*!*	

FUNCTION CrearObjeto( tcClassName AS String, tcClassLibrary AS String ) AS Object 
     
Local loNewObj as Object, ;
	o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg"
	
o = This

TRY 
	loNewObj = NewObject( tcClassName, tcClassLibrary )   
	
CATCH TO oErr
	This.lIsOk = .F.
	o.oError.Process( oErr )

FINALLY

ENDTRY

Return loNewObj
ENDFUNC
*!* 
*!*	END FUNCTION CrearObjeto
*!* 
*!*	///////////////////////////////////////////////////////

*!*	///////////////////////////////////////////////////////
*!*	Function......: NextTier
*!*	Description...: Obtiene un referencia a la siguiente capa y retorna un valor lógico
*!*	Date..........: Viernes 11 de Marzo de 2005 (17:29:51)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.0
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -  
*!*
*!*	

FUNCTION NextTier( ) AS Boolean
     
Local o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg"

o = this 
	
IF Vartype( o.oNextTier ) <> "O" and o.lIsOk 
	TRY 
		o.oNextTier = o.CrearObjeto( o.NextTierClassName, o.NextTierClassLibrary )
		
	CATCH TO oErr
		o.lIsOk = .F.		
		o.oError.Process( oErr )
		
	FINALLY


	ENDTRY
ENDIF	

Return o.lIsOk 
ENDFUNC
*!* 
*!*	END FUNCTION NextTier
*!* 
*!*	///////////////////////////////////////////////////////


*!*	///////////////////////////////////////////////////////
*!*	Function......: Nuevo
*!*	Description...: Crea una nueva instancia de la clase 
*!*	Date..........: Viernes 11 de Marzo de 2005 (16:28:15)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.0
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -  
*!*
*!*	

FUNCTION Nuevo(  ) AS Boolean;
        HELPSTRING "Crea una nueva instancia de la clase" 
        
Local o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg"

o = this 

Return o.PermiteNuevo 
ENDFUNC
*!* 
*!*	END FUNCTION Nuevo
*!* 
*!*	///////////////////////////////////////////////////////

*!*	///////////////////////////////////////////////////////
*!*	Function......: TraerUno
*!*	Description...: Obtiene un registro con los datos de la entidad
*!*	Date..........: Viernes 11 de Marzo de 2005 (17:52:39)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.0
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -  
*!*
*!*	

FUNCTION TraerUno( tnId AS Integer ) AS String;
        HELPSTRING "Obtiene un registro con los datos de la entidad" 
     
Local lcXML as String,;
	o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg" 

o = this 
	
	
Return lcXML
ENDFUNC
*!* 
*!*	END FUNCTION TraerUno
*!* 
*!*	///////////////////////////////////////////////////////

*!*	///////////////////////////////////////////////////////
*!*	Function......: TraerVarios
*!*	Description...: Obtiene un registro con los datos de la entidad
*!*	Date..........: Viernes 11 de Marzo de 2005 (17:52:39)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.0
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -  
*!*
*!*	

FUNCTION TraerVarios( tcWhere AS String ) AS String;
        HELPSTRING "Obtiene un XML con los datos de la entidad" 
     
Local lcXML as String,;
	o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg" 

o = this 
	
	
Return lcXML
ENDFUNC
*!* 
*!*	END FUNCTION TraerUno
*!* 
*!*	///////////////////////////////////////////////////////


*!*	///////////////////////////////////////////////////////
*!*	Function......: Grabar
*!*	Description...: Persiste el objeto en la base de datos
*!*	Date..........: Viernes 11 de Marzo de 2005 (16:32:50)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.0
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -  
*!*
*!*	

FUNCTION Grabar(  ) AS Boolean;
        HELPSTRING "Persiste el objeto en la base de datos" 
     
Local llReturnValue as Boolean,;
	o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg"

o = this 



Return llReturnValue
ENDFUNC
*!* 
*!*	END FUNCTION Grabar
*!* 
*!*	///////////////////////////////////////////////////////

*!*	///////////////////////////////////////////////////////
*!*	Function......: Aplicar
*!*	Description...: Persiste las modificaciones realizadas al objeto, pero continúa editandolo
*!*	Date..........: Viernes 11 de Marzo de 2005 (16:33:49)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.0
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -  
*!*
*!*	

FUNCTION Aplicar(  ) AS Boolean;
        HELPSTRING "Persiste las modificaciones realizadas al objeto, pero continúa editandolo" 
     
Local llReturnValue as Boolean,;
	o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg"

o = this 


Return llReturnValue
ENDFUNC
*!* 
*!*	END FUNCTION Aplicar
*!* 
*!*	///////////////////////////////////////////////////////

*!*	///////////////////////////////////////////////////////
*!*	Function......: Editar
*!*	Description...: Editar los atributos
*!*	Date..........: Viernes 18 de Marzo de 2005 (16:29:37)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.0
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -  
*!*
*!*	

FUNCTION Editar(  ) AS Boolean;
        HELPSTRING "Editar los atributos" 
     
Local luReturnValue as Boolean,;
	o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg"

o = this 



Return luReturnValue
ENDFUNC
*!* 
*!*	END FUNCTION Editar
*!* 
*!*	///////////////////////////////////////////////////////

*!*	///////////////////////////////////////////////////////
*!*	Function......: Borrar
*!*	Description...: Borra un elemento de la clase
*!*	Date..........: Viernes 18 de Marzo de 2005 (16:32:43)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.0
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -  
*!*
*!*	

FUNCTION Borrar(  ) AS Boolean;
        HELPSTRING "Borra un elemento de la clase" 
     
Local luReturnValue as Boolean,;
	o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg"

o = this 



Return luReturnValue
ENDFUNC
*!* 
*!*	END FUNCTION Borrar
*!* 
*!*	///////////////////////////////////////////////////////

*!*	///////////////////////////////////////////////////////
*!*	Procedure.....: Consultar
*!*	Description...: Permite consultar un elemento de la clase
*!*	Date..........: Viernes 18 de Marzo de 2005 (17:48:21)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.0
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -  
*!*
*!*	

PROCEDURE Consultar(  ) AS Void;
        HELPSTRING "Permite consultar un elemento de la clase"
Local o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg"

o = this 


ENDPROC
*!* 
*!*	END PROCEDURE Consultar
*!* 
*!*	///////////////////////////////////////////////////////

PROCEDURE Init
Local o as AbstractEntity OF "v:\praxis\comun\libs\abstractentity.prg"

o = This
TRY 
	o.oError = NEWOBJECT(o.oErrorClass, o.oErrorClassLibrary ) 
	
CATCH TO oErr
	o.lIsOk = .F.
	
FINALLY

ENDTRY

ENDPROC

PROCEDURE Destroy

ENDPROC

PROCEDURE Error(nError, cMethod, nLine)

ENDPROC

ENDDEFINE
*!* 
*!*	END DEFINE
*!* Class.........: AbstractEntity
*!* 
*!*	///////////////////////////////////////////////////////