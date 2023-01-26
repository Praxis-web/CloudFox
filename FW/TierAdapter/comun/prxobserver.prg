* Modificado 2009-02-20 - Eiff Damian
* #INCLUDE "v:\praxis\comun\include\praxis.h"
#INCLUDE "Fw\comunes\Include\Praxis.h" 

*!*	Begin Test
Local loObj As Object,;
	loCol As Subscribers Of "Prg\Observer.prg",;
	loObs As TabObserver Of "Prg\Observer.prg"


*Set Step On

Close Databases All


Try

	loMain = Createobject( "Custom" )
	loObs = Createobject( "prxObserver" )
	loMain.Name = "Form"
	loObs.Subscribe( "Show", loMain )
	loObs.Subscribe( "Hide", loMain )
	loObs.Subscribe( "Save", loMain )
	loObs.Subscribe( "Show", loMain )
	loObs.Unsubscribe( "Show", loMain )
	loObs.Subscribe( "Show", loMain )
	loObs.Subscribe( "Prueba", loObs )


	loMain.Name = "Custom"
	loObs.Subscribe( "Show", loMain )
	loObs.Subscribe( "Save", loMain )
	loObs.Subscribe( "Show", loMain )

	loMain.Name = "Label"
	loObs.Subscribe( "Close", loMain )
	loObs.Subscribe( "Hide", loMain )
	loObs.Subscribe( "Save", loMain )
	loObs.Subscribe( "Hide", loMain )

	loObs.OnEvent("Prueba",loObs)

	loMain = Null
	Release loMain

	loObs = Null
	Release loObs


Catch To oErr
	Local loError as ErrorHandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = NewObject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	
	loError.Process( oErr )

Finally

Endtry

Return

Endproc


*!*
*!* END Test
*!*
*!* ///////////////////////////////////////////////////////

*!* ======================== *** ==========================



