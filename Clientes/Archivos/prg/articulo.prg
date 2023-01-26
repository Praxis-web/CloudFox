#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE v:\CloudFox\Tools\JSON\Include\HTTP.h

* Rutinas del Artículo
*/ -----------------------------------------------------------------------------------------

#Define PROG_ALTA 			1
#Define PROG_MODIFICACION 	2


*/ -----------------------------------------------------------------------------------------

#Define PA_CODIGO			1
#Define PA_DESCRIPCION		2
#Define PA_ALIAS			3
#Define PA_CODIGO_BARRAS	4

Local lcCommand As String
Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

Try

	lcCommand = ""
	DRVA = "s:\Fenix\Dbf\DBF\"
	loArticulo = NewArticulo()

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Cremark = lcCommand
	loError.Process( oErr )


Finally
	loArticulo = Null

Endtry

Return

*########################################################################


*
* Abre todos los archivos necesarios para poder trabajar con los articulos
Procedure AbrirArchivosDeArticulos( tlAbrirSinIdx As Boolean ) As Void;
		HELPSTRING "Abre todos los archivos necesarios para poder trabajar con los articulos"
	Local lcCommand As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		loArticulo.AbrirArchivosDeArticulos( tlAbrirSinIdx )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Cremark = lcCommand
		loError.Process( oErr )


	Finally
		loArticulo = Null

	Endtry

	Return
Endproc


Procedure prxPedArt1( oObj As Object ) As Object;
		HELPSTRING "Pedido del articulo por CODIGO O DESCRIPCION"

	Local loObj As Object

	Local lcCommand As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		loObj = loArticulo.prxPedArt1( oObj )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Cremark = lcCommand
		loError.Process( oErr )


	Finally
		loArticulo = Null

	Endtry

	Return loObj

Endproc

Procedure prxPedArt( tnABM As Integer,;
		tuCodigo As Variant ,;
		tnCodRow As Integer,;
		tnCodCol As Integer,;
		tnDesRow As Integer,;
		tnDesCol As Integer,;
		tnAliRow As Integer,;
		tnAliCol As Integer,;
		tnBarRow As Integer,;
		tnBarCol As Integer ) As Object;
		HELPSTRING "Pedido del articulo por CODIGO O DESCRIPCION"

	Local loObj As Object

	Local lcCommand As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		loObj = loArticulo.prxPedArt( tnABM,;
			tuCodigo,;
			tnCodRow,;
			tnCodCol,;
			tnDesRow,;
			tnDesCol,;
			tnAliRow,;
			tnAliCol,;
			tnBarRow,;
			tnBarCol )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Cremark = lcCommand
		loError.Process( oErr )


	Finally
		loArticulo = Null

	Endtry

	Return loObj

Endproc


* Recibe un String y devuelve un string formateado para mostrar
Procedure prxMosArt( tcCodigo As String ) As String;
		HELPSTRING "Recibe un String y devuelve un string formateado para mostrar"

	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"
	Local lcReturn As String

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		lcReturn = loArticulo.prxMosArt( tcCodigo )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Cremark = lcCommand
		loError.Process( oErr )


	Finally
		loArticulo = Null

	Endtry

	Return lcReturn

Endproc && prxBusArt


*
* Armado del CODIGO para imprimir, con guiones, en funcion de sus partes
Procedure prxArmArt( tuGrup As Variant,;
		tuNume As Variant) As String;
		HELPSTRING "Armado del CODIGO en funcion de sus partes"

	Local lcArticulo As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"
	Local lcReturn As String

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		lcArticulo = loArticulo.prxArmArt( tuGrup,;
			tuNume )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return lcArticulo


Endproc && prxArmArt


*
* Armado del GRUPO en funcion de sus partes
Procedure prxBusGru( tuGrup As Variant ) As String;
		HELPSTRING "Armado del GRUPO en funcion de sus partes"

	Local lcGrup As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"
	Local lcReturn As String

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		lcGrup = loArticulo.prxBusGru( tuGrup )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return Upper( lcGrup )

Endproc && prxBusGru

*
* Armado de la LINEA en funcion de sus partes
Procedure prxBusLin( tuGrup As Variant, tuLin As Variant ) As String;
		HELPSTRING "Armado de la LINEA en funcion de sus partes"

	Local lcLin As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"
	Local lcReturn As String

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		lcLin = loArticulo.prxBusLin( tuGrup, tuLin )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return Upper( lcLin )

Endproc && prxBusLin


*
* Armado del GRUPO para imprimir
Procedure prxArmGru( tuGrup As Variant ) As String;
		HELPSTRING "Armado del GRUPO para imprimir"

	Local lcGrup As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"
	Local lcReturn As String

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		lcGrup = loArticulo.prxArmGru( tuGrup )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return Upper( lcGrup )

Endproc && prxArmGru

*
* Armado de la LINEA para imprimir
Procedure prxArmLin( tuGrup As Variant,;
		tuLin As Variant ) As String;
		HELPSTRING "Armado de la LINEA para imprimir"

	Local lcLin As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"
	Local lcReturn As String

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		lcLin = loArticulo.prxArmLin( tuGrup, tuLin )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return Upper( lcLin )

Endproc && prxArmLin



*
* Selector de Artículos
Procedure prxLista( tnAction As Integer ) As Object ;
		HELPSTRING "Selector de Artículos"

	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"
	Local loObj As Object

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		loObj = loArticulo.prxLista( tnAction )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return loObj

Endproc



*
* Recibe un String y devuelve un string validado para buscar el articulo por código
Procedure prxBusCod( tcCodigo As String ) As String;
		HELPSTRING "Recibe un String y devuelve un string validado para buscar el articulo por código"

	Local lcCodigo As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		lcCodigo = loArticulo.prxBusCod( tcCodigo )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return lcCodigo

Endproc && prxBusCod



*
* Devuelve un string para buscar el articulo por código
Procedure prxBusArt( tuGrup As Variant,;
		tuNume As Variant ) As String;
		HELPSTRING "Devuelve un string para buscar el articulo por código"

	Local lcCodigo As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		lcCodigo = loArticulo.prxBusArt( tuGrup, tuNume )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return lcCodigo

Endproc && prxBusArt

*
* Devuelve un string para buscar el articulo por código
* ( Solo para Rubro-Linea-Articulo )
Procedure prxArmarCodigo( tuGrup As Variant,;
		tuLin As Variant,;
		tuNume As Variant ) As String;
		HELPSTRING "Devuelve un string para buscar el articulo por código"

	Local lcCodigo As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		lcCodigo = loArticulo.prxArmarCodigo( tuGrup, tuLin, tuNume )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return lcCodigo

Endproc && prxArmarCodigo


*
* Devuelve un string en blanco, con la longitus del código
Procedure prxIniCod() As String;
		HELPSTRING "Devuelve un string en blanco, con la longitus del código"

	Local lcCodigo As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		lcCodigo = loArticulo.prxIniCod()

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return lcCodigo

Endproc && prxBusArt


*
* Devuelve la parte del código correspondiernte al grupo
Procedure ExtractGrup( tcCodigo As String, tcDataType As Character ) As Variant ;
		HELPSTRING "Devuelve la parte del código correspondiernte al grupo"

	Local luGrup As Variant
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		luGrup = loArticulo.ExtractGrup( tcCodigo, tcDataType )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return luGrup

Endproc && ExtractGrup

*
* Devuelve la parte del código correspondiernte a la linea
Procedure ExtractLin( tcCodigo As String, tcDataType As Character ) As Variant ;
		HELPSTRING "Devuelve la parte del código correspondiernte la linea"

	Local luLin As Variant
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		luLin = loArticulo.ExtractLin( tcCodigo, tcDataType )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return luLin

Endproc && ExtractLin


*
* Devuelve la parte del código correspondiernte al articulo
Procedure ExtractNume( tcCodigo As String,;
		tcDataType As Character ) As Variant ;
		HELPSTRING "Devuelve la parte del código correspondiernte al articulo"

	Local luNume As Variant
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		luNume = loArticulo.ExtractNume( tcCodigo, tcDataType )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry


	Return luNume

Endproc && ExtractNume



* Indica si el codigo corresponde a un codigo vacio
*
Procedure CodigoVacio( tcCodigo As String ) As Boolean
	Local lcCommand As String
	Local llEmpty As Boolean


	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		llEmpty = loArticulo.CodigoVacio( tcCodigo )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return llEmpty

Endproc && CodigoVacio


*
* Consulta de Grupos
Procedure prxTabGru(  ) As Void;
		HELPSTRING "Consulta de Grupos"
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"
	Local loObj As Object

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		loObj = loArticulo.prxTabGru()

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return loObj

Endproc

*
* Consulta de Lineas
Procedure prxTabLin(  ) As Void;
		HELPSTRING "Consulta de Lineas"
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"
	Local loObj As Object

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		loObj = loArticulo.prxTabLin()

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return loObj

Endproc

*
* Pedido del Grupo
Procedure prxPedGru( tnABM As Integer,;
		tuCodigo As Variant ,;
		tnCodRow As Integer,;
		tnCodCol As Integer,;
		tnDesRow As Integer,;
		tnDesCol As Integer ) As Object;
		HELPSTRING "Pedido del Grupo"
	Local loObj As Object

	Local lcCommand As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		loObj = loArticulo.prxPedGru( tnABM,;
			tuCodigo,;
			tnCodRow,;
			tnCodCol,;
			tnDesRow,;
			tnDesCol )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Cremark = lcCommand
		loError.Process( oErr )


	Finally
		loArticulo = Null

	Endtry

	Return loObj

Endproc


*
* Pedido de la Linea
Procedure prxPedLin( tnABM As Integer,;
		tuCodigo As Variant ,;
		tnCodRow As Integer,;
		tnCodCol As Integer,;
		tnDesRow As Integer,;
		tnDesCol As Integer ) As Object;
		HELPSTRING "Pedido de la Linea"
	Local loObj As Object

	Local lcCommand As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""
		loArticulo = NewArticulo()
		loObj = loArticulo.prxPedLin( tnABM,;
			tuCodigo,;
			tnCodRow,;
			tnCodCol,;
			tnDesRow,;
			tnDesCol )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Cremark = lcCommand
		loError.Process( oErr )


	Finally
		loArticulo = Null

	Endtry

	Return loObj

Endproc

*
* Pedido del Talle
Procedure prxPedTal( tnRubro As Integer,;
		tnRow As Integer,;
		tnCol As Integer,;
		tnSelected As Integer,;
		tlShow As Boolean,;
		tcCaption As String,;
		toParam As Object,;
		tnColumn As Integer ) As Object;
		HELPSTRING "Pedido del Talle"

	Local lnTalle_Id As Integer

	Local lcCommand As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""

		If Pcount() < 5
			tlShow = .T.
		Endif

		loArticulo = NewArticulo()
		lnTalle_Id = loArticulo.prxPedTal( tnRubro,;
			tnRow,;
			tnCol,;
			tnSelected,;
			tlShow,;
			tcCaption,;
			toParam,;
			tnColumn )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Cremark = lcCommand
		loError.Process( oErr )


	Finally
		loArticulo = Null

	Endtry

	Return lnTalle_Id

Endproc

*
* Pedido del Color
Procedure prxPedCol( tnArt_Id As Integer,;
		tnRow As Integer,;
		tnCol As Integer,;
		tnSelected As Integer,;
		tlShow As Boolean,;
		tcCaption As String,;
		toParam As Object,;
		tnColumn As Integer ) As Object;
		HELPSTRING "Pedido del Color"

	Local lnColor_Id As Integer

	Local lcCommand As String
	Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	Try

		lcCommand = ""

		If Pcount() < 5
			tlShow = .T.
		Endif

		loArticulo = NewArticulo()
		lnColor_Id = loArticulo.prxPedCol( tnArt_Id,;
			tnRow,;
			tnCol,;
			tnSelected,;
			tlShow,;
			tcCaption,;
			toParam,;
			tnColumn )

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Cremark = lcCommand
		loError.Process( oErr )


	Finally
		loArticulo = Null

	Endtry

	Return lnColor_Id

Endproc


