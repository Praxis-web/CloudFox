*------------------ TierAdapter Class Definition ------------------*
* Author........: Ruben Rovira - Martín Salías
* Date..........: 18/04/2003
* Notes.........: Second level of abstraction on the tier model
*               : BUSINESS LOGIC TIER
* See also......: DataTierAdapter, UserTierAdapter
*

#INCLUDE "FW\Tieradapter\Include\TA.h"
#INCLUDE "FW\ErrorHandler\eh.h"

Define Class BizTierAdapter As DataTierAdapter Of "FW\Tieradapter\DataTier\DataTierAdapter.prg"
	#If .F.
		Local This As BizTierAdapter Of "FW\Tieradapter\BizTier\BizTierAdapter.prg"
	#Endif

	* Indica el nivel de la capa dentro del modelo.
	cTierLevel = "Business"

	* Flag. Si es true, abre una transaccion global antes del Put()
	lOpenGlobalTransaction = .F.

	* ID de la transaccion en curso
	nTransactionID = -1

	* Comentario que se graba en el campo TransactionLog
	cTransactionLog = ""

	* Objeto transaction
	oTransaction = Null

	* Por default, esta capa se encuentra en un componente externo
	lComComponent = .T.

	*<TODO>: Debe haber un solo archivo externo, y éste tener la data para ubicar los demás archivos externos
	*		 La definicion de éste archivo debe estar en la capa de servicios, y puede redefinirse
	*        En el proyecto de cada cliente
	* Nombre del archivo de configuración
	cConfigFileName = "SysConfig.xml"

	* Nombre del archivo que contiene la carpeta por default para la capa
	cSystemDefaultFileName = ""

	* Nombre del archivo de configuración del componente ComPlusInfo
	cComServersConfig = ""

	* Nombre del archivo que contiene los errores de validación
	* Lo asigna el framework automáticamente
	cValidationCursorName  = ""

	* Indica si la Entidad valida los datos antes de grabar
	lValidateBeforePut = .F.

	* Permite almacenar el Diffgram de la entidad
	cDiffGram = ""

	* Permite almacenar el id del formulario de la entidad
	nFormId = 0

	nResultStatus = RESULT_BIZ_ERROR

	*!* Indica la cantidad de transacciones anidadas
	nTransactionLevel = 0

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="nformid" type="property" display="nFormId" />] + ;
		[<memberdata name="lopenglobaltransaction" type="property" display="lOpenGlobalTransaction" />] + ;
		[<memberdata name="ntransactionid" type="property" display="nTransactionID" />] + ;
		[<memberdata name="ctransactionlog" type="property" display="cTransactionLog" />] + ;
		[<memberdata name="otransaction" type="property" display="oTransaction" />] + ;
		[<memberdata name="nFormId" type="property" display="nFormId" />] + ;
		[<memberdata name="cdiffgram" type="property" display="cDiffGram" />] + ;
		[<memberdata name="ocolentities" type="property" display="oColEntities" />] + ;
		[<memberdata name="ocolentities_access" type="method" display="oColEntities_Access" />] + ;
		[<memberdata name="processlinkedentities" type="method" display="ProcessLinkedEntities" />] + ;
		[<memberdata name="fillcolentities" type="method" display="FillColEntities" />] + ;
		[<memberdata name="validateentities" type="method" display="ValidateEntities" />] + ;
		[<memberdata name="putbackentities" type="method" display="PutBackEntities" />] + ;
		[<memberdata name="getbackentities" type="method" display="GetBackEntities" />] + ;
		[<memberdata name="classbeforeput" type="method" display="ClassBeforePut" />] + ;
		[<memberdata name="hookbeforeput" type="method" display="HookBeforePut" />] + ;
		[<memberdata name="put" type="method" display="Put" />] + ;
		[<memberdata name="hookafterput" type="method" display="HookAfterPut" />] + ;
		[<memberdata name="classafterput" type="method" display="ClassAfterPut" />] + ;
		[<memberdata name="classbeforeput" type="method" display="ClassBeforePut" />] + ;
		[<memberdata name="hookbeforeput" type="method" display="HookBeforePut" />] + ;
		[<memberdata name="put" type="method" display="Put" />] + ;
		[<memberdata name="hookafterput" type="method" display="HookAfterPut" />] + ;
		[<memberdata name="classafterput" type="method" display="ClassAfterPut" />] + ;
		[<memberdata name="classbeforetransactionbegin" type="method" display="ClassBeforeTransactionBegin" />] + ;
		[<memberdata name="hookbeforetransactionbegin" type="method" display="HookBeforeTransactionBegin" />] + ;
		[<memberdata name="transactionbegin" type="method" display="TransactionBegin" />] + ;
		[<memberdata name="hookaftertransactionbegin" type="method" display="HookAfterTransactionBegin" />] + ;
		[<memberdata name="classaftertransactionbegin" type="method" display="ClassAfterTransactionBegin" />] + ;
		[<memberdata name="ntransactionlevel" type="property" display="nTransactionLevel" />] + ;
		[<memberdata name="processentity" type="method" display="ProcessEntity" />] + ;
		[<memberdata name="nprocesstype_assign" type="method" display="nProcessType_Assign" />] + ;
		[<memberdata name="lischild" type="property" display="lIsChild" />] + ;
		[<memberdata name="updatedefault" type="method" display="UpdateDefault" />] + ;
		[</VFPData>]

	*
	* ClassBefore Event
	* Persiste las modificaciones en la Base de Datos
	Protected Procedure ClassBeforePut() As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 25 de Mayo de 2009 (13:30:48)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecutePut As Boolean

		Try

			llExecutePut = .T.

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return llExecutePut

	Endproc && ClassBeforePut
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Persiste las modificaciones en la Base de Datos
	Procedure HookBeforePut() As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 25 de Mayo de 2009 (13:30:48)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecutePut As Boolean

		Try

			llExecutePut = This.oServiceTier.HookBeforePut()

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return llExecutePut

	Endproc && HookBeforePut
	*
	* Persiste las modificaciones en la Base de Datos
	Procedure Put( tnEntidad As Integer,;
			tcDiffGram As String,;
			tnLevel As Integer,;
			tnProcessType As Integer,;
			tcUniqueFormName As String ) As String;
			HELPSTRING "Persiste las modificaciones en la Base de Datos"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Persiste las modificaciones en la Base de Datos
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 25 de Mayo de 2009 (13:30:48)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			tnEntidad AS Integer
			tcDiffGram AS String
			tnLevel AS Integer
			tnProcessType AS Integer
			tcUniqueFormName AS String
			*:Remarks:
			*:Returns:
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcXML As String
		Local loXA As prxXMLAdapter Of "Comun\Prg\prxXMLAdapter.prg"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			* Guarda algunos parámetros para usarlos en otros métodos

			lcXML 				= ""
			loXA 				= Null
			This.nEntidadId 	= tnEntidad
			This.nProcessType 	= tnProcessType
			This.cDiffGram 		= tcDiffGram
			This.nLevel 		= tnLevel

			* En las entidades asociadas, tcUniqueFormName ya contiene el FormId
			* que fue calculado por la entidad principal
			If Vartype( tcUniqueFormName ) = "N"
				This.nFormId 		= tcUniqueFormName

			Else
				This.nFormId 		= This.GetFormId( tcUniqueFormName )

			Endif

			If This.lIsOk And This.ClassBeforePut()

				If This.lIsOk And This.HookBeforePut()


					* Si no es necesario, no perder el tiempo
					If This.lValidateBeforePut

						If This.lSerialize

							* Regenera los cursores, tal como estaban en la capa
							* de usuario
							* Primero trae los cursores de las entidades asociadas, ya que
							* el metodo GetBack(), después de traer los cursores de la
							* entidad principal, aplica los diffgram a todos los cursores.
							If This.lIsOk
								This.GetBackEntities()
							Endif

							If This.lIsOk
								This.GetBack( This.nEntidadId, This.cDiffGram, This.nLevel, loXA )
							Endif

						Endif

						If This.lIsOk
							lcXML = This.ProcessEntity()
						Endif

						If This.lIsOk
							lcXML = This.ProcessLinkedEntities()
						Endif

						If This.lIsOk
							lcXML = This.DoBizValidation()

							If This.lIsOk And Empty( lcXML )
								lcXML = This.ValidateEntities()
							Endif

							If Vartype( lcXML ) == "L"
								lcXML = ""
							Endif
						Endif

						If !Empty( lcXML )

							Do Case
								Case This.nResultStatus = RESULT_WARNINGS
									* ValidatePut está devolviendo un mensaje de error de validacion
									lcXML = WARNING_TAG + lcXML
									This.lIsOk = .F.
									This.cXMLoError = lcXML

								Case This.nResultStatus = RESULT_BIZ_ERROR
									* ValidatePut está devolviendo un mensaje de error de validacion
									* de las reglas de negocio
									lcXML = BIZ_TAG + lcXML
									This.lIsOk = .F.
									This.cXMLoError = lcXML

								Otherwise
									* ValidatePut está devolviendo un mensaje de error de validacion
									lcXML = WARNING_TAG + lcXML
									This.lIsOk = .F.
									This.cXMLoError = lcXML

							Endcase

						Endif

						If This.lIsOk And This.lSerialize
							* Regenera el diffgram para ésta entidad
							This.cDiffGram = This.PutBack( loXA, This.nLevel )
							If .F.
								Strtofile( This.cDiffGram, "C:\DiffgramPrincipal_"+This.Name+".Xml" )
							Endif

						Endif

					Endif && This.lValidateBeforePut

					*!*						If This.lIsOk And Empty( This.cDiffGram )
					*!*							* Si This.lSerialize = .F. y This.lValidateBeforePut = .F.
					*!*							* This.cDiffgram está vacío
					*!*							This.cDiffGram = This.PutBack( loXA, This.nLevel )
					*!*							If .F.
					*!*								Strtofile( This.cDiffGram, "C:\DiffgramPrincipal_"+This.Name+".Xml" )
					*!*							Endif

					*!*						Endif

					* Ahora si, abro la transacción y aplico, uno a uno, ;
					los TABLEUPDATE() correspondientes.
					If This.TransactionBegin()

						This.lIsOk = This.Tableupdate()

					Endif

					If This.lIsOk
						This.HookAfterPut()
					Endif

				Endif

				If This.lIsOk
					This.ClassAfterPut()
				Endif

			Endif

		Catch To oErr

			If This.lIsOk
				This.lIsOk = .F.

				* This.cXMLoError = This.oError.Process( oErr )
				Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				This.cXMLoError = loError.Process( oErr )

			Endif

		Finally
			loError = Null
			If !This.lIsOk
				lcXML = This.cXMLoError

				If This.lOnTransaction
					This.TransactionRollBack()
				Endif
			Endif

			loXA = .F.
			If Not This.lAlreadyConnected
				This.DisconnectFromBackend()
			Endif


			For i = 1 To Aused( lAUsed )
				lcTable = Upper( lAUsed[ i, 1 ] )
				If Left( lcTable, 5 ) = 'TEMP_'
					Use In Select( lcTable )

				Endif && Left( lcTable ), 5 ) = 'TEMP_'

			Endfor

		Endtry

		Return lcXML

	Endproc && Put
	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Persiste las modificaciones en la Base de Datos
	Procedure HookAfterPut() As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 25 de Mayo de 2009 (13:30:48)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


			This.oServiceTier.HookAfterPut()

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

	Endproc && HookAfterPut
	*
	* ClassAfter Event
	* Persiste las modificaciones en la Base de Datos
	Protected Procedure ClassAfterPut() As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 25 de Mayo de 2009 (13:30:48)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local loTransaction As utTransaction Of "FW\SysAdmin\Client\utTransaction.prg"

		Try


			This.UpdateDefault()

			If This.lIsOk
				This.TransactionEnd()
				llSuccess = .T.

				* Si todo salió bien, grabo en el registro correspondiente
				* a la transacción una indicación de que todo salió bien

				If This.lIsOk
					loTransaction = This.InstanciateEntity( "Transaction" )
					loTransaction.Done( This.nTransactionID )

				Endif

			Else
				This.TransactionRollBack()

			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			loTransaction = Null
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

	Endproc && ClassAfterPut




	*
	* Actualiza el campo Default
	Procedure UpdateDefault(  ) As Void;
			HELPSTRING "Actualiza el campo Default"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Actualiza el campo Default
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Jueves 24 de Septiembre de 2009 (17:06:12)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			If This.lHasDefault
				If This.GetValue( "Default" ) = TRUE
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Update <<This.cMainTableName>>
					Set Default = <<FALSE>>
					Where Default = <<TRUE>>
					And <<This.cMainCursorPK>> <> <<This.nEntidadId>>
					ENDTEXT

					This.ExecuteNonQuery( lcCommand )

				Endif

			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

	Endproc && UpdateDefault

	*
	* ClassBefore Event
	* Abre la transacción
	Protected Procedure ClassBeforeTransactionBegin() As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 25 de Mayo de 2009 (14:34:31)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteTransactionBegin As Boolean
		Local loXA As prxXMLAdapter Of "Comun\Prg\prxXMLAdapter.prg"
		Local loTransaction As utArchivo Of "FW\TierAdapter\UserTier\utArchivo.prg"

		Local i As Integer
		Local loEntity As utArchivo Of "FW\TierAdapter\UserTier\utArchivo.prg"
		Local loItem As Object

		Local loColEntities As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"

		Try

			llExecuteTransactionBegin = .T.

			This.lAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk
				* Almacenará el ID de la IdEntidad
				loXA = This.PopulateXMLAdapter( This.nEntidadId, This.nLevel )
			Endif

			If This.lIsOk And This.lSerialize
				loXA.LoadXML( This.cDiffGram )

				* Código de DEBUG
				If .F.
					Strtofile( This.cDiffGram, "C:\PutDiff.Xml" )
				Endif

				This.lIsOk = This.ApplyDiffgram( loXA, This.nLevel )

			Endif


			* Podría ser que la entidad haya sido instanciada
			* desde la clase de negocios de otra entidad.
			* En ese caso, la transacción es la de la entidad
			* principal.

			If This.lIsOk And This.nTransactionID <= 0

				* Primero intento abrir el objeto Transaction, grabo un
				* nuevo registro y recupero el ID de la transacción
				* Esto lo hago fuera de la transacción global, así queda
				* registrado el intento de una transacción fallida

				If This.lIsOk
					loTransaction = This.InstanciateEntity( "Transaction" )
				Endif

				If This.lIsOk
					This.nTransactionID = loTransaction.NewID( This.nProcessType,;
						This.nFormId )
					This.lIsOk = loTransaction.lIsOk
					This.cXMLoError = loTransaction.cXMLoError
				Endif

			Endif

			If This.lIsOk


				* Ahora hago lo mismo con cada uno de los objetos de la colección

				* DAE 2009-09-29(15:37:05)
				loColEntities = This.oColEntities
				* For i = 1 To This.oColEntities.Count
				For i = 1 To loColEntities.Count

					If This.lIsOk

						loEntity 	= Null
						*!*	                        loItem 		= Null
						*!*	                        loItem 	= loColEntities.Item[ i ]
						*!*	                        loEntity = loItem.oEntity

						loEntity = loColEntities.Item[ i ]

						loEntity.nTransactionID = This.nTransactionID

						*!*	                        loEntity.nEntidadId 	= loItem.nEntidadId
						*!*	                        loEntity.cDiffGram 		= loItem.cDiffGram
						*!*	                        loEntity.nLevel 		= loItem.nLevel
						*!*	                        loEntity.nProcessType	= loItem.nProcessType
						*!*	                        loEntity.nFormId 		= loItem.nFormId

						loEntity.TransactionBegin()

						This.lIsOk = loEntity.lIsOk
						This.cXMLoError = loEntity.cXMLoError

					Else
						Exit

					Endif
				Endfor
			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			loXA = Null
			loEntity 	= Null
			loItem 		= Null
			loTransaction = Null
			loColEntities = Null
			If !This.lIsOk
				llExecuteTransactionBegin = .F.
				Throw This.oError
			Endif

		Endtry

		Return llExecuteTransactionBegin

	Endproc && ClassBeforeTransactionBegin
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Abre la transacción
	Procedure HookBeforeTransactionBegin() As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 25 de Mayo de 2009 (14:34:31)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteTransactionBegin As Boolean

		Try

			llExecuteTransactionBegin = This.oServiceTier.HookBeforeTransactionBegin()

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return llExecuteTransactionBegin

	Endproc && HookBeforeTransactionBegin
	*
	* Abre la transacción
	Protected Procedure TransactionBegin() As Boolean ;
			HELPSTRING "Abre la transacción"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Abre la transacción
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 25 de Mayo de 2009 (14:34:31)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			If This.ClassBeforeTransactionBegin() And This.lIsOk

				If This.HookBeforeTransactionBegin() And This.lIsOk


					This.lIsOk = This.oBackEnd.BeginTransaction()

					If This.lIsOk
						This.nTransactionLevel = This.nTransactionLevel + 1
						This.lOnTransaction = .T.

					Else
						This.cXMLoError = This.oError.Process()

					Endif

					If This.lIsOk
						This.HookAfterTransactionBegin()
					Endif

				Endif

				If This.lIsOk
					This.ClassAfterTransactionBegin()
				Endif

			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				* DAE 2009-11-06(16:28:05)
				*!*	This.cXMLoError=This.oError.Process( oErr )
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				This.cXMLoError = loError.Process( oErr )
				Throw loError

			Endif

		Finally
			loError = Null
			* DAE 2009-11-06(16:28:00)
			*!*	If !This.lIsOk
			*!*		Throw This.oError
			*!*	Endif

		Endtry

	Endproc && TransactionBegin
	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Abre la transacción
	Procedure HookAfterTransactionBegin() As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 25 de Mayo de 2009 (14:34:31)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			This.oServiceTier.HookAfterTransactionBegin()

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

	Endproc && HookAfterTransactionBegin
	*
	* ClassAfter Event
	* Abre la transacción
	Protected Procedure ClassAfterTransactionBegin() As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 25 de Mayo de 2009 (14:34:31)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		* DAE 2009-11-06(16:28:46)
		*!*	Try


		*!*	Catch To oErr
		*!*		If This.lIsOk
		*!*			This.lIsOk = .F.
		*!*			This.cXMLoError=This.oError.Process( oErr )
		*!*		Endif

		*!*	Finally
		*!*		If !This.lIsOk
		*!*			Throw This.oError
		*!*		Endif

		*!*	Endtry

	Endproc && ClassAfterTransactionBegin

	Protected Procedure TransactionEnd

		Try
			This.lIsOk = This.oBackEnd.EndTransaction()

			If This.lIsOk
				This.nTransactionLevel = This.nTransactionLevel - 1
				This.lOnTransaction = ( This.nTransactionLevel > 0 )

			Else
				This.cXMLoError = This.oError.Process()

			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

	Endproc

	Protected Procedure TransactionRollBack

		Try

			If ! This.lOnDestroy
				If Vartype( This.oBackEnd ) = 'O'
					This.oBackEnd.Rollback()
					This.nTransactionLevel = This.nTransactionLevel - 1
					This.lOnTransaction = ( This.nTransactionLevel > 0 )

				Endif

			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )

			Endif

		Finally

		Endtry


	Endproc

	*
	*
	Procedure Destroy(  ) As Void

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			Do While This.lOnTransaction
				This.TransactionRollBack()

			Enddo

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				* DAE 2009-11-06(16:29:34)
				* This.cXMLoError = This.oError.Process( oErr )
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				This.cXMLoError = loError.Process( oErr )

			Endif

		Finally
			This.oTransaction = Null
			loError = Null
			DoDefault()

		Endtry

	Endproc && Destroy

	*
	* Permite realizar modificaciones a la entidad
	Procedure ProcessEntity(  ) As String;
			HELPSTRING "Permite realizar modificaciones a la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Permite realizar modificaciones a la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 17 de Julio de 2009 (10:16:10)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcXML As String

		Try

			lcXML = This.oServiceTier.ProcessEntity()

			If Empty( lcXML )
				lcXML = ""

			Endif && Empty( lcXML )

			This.lIsOk = This.oServiceTier.lIsOk

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return lcXML

	Endproc && ProcessEntity


	* ///////////////////////////////////////////////////////
	* Procedure.....: ProcessLinkedEntities
	* Description...: Procesa otras entidades asociadas
	* Date..........: Viernes 13 de Julio de 2007 (17:59:33)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Protected Procedure ProcessLinkedEntities(  ) As String;
			HELPSTRING "Procesa otras entidades asociadas"

		Local lcProcedureName As String
		Local loEntity As Object
		Local lcXML As String

		Try

			* Ejecuta el método definido en la propiedad ProcedureName
			* (si no se definió un metodo explicitamente, se trata de ejecutar
			* un metodo llamado ProcessXXX, donde XXX es el contenido de la propiedad
			* Name.

			lcXML = This.oServiceTier.ProcessLinkedEntities()

			If Empty( lcXML )
				lcXML = ""

			Endif && Empty( lcXML )

			This.lIsOk = This.oServiceTier.lIsOk

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally
			loEntity = Null

		Endtry

		Return lcXML

	Endproc
	*
	* END PROCEDURE ProcessLinkedEntities
	*
	* ///////////////////////////////////////////////////////

	* ///////////////////////////////////////////////////////
	* Procedure.....: ValidateEntities
	* Description...: Valida cada una de las entidades
	* Date..........: Viernes 17 de Agosto de 2007 (09:58:09)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Protected Procedure ValidateEntities(  ) As String;
			HELPSTRING "Valida cada una de las entidades"

		Local lcXML As String
		Local loEntity As Object

		Try

			* Ejecuta el método ValidatePut() de cada entidad asociada

			lcXML = ""

			For Each loEntity In This.oColEntities

				lcXML = loEntity.oEntity.DoBizValidation()

				This.lIsOk = loEntity.oEntity.lIsOk
				This.cXMLoError = loEntity.oEntity.cXMLoError

				If !This.lIsOk Or !Empty( lcXML )
					Exit
				Endif
			Endfor

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally
			loEntity = Null

		Endtry

		Return lcXML

	Endproc
	*
	* END PROCEDURE ValidateEntities
	*
	* ///////////////////////////////////////////////////////


	* ///////////////////////////////////////////////////////
	* Procedure.....: GetBackEntities
	* Description...: Trae los cursores originales de cada entidad
	* Date..........: Viernes 17 de Agosto de 2007 (16:27:46)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Protected Procedure GetBackEntities(  ) As Boolean;
			HELPSTRING "Trae los cursores originales de cada entidad"

		Local i As Integer
		Local loEntity As utArchivo Of "FW\TierAdapter\UserTier\utArchivo.prg"
		Local loItem As Object

		Try


			If This.lSerialize
				* Si no estoy en la misma DataSession que el cliente,
				* Tengo que recomponer los cursores igual que como estaban del lado del cliente
				* En esta rutina traigo todos los cursores de las entidades asociadas
				* y luego, en GetBack(), se aplica el diffgram traido del lado del cliente
				* a todas las tablas
				For i = 1 To This.oColEntities.Count
					If This.lIsOk

						loEntity = Null
						loItem = Null

						loItem = This.oColEntities.Item( i )
						loEntity = loItem.oEntity

						loEntity.GetOne( loEntity.nEntidadId, loEntity.nNivelJerarquiaTablas )

						This.lIsOk = loEntity.lIsOk
						This.cXMLoError = loEntity.cXMLoError

					Else
						Exit

					Endif
				Endfor
			Endif

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally
			loEntity = Null
			loItem = Null

		Endtry

	Endproc
	*
	* END PROCEDURE GetBackEntities
	*
	* ///////////////////////////////////////////////////////



	Protected Procedure PutBack( toXA As prxXMLAdapter,;
			nLevel As Integer )

		Local lcDiffGram As String
		Local i As Integer
		Local loParam As Object
		Local loXA As prxXMLAdapter Of "FW\Comun\Prg\prxXMLAdapter.prg"
		Local lnOffSet As Integer

		Try

			lnOffSet = 0
			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			* El diffgram es solo para las tablas de la entidad principal
			* Eliminar las tablas correspondientes a las entidades asociadas ( i > 1 )

			Do While This.oColTables.Count > 1
				This.oColTables.Remove( 2 )
			Enddo


			loXA = Null
			loXA = Newobject("prxXMLAdapter",;
				"prxXMLAdapter.prg")


			loParam = Createobject("Empty")
			AddProperty(loParam, "oXA", loXA )
			AddProperty(loParam, "nLevel", nLevel )

			If This.oColTables.Count > 0
				loTable = This.oColTables.Item( 1 )
				lnOffSet = loTable.Nivel - 1
			Endif

			AddProperty(loParam, "nOffSet", lnOffSet )

			If This.LookOverColTables( This.oColTables, "AddTable", loParam)
				lcDiffGram = loXA.GetDiffGram()
				* Código de DEBUG
				If .F.
					Strtofile( lcDiffGram, "C:\DiffgramPrincipal_"+This.Name+".Xml" )
				Endif

			Endif

			If This.lIsOk
				This.PutBackEntities()
			Endif

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally

		Endtry

		Return lcDiffGram

	Endproc

	* ///////////////////////////////////////////////////////
	* Procedure.....: PutBackEntities
	* Description...: Genera los diffgram para cada una de las entidades asociadas
	* Date..........: Viernes 17 de Agosto de 2007 (10:52:02)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Protected Procedure PutBackEntities(  ) As Boolean;
			HELPSTRING "Genera los diffgram para cada una de las entidades asociadas"

		Local i As Integer
		Local loXA As prxXMLAdapter Of "FW\Comun\Prg\prxXMLAdapter.prg"
		Local loEntity As Object
		Local loParam As Object
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			* Procesar las entidades asociadas
			For i = 1 To This.oColEntities.Count
				If This.lIsOk

					loEntity = Null
					loXA = Null
					loParam = Null

					loEntity = This.oColEntities.Item( i )

					loXA = Newobject("prxXMLAdapter", "prxXMLAdapter.prg")

					loParam = Createobject( "Empty" )

					AddProperty( loParam, "oXA", loXA )
					AddProperty( loParam, "nLevel", loEntity.nLevel )

					If loEntity.oEntity.LookOverColTables( loEntity.oEntity.oColTables, "AddTable", loParam)
						loEntity.cDiffGram = loXA.GetDiffGram()
						* Código de DEBUG
						If .F.
							Strtofile( loEntity.cDiffGram, "C:\DiffGramm_"+loEntity.Name+".Xml" )
						Endif

					Endif

					This.lIsOk = loEntity.oEntity.lIsOk
					This.cXMLoError = loEntity.oEntity.cXMLoError
				Endif
			Endfor

		Catch To oErr
			This.lIsOk = .F.
			* This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			loEntity = Null
			loXA = Null
			loParam = Null

		Endtry

		Return This.lIsOk

	Endproc && PutBackEntities

	*!*		* ///////////////////////////////////////////////////////
	*!*		* Procedure.....: ValidatePut
	*!*		* Description...: Permite validar los datos antes de ejecutar el Put()
	*!*		* Date..........: Lunes 16 de Octubre de 2006 (14:19:18)
	*!*		* Author........: Ricardo Aidelman
	*!*		* Project.......: Sistema Praxis
	*!*		* -------------------------------------------------------
	*!*		* Modification Summary
	*!*		* R/0001  -
	*!*		*
	*!*		*

	*!*		Procedure xxxValidatePut(  ) As String;
	*!*				HELPSTRING "Permite validar los datos antes de ejecutar el Put()"

	*!*			This.cValidationCursorName = ""

	*!*			* Aquí se validan todos los datos antes de enviarlos a grabar
	*!*			* Si todo está OK, devuelve un string vacio
	*!*			* Si hay errores, devuelve un string con el mensaje de error


	*!*			*			Hay que poner la propiedad This.ValidateBeforePut = .T. para que el
	*!*			*			This.Put() llame primero a This.GetBack(), para traer los cursores
	*!*			*			de las capas superiores, luego a éste método, para hacer las validaciones
	*!*			*			necesarias, y luego a This.PutBack() para volver a generar el diffgram
	*!*			*			y llamar a la capa inferior del Put()



	*!*			Return ""
	*!*		Endproc
	*!*		*
	*!*		* END PROCEDURE ValidatePut
	*!*		*
	*!*		* ///////////////////////////////////////////////////////

	* ///////////////////////////////////////////////////////
	* Procedure.....: GetFormId
	* Description...: Obtiene el Id del Formulario
	* Date..........: Miércoles 7 de Junio de 2006 (15:58:31)
	* Author........: Ricardo Aidelman
	* Project.......: SYS Admin
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Protected Procedure GetFormId( tcFormName As String ) As Integer;
			HELPSTRING "Obtiene el Id del Formulario"

		Local lnFormId As Integer
		Local loForm As oForm Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColForms As ColForms Of "Tools\Sincronizador\ColDataBases.prg"
		Local i As Integer
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			Do Case

				Case Vartype( tcFormName ) = "C"

					lnFormId = -1

					If !Empty( tcFormName )

						loColForms = NewColForms()

						i = loColForms.GetKey( Lower( tcFormName ) )

						If ! Empty( i )
							loForm = loColForms.Item( i )
							lnFormId = loForm.nFormId

						Endif && ! Empty( i )

					Endif

				Case Vartype( tcFormName ) = "N"
					lnFormId = tcFormName

				Otherwise
					lnFormId = -1

			Endcase

		Catch To oErr
			* If This.lIsOk
			This.lIsOk = .F.
			* DAE 2009-11-06(17:57:02)
			* This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

			* Endif
			*Throw This.oError
			Throw loError

		Finally
			loForm = Null
			loColForms = Null
			loError = Null

		Endtry

		Return lnFormId

	Endproc
	*
	* END PROCEDURE GetFormId
	*
	* ///////////////////////////////////////////////////////


	Protected Procedure oColEntities_Access
		If Vartype( This.oColEntities ) <> "O"
			This.oColEntities = Newobject( "colEntities", "colEntities.prg" )

			This.oColEntities.cTierLevel 	= "User"
			This.FillColEntities()
		Endif

		Return This.oColEntities
	Endproc


	*!*		* ///////////////////////////////////////////////////////
	*!*		* Procedure.....: SQLExecute
	*!*		* Description...: Ejecuta un comando SQL y devuelve un XML
	*!*		* Date..........: Jueves 19 de Enero de 2006 (11:22:52)
	*!*		* Author........: Ricardo Aidelman
	*!*		* Project.......: Tier Adapter
	*!*		* -------------------------------------------------------
	*!*		* Modification Summary
	*!*		* R/0001  -
	*!*		*
	*!*		*

	*!*		Procedure SQLExecute( tcSQLCommand As String,;
	*!*				tcAlias As String  ) As String;
	*!*				HELPSTRING "Ejecuta un comando SQL y devuelve un XML"

	*!*			Local lcXML As String

	*!*			lcXML = This.oNextTier.SQLExecute( tcSQLCommand, tcAlias )
	*!*			This.RetrieveNextTierData()
	*!*			Return lcXML

	*!*		Endproc
	*!*		*
	*!*		* END PROCEDURE SQLExecute
	*!*		*
	*!*		* ///////////////////////////////////////////////////////


	*
	* Devuelve una instancia del objeto
	Procedure InstanciateEntity( tcEntityName As String,;
			tcTierLevel As String,;
			tcObjectFactoryFileName As String ) As Object;
			HELPSTRING "Devuelve una instancia del objeto"

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loEntity As Object
		Try

			If Empty( tcTierLevel )
				tcTierLevel = "User"

			Endif

			loEntity = DoDefault( tcEntityName, tcTierLevel, tcObjectFactoryFileName )

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				* DAE 2009-11-06(17:55:16)
				*!*	This.cXMLoError=This.oError.Process( oErr )
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				This.cXMLoError = loError.Process( oErr )
				Throw loError

			Endif

		Finally
			* DAE 2009-11-06(17:55:08)
			*!*	If !This.lIsOk
			*!*		Throw This.oError
			*!*	Endif
			loError = Null

		Endtry

		Return loEntity

	Endproc && InstanciateEntity


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetEntity
	*!* Description...: Devuelve un Objeto de la colección Entities
	*!* Date..........: Miércoles 14 de Mayo de 2008 (18:41:10)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*



	Procedure GetEntity( tcEntityName As String,;
			tcTierLevel As String ) As Object;
			HELPSTRING "Devuelve un Objeto de la colección Entities"

		Try
			Local loEntity As Object

			If Empty( tcTierLevel )
				tcTierLevel = "User"
			Endif

			loEntity = DoDefault( tcEntityName,;
				tcTierLevel )

		Catch To oErr
			Local loError As ErrorHandler Of "fw\Actual\ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loEntity

	Endproc
	*!*
	*!* END PROCEDURE GetEntity
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: nProcessType_Assign
	*!* Date..........: Viernes 17 de Julio de 2009 (10:34:15)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure nProcessType_Assign( uNewValue As Integer )

		This.nProcessType = uNewValue
		This.oServiceTier.nProcessType = uNewValue

	Endproc && nProcessType_Assign


	Procedure DoBizValidation()
		Return This.oServiceTier.DoBizValidation()
	Endproc

	*
	* lValidateBeforePut_Access
	Protected Procedure lValidateBeforePut_Access()
		This.lValidateBeforePut = This.oServiceTier.lValidateBeforePut

		Return This.lValidateBeforePut

	Endproc && lValidateBeforePut

Enddefine