*!* ///////////////////////////////////////////////////////
*!* Class.........: prxObserver
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Implementa un patron Observer para reflejar los cambios que se produzcan en la colección de Solapas
*!* Date..........: Viernes 31 de Marzo de 2006 (16:32:18)
*!* Author........: Ricardo Aidelman
*!* Project.......: Observer
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class prxObserver As Session

	#If .F.
		Local This As prxObserver Of "Comun\prg\prxObserver.prg"
	#Endif

	*!* Manejador de Errores
	oError = Null

	*!* Semáforo
	lIsOk = .T.

	*!* Propiedades del objeto error en formato XML
	cXMLoError = ""

	*!* Colección de subscripciones
	oSubscribers = Null

	*!*
	ModuleName = "Observer"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="oerror" type="property" display="oError" />] + ;
		[<memberdata name="lIsOk" type="property" display="lIsOk" />] + ;
		[<memberdata name="cXMLoError" type="property" display="cXMLoError" />] + ;
		[<memberdata name="modulename" type="property" display="ModuleName" />] + ;
		[<memberdata name="osubscribers" type="property" display="oSubscribers" />] + ;
		[<memberdata name="subscribe" type="method" display="Subscribe" />] + ;
		[<memberdata name="onevent" type="method" display="OnEvent" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Init
	*!* Description...:
	*!* Date..........: Viernes 31 de Marzo de 2006 (16:34:56)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Observer
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Init(  ) As Boolean

		Try
			This.oSubscribers = Createobject("Subscribers")

		Catch To oErr
			This.lIsOk = .F.
			Throw oErr

		Finally

		Endtry

		Return This.lIsOk

	Endfunc
	*!*
	*!* END FUNCTION Init
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Subscribe
	*!* Description...: Subscribe el objeto a una colección de Eventos
	*!* Date..........: Viernes 31 de Marzo de 2006 (16:50:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Observer
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Subscribe( tcEvent As String, ;
			toObj As Object ) As Boolean;
			HELPSTRING "Subscribe el objeto a una colección de Eventos"

		Try
			This.oSubscribers.Subscribe( tcEvent, toObj )

		Catch To oErr
			This.oError = NewObject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally

		Endtry

		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE Subscribe
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Unsubscribe
	*!* Description...: Cancela la subscripción de un objeto a una colección de Eventos
	*!* Date..........: Viernes 31 de Marzo de 2006 (16:50:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Observer
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Unsubscribe( tcEvent As String, ;
			toObj As Object ) As Boolean;
			HELPSTRING "Cancela la subscripción de un objeto a una colección de Eventos"

		Local lcKey As String

		Try
			This.oSubscribers.Unsubscribe( tcEvent, toObj )

		Catch To oErr
			This.oError = NewObject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally

		Endtry

		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE Unsubscribe
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: OnEvent
	*!* Description...: Es invocado por los objetos cada vez que ocurre 
	*!*						algun evento
	*!* Date..........: Viernes 31 de Marzo de 2006 (16:50:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Observer
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!* Parámetros:
	*!* tcEvent: Nombre del evento
	*!* toParam: Objeto con parámetros que paso al Método del 
	*!* 			Objeto subscripto (Opcional)

	Procedure OnEvent( tcEvent As String, ;
			toParam As Object) As Void;
			HELPSTRING "Es invocado por los objetos cada vez que ocurre algun evento"

		Local loColEvents As Collection,;
			loSubscribedObject As Object,;
			lcKey As String

		Try
			*__ Busco el evento en la colección de eventos
			lcKey = Lower(tcEvent)
			If !Empty( This.oSubscribers.oColEvents.GetKey( lcKey ) )
				loColEvents = This.oSubscribers.oColEvents.Item( lcKey )

				*__ Por cada objeto subscripto al evento, ejecuto el ;
				método asociado.
				For Each loSubscribedObject In loColEvents
					If Pemstatus( loSubscribedObject, tcEvent, 5 )
						If Vartype( toParam ) == "O"
							loSubscribedObject.&tcEvent.( toObj )
							
						Else
							loSubscribedObject.&tcEvent
							
						Endif

					Endif
				Endfor
			Endif


		Catch To oErr
			This.oError = NewObject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE OnEvent
	*!*
	*!* ///////////////////////////////////////////////////////
Enddefine
*!*
*!* END DEFINE
*!* Class.........: prxObserver
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Subscribers
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Colección de Subscriptores
*!* Date..........: Viernes 31 de Marzo de 2006 (16:50:35)
*!* Author........: Ricardo Aidelman
*!* Project.......: Observer
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class Subscribers As Collection

	#If .F.
		Local This As Subscribers Of "Comun\Prg\prxObserver.prg"
	#Endif

	*!* Manejador de Errores
	oError = Null

	*!* Semáforo
	lIsOk = .T.

	*!* Propiedades del objeto error en formato XML
	cXMLoError = ""

	*!* Colección de Eventos
	oColEvents = Null

	*!*
	ModuleName = "Subscribers"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="oerror" type="property" display="oError" />] + ;
		[<memberdata name="lIsOk" type="property" display="lIsOk" />] + ;
		[<memberdata name="cXMLoError" type="property" display="cXMLoError" />] + ;
		[<memberdata name="ocolevents" type="property" display="oColEvents" />] + ;
		[<memberdata name="modulename" type="property" display="ModuleName" />] + ;
		[<memberdata name="subscribe" type="method" display="Subscribe" />] + ;
		[<memberdata name="unsubscribe" type="method" display="Unsubscribe" />] + ;
		[<memberdata name="addobjecttoevent" type="method" display="AddObjectToEvent" />] + ;
		[<memberdata name="addevent" type="method" display="AddEvent" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Init
	*!* Description...:
	*!* Date..........: Viernes 31 de Marzo de 2006 (16:50:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Observer
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Init(  ) As Boolean

		Try
			This.oColEvents = Createobject( "Collection" )

		Catch To oErr
			This.lIsOk = .F.
			Throw oErr

		Finally

		Endtry

		Return This.lIsOk

	Endfunc
	*!*
	*!* END FUNCTION Init
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Subscribe
	*!* Description...: Subscribe el objeto a una colección de Eventos
	*!* Date..........: Viernes 31 de Marzo de 2006 (16:50:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Observer
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Subscribe( tcEvent As String, ;
			toObj As Object ) As Boolean;
			HELPSTRING "Subscribe el objeto a una colección de Eventos"

		Try
			This.AddEvent( tcEvent )
			This.AddObjectToEvent( toObj, tcEvent )

		Catch To oErr
			This.oError = NewObject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally

		Endtry

		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE Subscribe
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Unsubscribe
	*!* Description...: Cancela la subscripción de un objeto a una colección de Eventos
	*!* Date..........: Viernes 31 de Marzo de 2006 (16:50:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Observer
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Unsubscribe( tcEvent As String, ;
			toObj As Object ) As Boolean;
			HELPSTRING "Cancela la subscripción de un objeto a una colección de Eventos"

		Local lcKey As String


		Try

			lcKey = Lower( toObj.Name )
			If !Empty( This.oColEvents.Item( Lower( tcEvent )).GetKey( lcKey ) )
				This.oColEvents.Item( Lower( tcEvent )).Remove( lcKey )
			Endif

		Catch To oErr
			This.oError = NewObject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally

		Endtry



		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE Unsubscribe
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddEvent
	*!* Description...: Agrega un elemento Event a la colección oColEvents
	*!* Date..........: Viernes 31 de Marzo de 2006 (16:50:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Observer
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure AddEvent( tcEvent As String ) As Boolean;
			HELPSTRING "Agrega un elemento Event a la colección oColEvents"

		Local lcKey As String,;
			loEvent As Collection

		Try

			lcKey = Lower(tcEvent)
			If Empty( This.oColEvents.GetKey( lcKey ) )
				loEvent=Createobject("Collection")
				loEvent.Name = lcKey

				With This.oColEvents As Collection
					.Add( loEvent, lcKey )
				Endwith

			Endif

		Catch To oErr
			This.oError = NewObject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally

		Endtry

		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE AddEvent
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddObjectToEvent
	*!* Description...: Agrega un elemento Object a la colección Objects del Elemento Event
	*!* Date..........: Viernes 31 de Marzo de 2006 (16:50:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Observer
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure AddObjectToEvent( toObj As Object,;
			tcEvent As String ) As Boolean;
			HELPSTRING "Agrega un elemento Object a la colección Objects del elemento Event"

		Local lcKey As String


		Try

			lcKey = Lower( toObj.Name )
			If Empty( This.oColEvents.Item( Lower( tcEvent )).GetKey( lcKey ) )
				This.oColEvents.Item( Lower( tcEvent )).Add( toObj, lcKey )
			Endif

		Catch To oErr
			This.oError = NewObject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally

		Endtry

		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE AddObjectToEvent
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Subscribers
*!*
*!* ///////////////////////////////////////////////////////