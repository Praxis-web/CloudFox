Lparameters oFoxcode

If oFoxcode.Location #1
	Return "_ECFG"
Endif

#Define CRLF Chr(13)+Chr(10)

oFoxcode.valuetype = "V"

Set Path To "v:\SistemasPraxisV2\FW\Comunes\prg\" Additive

Local lcProject As String
Local lcDataConfigurationKey As String
Local lcEntityName As String
Local lcBaseClass As String
Local lcAux As String


lcEntityName = Inputbox( "Nombre de la Entidad", "Entity Config" )
lcAux = lcEntityName


lcEntityName = Proper( lcEntityName  )
lcEntityName = Strtran( lcEntityName , " ", "" )
lcEntityName = Inputbox( "Nombre de la Entidad", "Entity Config", lcEntityName )

lcDataConfigurationKey = Inputbox( "Clave de Acceso (cDataConfigurationKey)", "Entity Config", lcAux )

lcDataConfigurationKey = Proper( lcDataConfigurationKey )
lcDataConfigurationKey = Strtran( lcDataConfigurationKey, " ", "" )
lcDataConfigurationKey = Inputbox( "Clave de Acceso (cDataConfigurationKey)", "Entity Config", lcDataConfigurationKey )


lcBaseClass = Inputbox( "Clase Base (Archivo, ChildEntity, ComprobanteCAB)", "Entity Config", "Archivo" )

lcBaseClass = Proper( lcBaseClass )
lcBaseClass = Strtran( lcBaseClass, " ", "" )
lcBaseClass = Inputbox( "Clase Base (Archivo, ChildEntity, ComprobanteCAB)", "Entity Config", lcBaseClass )


lcProject = Upper(Inputbox( "Nombre del Proyecto/Módulo", "Entity Config", "VENTAS" ))
lcProject = Upper( lcProject )
lcProject = Strtran( lcProject, " ", "_" )
lcProject = Upper(Inputbox( "Nombre del Proyecto/Módulo", "Entity Config", lcProject ))


TEXT TO myvar TEXTMERGE NOSHOW
*!* ///////////////////////////////////////////////////////
*!* Class.........: <<lcDataConfigurationKey>>
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Definición de las capas de la entidad <<lcDataConfigurationKey>>
*!* Date..........: <<DateMask(date())>> (<<time()>>)
*!* Author........: <<_USER>>
*!* Project.......: <<_PROJECTENV>>
*!* -------------------------------------------------------
*!*
*!*

Define Class <<lcDataConfigurationKey>> As Collection


	*!* Referencia a la colección TierConfig
	oColTiers = Null

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Init
	*!* Description...: Constructor
	*!* Date..........: <<DateMask(date())>> (<<time()>>)
	*!* Author........: <<_USER>>
	*!* Project.......: <<_PROJECTENV>>
	*!* -------------------------------------------------------
	*!*
	*!*

	Function Init(  ) As Boolean
		Try

			Local loColTierConfig As TierConfig Of "Fw\TierAdapter\Comun\TierConfig.prg"

			Local loTierObj As Object

			Local lcEntidad As String,;
				lcClaseBase as String

			lcEntidad = "<<lcEntityName>>"
			lcClaseBase = "<<lcBaseClass>>"

			loColTierConfig = Newobject("TierConfig","Fw\TierAdapter\Comun\TierConfig.prg")

			loTierObj = loColTierConfig.New( This.Name, "User" )
			loTierObj.cObjClass = "ut" + lcClaseBase
			loTierObj.cObjClassLibraryFolder = TA_USERTIER

			loTierObj = loColTierConfig.New( This.Name, "Service" )
			loTierObj.cObjClass = "st" + lcEntidad
			loTierObj.cObjClassLibraryFolder = <<lcProject>>_SERVICE
			loTierObj.cObjComponent = COM_<<lcProject>>
			loTierObj.lObjInComComponent = .T.


			loTierObj = loColTierConfig.New( This.Name, "Business" )
			loTierObj.cObjClass = "bt" + lcClaseBase
			loTierObj.cObjClassLibraryFolder = TA_BIZTIER
			loTierObj.cObjComponent = COM_TA
			loTierObj.lObjInComComponent = .T.

			loTierObj = loColTierConfig.New( This.Name, "Wrapper" )
			loTierObj.cObjClass = "bt" + lcClaseBase + "Wrapper"
			loTierObj.cObjClassLibraryFolder = TA_BIZTIER
			loTierObj.cObjComponent = COM_TA
			loTierObj.lObjInComComponent = .T.

			loTierObj = loColTierConfig.New( This.Name, "Data" )
			loTierObj.cObjClass = "dt" + lcClaseBase
			loTierObj.cObjClassLibraryFolder = TA_DATATIER
			loTierObj.cObjComponent = COM_TA
			loTierObj.lObjInComComponent = .T.

			This.oColTiers = loColTierConfig

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError


		Finally
			loColTierConfig = Null
			loTierObj = Null

		Endtry


	EndFunc && Init

EndDefine && <<lcDataConfigurationKey>>

ENDTEXT

Return myvar
