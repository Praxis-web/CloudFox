#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Clientes\Stock\Include\Stock.h" 
#INCLUDE "Clientes\Deudores\Include\Deudores.h"
#INCLUDE "Clientes\Acreedores\Include\Acreedores.h"
#INCLUDE "Clientes\Contable\Include\Contable.h"



*
* Actualizacion de Comprobantes
Procedure Comprobante(  ) As Void;
		HELPSTRING "Actualizacion de Comprobantes"

	Local lcCommand As String,;
		lcTitulo As String

	Local loReturn As Object
	Local loParam As Object
	Local loComprobante As Comprobante Of "Fw\Comunes\Prg\Comprobante.prg",;
	loApp As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

	Try

		lcCommand = ""
		loApp = NewApp() 
		
		loComprobante = GetEntity( "Comprobante" )
		loComprobante.nModuloId = loApp.nModuloId   

		lcTitulo = "Comprobantes"
		
		loParam = Createobject( "Empty" )
		AddProperty( loParam, "cAlias", loComprobante.cMainCursorName )
		AddProperty( loParam, "cTitulo", lcTitulo )
		AddProperty( loParam, "oBiz", loComprobante )
		AddProperty( loParam, "cPKField", loComprobante.cPKField )
		
		loComprobante.ValidarTabla() 
		
		loComprobante.GetAll()

		Do Form 'Fw\Comunes\scx\Comprobantes.scx' ;
			With loParam To loReturn

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally
		loParam 		= Null
		oParam 			= Null
		loReturn 		= Null
		loComprobante 	= Null
		loApp 			= Null
		
		Close Databases All

	Endtry

Endproc && Comprobante

