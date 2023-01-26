#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
Endif

* IONameSpace
Define Class IONameSpace As Namespacebase Of 'Tools\namespaces\prg\objectnamespace.prg'

	#If .F.
		Local This As IONameSpace Of 'Tools\namespaces\prg\IONameSpace.prg'
	#Endif

	*-- XML Metadata for customizable properties
	Protected m._MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "addpath" type = "method" display = "AddPath" />] ;
		+ [<memberdata name = "backuprar" type = "method" display = "BackupRAR" />] ;
		+ [<memberdata name = "fileexists" type = "method" display = "FileExists" />] ;
		+ [<memberdata name = "filelegalname" type = "method" display = "FileLegalName" />] ;
		+ [<memberdata name = "flegalname" type = "method" display = "FLegalName" />] ;
		+ [</VFPData>]

	Dimension m.AddPath_COMATTRIB[ 5 ]
	AddPath_COMATTRIB[ 1 ] = 0
	AddPath_COMATTRIB[ 2 ] = 'Devuelve el PATH que tiene configurado la aplicación y agrega el path dado si este no estaba incluido.'
	AddPath_COMATTRIB[ 3 ] = 'AddPath'
	AddPath_COMATTRIB[ 4 ] = 'String'
	* AddPath_COMATTRIB[ 5 ] = 0

	* AddPath
	* Devuelve el PATH que tiene configurado la aplicación y agrega el path dado si este no estaba incluido.
	Function AddPath ( tcPath As String ) As String HelpString 'Devuelve el PATH que tiene configurado la aplicación y agrega el path dado si este no estaba incluido.'

		Local loErr As Object
		Try

			If Empty ( Atc ( m.tcPath, Set ( 'Path' ) ) )
				Set Path To Set ( 'Path' ) + ',' + m.tcPath

			Endif && Empty ( Atc ( m.tcPath, Set ( 'Path' ) ) )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcPath
			THROW_EXCEPTION

		Endtry

		Return Set ( 'Path' )

	Endfunc && AddPath

	Dimension BackupRAR_COMATTRIB[ 5 ]
	BackupRAR_COMATTRIB[ 1 ] = 0
	BackupRAR_COMATTRIB[ 2 ] = 'Comprime el directorio dado con el compresor rar.'
	BackupRAR_COMATTRIB[ 3 ] = 'BackupRAR'
	BackupRAR_COMATTRIB[ 4 ] = 'Void'
	* BackupRAR_COMATTRIB[ 5 ] = 0

	* BackupRAR
	* Comprime el directorio dado con el compresor rar.
	Procedure BackupRAR ( tcDir As String, tcDirToBck As String, tcBckName As String, tlBckAutoInc As Logical, tcPass As String ) As Void HelpString 'Comprime el directorio dado con el compresor rar.'

		Local lcBckDir As String, ;
			lcBckName As String, ;
			lcCmdExp As String, ;
			lcCommands As String, ;
			lcDir As String, ;
			lcDirToBck As String, ;
			lcFilecmdBck As String, ;
			lcNewDir As String, ;
			lcmsg As String, ;
			ldFecha As Date, ;
			llBckAutoInc As Boolean, ;
			lnRet As Number, ;
			loErr As Object, ;
			loSetDefault As Object

		Declare Integer ShellExecute In shell32.Dll Integer thndWin, String tcAction, String tcFileName, String tcParams, String tcDir, Integer tnShowWin

		Try
			lnRet = 0
			*
			If Vartype ( tcDir ) == 'C' And ! Empty ( tcDir ) And ! Isblank ( tcDir ) And Directory ( tcDir )
				lcDir = tcDir

			Else && Vartype ( tcDir ) == 'C' And ! Empty ( tcDir ) And ! Isblank ( tcDir ) And Directory ( tcDir )
				lcDir = Addbs ( Justpath ( Sys ( 16 ) ) )

			Endif && Vartype ( tcDir ) == 'C' And ! Empty ( tcDir ) And ! Isblank ( tcDir ) And Directory ( tcDir )

			If Vartype ( tcDirToBck ) == 'C' And ! Empty ( tcDirToBck ) And ! Isblank ( tcDirToBck ) And Directory ( tcDirToBck )
				lcDirToBck = tcDirToBck

			Else && Vartype ( tcDirToBck ) == 'C' And ! Empty ( tcDirToBck ) And ! Isblank ( tcDirToBck ) And Directory ( tcDirToBck )
				If Vartype ( tcDirToBck ) == 'C' And ! Empty ( tcDirToBck ) And ! Isblank ( tcDirToBck ) And Directory ( Addbs ( lcDir ) + tcDirToBck )
					lcDirToBck = tcDirToBck

				Else && Vartype ( tcDirToBck ) == 'C' And ! Empty ( tcDirToBck ) And ! Isblank ( tcDirToBck ) And Directory ( Addbs ( lcDir ) + tcDirToBck )
					lcDirToBck = Addbs ( Justpath ( Sys( 16 ) ) )

				Endif && Vartype ( tcDirToBck ) == 'C' And ! Empty ( tcDirToBck ) And ! Isblank ( tcDirToBck ) And Directory ( Addbs ( lcDir ) + tcDirToBck )

			Endif && Vartype ( tcDirToBck ) == 'C' And ! Empty ( tcDirToBck ) And ! Isblank ( tcDirToBck ) And Directory ( tcDirToBck )

			lcBckName = 'backup'

			If Vartype (tcBckName) = 'C' And !Empty (tcBckName) And ! Isblank (tcBckName)
				lcBckName = tcBckName

			Endif && Vartype (tcBckName) = 'C' And !Empty (tcBckName) And ! Isblank (tcBckName)

			llBckAutoInc = .F.
			If Vartype ( tlBckAutoInc ) == 'L'
				llBckAutoInc = tlBckAutoInc

			Endif && Vartype ( tlBckAutoInc ) == 'L'

			lcCommands = ' a -w' + lcDir + 'tmp -k -t -tk -r -s -md4096 -rr3%% -rv3%%  -v8192k -y -m5 '

			If Vartype ( tcPass ) == 'C' And ! Empty ( tcPass ) And ! Isblank ( tcPass )
				lcCommands = lcCommands + ' -p' + tcPass

			Endif && Vartype ( tcPass ) == 'C' And ! Empty ( tcPass ) And ! Isblank ( tcPass )

			If llBckAutoInc
				lcCommands = lcCommands + ' -ag+YYYYMMDD-NN '

			Endif && llBckAutoInc

			lcCommands = lcCommands + ' Backup\' + lcBckName + ' ' + lcDirToBck
			lcCommands = Strtran ( lcCommands, Space( 2 ), Space( 1 ), -1, -1, 1 )

			If ! Directory ( lcDir + 'Backup' )
				lcNewDir = '"' + lcDir + 'Backup' + '"'
				Mkdir &lcNewDir.

			Endif && ! Directory ( lcDir + 'Backup' )

			If ! Directory ( lcDir + 'tmp' )
				lcNewDir = '"' + lcDir + 'tmp' + '"'
				Mkdir &lcNewDir.

			Endif && ! Directory ( lcDir + 'tmp' )

			* Wait 'Se va a realizar el backup de la base de datos' Window Nowait
			Wait 'Se va a realizar el backup de los datos' Window Nowait
			lcDir = '"' + lcDir + '"'
			* Cd &lcDir.
			loSetDefault = m.Environment.SetDefault ( &lcDir. )

			lnRet = ShellExecute(0, 'Open', 'rar.exe', lcCommands, &lcDir., 0)
			lcmsg = ''
			Do Case
				Case lnRet = 255 && USER BREAK       User stopped the process
				Case lnRet = 9   && CREATE ERROR     Create file error
				Case lnRet = 8   && MEMORY ERROR     Not enough memory for operation
				Case lnRet = 7   && USER ERROR       Command line option error
				Case lnRet = 6   && OPEN ERROR       Open file error
				Case lnRet = 5   && WRITE ERROR      Write to disk error
					lcmsg = 'Ocurrio un error durante el proceso de backup' + CR ;
						+ 'Error de escritura en el disco' + CR ;
						+ 'Comuniquese con el administrador del sistema'
				Case lnRet = 4   && LOCKED ARCHIVE   Attempt to modify an archive previously locked by the 'k' command
					lcmsg = 'Ocurrio un error durante el proceso de backup' + CR ;
						+ 'Error: Intento modificar un archivo bloqueado' + CR ;
						+ 'Comuniquese con el administrador del sistema'
				Case lnRet = 3   && CRC ERROR        A CRC error occurred when unpacking
					lcmsg = 'Ocurrio un error durante el proceso de backup' + CR ;
						+ 'Error en la comprobación CRC' + CR ;
						+ 'Comuniquese con el administrador del sistema'
				Case lnRet = 2   && FATAL ERROR      A fatal error occurred
					lcmsg = 'Ocurrio un error durante el proceso de backup' + CR ;
						+ 'Error fatal, no se pudo terminar el proceso de backup' + CR ;
						+ 'Comuniquese con el administrador del sistema'
				Case lnRet = 1   && WARNING          Non fatal error(s) occurred
					lcmsg = 'Ocurrio un error durante el proceso de backup' + CR ;
						+ 'Error no fatal' + CR ;
						+ 'Comuniquese con el administrador del sistema'
				Case lnRet = 0   && SUCCESS          Successful operation
					lcmsg = 'Finalizo el proceso de backup correctamente'
			Endcase

			* lcCmdExp     = ''
			* lcFilecmdBck = Addbs (Justpath (Sys(16))) + 'backup.cmd'
			* ldFecha      = Date() - 1
			* lcCmdExp     = lcCmdExp + '@xcopy ' + '.\backup\ S:\ /v /i /y /c /D:' + Transform (Month (ldFecha), '@L 99') + '-' + Transform (Day (ldFecha), '@L 99') + '-' + Transform (Year (ldFecha), '@L 9999') + CR + Chr(10)

			* = Strtofile (lcCmdExp, lcFilecmdBck, 0)
			* lnRet = ShellExecute(0, 'Open', lcFilecmdBck, '', &lcDir, 0)

			If ! Empty ( lcmsg )
				Messagebox ( lcmsg, 64, _vfp.Caption )

			Endif && ! Empty (lcmsg)

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcDir, tcDirToBck, tcBckName, tlBckAutoInc, tcPass
			THROW_EXCEPTION

		Finally
			Clear Dlls ShellExecute
			loSetDefault = Null

		Endtry

	Endproc && BackupRAR

	Dimension FileExists_COMATTRIB[ 5 ]
	FileExists_COMATTRIB[ 1 ] = 0
	FileExists_COMATTRIB[ 2 ] = 'Devuleve .T. si existe el archivo que coincide con el patron de busqueda.'
	FileExists_COMATTRIB[ 3 ] = 'FileExists'
	FileExists_COMATTRIB[ 4 ] = 'Boolean'
	* FileExists_COMATTRIB[ 5 ] = 0

	* FileExists
	* Devuleve .T. si existe el archivo que coincide con el patron de busqueda.
	Function FileExists ( tcFileSkeleton As String ) As Boolean HelpString 'Devuleve .T. si existe el archivo que coincide con el patron de busqueda.'

		Local laDir[1], ;
			llExist As Boolean, ;
			loErr As Object

		Try

			llExist = ! Empty ( Adir ( laDir, m.tcFileSkeleton ) )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFileSkeleton
			THROW_EXCEPTION

		Endtry

		Return llExist

	Endfunc && FileExists

	Dimension FileLegalName_COMATTRIB[ 5 ]
	FileLegalName_COMATTRIB[ 1 ] = 0
	FileLegalName_COMATTRIB[ 2 ] = 'Devuelve un nombre de archivo valido.'
	FileLegalName_COMATTRIB[ 3 ] = 'FileLegalName'
	FileLegalName_COMATTRIB[ 4 ] = 'String'
	* FileLegalName_COMATTRIB[ 5 ] = 0

	* FileLegalName
	* Devuelve un nombre de archivo valido.
	Function FileLegalName ( tcExt As String, tcPath As String, tnLen As String, tcPref As String ) As String HelpString 'Devuelve un nombre de archivo valido.'

		***************************************************************************************
		Local lcChar As String, ;
			lcFILE As String, ;
			lnI As Number, ;
			loErr As Object

		Note: Devuelve un Nombre de archivo valido
		* tcPATH: Ruta del archivo
		* tcPREF: Prefijo del Archivo
		* tnLEN : Longitud del Nombre
		* tcEXT : Extension

		Try

			tcPath = m.Variant.DefaultValue ( 'tcPATH',  ' ' )
			tcPref = m.Variant.DefaultValue ( 'tcPREF',  '_' )
			tnLen  = m.Variant.DefaultValue ( 'tnLEN',  8 )
			tcExt  = Alltrim ( m.Variant.DefaultValue ( 'tcEXT',  '' ) )

			If ! Empty ( m.tcExt )
				tcExt = '.' + m.tcExt

			Endif && ! Empty ( m.tcEXT )

			If ! Empty ( m.tcPath )
				If Right ( m.tcPath, 1 ) # '\' And Right ( m.tcPath, 1 ) # ':'
					* m.tcPath = m.tcPath + '\'
					tcPath = Addbs ( m.tcPath )

				Endif && Right ( m.tcPath, 1 ) # '\' And Right ( m.tcPath, 1 ) # ':'

			Endif && ! Empty ( m.tcPath )

			tcPref = Alltrim ( Substr ( m.tcPref, 1, 2 ) )
			tcPath = Alltrim ( m.tcPath )
			tcExt  = Alltrim ( m.tcExt )

			*!*	Do While .T.
			*!*		m.lcFILE = Substr ( m.tcPREF + Sys ( 2015 ), 1, m.tnLEN )
			*!*		If ! File ( m.tcPath + m.lcFILE + m.tcEXT )
			*!*			Exit
			*!*		Endif && ! File ( m.tcPath + m.lcFILE + m.tcEXT )
			*!*	EndDo

			lcFILE = Substr ( m.tcPref + Sys ( 2015 ), 1, m.tnLen )
			Do While ! File ( m.tcPath + m.lcFILE + m.tcExt )
				lcFILE = Substr ( m.tcPref + Sys ( 2015 ), 1, m.tnLen )

			Enddo && ! File ( m.tcPath + m.lcFILE + m.tcExt )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcExt, tcPath, tnLen, tcPref
			THROW_EXCEPTION

		Endtry

		Retu m.tcPath + m.lcFILE + m.tcExt

	Endfunc && FileLegalName

	Dimension FLegalName_COMATTRIB[ 5 ]
	FLegalName_COMATTRIB[ 1 ] = 0
	FLegalName_COMATTRIB[ 2 ] = 'Devuelve un nombre de archivo valido.'
	FLegalName_COMATTRIB[ 3 ] = 'FLegalName'
	FLegalName_COMATTRIB[ 4 ] = 'String'
	* FLegalName_COMATTRIB[ 5 ] = 0

	* FLegalName
	* Devuelve un nombre de archivo valido.
	Function FLegalName ( tcExt As String, tcPath As String, tnLen As String, tcPref As String ) As String HelpString 'Devuelve un nombre de archivo valido.'

		Return This.FileLegalName ( m.tcExt, m.tcPath, m.tnLen, m.tcPref )

	Endfunc && FLegalName

Enddefine && IONameSpace