*!* ///////////////////////////////////////////////////////
*!* Class.........: Articulo
*!* ParentClass...: prxCustom Of 'V:\CloudFox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....: Custom
*!* Description...: Clase para Grupo - Articulo
*!* 					La línea es un atributo
*!* Date..........: Martes 1 de Mayo de 2012 (11:31:09)
*!* Author........: Ricardo Aidelman
*!* Project.......: CloudFox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class Articulo As prxCustom Of 'V:\CloudFox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'

	#If .F.
		Local This As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"
	#Endif


	* ¿Utiliza Grupo?
	UsaGrupo = "S"

	* Picture Artículo
	PictArt = "999-99999999"

	* Longitud Grupo
	LenGrupo = 3

	* Longitud Articulo
	LenArt = 8

	* Grupo Numérico/AlfaNumérico
	GrupoAlfa = "N"

	* Completa el Número del Grupo con CEROS a la izquierda
	GrupoCeros = "N"

	* Articulo Numérico/AlfaNumérico
	ArtAlfa = "N"

	* Completa el Número del Artículo con CEROS a la izquierda
	ArtCeros = "N"

	* ¿Utiliza Alias?
	UsaAlias = "N"

	* ¿Utiliza Código de Barras?
	UsaBarras = "N"

	* Orden de pedido
	OrdenGet = "CD"

	* ¿Utiliza Código de Stock?
	CodStock = "N"

	* Cantidad de Listas de Precio
	Listas = 1

	* ¿Utiliza Artículos para Productos y Servicios?
	Servicios = "N"

	* Referencia al objeto
	oObj = Null

	* ¿Utiliza la búsqueda inteligente para las descripciones?
	AdvSearch = "N"

	* Si utiliza la busqueda inteligente, indica si la descrpcion del grupo
	* es tomada en cuenta
	ASGrupo = "N"

	* ¿Utiliza Línea?
	UsaLinea = "N"

	* Longitud Linea
	LenLinea = 3

	* Linea Numérico/AlfaNumérico
	LineaAlfa = "N"

	* Utiliza la Línea como Atributo o Parte del Código
	LinCodAtr = "A"

	* Completa el Número de la Linea con CEROS a la izquierda
	LineaCeros = "N"

	* Si utiliza la busqueda inteligente, indica si la descripcion de la Linea
	* es tomada en cuenta
	ASLinea = "N"

	* Indica por cual campo se está pidiendo el articulo
	nCurrent = 0

	* Nombre del archivo de grupo
	cTablaGrupo = "ar2Gru"

	* Nombre del campo que contiene el Código
	cFieldCodigo = "Nume1"

	* Nombre del campo que contiene el Grupo
	cFieldGrupo = "Grup1"

	cLeyendaGrupo 		= "Ingrese el Grupo"
	cLeyendaLinea 		= "Ingrese la Línea"
	cLeyendaArticulo 	= "Ingrese el Artículo"

	UsaTalle = "N"
	UsaColor = "N"


	lPermiteIngresoVacio = .F.

	* Indica si la tabla se sincroniza con la Web
	lIntegracionWeb = .F.

	* Indica si ar1Art tiene filtro por activos
	lFiltrarNoActivos = .T.

	PideLeyen = "N"

	* Código por default
	cCodigo = ""
	* Descripción por default
	cDescripcion = ""
	* Código de Barras por default
	cBarra = ""
	* Alias por default
	cAlias = ""


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ccodigo" type="property" display="cCodigo" />] + ;
		[<memberdata name="cdescripcion" type="property" display="cDescripcion" />] + ;
		[<memberdata name="cbarra" type="property" display="cBarra" />] + ;
		[<memberdata name="calias" type="property" display="cAlias" />] + ;
		[<memberdata name="oobj" type="property" display="oObj" />] + ;
		[<memberdata name="oobj_access" type="method" display="oObj_Access" />] + ;
		[<memberdata name="lengrupo" type="property" display="LenGrupo" />] + ;
		[<memberdata name="lenart" type="property" display="LenArt" />] + ;
		[<memberdata name="grupoalfa" type="property" display="GrupoAlfa" />] + ;
		[<memberdata name="artalfa" type="property" display="ArtAlfa" />] + ;
		[<memberdata name="pictart" type="property" display="PictArt" />] + ;
		[<memberdata name="usagrupo" type="property" display="UsaGrupo" />] + ;
		[<memberdata name="servicios" type="property" display="Servicios" />] + ;
		[<memberdata name="listas" type="property" display="Listas" />] + ;
		[<memberdata name="codstock" type="property" display="CodStock" />] + ;
		[<memberdata name="ordenget" type="property" display="OrdenGet" />] + ;
		[<memberdata name="usabarras" type="property" display="UsaBarras" />] + ;
		[<memberdata name="usaalias" type="property" display="UsaAlias" />] + ;
		[<memberdata name="usagrupo_access" type="method" display="UsaGrupo_Access" />] + ;
		[<memberdata name="prxmosart" type="method" display="prxMosArt" />] + ;
		[<memberdata name="prxarmart" type="method" display="prxArmArt" />] + ;
		[<memberdata name="extractnume" type="method" display="ExtractNume" />] + ;
		[<memberdata name="extractgrup" type="method" display="ExtractGrup" />] + ;
		[<memberdata name="abrirarchivosdearticulos" type="method" display="AbrirArchivosDeArticulos" />] + ;
		[<memberdata name="prxpedart" type="method" display="prxPedArt" />] + ;
		[<memberdata name="prxpedart1" type="method" display="prxPedArt1" />] + ;
		[<memberdata name="obtenerobjeto" type="method" display="ObtenerObjeto" />] + ;
		[<memberdata name="pidecodigo" type="method" display="PideCodigo" />] + ;
		[<memberdata name="pedircodigo" type="method" display="PedirCodigo" />] + ;
		[<memberdata name="grupoexiste" type="method" display="GrupoExiste" />] + ;
		[<memberdata name="articuloexiste" type="method" display="ArticuloExiste" />] + ;
		[<memberdata name="validararticuloenlaweb" type="method" display="ValidarArticuloEnLaWeb" />] + ;
		[<memberdata name="pidedescripcion" type="method" display="PideDescripcion" />] + ;
		[<memberdata name="pedirdescripcion" type="method" display="PedirDescripcion" />] + ;
		[<memberdata name="descripcionexiste" type="method" display="DescripcionExiste" />] + ;
		[<memberdata name="pidealias" type="method" display="PideAlias" />] + ;
		[<memberdata name="pediralias" type="method" display="PedirAlias" />] + ;
		[<memberdata name="pidebarras" type="method" display="PideBarras" />] + ;
		[<memberdata name="prxmosart" type="method" display="prxMosArt" />] + ;
		[<memberdata name="prxarmart" type="method" display="prxArmArt" />] + ;
		[<memberdata name="prxbusgru" type="method" display="prxBusGru" />] + ;
		[<memberdata name="prxarmgru" type="method" display="prxArmGru" />] + ;
		[<memberdata name="prxlista" type="method" display="prxLista" />] + ;
		[<memberdata name="armarcampos" type="method" display="ArmarCampos" />] + ;
		[<memberdata name="prxbuscod" type="method" display="prxBusCod" />] + ;
		[<memberdata name="prxbusart" type="method" display="prxBusArt" />] + ;
		[<memberdata name="prxinicod" type="method" display="prxIniCod" />] + ;
		[<memberdata name="extractgrup" type="method" display="ExtractGrup" />] + ;
		[<memberdata name="extractnume" type="method" display="ExtractNume" />] + ;
		[<memberdata name="codigovacio" type="method" display="CodigoVacio" />] + ;
		[<memberdata name="prxtabgru" type="method" display="prxTabGru" />] + ;
		[<memberdata name="prxpedgru" type="method" display="prxPedGru" />] + ;
		[<memberdata name="prxpedtal" type="method" display="prxPedTal" />] + ;
		[<memberdata name="prxpedcol" type="method" display="prxPedCol" />] + ;
		[<memberdata name="lpermiteingresovacio" type="property" display="lPermiteIngresoVacio" />] + ;
		[<memberdata name="pedircodigogrupo" type="method" display="PedirCodigoGrupo" />] + ;
		[<memberdata name="pidecodigogrupo" type="method" display="PideCodigoGrupo" />] + ;
		[<memberdata name="pidedescripciongrupo" type="method" display="PideDescripcionGrupo" />] + ;
		[<memberdata name="pedirdescripciongrupo" type="method" display="PedirDescripcionGrupo" />] + ;
		[<memberdata name="descripciongrupoexiste" type="method" display="DescripcionGrupoExiste" />] + ;
		[<memberdata name="barrasexiste" type="method" display="BarrasExiste" />] + ;
		[<memberdata name="artceros" type="property" display="ArtCeros" />] + ;
		[<memberdata name="grupoceros" type="property" display="GrupoCeros" />] + ;
		[<memberdata name="precio" type="method" display="Precio" />] + ;
		[<memberdata name="parametrosdeprecio" type="method" display="ParametrosDePrecio" />] + ;
		[<memberdata name="pedirgrupo" type="method" display="PedirGrupo" />] + ;
		[<memberdata name="pedirarticulo" type="method" display="PedirArticulo" />] + ;
		[<memberdata name="advancesearch" type="method" display="AdvanceSearch" />] + ;
		[<memberdata name="asgrupo" type="property" display="ASGrupo" />] + ;
		[<memberdata name="advsearch" type="property" display="AdvSearch" />] + ;
		[<memberdata name="lenlinea" type="property" display="LenLinea" />] + ;
		[<memberdata name="lineaalfa" type="property" display="LineaAlfa" />] + ;
		[<memberdata name="usalinea" type="property" display="UsaLinea" />] + ;
		[<memberdata name="usalinea_access" type="method" display="UsaLinea_Access" />] + ;
		[<memberdata name="lineaceros" type="property" display="LineaCeros" />] + ;
		[<memberdata name="aslinea" type="property" display="ASLinea" />] + ;
		[<memberdata name="lincodatr" type="property" display="LinCodAtr" />] + ;
		[<memberdata name="ncurrent" type="property" display="nCurrent" />] + ;
		[<memberdata name="cTablaGrupo" type="property" display="cTablaGrupo" />] + ;
		[<memberdata name="cfieldcodigo" type="property" display="cFieldCodigo" />] + ;
		[<memberdata name="cfieldgrupo" type="property" display="cFieldGrupo" />] + ;
		[<memberdata name="cleyendagrupo" type="property" display="cLeyendaGrupo" />] + ;
		[<memberdata name="cleyendalinea" type="property" display="cLeyendaLinea" />] + ;
		[<memberdata name="cleyendaarticulo" type="property" display="cLeyendaArticulo" />] + ;
		[<memberdata name="usacolor" type="property" display="UsaColor" />] + ;
		[<memberdata name="usatalle" type="property" display="UsaTalle" />] + ;
		[<memberdata name="lintegracionweb" type="property" display="lIntegracionWeb" />] + ;
		[<memberdata name="lfiltrarnoactivos" type="property" display="lFiltrarNoActivos" />] + ;
		[<memberdata name="pideleyen" type="property" display="PideLeyen" />] + ;
		[</VFPData>]


	Procedure Init
		Local lcCommand As String,;
			lcAlias As String
		Local loDataTier As PrxDataTier Of "Fw\Tieradapter\Comun\Prxdatatier.prg"
		Local llExist As Boolean

		Try

			lcCommand = ""
			lcAlias = Alias()
			llExist = .T.

			loDataTier = NewDT()

			If !Used( "ar0Art" )
				llExist = .F.

				Use ( Alltrim( DRVA ) + "ar0Art" ) Shared In 0
			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From ar0Art
				into Cursor cArticulo
			ENDTEXT

			&lcCommand

			Select cArticulo
			Locate

			Scatter Memo Name This Additive

			Use In Select( "cArticulo" )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			If !llExist
				Use In Select( "ar0Art" )
			Endif

			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

			loDataTier 		= Null
			loArticulo 		= Null

		Endtry


	Endproc


	*
	* Abre todos los archivos necesarios para poder trabajar con los articulos
	Procedure AbrirArchivosDeArticulos( tlAbrirSinIdx As Boolean ) As Void;
			HELPSTRING "Abre todos los archivos necesarios para poder trabajar con los articulos"
		Try


			If !IsRuntime()
				Set DataSession To 1
			Endif

			* Asegurarse que la colección existe
			o = NewColTables()

			If !tlAbrirSinIdx
				If !Used( "ar1art" )
					M_Use( 0, Trim(DRCOMUN)+'AR1ART', -1 )
				Endif

				If !Used( This.cTablaGrupo )
					M_Use( 0, Trim(DRCOMUN)+ This.cTablaGrupo, -1 )
				Endif
			Endif

			If !Used( "Articulos" )
				If Used( "ar1art" )
					Use ( Trim(DRCOMUN)+'AR1ART' ) Again Shared In 0 Alias Articulos

				Else
					M_Use( 0, Trim(DRCOMUN)+'AR1ART', 0, .F., "Articulos" )

				Endif

			Endif

			If GetValue( "UsaFormula", "ar0Stk", "N" ) = "S"
				If !Used( "Articulos_Formula" )
					If Used( "ar9art" )
						Use ( Trim(DRCOMUN)+'AR9ART' ) Again Shared In 0 Alias Articulos_Formula

					Else
						M_Use( 0, Trim(DRCOMUN)+'AR9ART', 0, .F., "Articulos_Formula" )

					Endif

				Endif

			Endif

			If !Used( "Rubros" )
				If !Used( This.cTablaGrupo )
					M_Use( 0, Trim(DRCOMUN)+ This.cTablaGrupo, 0, .F., "Rubros" )

				Else
					Use ( Trim(DRCOMUN)+ This.cTablaGrupo ) Again Shared In 0 Alias Rubros

				Endif

			Endif

			If GetValue( "UsaLinea", "ar0Art", "N" ) == "S"
				If !tlAbrirSinIdx
					If !Used( "ar3Lin" )
						M_Use( 0, Trim(DRCOMUN)+'ar3Lin', -1 )
					Endif
				Endif

				If !Used( "Lineas" )
					If !Used( "ar3Lin" )
						M_Use( 0, Trim(DRCOMUN)+'ar3Lin', 0, .F., "Lineas" )

					Else
						Use ( Trim(DRCOMUN)+'ar3Lin' ) Again Shared In 0 Alias Lineas

					Endif

				Endif

			Endif

			If This.UsaTalle == "S"
				M_Use( 0, Trim(DRCOMUN)+'ar1Tal', 0, .F., "Talles" )
			Endif

			If This.UsaColor == "S"
				M_Use( 0, Trim(DRCOMUN)+'ar1Col', 0, .F., "Colores" )
			Endif

			PonerFiltros()

			If Used( "ar1Art" )
				This.lFiltrarNoActivos = Like( "*ACTI1*", Upper(Filter("ar1Art")))

			Else
				This.lFiltrarNoActivos = Like( "*ACTI1*", Upper(Filter("Articulos")))

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			o = Null

		Endtry

	Endproc && AbrirArchivosDeArticulos




	*
	* Wraper de prxPedArt. Permite pasar un objeto como parametro
	Procedure prxPedArt1( loObj As Object ) As Object;
			HELPSTRING "Wraper de prxPedArt. Permite pasar un objeto como parametro"
		Local lcCommand As String
		Local loReturnObj As Object

		Try

			lcCommand = ""
			This.oObj = loObj
			loReturnObj = This.prxPedArt()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loObj = Null

		Endtry

		Return loReturnObj

	Endproc && prxPedArt1


	*
	* Pedido del articulo por CODIGO O DESCRIPCION

	* Devolucion
	*	Status: (1):Escape, (2):Empty, (3):Valor

	* Esta rutina es la encargada de abrir los archivos necesarios para poder buscar el articulo

	Procedure prxPedArt( tnABM As Integer,;
			tuCodigo As Variant ,;
			tnCodRow As Integer,;
			tnCodCol As Integer,;
			tnDesRow As Integer,;
			tnDesCol As Integer,;
			tnAliRow As Integer,;
			tnAliCol As Integer,;
			tnBarRow As Integer,;
			tnBarCol As Integer ) As Object;
			HELPSTRING "Pedido del articulo por CODIGO O DESCRIPCION"

		Local loObj As Object
		Local lcOrdenGet As String

		Local llUsaGrupo As Boolean,;
			llUsaAlias As Boolean,;
			llUsaBarras As Boolean,;
			llPideCodigo As Boolean,;
			llPideDescripcion As Boolean,;
			llPideLeyenda As Boolean


		Local lnI As Integer
		Local lnStatus As Integer

		Local llValidArt As Boolean,;
			llVacioArt  As Boolean

		Try

			If Vartype( plValidArt ) = "L"
				llValidArt = plValidArt

			Else
				llValidArt = .T.

			Endif

			If Vartype( plVacioArt ) = "L"
				* RA 28/02/2019(14:20:41)
				* Compatibilidad para atras
				This.lPermiteIngresoVacio = plVacioArt
			Endif

			loObj = This.oObj

			If Empty( Pcount() )
				tnABM 		= loObj.nABM
				tuCodigo 	= loObj.uCodigo
				tnCodRow 	= loObj.nCodRow
				tnCodCol 	= loObj.nCodCol
				tnDesRow 	= loObj.nDesRow
				tnDesCol 	= loObj.nDesCol
				tnAliRow 	= loObj.nAliRow
				tnAliCol 	= loObj.nAliCol
				tnBarRow 	= loObj.nBarRow
				tnBarCol  	= loObj.nBarCol

			Else
				loObj.nCodRow 	= tnCodRow
				loObj.nCodCol 	= tnCodCol
				loObj.nDesRow 	= tnDesRow
				loObj.nDesCol 	= tnDesCol
				loObj.nAliRow 	= tnAliRow
				loObj.nAliCol 	= tnAliCol
				loObj.nBarRow 	= tnBarRow
				loObj.nBarCol  	= tnBarCol

			Endif

			If !Inlist( tnABM, PROG_ALTA, PROG_MODIFICACION )
				Error "Error de Parametros en Pedido de Artículo: tnABM"
			Endif

			lcOrdenGet 	= This.OrdenGet
			llUsaGrupo 	= This.UsaGrupo = "S"
			llUsaAlias 	= This.UsaAlias = "S" And (!Empty( tnAliRow ) Or !Empty( tnAliCol ))
			llUsaBarras	= This.UsaBarras = "S" And (!Empty( tnBarRow ) Or !Empty( tnBarCol ))
			llPideDescripcion 	= (!Empty( tnDesRow ) Or !Empty( tnDesCol ) )
			llPideCodigo 		= (!Empty( tnCodRow ) Or !Empty( tnCodCol ) )
			llPideLeyenda 		= ( This.PideLeyen = "S" )

			If !Empty( tuCodigo )
				Do Case
					Case Substr( lcOrdenGet, 1, 1 ) = "C"
						loObj.Codigo = tuCodigo

					Case Substr( lcOrdenGet, 1, 1 ) = "D"
						loObj.Descripcion = tuCodigo

					Case Substr( lcOrdenGet, 1, 1 ) = "A"
						loObj.Alias = tuCodigo

					Case Substr( lcOrdenGet, 1, 1 ) = "B"
						loObj.Barras = tuCodigo

				Endcase

			Endif

			If !Empty( This.cCodigo )
				loObj.Codigo = This.cCodigo
			Endif
			If !Empty( This.cDescripcion )
				loObj.Descripcion = This.cDescripcion
			Endif
			If !Empty( This.cAlias )
				loObj.Alias = This.cAlias
			Endif
			If !Empty( This.cBarra )
				loObj.Barras = This.cBarra
			Endif


			lnStatus = -1
			lnI = 0

			lcTag = ""


			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VALOR, Iif( llValidArt, -99, ST_VACIO )) And !&Aborta And lnI < 5

				lnI = lnI + 1

				If lnI > 4
					If This.lPermiteIngresoVacio
						Loop

					Else
						lnI = 1

					Endif

				Endif

				lcTag = ""

				Do Case
					Case llPideCodigo And This.PideCodigo( lnI, lcOrdenGet, tnABM )
						This.nCurrent = PA_CODIGO
						lnStatus = This.PedirCodigo( loObj.Codigo, tnCodRow, tnCodCol, tnABM )
						lcTag = "ArtPK"

					Case llPideDescripcion And This.PideDescripcion( lnI, lcOrdenGet )
						This.nCurrent = PA_DESCRIPCION
						lnStatus = This.PedirDescripcion( loObj.Descripcion, tnDesRow, tnDesCol )
						lcTag = "Desc1"

					Case llUsaAlias And This.PideAlias( lnI, lcOrdenGet )
						This.nCurrent = PA_ALIAS
						lnStatus = This.PedirAlias( loObj.Alias, tnAliRow, tnAliCol )
						lcTag = "Alia1"

					Case llUsaBarras And This.PideBarras( lnI, lcOrdenGet )
						This.nCurrent = PA_CODIGO_BARRAS
						lnStatus = This.PedirBarras( loObj.Barras, tnBarRow, tnBarCol )
						lcTag = "Barr1"

				Endcase

			Enddo

			If Vartype( This.oObj ) = "O"
				loObj = This.oObj
			Endif

			loObj.Tag = lcTag

			If !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR )
				lnStatus = ST_ESCAPE
			Endif

			loObj.Status = lnStatus

			If lnStatus = ST_VALOR And tnABM = PROG_MODIFICACION

				If Type("loOBJ.grupo") = "C"

					cVariable = Replicate( "9", This.LenGrupo )

				Else
					cVariable = Val(Replicate( "9", This.LenGrupo ))

				Endif


				If llValidArt And (loObj.Grupo # cVariable)
					If .T. && llUsaGrupo
						* RA 2012-06-24(12:20:58)
						* Siempre se incluye el grupo en el codigo
						* Debe mostrarse siempre a traves de prxArmArt()
						loObj.Codigo 		= This.prxBusArt( Evaluate( "Articulos." + This.cFieldGrupo ), Evaluate( "Articulos." + This.cFieldCodigo ))

					Else
						loObj.Codigo 		= This.prxArmArt( Evaluate( "Articulos." + This.cFieldGrupo ), Evaluate( "Articulos." + This.cFieldCodigo ))  && prxBusArt( Articulos.Grup1, Articulos.Nume1 )

					Endif

					loObj.Descripcion 	= Articulos.Desc1
					loObj.Alias 		= Articulos.Alia1
					loObj.Barras 		= Articulos.Barr1

					If !Empty( Field( "Grup1", "Articulos" ))
						loObj.Grupo	= Articulos.Grup1
					Endif

					If !Empty( Field( "CodArt1", "Articulos" ))
						loObj.CodArt = Articulos.CodArt1
					Endif

					If !Empty( Field( "Id", "Articulos" ))
						loObj.Id = Articulos.Id
					Endif

					If !Empty( Field( "Grup_Id", "Articulos" ))
						loObj.Grup_Id = Articulos.Grup_Id
					Endif

					If This.UsaTalle == "S"
						loObj.Rubro = Articulos.Rubr1
					Endif

				Else
					loObj.Codigo	= This.prxBusCod( loObj.Codigo )
					*loObj.Codigo	= This.prxBusArt( loObj.Grupo, loObj.Numero )

				Endif

				If Used( "ar1Art" )
					lnRecno = Recno( "Articulos" )
					GotoRecno( lnRecno, "ar1Art" )
				Endif

				If lnStatus = ST_VALOR

					If loObj.lTalleColor

						If Empty( loObj.nTalRow )
							loObj.nTalRow = loObj.nCodRow
						Endif

						If Empty( loObj.nColRow )
							loObj.nColRow = loObj.nCodRow
						Endif

						If This.UsaTalle == "S"
							If Empty( loObj.nTalCol )
								loObj.nTalCol = loObj.nCodCol + This.LenArt + 2
							Endif

							loObj.Talle_Id = This.prxPedTal( loObj.Rubro, loObj.nTalRow, loObj.nTalCol, loObj.Talle_Id  )

							*loObj.nColCol = loObj.nTalCol + Len( loObj.Talle_Desc ) + 2
							loObj.nColCol = loObj.nTalCol + 5 + 2

						Else
							If Empty( loObj.nColCol )
								loObj.nColCol = loObj.nCodCol + This.LenArt + 2
							Endif

						Endif

						If This.UsaColor == "S"
							loObj.Color_Id = This.prxPedCol( loObj.Id, loObj.nColRow, loObj.nColCol, loObj.Color_Id  )
						Endif
					Endif

				Endif

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			This.oObj = Null

		Endtry

		Return loObj

	Endproc && prxPedArt


	*
	* Devuelve el objeto que va a contener las propiedades necesarias
	Procedure ObtenerObjeto(  ) As Object;
			HELPSTRING "Devuelve el objeto que va a contener las propiedades necesarias"

		Local loObj As Object

		Try

			loObj = Createobject( "Empty" )
			AddProperty( loObj, "Status", 0 )
			AddProperty( loObj, "Codigo", prxBusArt( "", "" ))
			AddProperty( loObj, "Descripcion", Space( Fsize( "Desc1", "Articulos" ) ))
			AddProperty( loObj, "Alias", Space( Fsize( "Alia1", "Articulos" ) ))
			AddProperty( loObj, "Barras", Space( Fsize( "Barr1", "Articulos" ) ))
			AddProperty( loObj, "Grupo", "")
			AddProperty( loObj, "CodArt", "")
			AddProperty( loObj, "Numero", "")
			AddProperty( loObj, "Id", 0 )
			AddProperty( loObj, "Grup_Id", 0 )
			AddProperty( loObj, "Tag", "ArtPK" )
			AddProperty( loObj, "Linea", "")
			AddProperty( loObj, "Lin_Id", 0 )

			AddProperty( loObj, "GrupoStock", "")
			AddProperty( loObj, "NumeroStock", "")
			AddProperty( loObj, "IdStock", 0 )

			AddProperty( loObj, "Talle_Id", 0 )
			AddProperty( loObj, "Talle_Desc", "" )

			AddProperty( loObj, "Color_Id", 0 )
			AddProperty( loObj, "Color_Desc", "" )

			AddProperty( loObj, "Rubro", 0 )

			AddProperty( loObj, "nABM", 0 )
			AddProperty( loObj, "uCodigo", "" )
			AddProperty( loObj, "nCodRow", 0 )
			AddProperty( loObj, "nCodCol", 0 )
			AddProperty( loObj, "nDesRow", 0 )
			AddProperty( loObj, "nDesCol", 0 )
			AddProperty( loObj, "nAliRow", 0 )
			AddProperty( loObj, "nAliCol", 0 )
			AddProperty( loObj, "nBarRow", 0 )
			AddProperty( loObj, "nBarCol", 0 )


			AddProperty( loObj, "nTalRow", 0 )
			AddProperty( loObj, "nTalCol", 0 )

			AddProperty( loObj, "nColRow", 0 )
			AddProperty( loObj, "nColCol", 0 )

			AddProperty( loObj, "lTalleColor", .F. )

			If This.UsaTalle = "S" Or This.UsaColor = "S"
				loObj.lTalleColor = .T.
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loObj

	Endproc && ObtenerObjeto


	*
	* Indica si es el turno de pedir el código
	Procedure PideCodigo( tnI As Integer, tcOrdenGet As String, tnABM As Integer ) As Boolean;
			HELPSTRING "Indica si es el turno de pedir el código"

		Local llOk As Boolean

		Try

			If tnABM = PROG_ALTA
				llOk = .T.

			Else
				llOk = ( Substr( tcOrdenGet, tnI, 1 ) == "C" )

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && PideCodigo


	*
	* Pide el Código
	Procedure PedirCodigo( tcCodigo As String,;
			tnRow As Integer,;
			tnCol As Integer,;
			tnABM As Integer ) As Integer;
			HELPSTRING "Piede el Código"

		Private puGrup As Variant,;
			puNume As Variant,;
			pnId As Integer

		Private pcOrden As String

		Local lnArtCol As Integer,;
			lnGruCol As Integer,;
			lnStatus As Integer

		Local lcGrupPicture As String,;
			lcNumePicture As String

		Local llValidArt As Boolean

		Local loObj As Object

		Try

			If Vartype( plValidArt ) = "L"
				llValidArt = plValidArt

			Else
				llValidArt = .T.

			Endif

			pcOrden = "CODIGO"

			SayMask( tnRow, tnCol, tcCodigo, "@R " + Alltrim( This.PictArt ), 0 )

			puGrup 	= This.ExtractGrup( tcCodigo )
			puNume 	= This.ExtractNume( tcCodigo )
			pnId 	= 0

			lcNumePicture = Alltrim( This.PictArt )
			lcNumePicture = Strtran( lcNumePicture, "-", "" )
			lcNumePicture = Strtran( lcNumePicture, "/", "" )


			If This.UsaGrupo = "S"
				lnGruCol = tnCol
				lnArtCol = tnCol + This.LenGrupo + 01
				lcGrupPicture = Substr( lcNumePicture, 1, This.LenGrupo )
				lcNumePicture = Substr( lcNumePicture, This.LenGrupo + 1 )

			Else
				lnGruCol = tnCol
				lnArtCol = tnCol
				lcGrupPicture = ""

			Endif

			lnStatus = -1

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR ) And !&Aborta

				lnStatus = This.PedirGrupo( tcCodigo,;
					tnRow,;
					lnGruCol,;
					PROG_MODIFICACION,;
					lcGrupPicture,;
					llValidArt )

				If lnStatus = ST_VALOR

					lnStatus = This.PedirArticulo( tcCodigo,;
						tnRow,;
						lnArtCol,;
						tnABM,;
						lcNumePicture,;
						llValidArt )

				Endif

			Enddo

			On Key Label F1

			If lnStatus = ST_VALOR Or !llValidArt
				loObj			= This.oObj
				loObj.Codigo 	= This.prxBusArt( puGrup, puNume )
				loObj.Id		= pnId

				loObj.Grupo		= This.ExtractGrup( loObj.Codigo, "C" )
				loObj.Numero	= This.ExtractNume( loObj.Codigo, "C" )
				loObj.CodArt	= loObj.Numero

				SayMask( tnRow, tnCol, This.prxArmArt( puGrup, puNume ), "", 0 )

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			On Key Label F1
			loObj = Null

		Endtry

		Return lnStatus

	Endproc && PedirCodigo


	*
	*
	Procedure PedirGrupo( tcCodigo As String,;
			tnRow As Integer,;
			tnCol As Integer,;
			tnABM As Integer,;
			tcPicture As String,;
			tlValidArt As Boolean ) As Integer

		Local lcCommand As String

		Local lnStatus As Integer

		Try

			lcCommand = ""

			If tnABM = PROG_MODIFICACION
				On Key Label F1 Do prxTabGru
			Endif

			Do While !&Aborta
				If This.UsaGrupo = "S"

					lnStatus = -1

					S_Line24( This.cLeyendaGrupo + "          [F1]: Consulta" )
					@ tnRow, tnCol Get puGrup Picture "@K " + tcPicture
					Read

					prxLastkey()

					SayMask( tnRow, tnCol, puGrup, tcPicture, 0 )
					@ tnRow, tnCol + This.LenGrupo Say "-"

					If &Aborta
						lnStatus = ST_ESCAPE
						Exit
					Endif


					If Empty( puGrup )
						If tnABM = PROG_ALTA
							Inform( "El GRUPO es obligatorio" )
							Loop

						Else
							lnStatus = ST_VACIO
							Exit

						Endif
					Endif

					If This.GrupoExiste( puGrup )
						lnStatus = ST_VALOR
						Exit

					Else
						S_Line22( Err3, .T. )
						This.prxTabGru()

					Endif

				Else
					lnStatus = ST_VALOR
					puGrup = Str( 1, This.LenGrupo )
					Exit

				Endif

			Enddo


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lnStatus

	Endproc && PedirGrupo



	*
	*
	Procedure PedirArticulo( tcCodigo As String,;
			tnRow As Integer,;
			tnCol As Integer,;
			tnABM As Integer,;
			tcPicture As String,;
			tlValidArt As Boolean ) As Integer

		Local lcCommand As String
		Local lnStatus As Integer

		Try

			lcCommand = ""


			If tnABM = PROG_MODIFICACION
				On Key Label F1 Do prxLista
			Endif

			Do While !&Aborta

				lnStatus = -1

				S_Line24( This.cLeyendaArticulo + "          [F1]: Consulta" )

				@ tnRow, tnCol Get puNume Picture "@K " + tcPicture
				Read

				prxLastkey()

				If Vartype( puNume ) = "N"
					SayMask( tnRow, tnCol, puNume, "@Z " + tcPicture, 0 )

				Else
					SayMask( tnRow, tnCol, puNume, tcPicture, 0 )

				Endif

				If &Aborta
					lnStatus = ST_ESCAPE
					Exit
				Endif

				If tnABM = PROG_ALTA
					If Empty( puNume )
						Inform( "El ARTICULO es obligatorio" )
						Exit
					Endif

					If !This.ArticuloExiste( puGrup, puNume )
						lnStatus = ST_VALOR
						Exit

					Else
						S_Line22( Err4 )

					Endif

				Else
					If Empty( puNume )
						If !tlValidArt
							If This.UsaGrupo = "S" ;
									And !Empty( puGrup )

								Keyboard '{F1}'
								Loop

							Else
								lnStatus = ST_VACIO
								Exit

							Endif

						Endif

					Endif

					If This.ArticuloExiste( puGrup, puNume )

						lnStatus = ST_VALOR
						Exit

					Else
						If ( This.UsaGrupo = "S" ;
								And !Empty( puGrup ) ) Or !Empty( puNume )

							S_Line22( Err3, .T. )
							prxLista()

						Else
							lnStatus = ST_VACIO
							Exit

						Endif


					Endif

				Endif
			Enddo

			If lnStatus = ST_VACIO And This.UsaGrupo = "S"
				* Volver a pedir el Grupo
				lnStatus = -1
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lnStatus

	Endproc && PedirArticulo

	*
	* Valida el grupo ingresado
	Procedure GrupoExiste( tuGrup As Variant ) As Boolean;
			HELPSTRING "Valida el grupo ingresado"

		Local llFound As Boolean,;
			llValidArt As Boolean

		Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loConsumirApi As ConsumirAPI Of "Tools\JSON\Prg\XmlHttp.prg",;
			loReg As Object,;
			loRespuesta As Object

		Try

			If Vartype( plValidArt ) = "L"
				llValidArt = plValidArt

			Else
				llValidArt = .T.

			Endif

			If llValidArt
				Select Rubros
				Set Order To Tag Codi2 In Rubros
				llFound = Seek( This.prxBusGru( tuGrup ), "Rubros", "Codi2" )

				loReg = Createobject( "Empty" )
				AddProperty( loReg, "Codi2", tuGrup )

				llFound = Seek( This.prxBusGru( tuGrup ), "Rubros", "Codi2" )

				If llFound
					loObj = This.oObj

					If !Empty( Field( "Id", "Rubros" ))
						loObj.Grup_Id 	= Rubros.Id
					Endif
				Endif

				If Used( This.cTablaGrupo )
					lnRecno = Recno( "Rubros" )

					Try
						GotoRecno( lnRecno, This.cTablaGrupo )

					Catch To oErr
						Go Bottom In ( This.cTablaGrupo )

					Finally

					Endtry

				Endif

			Else
				llFound = .T.

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loObj 				= Null
			loGlobalSettings 	= Null
			loConsumirApi 		= Null
			loReg 				= Null
			loRespuesta 		= Null

		Endtry

		Return llFound

	Endproc && GrupoExiste

	*
	* Valida el articulo ingresado
	Procedure ArticuloExiste( tuGrup As Variant, tuNume As Variant ) As Boolean;
			HELPSTRING "Valida el Articulo ingresado"

		Local llFound As Boolean,;
			llValidArt As Boolean

		Local lnRecno As Integer

		Try

			If Vartype( plValidArt ) = "L"
				llValidArt = plValidArt

			Else
				llValidArt = .T.

			Endif

			llFound = .F.

			If llValidArt

				Select Articulos
				Set Filter To
				llFound = Seek( This.prxBusArt( tuGrup, tuNume ), "Articulos", "ArtPK" )

				loReg = Createobject( "Empty" )
				AddProperty( loReg, "Grup1", tuGrup )
				AddProperty( loReg, "Nume1", tuNume )

				If This.lFiltrarNoActivos
					Select Articulos
					Set Filter To Acti1 = "S"
				Endif

				Set Order To Tag ArtPK In Articulos
				llFound = Seek( This.prxBusArt( tuGrup, tuNume ), "Articulos", "ArtPK" )

				If llFound
					loObj = This.oObj

					If !Empty( Field( "Id", "Articulos" ))
						loObj.Id = Articulos.Id
					Endif

					If !Empty( Field( "Grup_Id", "Articulos" ))
						loObj.Grup_Id 	= Articulos.Grup_Id
					Endif

					If Used( "ar1Art" )
						lnRecno = Recno( "Articulos" )

						Try
							Goto lnRecno In "ar1Art"

						Catch To oErr
							Go Bottom In "ar1Art"

						Finally

						Endtry

					Endif
				Endif

			Else
				llFound = .T.

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loObj 				= Null

		Endtry

		Return llFound

	Endproc && ArticuloExiste


	*
	* Indica si es el turno de pedir la Descripcion
	Procedure PideDescripcion( tnI As Integer, tcOrdenGet As String ) As Boolean;
			HELPSTRING "Indica si es el turno de pedir la Descripcion"

		Local llOk As Boolean

		Try

			llOk = ( Substr( tcOrdenGet, tnI, 1 ) == "D" )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && PideDescripcion


	*
	* Pide la Descripcion
	Procedure PedirDescripcion( tcDescripcion As String, tnRow As Integer, tnCol As Integer ) As Integer;
			HELPSTRING "Piede la Descripcion"

		Private pcDesc As String
		Private pcOrden As String

		Local lnStatus As Integer,;
			lnLen As Integer
		Local lcPicture As String

		Local loObj As Object

		Try

			pcOrden = "DESCRIPCION"

			pcDesc = tcDescripcion
			lnLen = Fsize( "Desc1", "Articulos" )

			If lnLen > 30
				lcPicture = "@!S30"
				lnLen = 30

			Else
				lcPicture = Replicate( '!', lnLen )

			Endif

			lnStatus = -1

			If Pemstatus( _Screen, "oObj_Aux", 5 )
				_Screen.oObj_Aux = Null

			Else
				AddProperty( _Screen, "oObj_Aux", Null )

			Endif

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR )

				On Key Label F1 Do prxLista With KEY_F1
				On Key Label F6 Do prxLista With KEY_F6

				_Screen.oObj_Aux = Null

				Do While !&Aborta
					If This.AdvSearch = "S"
						S_Line24( "Ingrese la descripción    [F1]:Consulta     [F6]:Búsqueda Avanzada" )

					Else
						S_Line24( "Ingrese la descripción          [F1]: Consulta" )

					Endif

					@ tnRow, tnCol Get pcDesc Picture lcPicture
					Read

					prxLastkey()

					SayMask( tnRow, tnCol, pcDesc, lcPicture, lnLen )

					If &Aborta
						lnStatus = ST_ESCAPE
						Exit
					Endif

					If Empty( pcDesc )
						lnStatus = ST_VACIO
						Exit
					Endif

					If Vartype( _Screen.oObj_Aux ) = "X"
						If This.DescripcionExiste( pcDesc )
							lnStatus = ST_VALOR
							loObj	= This.oObj

							loObj.Descripcion = pcDesc

							Exit

						Else
							S_Line22( Err3, .T. )
							This.prxLista( KEY_F6 )

							If !&Aborta
								lnStatus = ST_VALOR
								loObj	= This.oObj

								loObj.Descripcion = pcDesc

							Else
								lnStatus = ST_VACIO

							Endif

							Inkey()
							Exit

						Endif

					Else
						* RA 21/10/2018(10:12:01)
						* Da la posibilidad de inicializar loObj en prxLista()

						lnStatus = ST_VALOR
						This.oObj 	= _Screen.oObj_Aux
						loObj		= This.oObj

						loObj.Descripcion = pcDesc

						Exit

					Endif

				Enddo

			Enddo

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			On Key Label F1
			loObj = Null
			If Pemstatus( _Screen, "oObj_Aux", 5 )
				Removeproperty(_Screen, "oObj_Aux" )

			Endif


		Endtry

		Return lnStatus

	Endproc && PedirDescripcion

	*
	* Valida la Descripcion ingresada
	Procedure DescripcionExiste( tuDesc As String ) As Boolean;
			HELPSTRING "Valida la Descripcion ingresada"

		Local llFound As Boolean,;
			llValidArt As Boolean

		Try

			If Vartype( plValidArt ) = "L"
				llValidArt = plValidArt

			Else
				llValidArt = .T.

			Endif

			If llValidArt
				Set Order To Tag Desc1 In Articulos
				Set Near On
				llFound = Seek( Alltrim( Upper( tuDesc )), "Articulos", "Desc1" )
				Set Near Off

				If llFound And ( Len( Alltrim( tuDesc )) < 10 )
					llFound = .F.
				Endif

			Else
				llFound = .T.

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llFound

	Endproc && DescripcionExiste


	*
	* Indica si es el turno de pedir el Alias
	Procedure PideAlias( tnI As Integer, tcOrdenGet As String ) As Boolean;
			HELPSTRING "Indica si es el turno de pedir el Alias"

		Local llOk As Boolean

		Try

			llOk = ( Substr( tcOrdenGet, tnI, 1 ) == "A" )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && PideAlias

	*
	* Pide el Alias
	Procedure PedirAlias( tcAlias As String, tnRow As Integer, tnCol As Integer ) As Integer;
			HELPSTRING "Piede el Alias"

		Private pcAlias As String
		Private pcOrden As String

		Local lnStatus As Integer
		Local lcPicture As String

		Local loObj As Object

		Try

			pcOrden = "ALIAS"

			pcAlias = tcAlias
			lcPicture = Replicate( 'X', Fsize( "Alia1", "Articulos" ))

			lnStatus = -1

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR )

				lnStatus = -1

				Select Articulos
				Set Order To Tag Alia1 In Articulos

				On Key Label F1 Do prxLista

				S_Line24( "Ingrese la Alias          [F1]: Consulta" )

				@ tnRow, tnCol Get pcAlias Picture lcPicture
				Read

				SayMask( tnRow, tnCol, pcAlias, "", 0 )

				Do Case
					Case &Aborta
						lnStatus = ST_ESCAPE

					Case Empty( pcAlias )
						lnStatus = ST_VACIO

					Otherwise
						If Seek( pcAlias, "Articulos", "Alia1" )
							lnStatus = ST_VALOR

						Else
							loObj = prxLista()
							lnStatus = loObj.Status

						Endif

				Endcase

			Enddo

			loObj	= This.oObj
			loObj.Alias = pcAlias


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			On Key Label F1
			loObj = Null

		Endtry

		Return lnStatus

	Endproc && PedirAlias

	*
	* Pide el Alias
	Procedure xxxPedirAlias( tcAlias As String, tnRow As Integer, tnCol As Integer ) As Integer;
			HELPSTRING "Piede el Alias"

		Private pcAlias As String
		Private pcOrden As String

		Local lnStatus As Integer
		Local lcPicture As String

		Local loObj As Object

		Try

			pcOrden = "ALIAS"

			pcAlias = tcAlias
			lcPicture = Replicate( 'X', Fsize( "Alia1", "Articulos" ))

			lnStatus = -1

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR )

				Select Articulos
				Set Order To Tag Alia1 In Articulos

				On Key Label F1 Do prxLista

				S_Line24( "Ingrese la Alias          [F1]: Consulta" )

				lnStatus = I_Askey( 'pcAlias',;
					lcPicture,;
					pcAlias,;
					2,;
					2,;
					tnRow,;
					tnCol,;
					1 )

			Enddo

			loObj	= This.oObj
			loObj.Alias = pcAlias


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			On Key Label F1
			loObj = Null

		Endtry

		Return lnStatus

	Endproc && xxxPedirAlias


	*
	* Indica si es el turno de pedir el Codigo de Barras
	Procedure PideBarras( tnI As Integer, tcOrdenGet As String ) As Boolean;
			HELPSTRING "Indica si es el turno de pedir el Codigo de Barras"

		Local llOk As Boolean

		Try

			llOk = ( Substr( tcOrdenGet, tnI, 1 ) == "B" )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && PideBarras

	*
	* Pide el Codigo de Barras
	Procedure PedirBarras( tcBarras As String, tnRow As Integer, tnCol As Integer ) As Integer;
			HELPSTRING "Piede el Codigo de Barras"

		Private pcBarras As String
		Private pcOrden As String

		Local lnStatus As Integer
		Local lcPicture As String

		Local loObj As Object

		Try

			pcOrden = "BARRAS"

			pcBarras = tcBarras
			lcPicture = Replicate( '!', Fsize( "Barr1", "Articulos" ))

			lnStatus = -1

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR )

				On Key Label F1 Do prxLista

				Do While !&Aborta
					S_Line24( "Ingrese Código de Barras          [F1]: Consulta" )
					@ tnRow, tnCol Get pcBarras Picture "@K " + lcPicture
					Read


					pcBarras=Strtran(pcBarras,Chr(39),"-")  && para america
					prxLastkey()

					SayMask( tnRow, tnCol, pcBarras, lcPicture, 0 )

					If &Aborta
						lnStatus = ST_ESCAPE
						Exit
					Endif

					If Empty( pcBarras )
						lnStatus = ST_VACIO
						Exit

					Endif

					If This.BarrasExiste( pcBarras )
						lnStatus = ST_VALOR
						loObj	= This.oObj

						loObj.Barras 	= pcBarras

						Exit

					Else
						S_Line22( Err3, .T. )
						This.prxLista()

					Endif
				Enddo

			Enddo

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			On Key Label F1
			loObj = Null

		Endtry

		Return lnStatus

	Endproc && PedirBarras


	*
	* Valida la Barras ingresada
	Procedure BarrasExiste( tuBarr As String ) As Boolean;
			HELPSTRING "Valida el Codigo de Barras ingresado"

		Local llFound As Boolean,;
			llValidArt As Boolean

		Try

			If Vartype( plValidArt ) = "L"
				llValidArt = plValidArt

			Else
				llValidArt = .T.

			Endif

			If llValidArt
				Set Order To Tag Barr1 In Articulos
				llFound = Seek( Alltrim( Upper( tuBarr )), "Articulos", "Barr1" )

			Else
				llFound = .T.

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llFound

	Endproc && BarrasExiste


	* Recibe un String y devuelve un string formateado para mostrar
	Procedure prxMosArt( tcCodigo As String ) As String;
			HELPSTRING "Recibe un String y devuelve un string formateado para mostrar"

		Return This.prxArmArt( This.ExtractGrup( tcCodigo, "C" ), This.ExtractNume( tcCodigo, "C" ) )

	Endproc && prxMosArt

	*
	* Armado del CODIGO para imprimir, con guiones, en funcion de sus partes
	Procedure prxArmArt( tuGrup As Variant,;
			tuNume As Variant) As String;
			HELPSTRING "Armado del CODIGO en funcion de sus partes"

		Local lcArticulo As String


		Try
			If ( This.UsaGrupo == "S" )
				lcArticulo = Transform( This.prxBusArt( tuGrup, tuNume ), "@R " + Alltrim( This.PictArt ))

			Else
				lcArticulo = Transform( tuNume , "@R " + + Alltrim( This.PictArt ))

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcArticulo


	Endproc && prxArmArt


	*
	* Armado del GRUPO en funcion de sus partes
	Procedure prxBusGru( tuGrup As Variant,;
			lWeb As Boolean ) As String;
			HELPSTRING "Armado del GRUPO en funcion de sus partes"

		Local lcGrup As String

		Try


			If lWeb And This.GrupoAlfa == "N"
				lcGrup = StrZero( Val( Transform( tuGrup )), This.LenGrupo )

			Else
				*If Vartype( tuGrup ) == "N"
				If This.GrupoAlfa == "N"
					lcGrup = Str( Val( Transform( tuGrup )), This.LenGrupo )

				Else
					lcGrup = Padr( tuGrup, This.LenGrupo, " " )

				Endif
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return Upper( lcGrup )

	Endproc && prxBusGru


	*
	* Armado del GRUPO para imprimir
	Procedure prxArmGru( tuGrup As Variant ) As String;
			HELPSTRING "Armado del GRUPO para imprimir"

		Local lcGrup As String

		Try

			lcGrup = Transform( This.prxBusGru( tuGrup ), "@R " +  Substr( Alltrim( This.PictArt ), 1, This.LenGrupo ))

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return Upper( lcGrup )

	Endproc && prxArmGru


	*
	* Selector de Artículos
	Procedure prxLista( tnAction As Integer ) As Object ;
			HELPSTRING "Selector de Artículos"

		Local lnLen As Integer
		Local llUsaGrupo As Boolean,;
			llUsaAlias As Boolean,;
			llUsaBarras As Boolean,;
			llAdvanceSearch As Boolean

		Local loObj As Object
		Local lcAlias As String,;
			lcFiltro As String

		Try


			If Empty( tnAction )
				llAdvanceSearch = .F.

			Else
				Do Case
					Case tnAction = KEY_F1
						llAdvanceSearch = .F.

					Case tnAction = KEY_F6	And ( This.AdvSearch = "S" )
						llAdvanceSearch = .T.

					Otherwise
						llAdvanceSearch = .F.

				Endcase
			Endif

			llUsaGrupo 	= This.UsaGrupo = "S"
			llUsaAlias 	= This.UsaAlias = "S"
			llUsaBarras	= This.UsaBarras = "S"

			loObj = This.ObtenerObjeto()

			*Dimension Campo[ 1 ], Mascara[ 1 ], Nombre[ 1 ]
			Dimension aCampo[ 1 ], aMascara[ 1 ], aNombre[ 1 ]
			aCampo[ 1 ] = ""
			aMascara[ 1 ] = ""
			aNombre[ 1 ] = ""

			*This.ArmarCampos( @Campo, @Mascara, @Nombre, llAdvanceSearch )
			This.ArmarCampos( llAdvanceSearch )

			lcAlias = Alias()

			*dbEdit( 0, 0, 0, 0, @Campo, '', @Mascara, @Nombre )
			dbEdit( 0, 0, 0, 0, @aCampo, '', @aMascara, @aNombre )

			If &Aborta
				prxSetLastKey( 0 )

			Else

				Select Alias( lcAlias )

				puGrup 	= Evaluate( "Articulos." + This.cFieldGrupo )
				puNume 	= Evaluate( "Articulos." + This.cFieldCodigo )
				pcDesc 	= Desc1

				If llUsaAlias
					pcAlias = Alia1
				Endif

				If llUsaBarras
					pcBarras = Barr1
				Endif

				If Type( "ID" ) # "U"
					pnId = Id
				Endif

				Keyboard '{ENTER}'

				loObj.Status = ST_VALOR


				If llUsaGrupo
					loObj.Codigo = This.prxBusArt( puGrup, puNume )
				Else
					loObj.Codigo = This.prxArmArt( puGrup, puNume )
				Endif

				loObj.Descripcion 	= Desc1

				If llUsaAlias
					loObj.Alias = Alia1
				Endif

				If llUsaBarras
					loObj.Barras = Barr1
				Endif

				loObj.Id = Id

				If loObj.Id # Articulos.Id

					* RA 15/06/2017(15:36:41)

					If Seek( loObj.Id, "Articulos", "Id" )
						If Used( "ar1Art" )
							If !Seek( loObj.Id, "ar1Art", "Id" )
								Go Bottom In "ar1Art"
							Endif
						Endif

					Else

						* RA 16/06/2017(16:49:58)
						* Cuando la condicion del TAG "Id"
						* Incluia el "And (!Borrado)"
						* podria darse el caso que un articulo activo
						* quedara marcado con Borrado=.T. y
						* fallara en el Seek anterior
						* (Debe sacarse el "And (!Borrado)" en todos los
						* Tag "Id" de cualquier tabla

						Select Articulos
						Locate For Id = loObj.Id

						If !Found()

							Go Bottom In "Articulos"

							Warning( "No se pudo encontrar el Articulo seleccionado" )

						Endif

					Endif

				Endif

			Endif

			This.oObj = loObj

			If Pemstatus( _Screen, "oObj_Aux", 5 )
				_Screen.oObj_Aux = loObj
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			Use In Select( "cQuery" )

		Endtry

		Return loObj

	Endproc && prxLista


	*
	*
	*Procedure ArmarCampos( aCampo, aMascara, aNombre, lAdvanceSearch ) As Void
	Procedure ArmarCampos( lAdvanceSearch ) As Void
		Local lcCommand As String,;
			lcLista As String,;
			lcFilter As String

		Local lnLen As Integer
		Local llUsaGrupo As Boolean,;
			llUsaAlias As Boolean,;
			llUsaBarras As Boolean,;
			llAdvanceSearch As Boolean

		Local loObj As Object,;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loConsumirApi As ConsumirAPI Of "Tools\JSON\Prg\XmlHttp.prg"
		Local lcAlias As String

		Try

			lcCommand = ""

			llUsaGrupo 	= This.UsaGrupo = "S"
			llUsaAlias 	= This.UsaAlias = "S"
			llUsaBarras	= This.UsaBarras = "S"


			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
			Endif

			If Vartype( pcOrden ) <> "C"
				pcOrden = ""
			Endif

			If pcOrden = "DESCRIPCION" And lAdvanceSearch
				If This.ASGrupo = "S"
					lnLen = lnLen + 1
					If This.ASLinea = "S"
						lnLen = lnLen + 1
					Endif
				Endif
			Endif

			Dimension aCampo[ lnLen ],;
				aMascara[ lnLen ],;
				aNombre[ lnLen ]


			If This.UsaGrupo = "S"
				aCampo[1] = This.cFieldGrupo + "+" + This.cFieldCodigo

			Else
				aCampo[1] = This.cFieldCodigo

			Endif

			aCampo[2] = 'DESC1'

			Do Case
				Case !Empty( Field( "Prec01", "Articulos" ))
					aCampo[3] = 'PREC01'

				Case !Empty( Field( "Prec1", "Articulos" ))
					aCampo[3] = 'PREC1'

				Otherwise
					Error "No existe el aCampo Precios en Articulos"

			Endcase

			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
				aCampo[ lnLen ] = 'ALIA1'
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
				aCampo[ lnLen ] = 'BARR1'
			Endif

			aMascara[1] = "@R " + Alltrim( This.PictArt )
			aMascara[2] = Replicate( 'X', Fsize( "Desc1", "Articulos" ))
			aMascara[3] = WPICP

			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
				aMascara[ lnLen ] = Replicate( 'X', Fsize( "Alia1", "Articulos" ))
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
				aMascara[ lnLen ] = Replicate( 'X', Fsize( "Barr1", "Articulos" ))
			Endif


			aNombre[1] = 'C O D I G O'
			aNombre[2] = 'D E S C R I P C I O N'
			aNombre[3] = 'PRECIO'

			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
				aNombre[ lnLen ] = 'A L I A S'
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
				aNombre[ lnLen ] = 'C. de Barras'
			Endif

			If Vartype( pcOrden ) # "C"
				pcOrden = "CODIGO"
			Endif

			If !Inlist( pcOrden, "CODIGO", "DESCRIPCION", "ALIAS", "BARRAS" )
				pcOrden = "CODIGO"
			Endif

			If pcOrden = "DESCRIPCION" And lAdvanceSearch
				This.AdvanceSearch( pcDesc )
				lcAlias = Alias()

				If This.ASGrupo = "S"
					lnLen = lnLen + 1
					aCampo[ lnLen ] 	= "Rubro"
					aNombre[ lnLen ] = "Rubro"
					aMascara[ lnLen ] = Replicate( 'X', Fsize( This.cFieldGrupo, lcAlias ))

					If This.ASLinea = "S"
						lnLen = lnLen + 1
						aCampo[ lnLen ] = 'Linea'
						aNombre[ lnLen ] = 'Linea'
						aMascara[ lnLen ] = Replicate( 'X', Fsize( "Linea", lcAlias ))
					Endif
				Endif

			Else

				* Integración Web
				loGlobalSettings = NewGlobalSettings()

				If This.lIntegracionWeb And loGlobalSettings.lIntegracionWeb


					loConsumirApi 	= NewConsumirApi()


					TEXT To lcFilter NoShow TextMerge Pretext 15
					grupo=StrZero( Val( Transform( puGrup )), 3 ))
					ENDTEXT

					loRespuesta = loConsumirApi.Articulos( "LIST", lcFilter )

					If loRespuesta.lOk
						TEXT To lcCommand NoShow TextMerge Pretext 15
						Select	Grup1,
								Nume1,
								Desc1
							From Articulos
							Where .F.
							Into Cursor cArticulos ReadWrite
						ENDTEXT

						&lcCommand
						lcCommand = ""

						loColArticulos = loRespuesta.Data

						Select cArticulos

						For Each loArticulo In loColArticulos

							AddProperty( loArticulo, "Grup1", Str( Val( loArticulo.Grupo ), 3 ))
							AddProperty( loArticulo, "Nume1", Str( Val( loArticulo.Articulo ), 10 ))
							AddProperty( loArticulo, "Desc1", loArticulo.Descripcion )

							Append Blank
							Gather Name loArticulo

						Endfor

						Do Case
							Case pcOrden = "CODIGO"
								Locate For Val( Codi2 ) >= puGrup

								If Eof()
									Locate
								Endif

							Case pcOrden = "DESCRIPCION"

								TEXT To lcCommand NoShow TextMerge Pretext 15
								Select *
									From cRubros
									Order By Desc2
									Into Cursor cRubros ReadWrite
								ENDTEXT

								&lcCommand
								lcCommand = ""

								Locate For Desc2 >= pcDesc

								If Eof()
									Locate
								Endif

						Endcase

					Else

					Endif

				Else

					Sele Articulos
					Set Near On

					lcAlias = Alias()

					If Vartype( puGrup ) <> "C"
						*puGrup = ""

						If This.GrupoAlfa = "S"
							puGrup = ""

						Else
							If This.GrupoCeros = "S"
								puGrup = StrZero( puGrup, This.LenGrupo )

							Else
								If Vartype(puGrup) = "U"

									puGrup = 0

								Endif
								puGrup = Str( puGrup, This.LenGrupo )

							Endif

						Endif

					Endif

					If Vartype( puNume ) <> "C"
						*puNume = ""
						If This.ArtAlfa = "S"
							puNume = ""

						Else
							If This.ArtCeros = "S"
								If Vartype(puNume) = "U"

									puNume = 0

								Endif
								puNume = StrZero( puNume, This.LenArt )

							Else
								puNume = Str( puNume, This.LenArt )

							Endif

						Endif

					Endif

					If Vartype( pcDesc ) <> "C"
						pcDesc = ""
					Endif

					Do Case
						Case pcOrden = "CODIGO"
							Set Order To Tag ArtPK In Articulos
							=Seek( This.prxBusArt( puGrup, puNume ), "Articulos",  "ArtPK" )

						Case pcOrden = "DESCRIPCION"
							Set Order To Tag Desc1 In Articulos
							=Seek( C_ALFKEY( pcDesc ), "Articulos", "Desc1" )

						Case pcOrden = "ALIAS"
							Set Order To Tag Alia1 In Articulos
							=Seek( C_ALFKEY( pcAlias ), "Articulos", "Alia1" )

						Case pcOrden = "BARRAS"
							Set Order To Tag Barr1 In Articulos
							=Seek( C_ALFKEY( pcBarras ), "Articulos", "Barr1" )

					Endcase

					Set Near Off

					If Eof()
						Go Bottom
					Endif
				Endif

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && ArmarCampos



	*
	* Selector de Artículos
	Procedure xxxprxLista( tnAction As Integer ) As Object ;
			HELPSTRING "Selector de Artículos"

		Local lnLen As Integer
		Local llUsaGrupo As Boolean,;
			llUsaAlias As Boolean,;
			llUsaBarras As Boolean,;
			llAdvanceSearch As Boolean

		Local loObj As Object
		Local lcAlias As String

		Try

			If Empty( tnAction )
				llAdvanceSearch = .F.

			Else
				Do Case
					Case tnAction = KEY_F1
						llAdvanceSearch = .F.

					Case tnAction = KEY_F6	And ( This.AdvSearch = "S" )
						llAdvanceSearch = .T.

					Otherwise
						llAdvanceSearch = .F.

				Endcase
			Endif

			llUsaGrupo 	= This.UsaGrupo = "S"
			llUsaAlias 	= This.UsaAlias = "S"
			llUsaBarras	= This.UsaBarras = "S"

			loObj = This.ObtenerObjeto()

			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
			Endif

			If pcOrden = "DESCRIPCION" And llAdvanceSearch
				If This.ASGrupo = "S"
					lnLen = lnLen + 1
					If This.ASLinea = "S"
						lnLen = lnLen + 1
					Endif
				Endif
			Endif

			Dimension Campo[ lnLen ],;
				Mascara[ lnLen ],;
				Nombre[ lnLen ]


			*Campo[1] = 'prxArmArt( GRUP1, NUME1 )'

			If This.UsaGrupo = "S"
				Campo[1] = This.cFieldGrupo + "+" + This.cFieldCodigo

			Else
				Campo[1] = This.cFieldCodigo

			Endif

			Campo[2] = 'DESC1'
			*Campo[3] = 'ar_Moneda( PREC1, MONE1, 1 )'

			Do Case
				Case !Empty( Field( "Prec01", "Articulos" ))
					Campo[3] = 'PREC01'

				Case !Empty( Field( "Prec1", "Articulos" ))
					Campo[3] = 'PREC1'

				Otherwise
					Error "No existe el campo Precios en Articulos"

			Endcase

			*!*				Try

			*!*					Evaluate( "ar1art.prec01" )
			*!*					Campo[3] = 'PREC01'

			*!*				Catch To oErr
			*!*					Campo[3] = 'PREC1'

			*!*				Finally


			*!*				Endtry

			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
				Campo[ lnLen ] = 'ALIA1'
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
				Campo[ lnLen ] = 'BARR1'
			Endif

			Mascara[1] = "@R " + Alltrim( This.PictArt )
			Mascara[2] = Replicate( 'X', Fsize( "Desc1", "Articulos" ))
			Mascara[3] = WPICP

			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
				Mascara[ lnLen ] = Replicate( 'X', Fsize( "Alia1", "Articulos" ))
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
				Mascara[ lnLen ] = Replicate( 'X', Fsize( "Barr1", "Articulos" ))
			Endif


			Nombre[1] = 'C O D I G O'
			Nombre[2] = 'D E S C R I P C I O N'
			Nombre[3] = 'PRECIO'

			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
				Nombre[ lnLen ] = 'A L I A S'
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
				Nombre[ lnLen ] = 'C. de Barras'
			Endif

			If Vartype( pcOrden ) # "C"
				pcOrden = "CODIGO"
			Endif

			If !Inlist( pcOrden, "CODIGO", "DESCRIPCION", "ALIAS", "BARRAS" )
				pcOrden = "CODIGO"
			Endif

			If pcOrden = "DESCRIPCION" And llAdvanceSearch
				This.AdvanceSearch( pcDesc )
				lcAlias = Alias()

				If This.ASGrupo = "S"
					lnLen = lnLen + 1
					Campo[ lnLen ] 	= "Rubro"
					Nombre[ lnLen ] = "Rubro"
					Mascara[ lnLen ] = Replicate( 'X', Fsize( This.cFieldGrupo, lcAlias ))

					If This.ASLinea = "S"
						lnLen = lnLen + 1
						Campo[ lnLen ] = 'Linea'
						Nombre[ lnLen ] = 'Linea'
						Mascara[ lnLen ] = Replicate( 'X', Fsize( "Linea", lcAlias ))
					Endif
				Endif

			Else
				Sele Articulos
				Set Near On

				lcAlias = Alias()

				Do Case
					Case pcOrden = "CODIGO"
						Set Order To Tag ArtPK In Articulos
						=Seek( This.prxBusArt( puGrup, puNume ), "Articulos",  "ArtPK" )

					Case pcOrden = "DESCRIPCION"
						Set Order To Tag Desc1 In Articulos
						=Seek( C_ALFKEY( pcDesc ), "Articulos", "Desc1" )

					Case pcOrden = "ALIAS"
						Set Order To Tag Alia1 In Articulos
						=Seek( C_ALFKEY( pcAlias ), "Articulos", "Alia1" )

					Case pcOrden = "BARRAS"
						Set Order To Tag Barr1 In Articulos
						=Seek( C_ALFKEY( pcBarras ), "Articulos", "Barr1" )

				Endcase

				Set Near Off

				If Eof()
					Go Bottom
				Endif

			Endif

			dbEdit( 0, 0, 0, 0, @Campo, '', @Mascara, @Nombre )

			If &Aborta
				prxSetLastKey( 0 )

			Else

				Select Alias( lcAlias )

				puGrup 	= Evaluate( "Articulos." + This.cFieldGrupo )
				puNume 	= Evaluate( "Articulos." + This.cFieldCodigo )
				pcDesc 	= Desc1

				If llUsaAlias
					pcAlias = Alia1
				Endif

				If llUsaBarras
					pcBarras = Barr1
				Endif

				If Type( "ID" ) # "U"
					pnId = Id
				Endif

				Keyboard '{ENTER}'

				loObj.Status = ST_VALOR


				If llUsaGrupo
					loObj.Codigo = This.prxBusArt( puGrup, puNume )
				Else
					loObj.Codigo = This.prxArmArt( puGrup, puNume )
				Endif

				loObj.Descripcion 	= Desc1

				If llUsaAlias
					loObj.Alias = Alia1
				Endif

				If llUsaBarras
					loObj.Barras = Barr1
				Endif

				loObj.Id = Id

				If loObj.Id # Articulos.Id

					* RA 15/06/2017(15:36:41)

					If Seek( loObj.Id, "Articulos", "Id" )
						If Used( "ar1Art" )
							If !Seek( loObj.Id, "ar1Art", "Id" )
								Go Bottom In "ar1Art"
							Endif
						Endif

					Else

						* RA 16/06/2017(16:49:58)
						* Cuando la condicion del TAG "Id"
						* Incluia el "And (!Borrado)"
						* podria darse el caso que un articulo activo
						* quedara marcado con Borrado=.T. y
						* fallara en el Seek anterior
						* (Debe sacarse el "And (!Borrado)" en todos los
						* Tag "Id" de cualquier tabla

						Select Articulos
						Locate For Id = loObj.Id

						If !Found()

							Go Bottom In "Articulos"

							Warning( "No se pudo encontrar el Articulo seleccionado" )

						Endif

					Endif

				Endif

			Endif

			This.oObj = loObj

			If Pemstatus( _Screen, "oObj_Aux", 5 )
				_Screen.oObj_Aux = loObj
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			Use In Select( "cQuery" )

		Endtry

		Return loObj

	Endproc && xxxprxLista

	*
	* Búsqueda inteligente filtrando la descripcion
	Procedure AdvanceSearch( cExpressionSearched As String ) As Void;
			HELPSTRING "Búsqueda inteligente filtrando la descripcion"
		Local lcCommand As String,;
			lcExpressionSearched As String,;
			lcRubro As String,;
			lcLinea As String,;
			lcBarra As String,;
			lcAlias As String,;
			lcId As String,;
			lcJoinRubros As String,;
			lcJoinLineas As String,;
			lcPrecio As String,;
			lcWhere As String,;
			lcActivo As String

		Local loDt As PrxDataTier Of "FW\TierAdapter\Comun\prxDataTier.prg"

		Local llUsaAlias As Boolean,;
			llUsaBarras As Boolean,;
			llUsaId As Boolean

		Local lnLen As Integer

		Try

			lcCommand = ""
			lcExpressionSearched = Lower( Getwordnum( cExpressionSearched, 1 ))

			llUsaAlias 	= !Empty( Field( "Alia1", "Articulos" ))
			llUsaBarras = !Empty( Field( "Barr1", "Articulos" ))
			llUsaId 	= !Empty( Field( "Id", "Articulos" ))

			Do Case
				Case !Empty( Field( "Prec01", "Articulos" ))
					lcPrecio = "Prec01"

				Otherwise
					lcPrecio = "Prec1"

			Endcase

			lcJoinRubros = ""
			lcJoinLineas = ""

			If This.ASGrupo = "S"
				TEXT To lcJoinRubros NoShow TextMerge Pretext 15
				Left Outer Join Rubros r
					On r.Id = a.Grup_Id
						And Lower( r.Desc2 ) Like '%<<lcExpressionSearched>>%'
				ENDTEXT

				TEXT To lcRubro NoShow TextMerge Pretext 15
				r.Desc2 as Rubro,
				a.Grup_Id
				ENDTEXT

			Else

				TEXT To lcRubro NoShow TextMerge Pretext 15
				" " as Rubro,
				0 as Grup_Id
				ENDTEXT

			Endif

			If llUsaId
				TEXT To lcId NoShow TextMerge Pretext 15
					a.Id
				ENDTEXT

			Else
				TEXT To lcId NoShow TextMerge Pretext 15
					Cast( 0 as I ) as Id
				ENDTEXT

			Endif

			If llUsaAlias
				TEXT To lcAlias NoShow TextMerge Pretext 15
					a.Alia1
				ENDTEXT

			Else
				TEXT To lcAlias NoShow TextMerge Pretext 15
					"" as Alia1
				ENDTEXT

			Endif

			If llUsaBarras
				TEXT To lcBarra NoShow TextMerge Pretext 15
					a.Barr1
				ENDTEXT

			Else
				TEXT To lcBarra NoShow TextMerge Pretext 15
					"" as Barr1
				ENDTEXT

			Endif

			lcWhere = ""

			If Empty( Field( "Acti1", "Articulos" ))
				TEXT To lcActivo NoShow TextMerge Pretext 15
				"S" as Acti1
				ENDTEXT

			Else
				TEXT To lcActivo NoShow TextMerge Pretext 15
				a.Acti1
				ENDTEXT

			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select
					q2.<<This.cFieldGrupo>>,
					q2.<<This.cFieldCodigo>>,
					q2.Desc1,
					q2.<<lcPrecio>>,
					q2.Id,
					q2.Grup_Id,
					q2.Alia1,
					q2.Barr1,
					r.Desc2 as Rubro
				From (
					Select
							q.<<This.cFieldGrupo>>,
							q.<<This.cFieldCodigo>>,
							q.Desc1,
							q.<<lcPrecio>>,
							q.Id,
							q.Grup_Id,
							q.Alia1,
							q.Barr1,
							q.Rubro
						From (
								Select
										a.<<This.cFieldGrupo>>,
										a.<<This.cFieldCodigo>>,
										a.Desc1,
										<<lcActivo>>,
										a.<<lcPrecio>>,
										<<lcId>>,
										<<lcAlias>>,
										<<lcBarra>>,
										<<lcRubro>>
									From Articulos a
									<<lcJoinRubros>> ) q
						Where !Deleted()
							And ( q.Acti1 = "S" )
							And Lower( q.Desc1 ) Like '%<<lcExpressionSearched>>%'
							Or !Empty( q.Grup_Id )
						Order By q.Desc1 ) q2
				Left Outer Join Rubros r
					On r.Id = q2.Grup_Id
			ENDTEXT

			loDt = NewDT()
			loDt.SQLExecute( lcCommand, "cQuery1" )

			* Busca cuantas palabras hay
			lnLen = Getwordcount( cExpressionSearched )

			If lnLen > 1

				Dimension laWords[ lnLen ]

				For i = 1 To lnLen
					laWords[ i ] = Alltrim(Lower( Getwordnum( cExpressionSearched, i )))
				Endfor

				For i = 2 To lnLen

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Select
							<<This.cFieldGrupo>>,
							<<This.cFieldCodigo>>,
							Desc1,
							<<lcPrecio>>,
							Id,
							Grup_Id,
							Alia1,
							Barr1,
							Rubro
						From cQuery<<i-1>>
						With ( Buffering = .T. )
						Where !Deleted()
							And Lower( Desc1 ) Like '%<<laWords[ i ]>>%'
							Or Lower( Rubro ) Like '%<<laWords[ i ]>>%'
						Into Cursor cQuery<<i>>
					ENDTEXT

					&lcCommand

				Endfor

			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From cQuery<<lnLen>>
				With ( Buffering = .T. )
				Into cursor cQuery ReadWrite
			ENDTEXT

			&lcCommand

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loDt = Null

			For i = 1 To lnLen
				Use In Select( "cQuery" + Transform( i ))
			Endfor

		Endtry

	Endproc && AdvanceSearch


	*
	* Recibe un String y devuelve un string validado para buscar el articulo por código
	Procedure prxBusCod( tcCodigo As String ) As String;
			HELPSTRING "Recibe un String y devuelve un string validado para buscar el articulo por código"

		Return This.prxBusArt( This.ExtractGrup( tcCodigo, "C" ), This.ExtractNume( tcCodigo, "C" ) )

	Endproc && prxBusArt



	*
	* Devuelve un string para buscar el articulo por código
	Procedure prxBusArt( tuGrup As Variant,;
			tuNume As Variant ) As String;
			HELPSTRING "Devuelve un string para buscar el articulo por código"

		Local lcGrup As String,;
			lcNume As String

		Try

			If Vartype( tuGrup ) == "N"
				lcGrup = Str( tuGrup, This.LenGrupo )

				If This.GrupoCeros = "S"
					lcGrup = Padl( Alltrim( lcGrup ), This.LenGrupo, "0" )
				Endif

			Else
				lcGrup = Padr( tuGrup, This.LenGrupo, " " )

			Endif

			If Vartype( tuNume ) == "N"
				lcNume = Str( tuNume, This.LenArt )

				If This.ArtCeros = "S"
					lcNume = Padl( Alltrim( lcNume ), This.LenArt, "0" )
				Endif

			Else
				lcNume = Padr( tuNume, This.LenArt, " " )

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return Upper( lcGrup + lcNume )

	Endproc && prxBusArt



	*
	* Devuelve un string en blanco, con la longitus del código
	Procedure prxIniCod() As String;
			HELPSTRING "Devuelve un string en blanco, con la longitus del código"

		Local lcCodigo As String

		Try

			lcCodigo = This.prxBusCod( "" )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcCodigo

	Endproc && prxBusArt


	*
	* Devuelve la parte del código correspondiernte al grupo
	Procedure ExtractGrup( tcCodigo As String, tcDataType As Character ) As Variant ;
			HELPSTRING "Devuelve la parte del código correspondiernte al grupo"

		Local luGrup As Variant
		Try


			If Vartype( tcCodigo ) # "C"
				tcCodigo = Transform( tcCodigo )
			Endif

			luGrup = Substr( tcCodigo, 1, This.LenGrupo )

			If !Empty( tcDataType )
				Do Case
					Case tcDataType = "C"
						If ( This.GrupoAlfa == "N" )
							luGrup = Str( Val( luGrup ), This.LenGrupo )

							If This.GrupoCeros = "S"
								luGrup = Padl( Alltrim( luGrup ), This.LenGrupo, "0" )
							Endif

						Endif

					Case Inlist( tcDataType, "N", "I" )
						luGrup = Int( Val( luGrup ))

				Endcase

			Else
				If ( This.GrupoAlfa == "N" )
					luGrup = Int( Val( luGrup ))
				Endif

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return luGrup

	Endproc && ExtractGrup

	*
	* Devuelve la parte del código correspondiernte a la linea
	Procedure ExtractLin( tcCodigo As String, tcDataType As Character ) As Variant ;
			HELPSTRING "Devuelve la parte del código correspondiernte la linea"


		Return ""

	Endproc && ExtractLin


	*
	* Devuelve la parte del código correspondiernte al articulo
	Procedure ExtractNume( tcCodigo As String,;
			tcDataType As Character ) As Variant ;
			HELPSTRING "Devuelve la parte del código correspondiernte al articulo"

		Local luNume As Variant

		Try

			luNume = Substr( tcCodigo, This.LenGrupo + 1, This.LenArt )

			If !Empty( tcDataType )
				Do Case
					Case tcDataType = "C"
						If ( This.ArtAlfa == "N" )
							luNume = Str( Val( luNume ), This.LenArt )

							If This.ArtCeros = "S"
								luNume = Padl( Alltrim( luNume ), This.LenArt, "0" )
							Endif

						Endif

					Case Inlist( tcDataType, "N", "I" )
						luNume = Int( Val( luNume ))

				Endcase

			Else
				If ( This.ArtAlfa == "N" )
					luNume = Int( Val( luNume ))
				Endif

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return luNume

	Endproc && ExtractNume



	*
	*
	Procedure CodigoVacio( tcCodigo As String ) As Boolean
		Local lcCommand As String
		Local llEmpty As Boolean

		Try

			lcCommand = ""

			If This.UsaGrupo = "S"
				*llEmpty = Empty( This.ExtractGrup( tcCodigo, "N" ) )
				llEmpty = Empty( This.ExtractGrup( tcCodigo ) )

			Else
				llEmpty = .T.

			Endif

			If llEmpty
				*llEmpty = Empty( This.ExtractNume( tcCodigo, "N" ) )
				llEmpty = Empty( This.ExtractNume( tcCodigo ) )
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llEmpty

	Endproc && CodigoVacio

	*
	* Consulta de Grupos
	Procedure prxTabGru(  ) As Void;
			HELPSTRING "Consulta de Grupos"

		Dimension Campos[2],;
			Pictures[2],;
			Nombres[2]

		Local loObj As Object,;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loConsumirApi As ConsumirAPI Of "Tools\JSON\Prg\XmlHttp.prg"

		Try

			loObj = Createobject( "Empty" )
			AddProperty( loObj, "Codigo", "" )
			AddProperty( loObj, "Descripcion", "" )

			Campos[1] = 'prxArmGru( Codi2 )'
			Campos[2] = 'Desc2'

			PictureS[1] = Replicate( '!', Fsize( "Codi2", "Rubros" ))
			PictureS[2] = Replicate( 'X', Fsize( "Desc2", "Rubros" ))

			Nombres[1] = 'CODIGO'
			Nombres[2] = 'D E S C R I P C I O N'

			If Vartype( pcOrden ) # "C"
				pcOrden = "CODIGO"
			Endif

			If !Inlist( pcOrden, "CODIGO", "DESCRIPCION" )
				pcOrden = "CODIGO"
			Endif

			* Integración Web
			loGlobalSettings = NewGlobalSettings()

			If This.lIntegracionWeb And loGlobalSettings.lIntegracionWeb

				loConsumirApi 	= NewConsumirApi()
				loRespuesta 	= loConsumirApi.Grupos( "LIST" )

				If loRespuesta.lOk
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Select	Codi2,
							Desc2
						From Rubros
						Where .F.
						Into Cursor cRubros ReadWrite
					ENDTEXT

					&lcCommand
					lcCommand = ""

					loColRubros = loRespuesta.Data

					Select cRubros

					For Each loRubro In loColRubros

						If loRubro.Activo Or !This.lFiltrarNoActivos

							AddProperty( loRubro, "Codi2", This.prxBusGru( loRubro.Codigo ))
							AddProperty( loRubro, "Desc2", loRubro.Descripcion )

							Append Blank
							Gather Name loRubro
						Endif

					Endfor

					Do Case
						Case pcOrden = "CODIGO"
							If This.GrupoAlfa == "S"
								Locate For Codi2 >= puGrup

							Else
								Locate For Val( Codi2 ) >= puGrup

							Endif

							If Eof()
								Locate
							Endif

						Case pcOrden = "DESCRIPCION"

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Select *
								From cRubros
								Order By Desc2
								Into Cursor cRubros ReadWrite
							ENDTEXT

							&lcCommand
							lcCommand = ""

							Locate For Desc2 >= pcDesc

							If Eof()
								Locate
							Endif

					Endcase

				Else

				Endif

			Else
				Sele Rubros
				Set Near On

				Do Case
					Case pcOrden = "CODIGO"
						Set Order To Tag Codi2 In Rubros
						=Seek( This.prxBusGru( puGrup ), "Rubros",  "Codi2" )

					Case pcOrden = "DESCRIPCION"
						Set Order To Tag Desc2 In Rubros
						=Seek( C_ALFKEY( pcDesc ), "Rubros", "Desc2" )

				Endcase

				Set Near Off

				If Eof()
					Go Bottom
				Endif
			Endif

			dbEdit( 0, 0, 0, 0, @Campos, '', @PictureS, @Nombres )

			If &Aborta
				prxSetLastKey( 0 )

			Else
				puGrup = Codi2
				pcDesc = Desc2

				loObj.Codigo = Codi2
				loObj.Descripcion = Desc2

				Keyboard '{ENTER}'

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loObj

	Endproc && prxTabGru


	*
	* Pedido del Grupo
	Procedure prxPedGru( tnABM As Integer,;
			tuCodigo As Variant ,;
			tnCodRow As Integer,;
			tnCodCol As Integer,;
			tnDesRow As Integer,;
			tnDesCol As Integer ) As Object;
			HELPSTRING "Pedido del Grupo"

		Local loObj As Object
		Local lcOrdenGet As String

		Local lnI As Integer
		Local lnStatus As Integer
		Local llPideDescripcion As Boolean,;
			llValidArt As Boolean

		Try

			If Vartype( plValidArt ) = "L"
				llValidArt = plValidArt

			Else
				llValidArt = .T.

			Endif

			loObj = Createobject( "Empty" )
			AddProperty( loObj, "Status", 0 )
			AddProperty( loObj, "Codigo", This.ExtractGrup( prxBusGru( "" )))
			AddProperty( loObj, "Descripcion", Space( 30 ))
			AddProperty( loObj, "Id", 0 )

			If !Empty( tuCodigo )
				loObj.Codigo = tuCodigo
			Endif


			llPideDescripcion = (!Empty( tnDesRow ) Or !Empty( tnDesCol ) )

			lnStatus = -1
			lnI = 0

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VALOR ) And !&Aborta

				lnI = lnI + 1

				If lnI > 4
					lnI = 1
				Endif

				Do Case
					Case This.PideCodigoGrupo( lnI, tnABM )
						lnStatus = This.PedirCodigoGrupo( loObj.Codigo, tnCodRow, tnCodCol, tnABM, loObj  )

					Case llPideDescripcion And This.PideDescripcionGrupo( lnI )
						lnStatus = This.PedirDescripcionGrupo( loObj.Descripcion, tnDesRow, tnDesCol )

				Endcase

			Enddo

			If !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR )
				lnStatus = ST_ESCAPE
			Endif

			loObj.Status = lnStatus

			If lnStatus = ST_VALOR And tnABM = PROG_MODIFICACION And llValidArt
				loObj.Codigo 		= This.prxBusGru( Rubros.Codi2 )
				loObj.Descripcion 	= Rubros.Desc2
				loObj.Id 			= Rubros.Id
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loObj

	Endproc && prxPedGru

	*
	* Pide el Código del Grupo
	Procedure PedirCodigoGrupo( tcCodigo As String,;
			tnRow As Integer,;
			tnCol As Integer,;
			tnABM As Integer,;
			toObj As Object  ) As Integer;
			HELPSTRING "Pide el Código"

		Local lnStatus As Integer

		Local lcGrupPicture As String,;
			lcNumePicture  As String

		Try

			pcOrden = "CODIGO"

			puGrup = tcCodigo

			lcNumePicture = Alltrim( This.PictArt )
			lcNumePicture = Strtran( lcNumePicture, "-", "" )
			lcNumePicture = Strtran( lcNumePicture, "/", "" )

			lcGrupPicture = Substr( lcNumePicture, 1, This.LenGrupo )
			lcNumePicture = Substr( lcNumePicture, This.LenGrupo + 1 )

			lnStatus = -1

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR ) And !&Aborta

				If tnABM = PROG_MODIFICACION
					On Key Label F1 Do prxTabGru
				Endif

				Do While !&Aborta
					lnStatus = -1

					S_Line24( This.cLeyendaGrupo + "          [F1]: Consulta" )
					@ tnRow, tnCol Get puGrup Picture "@K " + lcGrupPicture
					Read

					prxLastkey()

					SayMask( tnRow, tnCol, puGrup, lcGrupPicture, 0 )

					If &Aborta
						lnStatus = ST_ESCAPE
						Exit
					Endif

					If tnABM = PROG_ALTA
						If Empty( puGrup )
							Inform( "El GRUPO es obligatorio" )
							Exit
						Endif

						If !This.GrupoExiste( puGrup )
							lnStatus = ST_VALOR
							Exit

						Else
							S_Line22( Err4 )

						Endif

					Else
						If Empty( puGrup )
							lnStatus = ST_VACIO
							Exit
						Endif

						If This.GrupoExiste( puGrup )
							lnStatus = ST_VALOR
							Exit

						Else
							S_Line22( Err3, .T. )
							This.prxTabGru()

						Endif

					Endif

				Enddo
			Enddo

			On Key Label F1

			If lnStatus = ST_VALOR
				toObj.Codigo 		= This.prxBusGru( puGrup )
				SayMask( tnRow, tnCol, This.prxArmGru( puGrup ), "", 0 )
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			On Key Label F1

		Endtry

		Return lnStatus

	Endproc && PedirCodigoGrupo


	*
	* Indica si es el turno de pedir el código de Grupo
	Procedure PideCodigoGrupo( tnI As Integer, tnABM As Integer ) As Boolean;
			HELPSTRING "Indica si es el turno de pedir el código de Grupo"

		Local llOk As Boolean

		Try

			If tnABM = PROG_ALTA
				llOk = .T.

			Else
				llOk = ( tnI = 1 )
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && PideCodigoGrupo

	*
	* Indica si es el turno de pedir la Descripcion del Grupo
	Procedure PideDescripcionGrupo( tnI As Integer ) As Boolean;
			HELPSTRING "Indica si es el turno de pedir la Descripcion de Grupo"

		Local llOk As Boolean

		Try

			llOk = ( tnI = 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && PideDescripcionGrupo

	*
	* Pide la Descripcion del Grupo
	Procedure PedirDescripcionGrupo( tcDescripcion As String, tnRow As Integer, tnCol As Integer ) As Integer;
			HELPSTRING "Piede la Descripcion del Grupo"

		Private pcDesc As String
		Private pcOrden As String

		Local lnStatus As Integer
		Local lcPicture As String

		Try

			pcOrden = "DESCRIPCION"

			pcDesc = tcDescripcion
			lcPicture = Replicate( 'X', Fsize( "Desc2", "Rubros" ))

			lnStatus = -1

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR )

				On Key Label F1 Do prxTabGru

				Do While !&Aborta
					S_Line24( "Ingrese la descripción          [F1]: Consulta" )
					@ tnRow, tnCol Get pcDesc Picture lcPicture
					Read

					prxLastkey()

					SayMask( tnRow, tnCol, pcDesc, lcPicture, 0 )

					If &Aborta
						lnStatus = ST_ESCAPE
						Exit
					Endif

					If Empty( pcDesc )
						lnStatus = ST_VACIO
						Exit

					Endif

					If This.DescripcionGrupoExiste( pcDesc )
						lnStatus = ST_VALOR
						Exit

					Else
						S_Line22( Err3, .T. )
						This.prxTabGru()

					Endif
				Enddo

			Enddo

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			On Key Label F1

		Endtry

		Return lnStatus

	Endproc && PedirDescripcionGrupo

	*
	* Valida la Descripcion del Grupo ingresada
	Procedure DescripcionGrupoExiste( tuDesc As String ) As Boolean;
			HELPSTRING "Valida la Descripcion del Grupo ingresada"

		Local llFound As Boolean,;
			llValidArt As Boolean

		Try

			If Vartype( plValidArt ) = "L"
				llValidArt = plValidArt

			Else
				llValidArt = .T.

			Endif

			If llValidArt
				Set Order To Tag Desc2 In Rubros
				llFound = Seek( Alltrim( tuDesc ), "Rubros", "Desc2" )

				This.prxTabGru()

			Else
				llFound = .T.

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llFound

	Endproc && DescripcionGrupoExiste

	*
	* oObj_Access
	Protected Procedure oObj_Access()

		Try

			If Vartype( This.oObj ) # "O"
				This.oObj = This.ObtenerObjeto()
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return This.oObj

	Endproc && oObj_Access



	*
	* Devuelve el Precio del Artículo
	Procedure Precio( oParam As Object ) As Number;
			HELPSTRING "Devuelve el Precio del Artículo"
		Local lcCommand As String,;
			lcLista As String

		Local lnLista As Integer,;
			lnIvaId As Integer
		Local lnPrecio As Number,;
			lnAlicuotaIva As Number

		Try

			lcCommand = ""

			If Empty( Pcount() )
				oParam = This.ParametrosDePrecio()
			Endif

			If Vartype( oParam ) = "N"
				lnLista = oParam
				oParam = This.ParametrosDePrecio()
				oParam.nLista = lnLista
			Endif

			If Vartype( oParam ) # "O"
				oParam = This.ParametrosDePrecio()
			Endif

			lcLista = StrZero( oParam.nLista, 2 )

			If Empty( Field( "Prec" + lcLista, oParam.cTabla ))
				lcLista = Str( oParam.nLista, 1 )
			Endif

			lnPrecio = Evaluate( oParam.cTabla + ".Prec" + lcLista )

			* Con Iva Incluído o Precio Neto
			If oParam.lIncluyeIva
				* Agregar el iva correspondiente al articulo

				lnAlicuotaIva = GetTasaIva( Evaluate( oParam.cTabla + ".Tiva1" ))
				lnPrecio = lnPrecio * ( 1 + ( lnAlicuotaIva / 100 ) )

			Endif

			* Moneda de facturación. si no existe, toma como default la moneda
			* de venta o compra, segun el caso
			* oParam.nIdMonedaDeFacturacion

			* 1: Precio de Venta (default)
			* 2: Precio de Compra
			* 3: Costo Base
			* oParam.nTipoDePrecio

			* Cantidad de Decimales
			lnPrecio = Round( lnPrecio, oParam.nDecimales )

			* Moneda de Compra
			* oParam.nIdMonedaDeCompra

			* Moneda de Venta
			* oParam.nIdMonedaDeVenta


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			oParam = Null

		Endtry

		Return lnPrecio

	Endproc && Precio



	*
	* Devuelve un objeto con las parametros que requiere el metodo Precio()
	Procedure ParametrosDePrecio(  ) As Object;
			HELPSTRING "Devuelve un objeto con las parametros que requiere el metodo Precio()"
		Local loObj As Object

		Try

			loObj = Createobject( "Empty" )

			* Número de Lista de Precios
			AddProperty( loObj, "nLista", 1 )

			* Con Iva Incluído o Precio Neto
			AddProperty( loObj, "lIncluyeIva", .F. )

			* Moneda de facturación. si no existe, toma como default la moneda
			* de venta o compra, segun el caso
			AddProperty( loObj, "nIdMonedaDeFacturacion", 0 )

			* 1: Precio de Venta (default)
			* 2: Precio de Compra
			* 3: Costo Base
			AddProperty( loObj, "nTipoDePrecio", 1 )

			* Cantidad de Decimales
			AddProperty( loObj, "nDecimales", GetValue( "Depu0", "ar0Est", 2 ) )

			* Moneda de Compra
			AddProperty( loObj, "nIdMonedaDeCompra", 1 )

			* Moneda de Venta
			AddProperty( loObj, "nIdMonedaDeVenta", 1 )

			* Tabla
			AddProperty( loObj, "cTabla", "Articulos" )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loObj

	Endproc && ParametrosDePrecio


	*
	* Pedido del Talle
	Procedure prxPedTal( tnRubro As Integer,;
			tnRow As Integer,;
			tnCol As Integer,;
			tnSelected As Integer,;
			tlShow As Boolean,;
			tcCaption As String,;
			toParam As Object,;
			tnColumn As Integer ) As Object;
			HELPSTRING "Pedido del Talle"

		Local lnTalle_Id As Integer,;
			i As Integer,;
			lnColumn As Integer,;
			lnSelected As Integer

		Local lcCommand As String,;
			lcCaption As String

		Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

		Try

			lcCommand = ""
			lnTalle_Id = 0

			If Empty( tnSelected )
				tnSelected = 0
			Endif

			If Empty( tcCaption )
				tcCaption = "Talles"
			Endif
			lcCaption = tcCaption

			If Empty( tnColumn )
				tnColumn = 2
			Endif
			lnColumn = tnColumn

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From Talles
				Where !Deleted()
					And ( Rubro = <<tnRubro>> )
					And Activo
				Order By Orden
				Into Cursor cTalles ReadWrite
			ENDTEXT

			&lcCommand
			lcCommand = ""

			If !Empty( _Tally )

				Dimension aTalles[ _Tally, 2 ]

				Select cTalles
				Locate

				lnSelected = 1
				i = 0
				Scan
					i = i + 1

					aTalles[ i, 1 ] = cTalles.Id
					aTalles[ i, 2 ] = cTalles.Talle

					If cTalles.Id = tnSelected
						lnSelected = i
					Endif

				Endscan

				lnSelected = S_Opcion( tnRow, tnCol, 0, 0, ;
					"aTalles", lnSelected, tlShow, lcCaption, toParam, lnColumn )

				If !Empty( lnSelected )
					lnTalle_Id = aTalles[ lnSelected, 1 ]
					This.oObj.Talle_Desc = aTalles[ lnSelected, 2 ]
				Endif

			Else
				This.oObj.Talle_Desc = Space( Fsize( "Talle", "Talles" ))

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )


		Finally
			loArticulo = Null
			Use In Select( "cTalles" )

		Endtry

		Return lnTalle_Id

	Endproc

	*
	* Pedido del Color
	Procedure prxPedCol( tnArt_Id As Integer,;
			tnRow As Integer,;
			tnCol As Integer,;
			tnSelected As Integer,;
			tlShow As Boolean,;
			tcCaption As String,;
			toParam As Object,;
			tnColumn As Integer ) As Object;
			HELPSTRING "Pedido del Color"

		Local lnColor_Id As Integer,;
			i As Integer,;
			lnColumn As Integer,;
			lnSelected As Integer

		Local lcCommand As String,;
			lcCaption As String

		Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

		Try

			lcCommand = ""
			lnColor_Id = 0

			If Empty( tnSelected )
				tnSelected = 0
			Endif

			If Empty( tcCaption )
				tcCaption = "Colores"
			Endif
			lcCaption = tcCaption

			If Empty( tnColumn )
				tnColumn = 2
			Endif
			lnColumn = tnColumn

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From Colores
				Where !Deleted()
					And ( Art_Id = <<tnArt_Id>> )
					And Activo
				Order By Orden
				Into Cursor cColores ReadWrite
			ENDTEXT

			&lcCommand
			lcCommand = ""

			If !Empty( _Tally )

				Dimension aColores[ _Tally, 3 ]

				Select cColores
				Locate

				lnSelected = 1
				i = 0
				Scan
					i = i + 1

					aColores[ i, 1 ] = cColores.Id
					aColores[ i, 2 ] = cColores.Color
					aColores[ i, 3 ] = cColores.Abrev

					If cColores.Id = tnSelected
						lnSelected = i
					Endif

				Endscan

				lnSelected = S_Opcion( tnRow, tnCol, 0, 0, ;
					"aColores", lnSelected, tlShow, lcCaption, toParam, lnColumn )

				If !Empty( lnSelected )
					lnColor_Id = aColores[ lnSelected, 1 ]
					This.oObj.Color_Desc = aColores[ lnSelected, 3 ]
				Endif

			Else
				This.oObj.Color_Desc = Space( Fsize( "Abrev", "Colores" ))

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )


		Finally
			loArticulo = Null
			Use In Select( "cColores" )

		Endtry

		Return lnColor_Id

	Endproc


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Articulo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Articulo2
*!* ParentClass...: Articulo Of "Clientes\Archivos\Prg\Articulo.prg"
*!* BaseClass.....: Custom
*!* Description...: Clase para Rubro - Linea - Articulo
*!* Date..........: Miércoles 4 de Junio de 2014 (10:01:06)
*!* Author........: Ricardo Aidelman
*!* Project.......: CloudFox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class Articulo2 As Articulo Of "Clientes\Archivos\Prg\Articulo.prg"

	#If .F.
		Local This As Articulo2 Of "Clientes\Archivos\Prg\Articulo.prg"
	#Endif

	* ¿Utiliza Línea?
	UsaLinea = "S"

	* Utiliza la Línea como Atributo o Parte del Código
	LinCodAtr = "C"

	* Longitud Linea
	LenLinea = 3

	* Linea Numérico/AlfaNumérico
	LineaAlfa = "N"

	* Completa el Número de la Linea con CEROS a la izquierda
	LineaCeros = "N"

	* Si utiliza la busqueda inteligente, indica si la descripcion de la Linea
	* es tomada en cuenta
	ASLinea = "N"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lenlinea" type="property" display="LenLinea" />] + ;
		[<memberdata name="lineaalfa" type="property" display="LineaAlfa" />] + ;
		[<memberdata name="usalinea" type="property" display="UsaLinea" />] + ;
		[<memberdata name="usalinea_access" type="method" display="UsaLinea_Access" />] + ;
		[<memberdata name="lineaexiste" type="method" display="LineaExiste" />] + ;
		[<memberdata name="pedircodigolinea" type="method" display="PedirCodigoLinea" />] + ;
		[<memberdata name="pidecodigolinea" type="method" display="PideCodigoLinea" />] + ;
		[<memberdata name="pidedescripcionlinea" type="method" display="PideDescripcionLinea" />] + ;
		[<memberdata name="pedirdescripcionlinea" type="method" display="PedirDescripcionLinea" />] + ;
		[<memberdata name="descripcionlineaexiste" type="method" display="DescripcionLineaExiste" />] + ;
		[<memberdata name="lineaceros" type="property" display="LineaCeros" />] + ;
		[<memberdata name="pedirlinea" type="method" display="PedirLinea" />] + ;
		[<memberdata name="extractlin" type="method" display="ExtractLin" />] + ;
		[<memberdata name="prxbuslin" type="method" display="prxBusLin" />] + ;
		[<memberdata name="prxarmlin" type="method" display="prxArmLin" />] + ;
		[<memberdata name="extractlin" type="method" display="ExtractLin" />] + ;
		[<memberdata name="prxtablin" type="method" display="prxTabLin" />] + ;
		[<memberdata name="prxpedlin" type="method" display="prxPedLin" />] + ;
		[<memberdata name="prxarmarcodigo" type="method" display="prxArmarCodigo" />] + ;
		[<memberdata name="aslinea" type="property" display="ASLinea" />] + ;
		[</VFPData>]

	*
	*
	Procedure Init(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			DoDefault()

			If This.UsaLinea = "N"
				This.LenLinea = 0
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Init


	*
	* Pide el Código
	Procedure PedirCodigo( tcCodigo As String,;
			tnRow As Integer,;
			tnCol As Integer,;
			tnABM As Integer ) As Integer;
			HELPSTRING "Piede el Código"

		Private puGrup As Variant,;
			puLin As Variant,;
			puNume As Variant,;
			pnId As Integer

		Private pcOrden As String

		Local lnArtCol As Integer,;
			lnGruCol As Integer,;
			lnLinCol As Integer,;
			lnStatus As Integer

		Local lcGrupPicture As String,;
			lcLinPicture As String,;
			lcNumePicture As String,;
			lcGlobalPicture As String

		Local llValidArt As Boolean

		Local loObj As Object

		Try

			If Vartype( plValidArt ) = "L"
				llValidArt = plValidArt

			Else
				llValidArt = .T.

			Endif

			pcOrden = "CODIGO"

			SayMask( tnRow, tnCol, tcCodigo, "@R " + Alltrim( This.PictArt ), 0 )

			puGrup 	= This.ExtractGrup( tcCodigo )
			puLin 	= This.ExtractLin( tcCodigo )
			puNume 	= This.ExtractNume( tcCodigo )
			pnId 	= 0

			lcGlobalPicture = Alltrim( This.PictArt )
			lcGlobalPicture = Strtran( lcGlobalPicture, "-", "" )
			lcGlobalPicture = Strtran( lcGlobalPicture, "/", "" )

			If This.UsaGrupo = "S"
				lnGruCol = tnCol

				If This.UsaLinea = "S"
					lnLinCol = tnCol + This.LenGrupo + 01
					lnArtCol = lnLinCol + This.LenLinea + 01

					lcLinPicture = Substr( lcGlobalPicture, This.LenGrupo + 1, This.LenLinea )
					lcNumePicture = Substr( lcGlobalPicture, This.LenGrupo + This.LenLinea + 1 )

				Else
					lnArtCol = lnLinCol + This.LenGrupo + 01
					lnLinCol = lnArtCol
					lcLinPicture = ""
					lcNumePicture = Substr( lcGlobalPicture, This.LenGrupo + 1 )

				Endif

				lcGrupPicture = Substr( lcGlobalPicture, 1, This.LenGrupo )


			Else
				lnGruCol = tnCol
				lnLinCol = tnCol
				lnArtCol = tnCol
				lcGrupPicture = ""
				lcLinPicture = ""

			Endif

			lnStatus = -1

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR ) And !&Aborta

				lnStatus = This.PedirGrupo( tcCodigo,;
					tnRow,;
					lnGruCol,;
					PROG_MODIFICACION,;
					lcGrupPicture,;
					llValidArt )

				If lnStatus = ST_VALOR

					lnStatus = This.PedirLinea( tcCodigo,;
						tnRow,;
						lnLinCol,;
						PROG_MODIFICACION,;
						lcLinPicture,;
						llValidArt )

				Endif


				If lnStatus = ST_VALOR

					lnStatus = This.PedirArticulo( tcCodigo,;
						tnRow,;
						lnArtCol,;
						tnABM,;
						lcNumePicture,;
						llValidArt )

				Endif

			Enddo

			On Key Label F1

			If lnStatus = ST_VALOR Or !llValidArt
				loObj			= This.oObj
				loObj.Codigo 	= This.prxArmarCodigo( puGrup, puLin, puNume )
				loObj.Grupo		= This.ExtractGrup( loObj.Codigo, "C" )
				loObj.Linea		= This.ExtractLin( loObj.Codigo, "C" )
				loObj.Numero	= This.ExtractNume( loObj.Codigo, "C" )
				loObj.Id		= pnId
				loObj.CodArt	= loObj.Linea + loObj.Numero

				SayMask( tnRow, tnCol, This.prxMosArt( loObj.Codigo ), "", 0 )

			Endif



		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			On Key Label F1
			loObj = Null

		Endtry

		Return lnStatus

	Endproc && PedirCodigo

	*
	*
	Procedure PedirArticulo( tcCodigo As String,;
			tnRow As Integer,;
			tnCol As Integer,;
			tnABM As Integer,;
			tcPicture As String,;
			tlValidArt As Boolean ) As Integer

		Local lcCommand As String
		Local lnStatus As Integer

		Try

			lcCommand = ""


			If tnABM = PROG_MODIFICACION
				On Key Label F1 Do prxLista
			Endif

			Do While !&Aborta

				lnStatus = -1

				S_Line24( This.cLeyendaArticulo + "          [F1]: Consulta" )

				@ tnRow, tnCol Get puNume Picture "@K " + tcPicture
				Read

				prxLastkey()

				SayMask( tnRow, tnCol, puNume, tcPicture, 0 )

				If &Aborta
					lnStatus = ST_ESCAPE
					Exit
				Endif

				If tnABM = PROG_ALTA
					If Empty( puNume )
						Inform( "El ARTICULO es obligatorio" )
						Exit
					Endif

					If !This.ArticuloExiste( puGrup, puLin, puNume )
						lnStatus = ST_VALOR
						Exit

					Else
						S_Line22( Err4 )

					Endif

				Else
					If Empty( puNume )
						If !tlValidArt
							If This.UsaGrupo = "S" ;
									And !Empty( puGrup )

								Keyboard '{F1}'
								Loop

							Else
								lnStatus = ST_VACIO
								Exit

							Endif

						Endif

					Endif

					If This.ArticuloExiste( puGrup, puLin, puNume )
						lnStatus = ST_VALOR
						Exit

					Else
						S_Line22( Err3, .T. )
						prxLista()

					Endif

				Endif
			Enddo

			If lnStatus = ST_VACIO And This.UsaGrupo = "S"
				* Volver a pedir el Grupo
				lnStatus = -1
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lnStatus

	Endproc && PedirArticulo

	*
	*
	Procedure PedirLinea( tcCodigo As String,;
			tnRow As Integer,;
			tnCol As Integer,;
			tnABM As Integer,;
			tcPicture As String,;
			tlValidArt As Boolean ) As Integer

		Local lcCommand As String
		Local lnStatus As Integer

		Try

			lcCommand = ""

			If tnABM = PROG_MODIFICACION
				On Key Label F1 Do prxTabLin
			Endif

			Do While !&Aborta
				If This.UsaLinea = "S"

					lnStatus = -1

					S_Line24( This.cLeyendaLinea + "          [F1]: Consulta" )
					@ tnRow, tnCol Get puLin Picture "@K " + tcPicture
					Read

					prxLastkey()

					SayMask( tnRow, tnCol, puLin, tcPicture, 0 )
					@ tnRow, tnCol - 1 Say "-"
					@ tnRow, tnCol + This.LenLinea Say "-"

					If &Aborta
						lnStatus = ST_ESCAPE
						Exit
					Endif


					If Empty( puLin )
						If tnABM = PROG_ALTA
							Inform( "La LINEA es obligatoria" )
							Loop

						Else
							If !tlValidArt
								lnStatus = ST_VACIO
								Exit
							Endif

						Endif
					Endif

					If This.LineaExiste( puGrup, puLin )
						lnStatus = ST_VALOR
						Exit

					Else
						S_Line22( Err3, .T. )
						This.prxTabLin()

					Endif

				Else
					lnStatus = ST_VALOR
					puLin = 1
					Exit

				Endif

			Enddo

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lnStatus

	Endproc && PedirLinea



	*
	* Valida la Linea ingresada
	Procedure LineaExiste( tuGrup As Variant, tuLin As Variant ) As Boolean;
			HELPSTRING "Valida la Linea ingresada"

		Local llFound As Boolean,;
			llValidLin As Boolean

		Local lnRecno As Integer

		Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loConsumirApi As ConsumirAPI Of "Tools\JSON\Prg\XmlHttp.prg",;
			loReg As Object,;
			loRespuesta As Object

		Try

			If Vartype( plValidArt ) = "L"
				llValidLin = plValidArt

			Else
				llValidLin = .T.

			Endif

			Set Order To Tag LinPK In Lineas

			If llValidLin

				Select Lineas
				llFound = Seek( This.prxBusLin( tuGrup, tuLin ), "Lineas", "LinPK" )

				loReg = Createobject( "Empty" )
				AddProperty( loReg, "Rubr3", tuGrup )
				AddProperty( loReg, "Codi3", tuLin )

				llFound = Seek( This.prxBusLin( tuGrup, tuLin ), "Lineas", "LinPK" )

				If llFound

					loObj = This.oObj

					If !Empty( Field( "Id", "Lineas" ))
						loObj.Lin_Id 	= Lineas.Id
					Endif

					If Used( "ar3Lin" )
						lnRecno = Recno( "Lineas" )

						Try
							Goto lnRecno In "ar3Lin"

						Catch To oErr
							Go Bottom In "ar3Lin"

						Finally

						Endtry

					Endif
				Endif

			Else
				llFound = .T.

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loObj 				= Null
			loGlobalSettings 	= Null
			loConsumirApi 		= Null
			loReg 				= Null
			loRespuesta 		= Null

		Endtry

		Return llFound

	Endproc && LineaExiste

	*
	* Valida el articulo ingresado
	Procedure ArticuloExiste( tuGrup As Variant,;
			tuLin As Variant,;
			tuNume As Variant ) As Boolean;
			HELPSTRING "Valida el Articulo ingresado"

		Local lcCommand As String,;
			lcGrup As String,;
			lcLin As String,;
			lcNume As String,;
			lcCodigo As String

		Local llFound As Boolean

		Try

			lcCommand = ""

			lcCodigo = This.prxArmarCodigo( tuGrup,;
				tuLin,;
				tuNume )

			lcGrup = This.ExtractGrup( lcCodigo, "C" )
			lcLin  = This.ExtractLin( lcCodigo, "C" )
			lcNume = This.ExtractNume( lcCodigo, "C" )

			llFound = DoDefault( lcGrup, lcLin + lcNume )

			If llFound
				loObj = This.oObj
				loObj.Lin_Id 	= Articulos.Lin_Id
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry


		Return llFound

	Endproc && ArticuloExiste


	*
	* Armado de la LINEA en funcion de sus partes
	Procedure prxBusLin( tuGrup As Variant,;
			tuLin As Variant,;
			lWeb As Boolean  ) As String;
			HELPSTRING "Armado de la LINEA en funcion de sus partes"

		Local lcGrup As String,;
			lcLin As String

		Try

			If lWeb And This.GrupoAlfa == "N"
				lcGrup = StrZero( Val( Transform( tuGrup )), This.LenGrupo )

			Else

				If Vartype( tuGrup ) == "N"
					lcGrup = Str( tuGrup, This.LenGrupo )

					If This.GrupoCeros = "S"
						lcGrup = Padl( Alltrim( lcGrup ), This.LenGrupo, "0" )
					Endif

				Else
					lcGrup = Padr( tuGrup, This.LenGrupo, " " )

				Endif

			Endif

			If lWeb And This.LineaAlfa == "N"
				lcLin = StrZero( Val( Transform( tuLin )), This.LenLinea )

			Else

				If Vartype( tuLin ) == "N"
					lcLin = Str( tuLin, This.LenLinea )

					If This.LineaCeros = "S" Or lWeb
						lcLin = Padl( Alltrim( lcLin ), This.LenLinea, "0" )
					Endif

				Else
					lcLin = Padr( tuLin, This.LenLinea, " " )

				Endif
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return Upper( lcGrup + lcLin )

	Endproc && prxBusLin

	*
	* Armado de la LINEA para imprimir, con guiones, en funcion de sus partes
	Procedure prxArmLin( tuGrup As Variant,;
			tuLin As Variant) As String;
			HELPSTRING "Armado del CODIGO en funcion de sus partes"

		Local lcLinea As String,;
			lcLinPicture As String


		Try

			lcLinPicture = Substr( Alltrim( This.PictArt ), 1, This.LenGrupo + 1 + This.LenLinea )
			lcLinea = Transform( This.prxBusLin( tuGrup, tuLin ), "@R " + lcLinPicture )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcLinea


	Endproc && prxArmLin


	* Recibe un String y devuelve un string formateado para mostrar
	Procedure prxMosArt( tcCodigo As String ) As String;
			HELPSTRING "Recibe un String y devuelve un string formateado para mostrar"

		Local lcCodigo As String,;
			lcArticulo As String

		Try

			lcCodigo = This.prxArmarCodigo( This.ExtractGrup( tcCodigo, "C" ),;
				This.ExtractLin(  tcCodigo, "C" ),;
				This.ExtractNume( tcCodigo, "C" ) )

			If ( This.UsaGrupo == "S" )
				lcArticulo = Transform( lcCodigo, "@R " + Alltrim( This.PictArt ))

			Else
				lcArticulo = Transform( tuNume, "@R " + + Alltrim( This.PictArt ))

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcArticulo


	Endproc && prxMosArt

	*
	* Armado del CODIGO para imprimir, con guiones, en funcion de sus partes
	Procedure prxArmArt( tcGrup As String,;
			tcNume As String ) As String;
			HELPSTRING "Armado del CODIGO en funcion de sus partes"

		Local lcCodigo As String,;
			lcArticulo As String


		Try

			lcCodigo = This.prxBusArt( tcGrup, tcNume )

			If ( This.UsaGrupo == "S" )
				lcArticulo = Transform( lcCodigo, "@R " + Alltrim( This.PictArt ))

			Else
				lcArticulo = Transform( tuNume, "@R " + + Alltrim( This.PictArt ))

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcArticulo


	Endproc && prxArmArt

	*
	* Recibe un String y devuelve un string validado para buscar el articulo por código
	Procedure prxBusCod( tcCodigo As String ) As String;
			HELPSTRING "Recibe un String y devuelve un string validado para buscar el articulo por código"

		Return This.prxArmarCodigo( This.ExtractGrup( tcCodigo, "C" ), This.ExtractLin( tcCodigo, "C" ), This.ExtractNume( tcCodigo, "C" ) )

	Endproc && prxBusArt



	*
	* Devuelve un string para buscar el articulo por código
	Procedure prxBusArt( tcGrup As String,;
			tcNume As String ) As String;
			HELPSTRING "Devuelve un string para buscar el articulo por código"

		Local lcGrup As String,;
			lcNume As String,;
			lcCodigo As String

		Try

			lcGrup = Padr( tcGrup, This.LenGrupo, " " )
			lcNume = Padr( tcNume, This.LenLinea + This.LenArt, " " )

			lcCodigo = This.prxArmarCodigo( This.ExtractGrup( lcGrup + lcNume, "C" ),;
				This.ExtractLin(  lcGrup + lcNume, "C" ),;
				This.ExtractNume( lcGrup + lcNume, "C" ) )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcCodigo

	Endproc && prxBusArt



	*
	* Devuelve la parte del código correspondiernte al articulo
	Procedure ExtractNume( tcCodigo As String,;
			tcDataType As Character ) As Variant ;
			HELPSTRING "Devuelve la parte del código correspondiernte al articulo"

		Local luNume As Variant

		Try

			luNume = Substr( tcCodigo, This.LenGrupo + This.LenLinea + 1, This.LenArt )

			If !Empty( tcDataType )
				Do Case
					Case tcDataType = "C"
						If ( This.ArtAlfa == "N" )
							luNume = Str( Val( luNume ), This.LenArt )

							If This.ArtCeros = "S"
								luNume = Padl( Alltrim( luNume ), This.LenArt, "0" )
							Endif

						Endif

					Case Inlist( tcDataType, "N", "I" )
						luNume = Int( Val( luNume ))

				Endcase

			Else
				If ( This.ArtAlfa == "N" )
					luNume = Int( Val( luNume ))
				Endif

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return luNume

	Endproc && ExtractNume



	*
	* Devuelve la parte del código correspondiernte a la linea
	Procedure ExtractLin( tcCodigo As String, tcDataType As Character ) As Variant ;
			HELPSTRING "Devuelve la parte del código correspondiernte la linea"

		Local luLin As Variant

		Try

			luLin = Substr( tcCodigo, This.LenGrupo + 1, This.LenLinea )

			If !Empty( tcDataType )
				Do Case
					Case tcDataType = "C"
						If ( This.LineaAlfa == "N" )
							luLin  = Str( Val( luLin  ), This.LenLinea )

							If This.LineaCeros = "S"
								luLin  = Padl( Alltrim( luLin  ), This.LenLinea, "0" )
							Endif

						Endif

					Case Inlist( tcDataType, "N", "I" )
						luLin  = Int( Val( luLin  ))

				Endcase

			Else
				If ( This.LineaAlfa == "N" )
					luLin  = Int( Val( luLin  ))
				Endif

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return luLin

	Endproc && ExtractLin


	*
	* Consulta de Lineas
	Procedure prxTabLin(  ) As Void;
			HELPSTRING "Consulta de Lineas"

		Dimension Campos[2],;
			Pictures[2],;
			Nombres[2]

		Local lcLinPicture As String,;
			lcFilter As String,;
			lcGrupo As String

		Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loConsumirApi As ConsumirAPI Of "Tools\JSON\Prg\XmlHttp.prg",;
			loColLineas As Collection,;
			loLinea As Object

		Try

			Campos[1] = 'prxArmLin( Rubr3, Codi3 )'
			Campos[2] = 'Desc3'

			lcLinPicture = Substr( Alltrim( This.PictArt ), 1, This.LenGrupo + 1 + This.LenLinea )

			PictureS[1] = lcLinPicture
			PictureS[2] = Replicate( 'X', Fsize( "Desc3", "Lineas" ))

			Nombres[1] = 'CODIGO'
			Nombres[2] = 'D E S C R I P C I O N'

			If Vartype( pcOrden ) # "C"
				pcOrden = "CODIGO"
			Endif

			If !Inlist( pcOrden, "CODIGO", "DESCRIPCION" )
				pcOrden = "CODIGO"
			Endif

			loGlobalSettings = NewGlobalSettings()

			If This.lIntegracionWeb And loGlobalSettings.lIntegracionWeb

				loConsumirApi = NewConsumirApi()

				lcGrupo = This.prxBusGru( puGrup, .T. )

				TEXT To lcFilter NoShow TextMerge Pretext 15
				grupo=<<lcGrupo>>
				ENDTEXT

				loRespuesta = loConsumirApi.Lineas( "LIST", lcFilter )

				If loRespuesta.lOk
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Select	Rubr3,
							Codi3,
							Desc3
						From Lineas
						Where .F.
						Into Cursor cLineas ReadWrite
					ENDTEXT

					&lcCommand
					lcCommand = ""

					loColLineas = loRespuesta.Data

					Select cLineas

					For Each loLinea In loColLineas

						If loLinea.Activo Or !This.lFiltrarNoActivos

							AddProperty( loLinea, "Rubr3", This.ExtractGrup( loLinea.Codigo ))
							AddProperty( loLinea, "Codi3", This.ExtractLin( loLinea.Codigo ))
							AddProperty( loLinea, "Desc3", loLinea.Descripcion )

							Append Blank
							Gather Name loLinea

						Endif

					Endfor

					Do Case
						Case pcOrden = "CODIGO"
							Locate For Upper( Rubr3 + Codi3 ) >= Upper( This.prxBusLin( puGrup, puLin ))

							If Eof()
								Locate
							Endif

						Case pcOrden = "DESCRIPCION"

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Select *
								From cLineas
								Order By Desc3
								Into Cursor cLineas ReadWrite
							ENDTEXT

							&lcCommand
							lcCommand = ""

							Locate For Upper( Desc3 ) >= ( pcDesc )

							If Eof()
								Locate
							Endif

					Endcase

				Else

				Endif

			Else

				Select Lineas
				Set Near On

				Do Case
					Case pcOrden = "CODIGO"
						Set Order To Tag LinPK In Lineas
						=Seek( This.prxBusLin( puGrup, puLin ), "Lineas",  "LinPK" )

					Case pcOrden = "DESCRIPCION"
						Set Order To Tag Desc3 In Lineas
						=Seek( C_ALFKEY( pcDesc ), "Lineas", "Desc3" )

				Endcase

				Set Near Off

				If Eof()
					Go Bottom
				Endif

			Endif

			dbEdit( 0, 0, 0, 0, @Campos, '', @PictureS, @Nombres )

			If &Aborta
				prxSetLastKey( 0 )

			Else
				puGrup 	= Rubr3
				puLin 	= Codi3
				pcDesc 	= Desc3

				Keyboard '{ENTER}'

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			Use In Select( "cLineas" )
			Select Lineas

		Endtry

	Endproc && prxTabLin

	*
	* Consulta de Lineas
	Procedure xxx_prxTabLin(  ) As Void;
			HELPSTRING "Consulta de Lineas"

		Dimension Campos[2],;
			Pictures[2],;
			Nombres[2]

		Local lcLinPicture As String

		Try

			Campos[1] = 'prxArmLin( Rubr3, Codi3 )'
			Campos[2] = 'Desc3'

			lcLinPicture = Substr( Alltrim( This.PictArt ), 1, This.LenGrupo + 1 + This.LenLinea )

			PictureS[1] = lcLinPicture
			PictureS[2] = Replicate( 'X', Fsize( "Desc3", "Lineas" ))

			Nombres[1] = 'CODIGO'
			Nombres[2] = 'D E S C R I P C I O N'

			If Vartype( pcOrden ) # "C"
				pcOrden = "CODIGO"
			Endif

			If !Inlist( pcOrden, "CODIGO", "DESCRIPCION" )
				pcOrden = "CODIGO"
			Endif


			Sele Lineas
			Set Near On

			Do Case
				Case pcOrden = "CODIGO"
					Set Order To Tag LinPK In Lineas
					=Seek( This.prxBusLin( puGrup, puLin ), "Lineas",  "LinPK" )

				Case pcOrden = "DESCRIPCION"
					Set Order To Tag Desc3 In Lineas
					=Seek( C_ALFKEY( pcDesc ), "Lineas", "Desc3" )

			Endcase

			Set Near Off

			If Eof()
				Go Bottom
			Endif

			dbEdit( 0, 0, 0, 0, @Campos, '', @PictureS, @Nombres )

			If &Aborta
				prxSetLastKey( 0 )

			Else
				puGrup 	= Rubr3
				puLin 	= Codi3
				pcDesc 	= Desc3

				Keyboard '{ENTER}'

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && xxx_prxTabLin


	*
	* Pedido de la Linea
	Procedure prxPedLin( tnABM As Integer,;
			tuCodigo As Variant ,;
			tnCodRow As Integer,;
			tnCodCol As Integer,;
			tnDesRow As Integer,;
			tnDesCol As Integer ) As Object;
			HELPSTRING "Pedido de la Linea"

		Local loObj As Object
		Local lcOrdenGet As String

		Local lnI As Integer
		Local lnStatus As Integer
		Local llPideDescripcion As Boolean

		Private puGrup As Variant,;
			puLin As Variant,;
			pnId As Integer

		Private pcOrden As String


		Try

			puGrup 	= ""
			puLin 	= ""
			pnId 	= 0
			pcOrden = ""

			loObj = Createobject( "Empty" )
			AddProperty( loObj, "Status", 0 )
			AddProperty( loObj, "Codigo", prxBusLin( "", "" ) )
			AddProperty( loObj, "Descripcion", Space( 30 ))
			AddProperty( loObj, "Grupo", "" )
			AddProperty( loObj, "Linea", "" )
			AddProperty( loObj, "Id", 0 )
			AddProperty( loObj, "Grup_Id", 0 )
			AddProperty( loObj, "Tag", "LinPK" )

			If !Empty( tuCodigo )
				loObj.Codigo = tuCodigo
			Endif


			llPideDescripcion = (!Empty( tnDesRow ) Or !Empty( tnDesCol ) )

			lnStatus = -1
			lnI = 0

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VALOR ) And !&Aborta

				lnI = lnI + 1

				If lnI > 4
					lnI = 1
				Endif

				Do Case
					Case This.PideCodigoLinea( lnI, tnABM )
						lnStatus = This.PedirCodigoLinea( loObj.Codigo, tnCodRow, tnCodCol, tnABM, loObj  )

					Case llPideDescripcion And This.PideDescripcionLinea( lnI )
						lnStatus = This.PedirDescripcionLinea( loObj.Descripcion, tnDesRow, tnDesCol )

				Endcase

			Enddo

			If !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR )
				lnStatus = ST_ESCAPE
			Endif

			loObj.Status = lnStatus

			If lnStatus = ST_VALOR

				If tnABM = PROG_MODIFICACION
					loObj.Codigo 		= This.prxBusLin( Lineas.Rubr3, Lineas.Codi3 )
					loObj.Descripcion 	= Lineas.Desc3
					loObj.Grupo			= Lineas.Rubr3
					loObj.Linea			= Lineas.Codi3
					loObj.Tag			= Order( "Lineas" )
					loObj.Grup_Id		= Lineas.Grup_Id
					loObj.Id			= Lineas.Id

				Else
					loObj.Codigo 		= This.prxBusLin( puGrup, puLin )
					loObj.Descripcion 	= Space( Fsize( "Desc3", "Lineas" ))
					loObj.Grupo			= This.ExtractGrup( loObj.Codigo, "C" )
					loObj.Linea			= This.ExtractLin( loObj.Codigo, "C" )
					loObj.Tag			= Order( "Lineas" )

				Endif

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loObj

	Endproc && prxPedLin

	*
	* Pide el Código de la Linea
	* Por definición, si utiliza Linea tambien utiliza Grupo
	Procedure PedirCodigoLinea( tcCodigo As String,;
			tnRow As Integer,;
			tnCol As Integer,;
			tnABM As Integer,;
			toObj As Object  ) As Integer;
			HELPSTRING "Piede el Código de la Linea"


		Local lnLinCol As Integer,;
			lnGruCol As Integer,;
			lnStatus As Integer

		Local lcGrupPicture As String,;
			lcLinPicture As String,;
			lcGrupo As String,;
			lcAlias As String

		Local llValidArt As Boolean

		Local loObj As Object

		Try

			If Vartype( plValidArt ) = "L"
				llValidArt = plValidArt

			Else
				llValidArt = .T.

			Endif

			lcAlias = Alias()


			pcOrden = "CODIGO"

			puGrup 	= This.ExtractGrup( tcCodigo )
			puLin 	= This.ExtractLin( tcCodigo )
			pnId 	= 0

			lcLinPicture = Substr( Alltrim( This.PictArt ), 1, This.LenGrupo + 1 + This.LenLinea )

			SayMask( tnRow, tnCol, tcCodigo, "@R " + lcLinPicture )

			lnGruCol = tnCol
			lnLinCol = tnCol + This.LenGrupo + 01
			lcGrupPicture 	= Substr( lcLinPicture, 1, This.LenGrupo )
			lcLinPicture 	= Substr( lcLinPicture, This.LenGrupo + 2 )

			lnStatus = -1

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR ) And !&Aborta

				On Key Label F1 Do prxTabGru

				Do While !&Aborta

					lnStatus = -1

					S_Line24( This.cLeyendaLinea + "          [F1]: Consulta" )
					@ tnRow, lnGruCol Get puGrup Picture "@K " + lcGrupPicture
					Read

					prxLastkey()

					SayMask( tnRow, lnGruCol, puGrup, lcGrupPicture, 0 )
					@ tnRow, lnLinCol - 1 Say "-"

					If &Aborta
						lnStatus = ST_ESCAPE
						Exit
					Endif

					If Empty( puGrup )
						If tnABM = PROG_ALTA
							Inform( "El GRUPO es obligatorio" )
							Loop

						Else
							If llValidArt
								lnStatus = ST_VACIO
								Exit
							Endif

						Endif
					Endif

					If This.GrupoExiste( puGrup )
						lnStatus = ST_VALOR
						Exit

					Else
						S_Line22( Err3, .T. )
						This.prxTabGru()

					Endif

				Enddo

				On Key Label F1

				If lnStatus = ST_VALOR

					lnStatus = -1

					Do While !Inlist( lnStatus, ST_ESCAPE, ST_VALOR, ST_VACIO )

						If tnABM = PROG_MODIFICACION
							On Key Label F1 Do prxTabLin

						Else

							lcGrupo = This.ExtractGrup( This.prxBusLin( puGrup, puLin ), "C" )
							TEXT To lcCommand NoShow TextMerge Pretext 15
							Select Val( Codi3 ) as Codigo
								From Lineas
								Where !Deleted()
									And Rubr3 = '<<lcGrupo>>'
								Into Cursor cLineasAux
							ENDTEXT

							&lcCommand

							puLin = GetFirstFree( "cLineasAux",;
								"",;
								"Codigo",;
								"" )

							Use In Select( "cLineasAux" )



						Endif

						Do While !&Aborta

							lnStatus = -1

							S_Line24( This.cLeyendaGrupo + "          [F1]: Consulta" )

							@ tnRow, lnLinCol Get puLin Picture "@K " + lcLinPicture
							Read

							prxLastkey()

							SayMask( tnRow, lnLinCol, puLin, lcLinPicture, 0 )

							If &Aborta
								lnStatus = ST_ESCAPE
								Exit
							Endif

							If tnABM = PROG_ALTA
								If Empty( puLin )
									Inform( "La LINEA es obligatoria" )
									Exit
								Endif

								If !This.LineaExiste( puGrup, puLin )
									lnStatus = ST_VALOR
									Exit

								Else
									S_Line22( Err4 )

								Endif

							Else
								If Empty( puLin )
									If llValidArt
										If !Empty( puGrup )
											Keyboard '{F1}'
											Loop
										Endif
									Endif
								Endif

								If This.LineaExiste( puGrup, puLin )
									lnStatus = ST_VALOR
									Exit

								Else
									S_Line22( Err3, .T. )
									This.prxTabLin()

								Endif

							Endif
						Enddo
					Enddo

					If lnStatus = ST_VACIO
						* Volver a pedir el Grupo
						lnStatus = -1
					Endif

				Endif

			Enddo

			On Key Label F1

			If lnStatus = ST_VALOR
				loObj			= This.oObj
				loObj.Codigo 	= This.prxBusLin( puGrup, puLin )
				loObj.Grupo		= puGrup
				loObj.Linea		= puLin
				loObj.Lin_Id	= pnId

				SayMask( tnRow, tnCol, This.prxArmLin( puGrup, puLin ), "", 0 )

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			On Key Label F1
			loObj = Null

			Select Alias( lcAlias )

		Endtry

		Return lnStatus

	Endproc && PedirCodigoLinea



	*
	* Indica si es el turno de pedir el código de la Linea
	Procedure PideCodigoLinea( tnI As Integer, tnABM As Integer ) As Boolean;
			HELPSTRING "Indica si es el turno de pedir el código de la Linea"

		Local llOk As Boolean

		Try

			If tnABM = PROG_ALTA
				llOk = .T.

			Else
				llOk = ( tnI = 1 )
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && PideCodigoLinea

	*
	* Indica si es el turno de pedir la Descripcion de la Linea
	Procedure PideDescripcionLinea( tnI As Integer ) As Boolean;
			HELPSTRING "Indica si es el turno de pedir la Descripcion de la Linea"

		Local llOk As Boolean

		Try

			llOk = ( tnI = 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && PideDescripcionLinea

	*
	* Pide la Descripcion de la Linea
	Procedure PedirDescripcionLinea( tcDescripcion As String, tnRow As Integer, tnCol As Integer ) As Integer;
			HELPSTRING "Pide la Descripcion de la Linea"

		Private pcDesc As String
		Private pcOrden As String

		Local lnStatus As Integer
		Local lcPicture As String

		Try

			pcOrden = "DESCRIPCION"

			pcDesc = tcDescripcion
			lcPicture = Replicate( 'X', Fsize( "Desc3", "Lineas" ))

			lnStatus = -1

			Do While !Inlist( lnStatus, ST_ESCAPE, ST_VACIO, ST_VALOR )

				On Key Label F1 Do prxTabLin

				Do While !&Aborta
					S_Line24( "Ingrese la descripción          [F1]: Consulta" )
					@ tnRow, tnCol Get pcDesc Picture "@K " + lcPicture
					Read

					prxLastkey()

					SayMask( tnRow, tnCol, pcDesc, lcPicture, 0 )

					If &Aborta
						lnStatus = ST_ESCAPE
						Exit
					Endif

					If Empty( pcDesc )
						lnStatus = ST_VACIO
						Exit

					Endif

					If This.DescripcionLineaExiste( pcDesc )
						lnStatus = ST_VALOR
						Exit

					Else
						S_Line22( Err3, .T. )
						This.prxTabLin()

					Endif
				Enddo

			Enddo

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			On Key Label F1

		Endtry

		Return lnStatus

	Endproc && PedirDescripcionLinea

	*
	* Valida la Descripcion de la Linea ingresada
	Procedure DescripcionLineaExiste( tuDesc As String ) As Boolean;
			HELPSTRING "Valida la Descripcion de la Linea ingresada"

		Local llFound As Boolean,;
			llValidArt As Boolean

		Try

			If Vartype( plValidArt ) = "L"
				llValidArt = plValidArt

			Else
				llValidArt = .T.

			Endif

			Set Order To Tag Desc3 In Lineas

			If llValidArt

				llFound = Seek( Alltrim( tuDesc ), "Lineas", "Desc3" )

			Else
				llFound = .T.

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llFound

	Endproc && DescripcionLineaExiste


	*
	* Devuelve un string para buscar el articulo por código
	* ( Solo para Rubro-Linea-Articulo )
	Procedure prxArmarCodigo( tuGrup As Variant,;
			tuLin As Variant,;
			tuNume As Variant ) As String;
			HELPSTRING "Devuelve un string para buscar el articulo por código"

		Local lcGrup As String,;
			lcNume As String,;
			lcLin As String

		Try

			lcGrup = ""
			lcNume = ""
			lcLin  = ""

			If This.GrupoAlfa == "N" && Vartype( tuGrup ) == "N"
				lcGrup = Str( Val( Transform( tuGrup )), This.LenGrupo )

				If This.GrupoCeros = "S"
					lcGrup = Padl( Alltrim( lcGrup ), This.LenGrupo, "0" )
				Endif

			Else
				lcGrup = Padr( tuGrup, This.LenGrupo, " " )

			Endif

			If This.UsaLinea = "S"
				If This.LineaAlfa == "N"	&& Vartype( tuLin ) == "N"
					lcLin = Str( Val( Transform( tuLin )), This.LenLinea )

					If This.ArtCeros = "S"
						lcLin = Padl( Alltrim( lcLin ), This.LenLinea, "0" )
					Endif

				Else
					lcLin = Padr( tuLin, This.LenLinea, " " )

				Endif
			Endif


			If This.ArtAlfa == "N"	&& Vartype( tuNume ) == "N"
				lcNume = Str( Val( Transform( tuNume )), This.LenArt )

				If This.ArtCeros = "S"
					lcNume = Padl( Alltrim( lcNume ), This.LenArt, "0" )
				Endif

			Else
				lcNume = Padr( tuNume, This.LenArt, " " )

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return Upper( lcGrup + lcLin + lcNume )

	Endproc && prxArmarCodigo

	*
	* Búsqueda inteligente filtrando la descripcion
	Procedure AdvanceSearch( cExpressionSearched As String ) As Void;
			HELPSTRING "Búsqueda inteligente filtrando la descripcion"
		Local lcCommand As String,;
			lcExpressionSearched As String,;
			lcRubro As String,;
			lcLinea As String,;
			lcBarra As String,;
			lcAlias As String,;
			lcId As String,;
			lcJoinRubros As String,;
			lcJoinLineas As String

		Local loDt As PrxDataTier Of "FW\TierAdapter\Comun\prxDataTier.prg"

		Local llUsaAlias As Boolean,;
			llUsaBarras As Boolean,;
			llUsaId As Boolean

		Local lnLen As Integer

		Try

			lcCommand = ""
			lcExpressionSearched = Lower( Getwordnum( cExpressionSearched, 1 ))

			llUsaAlias 	= !Empty( Field( "Alia1", "Articulos" ))
			llUsaBarras = !Empty( Field( "Barr1", "Articulos" ))
			llUsaId 	= !Empty( Field( "Id", "Articulos" ))

			lcJoinRubros = ""
			lcJoinLineas = ""

			If This.ASGrupo = "S"
				TEXT To lcJoinRubros NoShow TextMerge Pretext 15
				Left Outer Join Rubros r
					On r.Id = a.Grup_Id
						And Lower( r.Desc2 ) Like '%<<lcExpressionSearched>>%'
				ENDTEXT

				TEXT To lcRubro NoShow TextMerge Pretext 15
				r.Desc2 as Rubro,
				a.Grup_Id
				ENDTEXT

				If This.ASLinea = "S"
					TEXT To lcJoinLineas NoShow TextMerge Pretext 15
					Left Outer Join Lineas l
						On l.Id = a.Lin_Id
							And Lower( l.Desc3 ) Like '%<<lcExpressionSearched>>%'
					ENDTEXT

					TEXT To lcLinea NoShow TextMerge Pretext 15
					l.Desc3 as Linea,
					a.Lin_Id
					ENDTEXT

				Else
					TEXT To lcLinea NoShow TextMerge Pretext 15
					" " as Linea,
					0 as Lin_Id
					ENDTEXT

				Endif

			Else

				TEXT To lcRubro NoShow TextMerge Pretext 15
				" " as Rubro,
				0 as Grup_Id
				ENDTEXT

				TEXT To lcLinea NoShow TextMerge Pretext 15
				" " as Linea,
				0 as Lin_Id
				ENDTEXT

			Endif

			If llUsaId
				TEXT To lcId NoShow TextMerge Pretext 15
					a.Id
				ENDTEXT

			Else
				TEXT To lcId NoShow TextMerge Pretext 15
					Cast( 0 as I ) as Id
				ENDTEXT

			Endif

			If llUsaAlias
				TEXT To lcAlias NoShow TextMerge Pretext 15
					a.Alia1
				ENDTEXT

			Else
				TEXT To lcAlias NoShow TextMerge Pretext 15
					"" as Alia1
				ENDTEXT

			Endif

			If llUsaBarras
				TEXT To lcBarra NoShow TextMerge Pretext 15
					a.Barr1
				ENDTEXT

			Else
				TEXT To lcBarra NoShow TextMerge Pretext 15
					"" as Barr1
				ENDTEXT

			Endif


			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select
					q2.<<This.cFieldGrupo>>,
					q2.<<This.cFieldCodigo>>,
					q2.Desc1,
					q2.Prec01,
					q2.Id,
					q2.Grup_Id,
					q2.Lin_Id,
					q2.Alia1,
					q2.Barr1,
					r.Desc2 as Rubro,
					l.Desc3 as Linea
				From (
					Select
							q.<<This.cFieldGrupo>>,
							q.<<This.cFieldCodigo>>,
							q.Desc1,
							q.Prec01,
							q.Id,
							q.Grup_Id,
							q.Lin_Id,
							q.Alia1,
							q.Barr1,
							q.Rubro,
							q.Linea
						From (
								Select
										a.<<This.cFieldGrupo>>,
										a.<<This.cFieldCodigo>>,
										a.Desc1,
										a.Prec01,
										<<lcId>>,
										<<lcAlias>>,
										<<lcBarra>>,
										<<lcRubro>>,
										<<lcLinea>>
									From Articulos a
									<<lcJoinRubros>>
									<<lcJoinLineas>> ) q
						Where !Deleted()
							And Lower( Desc1 ) Like '%<<lcExpressionSearched>>%'
							Or !IsNull( q.Rubro )
							Or !IsNull( q.Linea )
						Order By q.Desc1 ) q2
				Left Outer Join Rubros r
					On r.Id = q2.Grup_Id
				Left Outer Join Lineas l
					On l.Id = q2.Lin_Id
			ENDTEXT

			loDt = NewDT()
			loDt.SQLExecute( lcCommand, "cQuery1" )

			* Busca cuantas palabras hay
			lnLen = Getwordcount( cExpressionSearched )

			If lnLen > 1

				Dimension laWords[ lnLen ]

				For i = 1 To lnLen
					laWords[ i ] = Alltrim(Lower( Getwordnum( cExpressionSearched, i )))
				Endfor

				For i = 2 To lnLen

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Select
							<<This.cFieldGrupo>>,
							<<This.cFieldCodigo>>,
							Desc1,
							Prec01,
							Id,
							Grup_Id,
							Lin_Id,
							Alia1,
							Barr1,
							Rubro,
							Linea
						From cQuery<<i-1>>
						With ( Buffering = .T. )
						Where !Deleted()
							And Lower( Desc1 ) Like '%<<laWords[ i ]>>%'
							Or Lower( Rubro ) Like '%<<laWords[ i ]>>%'
							Or Lower( Linea ) Like '%<<laWords[ i ]>>%'
						Into Cursor cQuery<<i>>
					ENDTEXT

					&lcCommand

				Endfor

			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From cQuery<<lnLen>>
				With ( Buffering = .T. )
				Into cursor cQuery ReadWrite
			ENDTEXT

			&lcCommand

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loDt = Null

			For i = 1 To lnLen
				Use In Select( "cQuery" + Transform( i ))
			Endfor

		Endtry

	Endproc && AdvanceSearch


	*
	* Selector de Artículos
	Procedure prxLista( tnAction As Integer ) As Object ;
			HELPSTRING "Selector de Artículos"

		Local lnLen As Integer
		Local llUsaGrupo As Boolean,;
			llUsaAlias As Boolean,;
			llUsaBarras As Boolean,;
			llAdvanceSearch As Boolean

		Local loObj As Object
		Local lcAlias As String,;
			lcCodigo As String

		Try

			If This.nCurrent = PA_CODIGO
				lcCodigo 	= This.prxArmarCodigo( puGrup, puLin, puNume )
				puNume 		= This.ExtractLin( lcCodigo, "C" ) + This.ExtractNume( lcCodigo, "C" )
				puGrup 		= This.ExtractGrup( lcCodigo, "C" )

				loObj = DoDefault( tnAction )

				lcCodigo = This.prxBusArt( puGrup, puNume )

				puLin 	= This.ExtractLin( lcCodigo )
				puNume 	= This.ExtractNume( lcCodigo )
				puGrup 		= This.ExtractGrup( lcCodigo )

			Else
				loObj = DoDefault( tnAction )

			Endif

			If Pemstatus( _Screen, "oObj_Aux", 5 )
				_Screen.oObj_Aux = loObj
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loObj

	Endproc && prxLista


	*
	*
	*Procedure ArmarCampos( aCampo, aMascara, aNombre, lAdvanceSearch ) As Void
	Procedure ArmarCampos( lAdvanceSearch ) As Void
		Local lcCommand As String,;
			lcFilter As String,;
			lcGrupo As String,;
			lcLinea As String,;
			lcNume As String

		Local lnLen As Integer
		Local llUsaGrupo As Boolean,;
			llUsaAlias As Boolean,;
			llUsaBarras As Boolean,;
			llAdvanceSearch As Boolean

		Local loObj As Object,;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loConsumirApi As ConsumirAPI Of "Tools\JSON\Prg\XmlHttp.prg"
		Local lcAlias As String

		Try

			lcCommand = ""

			llUsaGrupo 	= ( This.UsaGrupo 	= "S" )
			llUsaAlias 	= ( This.UsaAlias 	= "S" )
			llUsaBarras	= ( This.UsaBarras 	= "S" )

			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
			Endif

			If Vartype( pcOrden ) <> "C"
				pcOrden = ""
			Endif

			If pcOrden = "DESCRIPCION" And lAdvanceSearch
				If This.ASGrupo = "S"
					lnLen = lnLen + 1
					If This.ASLinea = "S"
						lnLen = lnLen + 1
					Endif
				Endif
			Endif

			Dimension aCampo[ lnLen ],;
				aMascara[ lnLen ],;
				aNombre[ lnLen ]


			If This.UsaGrupo = "S"
				aCampo[1] = This.cFieldGrupo + "+" + This.cFieldCodigo

			Else
				aCampo[1] = This.cFieldCodigo

			Endif

			aCampo[2] = 'DESC1'

			Do Case
				Case !Empty( Field( "Prec01", "Articulos" ))
					aCampo[3] = 'PREC01'

				Case !Empty( Field( "Prec1", "Articulos" ))
					aCampo[3] = 'PREC1'

				Otherwise
					Error "No existe el aCampo Precios en Articulos"

			Endcase

			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
				aCampo[ lnLen ] = 'ALIA1'
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
				aCampo[ lnLen ] = 'BARR1'
			Endif

			aMascara[1] = "@R " + Alltrim( This.PictArt )
			aMascara[2] = Replicate( 'X', Fsize( "Desc1", "Articulos" ))
			aMascara[3] = WPICP

			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
				aMascara[ lnLen ] = Replicate( 'X', Fsize( "Alia1", "Articulos" ))
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
				aMascara[ lnLen ] = Replicate( 'X', Fsize( "Barr1", "Articulos" ))
			Endif


			aNombre[1] = 'C O D I G O'
			aNombre[2] = 'D E S C R I P C I O N'
			aNombre[3] = 'PRECIO'

			lnLen = 3

			If llUsaAlias
				lnLen = lnLen + 1
				aNombre[ lnLen ] = 'A L I A S'
			Endif

			If llUsaBarras
				lnLen = lnLen + 1
				aNombre[ lnLen ] = 'C. de Barras'
			Endif

			If Vartype( pcOrden ) # "C"
				pcOrden = "CODIGO"
			Endif

			If !Inlist( pcOrden, "CODIGO", "DESCRIPCION", "ALIAS", "BARRAS" )
				pcOrden = "CODIGO"
			Endif

			If pcOrden = "DESCRIPCION" And lAdvanceSearch
				This.AdvanceSearch( pcDesc )
				lcAlias = Alias()

				If This.ASGrupo = "S"
					lnLen = lnLen + 1
					aCampo[ lnLen ] 	= "Rubro"
					aNombre[ lnLen ] = "Rubro"
					aMascara[ lnLen ] = Replicate( 'X', Fsize( This.cFieldGrupo, lcAlias ))

					If This.ASLinea = "S"
						lnLen = lnLen + 1
						aCampo[ lnLen ] = 'Linea'
						aNombre[ lnLen ] = 'Linea'
						aMascara[ lnLen ] = Replicate( 'X', Fsize( "Linea", lcAlias ))
					Endif
				Endif

			Else

				* Integración Web
				loGlobalSettings = NewGlobalSettings()

				If This.lIntegracionWeb And loGlobalSettings.lIntegracionWeb


					loConsumirApi 	= NewConsumirApi()

					lcCodigo 	= This.prxArmarCodigo( puGrup, puLin, puNume )
					lcGrupo = This.prxBusGru( puGrup, .T. )
					lcLinea = This.prxBusLin( puGrup, puLin, .T. )

					TEXT To lcFilter NoShow TextMerge Pretext 15
					linea=<<lcLinea>>
					ENDTEXT

					&lcCommand
					lcCommand 	= ""
					loRespuesta = loConsumirApi.Articulos( "LIST", lcFilter )

					If loRespuesta.lOk
						TEXT To lcCommand NoShow TextMerge Pretext 15
						Select	Grup1,
								Nume1,
								Desc1
							From Articulos
							Where .F.
							Into Cursor cArticulos ReadWrite
						ENDTEXT

						&lcCommand
						lcCommand = ""

						loColArticulos = loRespuesta.Data

						Select cArticulos

						For Each loArticulo In loColArticulos

							lcNume = This.ExtractLin( loArticulo.Linea + loArticulo.Articulo, "C" )
							lcNume = lcNume + This.ExtractNume( loArticulo.Linea + loArticulo.Articulo, "C" )

							AddProperty( loArticulo, "Grup1", This.prxBusGru( loArticulo.Grupo ))
							AddProperty( loArticulo, "Nume1", lcNume )
							AddProperty( loArticulo, "Desc1", loArticulo.Descripcion )

							Append Blank
							Gather Name loArticulo

						Endfor

						Do Case
							Case pcOrden = "CODIGO"

								Locate For Upper( Grup1 + Nume1 ) >= Upper( lcCodigo )

								If Eof()
									Locate
								Endif

							Case pcOrden = "DESCRIPCION"

								TEXT To lcCommand NoShow TextMerge Pretext 15
								Select *
									From cRubros
									Order By Desc2
									Into Cursor cRubros ReadWrite
								ENDTEXT

								&lcCommand
								lcCommand = ""

								Locate For Desc2 >= pcDesc

								If Eof()
									Locate
								Endif

						Endcase

					Else

					Endif

				Else

					Sele Articulos
					Set Near On

					lcAlias = Alias()

					If Vartype( puGrup ) <> "C"
						puGrup = ""
					Endif

					If Vartype( puNume ) <> "C"
						puNume = ""
					Endif

					If Vartype( pcDesc ) <> "C"
						pcDesc = ""
					Endif

					Do Case
						Case pcOrden = "CODIGO"
							Set Order To Tag ArtPK In Articulos
							=Seek( This.prxBusArt( puGrup, puNume ), "Articulos",  "ArtPK" )

						Case pcOrden = "DESCRIPCION"
							Set Order To Tag Desc1 In Articulos
							=Seek( C_ALFKEY( pcDesc ), "Articulos", "Desc1" )

						Case pcOrden = "ALIAS"
							Set Order To Tag Alia1 In Articulos
							=Seek( C_ALFKEY( pcAlias ), "Articulos", "Alia1" )

						Case pcOrden = "BARRAS"
							Set Order To Tag Barr1 In Articulos
							=Seek( C_ALFKEY( pcBarras ), "Articulos", "Barr1" )

					Endcase

					Set Near Off

					If Eof()
						Go Bottom
					Endif
				Endif

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && ArmarCampos


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Articulo
*!*
*!* ///////////////////////////////////////////////////////