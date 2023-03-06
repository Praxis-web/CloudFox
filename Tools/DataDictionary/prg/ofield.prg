#include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'
#Include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oBase.prg'
    Do 'ErrorHandler\prg\ErrorHandler.prg'
    Do 'Tools\DataDictionary\prg\oTable.prg'

Endif

* oField
* Campo de tabla de la base de datos.
Define Class oField As oBase Of 'Tools\DataDictionary\prg\oBase.prg'

    #If .F.
        Local This As oField Of 'Tools\DataDictionary\prg\oField.prg'
    #Endif

    #If .F.
        TEXT
		 *:Help Documentation
		 *:Description:
		 Campo de tabla de la base de datos. 
		 *:Project:
		 Sistemas Praxis
		 *:Autor:
		 Damián Eiff
		 *:Date:
		 Martes 29 de Mayo de 2007 (11:00:34)
		 *:Parameters:
		 *:Remarks:
		 *:Returns:
		 *:Example:
		 *:SeeAlso:
		 *:Events:
		 *:KeyWords:
		 *:Inherits:
		 *:Exceptions:
		 *:NameSpace:
		 digitalizarte.com
		 *:EndHelp
        ENDTEXT
    #Endif

    * Tipo de Dato
    cFieldType = ''

    * Ancho del Campo
    nFieldWidth = 0

    * Presición del Campo
    nFieldPrecision = 0

    * Indica si permite valores nulos.
    lNull = .F.

    * Specifies the table validation rule for the field.
    * Must evaluate to a logical expression and can be a user-defined function
    * or a stored procedure.
    cCheck = ''

    * Mensaje de error que se muestra si Check evalua a .F.
    cErrorMessage = ''

    * Indica si el campo es autoincremental.
    lAutoinc = .F.

    * Si es mayor que 0, indica el siguiente número automático.
    *nNextvalue = 0

    * Incremento en campos autoincrementales.
    *nStepValue = 1

    * Valor por defecto
    Default = Null

    * Indica si incluye la clausula NOCPTRANS.
    *lNoCPTrans = .F.

    * Indica si incluye la cláusula NOVALIDATE.
    *lNovalidate = .F.

    DataSession = SET_DEFAULT

    * Tipo de indice generado para este campo. (Constantes definidas en ta.h)
    *nIndexKey = IK_NOKEY

    * Condición de filtro para el indice ( Default: "!Deleted()" )
    * cForExpression = "( !Deleted() )"
    * El default se inicializa en utRutina -> Archivo.Indexar
    *cForExpression = ""

    *
    *cCollate = 'SPANISH'

    * Nombre de la tabla a la que hace referencia
    * Si no se especifica, toma por defecto el nombre del campo
    * Se usa en la FK
    cReferences = ''

    * Campo con el que se relaciona en la tabla externa.
    * Si está en blanco se relaciona con la PK de la tabla externa
    cFK_ToField = ""

    * Modelo de la tabla externa
    cFK_Modelo = ""

    * Indica si la expresión de indice diferencia mayusculas de minusculas
    lCaseSensitive = .F.

    * Specifies an index tag name
    *!*	Index tag names can contain up to 10 characters.
    *cTagName = ''

    * Nombre del campo que es la clave de la tabla padre
    cParentPk = ''

    * Etiqueta de indices correspondiente a la tabla padre
    *cParentTagName = ''

    * Clave de acceso a la tabla externa de una FK
    *cParentKeyName = ''

    * Filtro sobre la tabla padre
    * (Ej: Tipo4 = '3' )
    *cParentFilterCriteria = "( 1 > 0 )"


    * Contiene el valor de la propiedad Caption del control Label que mostrará el campo
    cCaption = ''

    * Caption del Header en la Grilla
    cHeaderCaption = ''



    * Comentario que documenta el objeto
    cComment = ''

    * Name of the class used for field mapping.
    *cDisplayClass = ''

    * Path to the class library specified with the DisplayClass property
    *cDisplayClassLibrary = ''

    * The field display format
    cFormat = ''

    * The field input format
    cInputMask = ''

    * Condición a cumplir para que se dispare el trigger
    *cTriggerConditionForInsert = '.T.'

    * Condición a cumplir para que se dispare el trigger
    *cTriggerConditionForUpdate = '.T.'

    * Condición a cumplir para que se dispare el trigger
    *cTriggerConditionForDelete = '.T.'

    * Indica si el campo se muestra en la Grilla
    lShowInGrid = .F.

    * Referencia al objeto que toma el control en una grilla.
    oCurrentControl = Null

    * Posición dentro de la grilla
    * nGridOrder = 0 Indica que no se utiliza el campo
    * nGridOrder > 0 Posicion que ocupa en la grilla
    * nGridOrder < 0 Es una columna que no se muestra
    nGridOrder = 0

    * Posición dentro de la grilla del Selector
    * nSelectorOrder = 0 Indica que no se utiliza el campo
    * nSelectorOrder > 0 Posicion que ocupa en la grilla
    * nSelectorOrder < 0 Es una columna que no se muestra
    nSelectorOrder = 0

    * Indica si el campo se muestra en el navegador
    *lShowInNavigator = .F.

    * Posición dentro del KeyFinder
    * nShowInKeyFinder = 0 Indica que no se utiliza el campo en el KeyFinder
    * nShowInKeyFinder > 0 Posicion que ocupa en el KeyFinder
    * nShowInKeyFinder < 0 Es una columna que no se muestra en el KeyFinder pero se utiliza para las busquedas
    *nShowInKeyFinder = 0

    * Posición dentro del Combo
    * 	nComboOrder = 0 Indica que no se utiliza el campo en el Combo
    * 	nComboOrder > 0 Posicion que ocupa en el Combo
    * 	nComboOrder < 0 Es una columna que no se muestra en el Combo
    nComboOrder = 0

    * Posición dentro del Filtro
    * nShowInFilter = 0 Indica que no se utiliza el campo en el Filtro
    * nShowInFilter > 0 Posicion que ocupa en el Filtro
    nShowInFilter = 0

    * Nombre del campo a filtrar
    cFilterFieldName = ""

    * Tipo de Datos a filtrar
    cFilterDataType = " "

    * Control asociado al filtro
    * Si está vacío, infiere lo siguiente en función del tipo de datos
    * Character: TextBox
    * Integer: Combo (FK) Puede ser ListBox si se filtra por "Varios"
    * Date: taDatePicker
    * Numeric: Spiner
    cFilterControl = ""

    * Indica los commando de filtro que excluye
    cFilterLookUpExclude = ""

    * Indica los commando de filtro que incluye
    cFilterLookUpInclude = ""

    * Indica si el filtro permanece fijo
    lFilterEsSistema = .F.

    * Indica si el filtro se inicializa Activo
    lFilterActivo = .F.

    * Indica si el campo está incluido en la búsqueda rápida del KeyFinder
    *lFastSearch = .F.

    * Condición de Búsqueda
    *cSearchCondition = '!#'

    * Indica si el campo es requerido
    lRequired = .F.

    * Nombre de fantasía por el que se accede a la coleccion oDataDictionary
    cKeyName = ''

    * Mensaje a mostrar cuando se pase el cursor sobre el control
    cToolTipText = ''

    * Mensaje a mostrar en la barra de estado
    cStatusBarText = ''

    * Longitud del control que muestra el campo.
    * Prevalece sobre FieldWidth. (para los combos de las FK)
    nLength = 0

    * Longitud Máxima del control que muestra el campo en una Grilla.
    * Prevalece sobre nLength
    nGridMaxLength = 0

    *
    nMaxValue = 0
    *
    nLowValue = 0

    lFitColumn   = .F.

    lOrderByThis = .F.

    * Indica si el campo es logico
    lIsLogical = .F.

    * Indica si el control asociado al campo es el que toma el foco
    lGetFirstFocus = .F.

    * Expresión que se ejecuta para asignarle un valor al campo
    cDefaultValueExpression = ''

    * Indica si el campo es de sistema
    lIsSystem = .F.

    * Indica si es clave primaria
    lIsPrimaryKey = .F.

    * Condicion de búsqueda predeterminada
    * Valores posibles:
    * 					"E" 	->	Entre
    * 					"like" 	->	Comienza con
    * 					"%" 	->	Contiene
    * 					"!#" 	->	Igual
    * 					"#" 	->	Distinto
    *cDefaultCondition = '%'

    * Indica si el campo es virtual
    lIsVirtual = .F.

    * Indica que el campo se graba en la base de datos
    *lSaveInDataBase = .T.

    * Indica que la columna se indexa en el cliente
    *lIndexOnClient = .F.

    * Nombre del Tag actual para el campo
    *cCurrentTagName = ''

    * Expresion para utilizar de forma predeterminada en las consultas SQL
    *cDefaultSqlExp = ''

    * Indica que el campo se muestra como parte de otra tabla caundo existe un FK a la tabla
    *nDefaultReference = 0

    * Caption de la columna que hace referencia a la FK
    *cReferenceCaption = ''

    Name = 'oField'

    lVisible   = .T.

    lCanUpdate = .T.

    cPageName = ''

    *lSameRowAsPrevious = .F.

    lEnable = .T.

    lReadOnly = .F.

    * Sentencia que se ejecuta para crear el campo virtual
    *cVirtualCommand = ""

    *
    nAlignment = -1
    *
    nGridAlignment = -1

    * Expresion de indice para usar en el ordenamiento dentro del Browse
    cGridIndexExpression = ""

    * Indica si permite valores negativos en valores numericos
    lNegativeValue = .F.

    * Indica la tabla con la que se relaciona.
    * Solo para campos relacionales (ManyToMany, OneToMany, OneToOne)
    ToTable = ""

    * Cuando el campo contiene una FK, indica si muestra la FK, o el
    * nombre de la FK apuntada
    lStr = .F.

    *
    cGridColumnControlSource = ""



    * Opciones válidas, en formato Descripcion, Valor
    *!*	loChoices = Createobject( "Collection" )

    *!*	loItem = Createobject( "Empty" )
    *!*	AddProperty( loItem, "Descripcion", "Positivo" )
    *!*	AddProperty( loItem, "Valor", 1 )
    *!*	loChoices.Add( loItem )

    *!*	loItem = Createobject( "Empty" )
    *!*	AddProperty( loItem, "Descripcion", "Negativo" )
    *!*	AddProperty( loItem, "Valor", -1 )
    *!*	loChoices.Add( loItem )
    *
    * Se muestran en ComboBox o ListBox
    oChoices = Null

    * Indica si elimina los espacios en blanco iniciales y finales en datos alfanuméricos
    Ltrim = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="ltrim" type="property" display="lTrim" />] ;
        + [<memberdata name="ochoices" type="property" display="oChoices" />] ;
        + [<memberdata name="cfk_tofield" type="property" display="cFK_ToField" />] ;
        + [<memberdata name="cfk_modelo" type="property" display="cFK_Modelo" />] ;
        + [<memberdata name="totable" type="property" display="ToTable" />] ;
        + [<memberdata name="cvirtualcommand" type="property" display="cVirtualCommand" />] ;
        + [<memberdata name="lvisible" type="property" display="lVisible" />] ;
        + [<memberdata name="creferencecaption" type="property" display="cReferenceCaption" />] ;
        + [<memberdata name="ndefaultreference" type="property" display="nDefaultReference" />] ;
        + [<memberdata name="nselectororder" type="property" display="nSelectorOrder" />] ;
        + [<memberdata name="ncomboorder" type="property" display="nComboOrder" />] ;
        + [<memberdata name="cdefaultsqlexp" type="property" display="cDefaultSqlExp" />] ;
        + [<memberdata name="ccurrenttagname" type="property" display="CcurrentTagName" />] ;
        + [<memberdata name="ccurrenttagname_access" type="method" display="cCurrentTagName_Access" />] ;
        + [<memberdata name="lindexonclient" type="property" display="lIndexOnClient" />] ;
        + [<memberdata name="lsaveindatabase" type="property" display="lSaveInDataBase" />] ;
        + [<memberdata name="lisvirtual" type="property" display="lIsVirtual" />] ;
        + [<memberdata name="cdefaultcondition" type="property" display="cDefaultCondition" />] ;
        + [<memberdata name="nshowinkeyfinder" type="property" display="nShowInKeyFinder" />] ;
        + [<memberdata name="nshowinfilter" type="property" display="nShowInFilter" />] ;
        + [<memberdata name="cfilterfieldname" type="property" display="cFilterFieldName" />] ;
        + [<memberdata name="cfilterdatatype" type="property" display="cFilterDataType" />] ;
        + [<memberdata name="cfiltercontrol" type="property" display="cFilterControl" />] ;
        + [<memberdata name="cfilterlookupexclude" type="property" display="cFilterLookUpExclude" />] ;
        + [<memberdata name="cfilterlookupinclude" type="property" display="cFilterLookUpInclude" />] ;
        + [<memberdata name="lfilteressistema" type="property" display="lFilterEsSistema" />] ;
        + [<memberdata name="lfilteractivo" type="property" display="lFilterActivo" />] ;
        + [<memberdata name="lfastsearch" type="property" display="lFastSearch" />] ;
        + [<memberdata name="lisprimarykey" type="property" display="lIsPrimaryKey" />] ;
        + [<memberdata name="cparentkeyname" type="property" display="cParentKeyName" />] ;
        + [<memberdata name="cdefaultvalueexpression" type="property" display="cDefaultValueExpression" />] ;
        + [<memberdata name="lgetfirstfocus" type="property" display="lGetFirstFocus" />] ;
        + [<memberdata name="nlength" type="property" display="nLength" />] ;
        + [<memberdata name="ngridmaxlength" type="property" display="nGridMaxLength" />] ;
        + [<memberdata name="cstatusbartext" type="property" display="cStatusBarText" />] ;
        + [<memberdata name="cstatusbartext_access" type="method" display="cStatusBarText_Access" />] ;
        + [<memberdata name="ctooltiptext" type="property" display="cToolTipText" />] ;
        + [<memberdata name="cparenttagname" type="property" display="cParentTagName" />] ;
        + [<memberdata name="lcasesensitive" type="property" display="lCaseSensitive" />] ;
        + [<memberdata name="nindexkey" type="property" display="nIndexKey" />] ;
        + [<memberdata name="ctagname" type="property" display="cTagName" />] ;
        + [<memberdata name="creferences" type="property" display="cReferences" />] ;
        + [<memberdata name="ccollate" type="property" display="cCollate" />] ;
        + [<memberdata name="lnovalidate" type="property" display="lNovalidate" />] ;
        + [<memberdata name="lnocptrans" type="property" display="lNocptrans" />] ;
        + [<memberdata name="default" type="property" display="Default" />] ;
        + [<memberdata name="nstepvalue" type="property" display="nStepValue" />] ;
        + [<memberdata name="nnextvalue" type="property" display="nNextValue " />] ;
        + [<memberdata name="lautoinc" type="property" display="lAutoinc" />] ;
        + [<memberdata name="cerrormessage" type="property" display="cErrorMessage" />] ;
        + [<memberdata name="ccheck" type="property" display="cCheck" />] ;
        + [<memberdata name="lnull" type="property" display="lNull" />] ;
        + [<memberdata name="nfieldprecision" type="property" display="nFieldPrecision" />] ;
        + [<memberdata name="nfieldwidth" type="property" display="nFieldWidth" />] ;
        + [<memberdata name="cfieldtype" type="property" display="cFieldType" />] ;
        + [<memberdata name="cruleexpression" type="property" display="cRuleExpression" />] ;
        + [<memberdata name="cinputmask" type="property" display="cInputMask" />] ;
        + [<memberdata name="cformat" type="property" display="cFormat" />] ;
        + [<memberdata name="cdisplayclasslibrary" type="property" display="cDisplayClassLibrary" />] ;
        + [<memberdata name="cdisplayclass" type="property" display="cDisplayClass" />] ;
        + [<memberdata name="ccomment" type="property" display="cComment" />] ;
        + [<memberdata name="ccaption" type="property" display="cCaption" />] ;
        + [<memberdata name="cheadercaption" type="property" display="cHeaderCaption" />] ;
        + [<memberdata name="ctriggerconditionforinsert" type="property" display="cTriggerConditionForInsert" />] ;
        + [<memberdata name="ctriggerconditionforupdate" type="property" display="cTriggerConditionForUpdate" />] ;
        + [<memberdata name="ctriggerconditionfordelete" type="property" display="cTriggerConditionForDelete" />] ;
        + [<memberdata name="cdisplayclasslibrary_assign" type="method" display="cDisplayClassLibrary_Assign" />] ;
        + [<memberdata name="cparentpk" type="property" display="cParentPk" />] ;
        + [<memberdata name="lshowingrid" type="property" display="lShowInGrid" />] ;
        + [<memberdata name="lrequired" type="property" display="lRequired" />] ;
        + [<memberdata name="ckeyname" type="property" display="cKeyName" />] ;
        + [<memberdata name="ckeyname_access" type="method" display="cKeyName_Access" />] ;
        + [<memberdata name="ngridorder" type="property" display="nGridOrder" />] ;
        + [<memberdata name="lfitcolumn" type="property" display="lFitColumn" />] ;
        + [<memberdata name="lorderbythis" type="property" display="lOrderByThis" />] ;
        + [<memberdata name="lislogical" type="property" display="lIsLogical" />] ;
        + [<memberdata name="lissystem" type="property" display="lIsSystem" />] ;
        + [<memberdata name="lshowinnavigator" type="property" display="lShowInNavigator" />] ;
        + [<memberdata name="lenable" type="property" display="lEnable" />] ;
        + [<memberdata name="lreadonly" type="property" display="lReadOnly" />] ;
        + [<memberdata name="lcanupdate" type="property" display="lCanUpdate" />] ;
        + [<memberdata name="nalignment" type="property" display="nAlignment" />] ;
        + [<memberdata name="cgridindexexpression" type="property" display="cGridIndexExpression" />];
        + [<memberdata name="cforexpression" type="property" display="cForExpression" />] ;
        + [<memberdata name="ctagname_access" type="method" display="cTagName_Access" />] ;
        + [<memberdata name="cparentfiltercriteria" type="property" display="cParentFilterCriteria" />] ;
        + [<memberdata name="lnegativevalue" type="property" display="lNegativeValue" />] ;
        + [<memberdata name="lstr" type="property" display="lStr" />] ;
        + [<memberdata name="creferences_access" type="method" display="cReferences_Access" />] ;
        + [<memberdata name="ocurrentcontrol" type="property" display="oCurrentControl" />] ;
        + [<memberdata name="cgridcolumncontrolsource" type="property" display="cGridColumnControlSource" />] ;
        + [<memberdata name="ngridalignment" type="property" display="nGridAlignment" />] ;
        + [<memberdata name="nlowvalue" type="property" display="nLowValue" />] ;
        + [<memberdata name="nmaxvalue" type="property" display="nMaxValue" />] ;
        + [<memberdata name="nlength_assign" type="method" display="nLength_Assign" />] ;
        + [</VFPData>]


    *
    * cStatusBarText_Access
    Protected Function cStatusBarText_Access() As String

        If Empty ( This.cStatusBarText )
            This.cStatusBarText = This.cToolTipText

        Endif && This.cStatusBarText

        Return This.cStatusBarText

    Endfunc && cStatusBarText_Access

    *!*	* DisplayClassLibrary_Assign
    *!*	Protected Procedure cDisplayClassLibrary_Assign ( tcDisplayClassLibrary As String ) As Void

    *!*		#If .F.
    *!*			TEXT
    *!*		 *:Help Documentation
    *!*		 *:Project:
    *!*		 Sistemas Praxis
    *!*		 *:Autor:
    *!*		 Damián Eiff
    *!*		 *:Date:
    *!*		 Sábado 19 de Julio de 2008 (11:48:25)
    *!*		 *:Parameters:
    *!*		 *:Remarks:
    *!*		 *:Returns:
    *!*		 *:Example:
    *!*		 *:SeeAlso:
    *!*		 *:Events:
    *!*		 *:KeyWords:
    *!*		 *:Inherits:
    *!*		 *:Exceptions:
    *!*		 *:NameSpace:
    *!*		 digitalizarte.com
    *!*		 *:EndHelp
    *!*			ENDTEXT
    *!*		#Endif

    *!*		If m.Logical.IsRunTime()
    *!*			tcDisplayClassLibrary = ''

    *!*		Else && m.Logical.IsRunTime()
    *!*			If ! Empty ( m.tcDisplayClassLibrary )
    *!*				If Upper ( Justext( m.tcDisplayClassLibrary ) ) # 'VCX'
    *!*					tcNewValue = m.tcDisplayClassLibrary + '.vcx'

    *!*				Endif && Upper( Justext( m.tcDisplayClassLibrary ) ) # "VCX"

    *!*			Endif && ! Empty( m.tcDisplayClassLibrary )

    *!*		Endif && m.Logical.IsRunTime()

    *!*		This.cDisplayClassLibrary = m.tcDisplayClassLibrary

    *!*	Endproc && DisplayClassLibrary_Assign

    * cKeyName_Access
    Protected Function cKeyName_Access() As String

        If Empty ( This.cKeyName )
            This.cKeyName = This.cCaption

        Endif && Empty ( This.cKeyName )

        Return This.cKeyName

    Endfunc && cKeyName_Access

    * Caption_Access
    Protected Function cCaption_Access() As String

        If Empty ( This.cCaption )
            This.cCaption = This.Name

        Endif && Empty ( This.cCaption )

        Return This.cCaption

    Endfunc && cCaption_Access

    * Caption_Access
    Protected Function cHeaderCaption_Access() As String

        If Empty ( This.cHeaderCaption )
            This.cHeaderCaption = This.cCaption

        Endif && Empty ( This.cHeaderCaption )

        Return This.cHeaderCaption

    Endfunc && cHeaderCaption_Access



    *
    *
    Protected Procedure cReferences_Access(  ) As String
        Local lcCommand As String

        Try

            lcCommand = ""
            If Empty( This.cReferences )
                This.cReferences = This.Name
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return This.cReferences

    Endproc && cReferences_Access


    * oCurrentControl_Access
    Protected Function oCurrentControl_Access() As Object

        Local lcCommand As String, ;
            loCurrentControl As Object, ;
            loErr As Exception, ;
            loError As 'ErrorHandler' Of 'ErrorHandler\Prg\ErrorHandler.prg'

        Try

            If Isnull( This.oCurrentControl )
                loCurrentControl = Createobject( 'Empty' )
                AddProperty( loCurrentControl, 'Name' )
                AddProperty( loCurrentControl, 'Class' )
                AddProperty( loCurrentControl, 'ClassLibrary' )
                This.oCurrentControl = loCurrentControl

            Endif && Isnull( This.oCurrentControl )

        Catch To loErr
            DEBUG_CLASS_EXCEPTION
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            m.loError.Process ( m.loErr )
            THROW_EXCEPTION

        Finally
            loCurrentControl = Null

        Endtry

        Return This.oCurrentControl

    Endfunc && oCurrentControl_Access




    * nLength_Assign

    Protected Procedure nLength_Assign( uNewValue )

        This.nLength = uNewValue

        Do Case
            Case Inlist ( Lower(This.cFieldType), 'i', 'int', 'integer', 'long' )
                This.cInputMask = ConvertInputMask ( This.nLength, 0, '#', .F. )
                This.nMaxValue 	= Val(Replicate( "9", This.nLength))
                This.nLowValue 	= 0


        Endcase

    Endproc && nLength_Assign



Enddefine && oField