Define Class Comprobante As Entidad Of "V:\Clipper2fox\Rutinas\Prg\prxEntidad.prg"

	#If .F.
		Local This As Comprobante Of "Fw\Comunes\Prg\Comprobante.prg"
	#Endif

	* Criterio de busqueda por defecto
	cFilterCriteria = "( 1 > 0 )"

	* Id del modulo al que pertenece el Comprobante
	nModuloId = 0

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="nmoduloid" type="property" display="nModuloId" />] + ;
		[<memberdata name="validartabla" type="method" display="ValidarTabla" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: HookBeforeInitialize
	*!* Description...:
	*!* Date..........: Domingo 7 de Julio de 2013 (16:34:20)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Clipper2Fox
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure HookBeforeInitialize( ) As Boolean

		Local lcCommand As String

		Try

			lcCommand = ""

			* Alias de la Tabla
			This.cMainTableName 	= "Comprobantes"

			* Alias del cursor transitorio
			This.cMainCursorName 	= "cComprobantes"

			* Campo clave
			This.cPKField			= "Id"

			* Carpeta donde se encuentra la Tabla
			This.cTableFolder 		= drComun

			* Nombre real de la tabla
			This.cRealTableName 	= "Comprobantes"

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry


	Endproc
	*!*
	*!* END Procedure HookBeforeInitialize
	*!*
	*!* ///////////////////////////////////////////////////////



	*
	* Verifica que se encuentren todos los comprobantes del sistema
	Procedure ValidarTabla(  ) As Void;
			HELPSTRING "Verifica que se encuentren todos los comprobantes del sistema"
		Local lcCommand As String


		Local lcCommand As String,;
			lcDeudores As String,;
			lcAcreedores As String,;
			lcStock As String,;
			lcNombre As String,;
			lcAbrev As String,;
			lcAlias as String 

		Local i As Integer,;
			lnComp_Id As Integer,;
			lnModulo_Id As Integer,;
			lnSigno_St As Integer,;
			lnSigno_Co As Integer,;
			lnModulo_Id As Integer,;
			lnOrden As Integer,;
			lnId_Asoc As Integer,;
			lnTalonar_Id As Integer,;
			lnEquiCom_Id as Integer,;
			lnDepo_Id as Integer,;
			lnTipoMov as Integer 

		Local llActivo As Boolean,;
			llNumAuto As Boolean,;
			llFound As Boolean,;
			llPideCodi as Boolean,;
			llPideDepo as Boolean 


		Try

			lcCommand = ""

			DoDefault()
			This.CerrarTabla()
			This.AbrirTabla()

			Select Alias( This.cMainTableName )

			* Comprobantes Deudores
			TEXT To lcDeudores NoShow TextMerge Pretext 15
			InList( i,
			DE_FACTURA,
			DE_NOTA_DE_DEBITO,
			DE_NOTA_DE_CREDITO,
			DE_RECIBO_DE_COBRANZA,
			DE_AJUSTE_DEBE,
			DE_AJUSTE_HABER,
			DE_DOCUMENTO
			)
			ENDTEXT

			* Comprobantes Acreedores
			TEXT To lcAcreedores NoShow TextMerge Pretext 15
			InList( i,
			AC_FACTURA,
			AC_NOTA_DE_DEBITO,
			AC_NOTA_DE_CREDITO,
			AC_ORDEN_DE_PAGO,
			AC_AJUSTE_DEBE,
			AC_AJUSTE_HABER,
			AC_DOCUMENTO
			)
			ENDTEXT


			* Comprobantes Stock
			TEXT To lcStock NoShow TextMerge Pretext 15
			InList( i,
			ST_INGRESO,
			ST_PARTE_DE_PRODUCCION,
			ST_AJUSTE_DE_ENTRADA,
			ST_AJUSTE_DE_SALIDA,
			ST_TRANSFERENCIA_DE_ENTRADA,
			ST_TRANSFERENCIA_DE_SALIDA,
			ST_REMITO_SALIDA,
			ST_REMITO_ENTRADA
			)
			EndText
			
			For i = 1 To 99

				lcNombre 		= ""
				lcAbrev			= ""
				lcAlias			= ""
				llActivo 		= .T.
				lnTipoMov 		= 0 
				lnSigno_St 		= ST_ENTRADA
				lnSigno_Co 		= CO_DEBE
				lnModulo_Id 	= 0
				lnOrden 		= 0
				lnTalonar_Id 	= 0
				lnId_Asoc 		= 0
				llNumAuto 		= .T.
				lnEquiCom_Id	= i
				llPideCodi 		= .T.
				llPideDepo 		= .T.  
				lnDepo_Id 		= 0 
				

				llFound = .F.
				
				Do Case
					Case Evaluate( lcDeudores )
						lnModulo_Id = MDL_DEUDORES
						lnTipoMov 	= ST_VENTA
						llFound 	= .T.

						Do Case
							Case i = DE_FACTURA
								lcNombre 		= "Factura de Venta"
								lcAbrev			= "FAC"
								lnSigno_St 		= ST_SALIDA

							Case i = DE_NOTA_DE_DEBITO
								lcNombre 		= "Nota de Débito Deudora"
								lcAbrev			= "NDB"

							Case i = DE_NOTA_DE_CREDITO
								lcNombre 		= "Nota de Crédito Deudora"
								lcAbrev			= "NCR"
								lnSigno_Co 		= CO_HABER
								

							Case i = DE_RECIBO_DE_COBRANZA
								lcNombre 		= "Recibo de Cobranza"
								lcAbrev			= "REC"
								lnSigno_Co 		= CO_HABER

							Case i = DE_AJUSTE_DEBE
								lcNombre 		= "Ajuste al Debe Deudor"
								lcAbrev			= "AJD"

							Case i = DE_AJUSTE_HABER
								lcNombre 		= "Ajuste al Haber Deudor"
								lcAbrev			= "AJH"
								lnSigno_Co 		= CO_HABER

							Case i = DE_DOCUMENTO
								lcNombre 		= "Documento de Terceros"
								lcAbrev			= "DTO"

							Otherwise

						Endcase

					Case Evaluate( lcAcreedores )
						lnModulo_Id = MDL_ACREEDORES
						lnTipoMov 	= ST_COMPRA
						llFound 	= .T.

						Do Case
							Case i = AC_FACTURA
								lcNombre 		= "Factura de Compra"
								lcAbrev			= "FAC"
								lnSigno_Co 		= CO_HABER

							Case i = AC_NOTA_DE_DEBITO
								lcNombre 		= "Nota de Débito Acreedora"
								lcAbrev			= "NDB"
								lnSigno_Co 		= CO_HABER

							Case i = AC_NOTA_DE_CREDITO
								lcNombre 		= "Nota de Crédito Acreedora"
								lcAbrev			= "NCR"
								lnSigno_St 		= ST_SALIDA

							Case i = AC_ORDEN_DE_PAGO
								lcNombre 		= "Orden de Pago"
								lcAbrev			= "O/P"

							Case i = AC_AJUSTE_DEBE
								lcNombre 		= "Ajuste al Debe Acreedor"
								lcAbrev			= "AJD"

							Case i = AC_AJUSTE_HABER
								lcNombre 		= "Ajuste al Haber Acreedor"
								lcAbrev			= "AJH"
								lnSigno_Co 		= CO_HABER

							Case i = AC_DOCUMENTO
								lcNombre 		= "Documento Propio"
								lcAbrev			= "DTO"
								lnSigno_Co 		= CO_HABER

							Otherwise

						Endcase


					Case Evaluate( lcStock )
						lnModulo_Id = MDL_STOCK
						lnTipoMov 	= ST_AJUSTE 
						llFound 	= .T.

						Do Case
							Case i = ST_INGRESO
								lcNombre 		= "Ingreso"
								lcAbrev			= "ING"
								lcAlias 		= STA_INGRESO

							Case i = ST_PARTE_DE_PRODUCCION
								lcNombre 		= "Parte de Producción"
								lcAbrev			= "PPR"
								lcAlias 		= STA_PARTE_DE_PRODUCCION

							Case i = ST_AJUSTE_DE_ENTRADA
								lcNombre 		= "Ajuste de Entrada"
								lcAbrev			= "AJE"
								lcAlias 		= STA_AJUSTE_DE_ENTRADA

							Case i = ST_AJUSTE_DE_SALIDA
								lcNombre 		= "Ajuste de Salida"
								lcAbrev			= "AJS"
								lnSigno_St 		= ST_SALIDA
								lcAlias 		= STA_AJUSTE_DE_SALIDA

							Case i = ST_TRANSFERENCIA_DE_ENTRADA
								lcNombre 		= "Transferencia (Entrada)"
								lcAbrev			= "TRE"
								lnId_Asoc 		= ST_TRANSFERENCIA_DE_SALIDA
								lnTipoMov 		= ST_TRANSFERENCIA
								lcAlias 		= STA_TRANSFERENCIA_DE_ENTRADA

							Case i = ST_TRANSFERENCIA_DE_SALIDA
								lcNombre 		= "Transferencia (Salida)"
								lcAbrev			= "TRS"
								lnId_Asoc 		= ST_TRANSFERENCIA_DE_ENTRADA
								lnSigno_St 		= ST_SALIDA
								lnTipoMov 		= ST_TRANSFERENCIA
								lcAlias 		= STA_TRANSFERENCIA_DE_SALIDA

							Case i = ST_REMITO_SALIDA
								lcNombre 		= "Remito (Salida)"
								lcAbrev			= "RTO"
								lnSigno_St 		= ST_SALIDA
								lcAlias 		= STA_REMITO_SALIDA

							Case i = ST_REMITO_ENTRADA
								lcNombre 		= "Remito (Entrada)"
								lcAbrev			= "RTO"
								lcAlias 		= STA_REMITO_ENTRADA

							Otherwise

						Endcase

					Otherwise

				Endcase

				If llFound

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Locate For Id = <<i>>
					ENDTEXT

					&lcCommand

					If !Found()

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Insert Into <<This.cMainTableName>> (
							Id,
							Nombre,
							Abrev,
							Alias,
							Activo,
							Tipo_Mvto,
							Signo_St,
							Signo_Co,
							Modulo_Id,
							Orden,
							Talonar_Id,
							id_Asoc,
							NumAuto,
							PideCodi,
							PideDepo,
							Depo_Id,
							TS ) Values (
							<<i>>,
							"<<lcNombre>>",
							"<<lcAbrev>>",
							"<<lcAlias>>",
							<<llActivo>>,
							<<lnTipoMov>>,
							<<lnSigno_St>>,
							<<lnSigno_Co>>,
							<<lnModulo_Id>>,
							<<lnOrden>>,
							<<lnTalonar_Id>>,
							<<lnId_Asoc>>,
							<<llNumAuto>>,
							<<llPideCodi>>,
							<<llPideDepo>>,
							<<lnDepo_Id>>, 
							Datetime() )
						ENDTEXT

						&lcCommand
						lcCommand = ""
						
					Endif
				Endif

			Endfor

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && ValidarTabla


	*
	* Lee los parámetros asociados a la entidad
	Procedure LeerParametros(  ) As Void;
			HELPSTRING "Lee los parámetros asociados a la entidad"
		Local lcCommand As String

		Try

			lcCommand = ""
			This.lEditInBrowse = .T.

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && LeerParametros

	*
	* Trae los elementos filttrados por alguna condicion
	* oParam.cFilterCriteria = Criterio de Filtro
	* oParam.cOrderBy = Clausula de Ordenamiento
	* oParam.cFieldList = Lista de Campos
	* oParam.cJoins = Joins
	* oParam.nLevel = Nivel de profundidad que trae
	* oParam.cAlias = Alias alternativo a This.cMainCursorName

	Procedure GetByWhere( oParam As Object ) As Integer;
			HELPSTRING "Trae los elementos filttrados por alguna condicion"

		Local lcCommand As String,;
			lcAlias As String,;
			lcFilterCriteria As String,;
			lcParentFilter As String,;
			lcOrderBy As String,;
			lcFieldList As String,;
			lcJoins As String

		Local lnLevel As Integer

		Local loParent As PrxEntity Of "Fw\TierAdapter\Comun\prxEntity.prg"
		Local lnTally As Integer

		Try

			lcCommand = ""
			
			* Valores por defecto
			lcParentFilter 	= ""
			lcAlias 		= This.cMainCursorName
			lnNivel 		= 1
			lcFieldList		= " * "
			lcJoins			= ""
			lcFilterCriteria = ""
			
			If !Empty( This.nModuloId )
				Text To lcFilterCriteria NoShow TextMerge Pretext 15
				( Modulo_Id = <<This.nModuloId>> )
				EndText
			EndIf
			
			If !Empty( lcFilterCriteria ) 
				If Empty( This.cFilterCriteria )
					This.cFilterCriteria = lcFilterCriteria 
					 
				Else
					This.cFilterCriteria = This.cFilterCriteria + " And " + lcFilterCriteria 
					 
				Endif

			EndIf

			Text To lcOrderBy NoShow TextMerge Pretext 15
			Order By Modulo_Id, Orden, Nombre
			EndText

			
			If Vartype( oParam ) # "O"
				oParam = Createobject( "Empty" )
			Endif

			If !Pemstatus( oParam, "cFilterCriteria", 5 ) And !Empty( This.cFilterCriteria )
				AddProperty( oParam, "cFilterCriteria", This.cFilterCriteria ) 
			EndIf

			If !Pemstatus( oParam, "cOrderBy", 5 )
				AddProperty( oParam, "cOrderBy", lcOrderBy ) 
			EndIf
			
			lnTally = DoDefault( oParam )


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			oParam = Null

		Endtry

		Return lnTally

	Endproc && GetByWhere
	

Enddefine


*!* ///////////////////////////////////////////////////////
*!* Class.........: CboComprobantes
*!* ParentClass...: ComboBox
*!* BaseClass.....: ComboBox
*!* Description...: Comprobantes
*!* Date..........: Domingo 15 de Abril de 2012 (12:19:45)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class CboComprobantes As ComboBox

	#If .F.
		Local This As CboComprobantes Of "Fw\Comunes\Prg\Comprobante.prg"
	#Endif

	BoundColumn 	= 2
	BoundTo 		= .T.
	ColumnCount 	= 1
	RowSourceType 	= 0
	RowSource 		= ""
	Style			= 2
	Sorted 			= .T.


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	Procedure Init()
		Local lcCommand As String

		Local loComprobante As Comprobante Of "Fw\Comunes\Prg\Comprobante.prg"

		Try

			lcCommand = ""
			loComprobante = GetEntity( "Comprobante" )

			loComprobante.GetAll()

			Select Alias( loComprobante.cMainCursorName )
			Locate

			Scan
				This.AddItem( Evaluate( loComprobante.cMainCursorName + ".Nombre" ))
				This.List( This.NewIndex, 2 ) = Transform( Evaluate( loComprobante.cMainCursorName + "." + loComprobante.cPKField ))
			Endscan

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loComprobante = Null

		Endtry

	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: CboComprobantes
*!*
*!* ///////////////////////////////////////////////////////