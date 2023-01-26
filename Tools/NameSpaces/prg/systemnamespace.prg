#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
Endif

#Define EWX_LOGOFF 		0
#Define EWX_SHUTDOWN 	1
#Define EWX_REBOOT 		2
#Define EWX_FORCE 		4

#Define PROCESS_TERMINATE  0x1

* SystemNameSpace
Define Class SystemNameSpace As Namespacebase Of 'Tools\namespaces\prg\objectnamespace.prg'

	#If .F.
		Local This As SystemNameSpace Of 'Tools\namespaces\prg\SystemNameSpace.prg'
	#Endif

	* Matriz con los procesos activos
	aProcesses[ 4, 1 ] = .F.

	*-- XML Metadata for customizable properties
	Protected m._MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>]  + ;
		[<VFPData>] + ;
		[<memberdata name = "exitwindows" type = "method" display = "ExitWindows" />]  + ;
		[<memberdata name = "launch" type = "method" display = "Launch" />] + ;
		[<memberdata name = "runshell" type = "method" display = "RunShell" />] + ;
		[<memberdata name="aprocesses" type="property" display="aProcesses" />] + ;
		[<memberdata name="aprocesses_access" type="method" display="aProcesses_Access" />] + ;
		[<memberdata name="loadprocesses" type="method" display="LoadProcesses" />] + ;
		[<memberdata name="killprocess" type="method" display="KillProcess" />] + ;
		[<memberdata name="apinumtostr" type="method" display="APINumtoStr" />] + ;
		[<memberdata name="apistrtonum" type="method" display="APIStrtoNum" />] + ;
		[</VFPData>]

	* ExitWindows
	Procedure ExitWindows ( tnAction As Integer ) As Void HelpString ''

		Local lnResult As Integer, ;
			loErr As Object

		#If .F.

			TEXT
				Cerrar todos los programas e iniciar la sesión como un usuario distinto.
				EWX_LOGOFF = 0

				Apagar el equipo .
				EWX_SHUTDOWN = 1

				Reiniciar el equipo.
				EWX_REBOOT = 2

				Forzar el apagado. Los ficheros abiertos se pueden perder.
				Las aplicaciones no preguntarán si se quieren guardar las modificaciones.
				EWX_FORCE = 4

			ENDTEXT

		#Endif

		Declare Integer ExitWindowsEx In 'user32.dll' Integer uFlags, Integer dwReserved

		Try

			If Empty ( tnAction )
				tnAction = EWX_LOGOFF

			Endif && Empty( tnAction )

			lnResult = ExitWindowsEx ( tnAction, 0 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Finally
			Clear Dlls ExitWindowsEx

		Endtry

		Return lnResult

	Endproc && ExitWindows

	* Launch
	* Ejecuta el formulario o prg.
	Procedure Launch ( tcTarget As String, tcParameters As String ) As Void HelpString 'Ejecuta el formulario o prg.'

		Local lcCommandLine As String, ;
			lcExtension As String, ;
			lcParameters As String, ;
			loErr As Exception

		Try

			lcExtension = Lower ( Justext ( tcTarget ) )

			If Empty ( lcExtension )
				lcExtension = 'scx'
				tcTarget    = Alltrim ( tcTarget ) + '.' + lcExtension

			Endif && Empty( lcExtension )

			If Empty ( tcParameters )
				lcParameters = ''

			Else && Empty( tcParameters )
				lcParameters = 'with ' + tcParameters

			Endif && Empty( tcParameters )

			Do Case
				Case lcExtension == 'prg'
					lcCommandLine = 'DO ( tcTarget ) ' + lcParameters

				Otherwise
					lcCommandLine = 'DO FORM ( tcTarget ) ' + lcParameters

			Endcase

			&lcCommandLine.

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcTarget, tcParameters
			THROW_EXCEPTION

		Endtry

	Endproc && Launch

	* RunShell
	Function RunShell ( tcFileName, tcCommandLine, tlWaitForCompletion, tnShowWindow ) As Variant

		Local loErr As Object, ;
			luRet As Variant
		Try
			luRet =  CreateProcess ( tcFileName, tcCommandLine, tlWaitForCompletion, tnShowWindow )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFileName, tcCommandLine, tlWaitForCompletion, tnShowWindow
			THROW_EXCEPTION

		Endtry

		Return luRet

	Endfunc && RunShell

	************************************************************************
	* wwAPI :: Createprocess
	****************************************
	***  Function: Calls the CreateProcess API to run a Windows application
	***    Assume: Gets around RUN limitations which has command line
	***            length limits and problems with long filenames.
	***            Can do everything EXCEPT REDIRECTION TO FILE!
	***      Pass: lcExe - Name of the Exe
	***            lcCommandLine - Any command line arguments
	***    Return: .t. or .f.
	************************************************************************
	Function CreateProcess ( tcExe, tcCommandLine, tnShowWindow, llWaitForCompletion)

		Local lcProcessInfo As String, ;
			lcStartupInfo As String, ;
			lhProcess, ;
			lnResult As Number
		*:Global cProcessInfo, ;
		cStartupInfo, ;
		hProcess

		Declare Integer CreateProcess In kernel32 As _CreateProcess ;
			String   lpApplicationName, ;
			String   lpCommandLine, ;
			Integer  lpProcessAttributes, ;
			Integer  lpThreadAttributes, ;
			Integer  bInheritHandles, ;
			Integer  dwCreationFlags, ;
			Integer  lpEnvironment, ;
			String   lpCurrentDirectory, ;
			String   lpStartupInfo, ;
			String @ lpProcessInformation


		lcProcessInfo = Replicate (Chr(0), 128)
		lcStartupInfo = m.This.GetStartupInfo ( tnShowWindow )

		If ! Empty ( tcCommandLine )
			tcCommandLine = ["] + tcExe + [" ] + tcCommandLine

		Else
			tcCommandLine = ''

		Endif

		lnResult  = _CreateProcess ( tcExe, tcCommandLine, 0, 0, 1, 0, 0,  Sys(5) + Curdir(), lcStartupInfo, @lcProcessInfo)
		lhProcess = m.This.CharToBin ( Substr ( lcProcessInfo, 1, 4 ) )

		If llWaitForCompletion
			#Define WAIT_TIMEOUT 0x00000102
			Declare Integer WaitForSingleObject In kernel32.Dll Integer hHandle, Integer dwMilliseconds

			Do While .T.
				*** Update every 100 milliseconds
				If WaitForSingleObject ( lhProcess, 100 ) # WAIT_TIMEOUT
					Exit

				Else
					DoEvents

				Endif

			Enddo

		Endif

		Declare Integer CloseHandle In kernel32.Dll  Integer hObject
		CloseHandle ( lhProcess )

		Return Iif ( lnResult == 1, .T., .F. )

	Endfunc && CreateProcess

	* GetStartupInfo
	Function GetStartupInfo ( tnShowWindow )
		Local lnFlags As Number
		* creates the STARTUP structure to specify main window
		* properties if a new window is created for a new process

		If Empty ( tnShowWindow )
			tnShowWindow = 1

		Endif

		*| typedef struct _STARTUPINFO {
		*| DWORD cb; 4
		*| LPTSTR lpReserved; 4
		*| LPTSTR lpDesktop; 4
		*| LPTSTR lpTitle; 4
		*| DWORD dwX; 4
		*| DWORD dwY; 4
		*| DWORD dwXSize; 4
		*| DWORD dwYSize; 4
		*| DWORD dwXCountChars; 4
		*| DWORD dwYCountChars; 4
		*| DWORD dwFillAttribute; 4
		*| DWORD dwFlags; 4
		*| WORD wShowWindow; 2
		*| WORD cbReserved2; 2
		*| LPBYTE lpReserved2; 4
		*| HANDLE hStdInput; 4
		*| HANDLE hStdOutput; 4
		*| HANDLE hStdError; 4
		*| } STARTUPINFO, *LPSTARTUPINFO; total: 68 bytes

		#Define STARTF_USESTDHANDLES 0x0100
		#Define STARTF_USESHOWWINDOW 1
		#Define SW_HIDE 0
		#Define SW_SHOWMAXIMIZED 3
		#Define SW_SHOWNORMAL 1

		lnFlags = STARTF_USESHOWWINDOW

		Return m.This.BinToChar(80) + ;
			m.This.BinToChar(0) + m.This.BinToChar(0) + m.This.BinToChar(0) + ;
			m.This.BinToChar(0) + m.This.BinToChar(0) + m.This.BinToChar(0) + m.This.BinToChar(0) + ;
			m.This.BinToChar(0) + m.This.BinToChar(0) + m.This.BinToChar(0) + ;
			m.This.BinToChar (lnFlags) + ;
			m.This.BinToWordChar ( tnShowWindow ) + ;
			m.This.BinToWordChar (0) + m.This.BinToChar(0) + ;
			m.This.BinToChar(0) + m.This.BinToChar(0) + m.This.BinToChar(0) + Replicate (Chr(0), 30)

	Endfunc && GetStartupInfo

	* CharToBin
	Function CharToBin ( tcBinString, tlSigned )
		****************************************
		***  Function: Binary Numeric conversion routine.
		***            Converts DWORD or Unsigned Integer string
		***            to Fox numeric integer value.
		***      Pass: lcBinString -  String that contains the binary data
		***            llSigned    -  if .T. uses signed conversion
		***                           otherwise value is unsigned (DWORD)
		***    Return: Fox number
		************************************************************************
		Local liIdx As Integer, ;
			lnWord As Number
		*:Global i

		lnWord = 0
		For liIdx = 1 To Len (tcBinString)
			lnWord = lnWord + ( Asc ( Substr ( tcBinString, m.liIdx, 1 ) ) * ( 2 ^ ( 8 * (m.liIdx - 1) ) ) )
		Endfor

		If tlSigned And lnWord > 0x80000000
			lnWord = lnWord - 1 - 0xFFFFFFFF

		Endif

		Return lnWord
		*  wwAPI :: CharToBin

	Endfunc && CharToBin

	* BinToChar
	Function BinToChar (lnValue)
		****************************************
		***  Function: Creates a DWORD value from a number
		***      Pass: lnValue - VFP numeric integer (unsigned)
		***    Return: binary string
		************************************************************************

		Local laByte[4]
		If lnValue < 0
			lnValue = lnValue + 4294967296

		Endif

		laByte[ 1 ] = lnValue % 256
		laByte[ 2 ] = Bitrshift (lnValue, 8) % 256
		laByte[ 3 ] = Bitrshift (lnValue, 16) % 256
		laByte[ 4 ] = Bitrshift (lnValue, 24) % 256
		Return Chr ( laByte[ 1 ] ) + Chr ( laByte[ 2 ]) + Chr ( laByte[ 3 ] ) + Chr ( laByte[ 4 ] )
		*  wwAPI :: BinToChar

	Endfunc && BinToChar

	************************************************************************
	Function BinToWordChar ( tnValue )
		****************************************
		***  Function: Creates a DWORD value from a number
		***      Pass: lnValue - VFP numeric integer (unsigned)
		***    Return: binary string
		************************************************************************
		Return Chr ( Mod ( m.tnValue, 256) ) + Chr (Int (m.tnValue / 256) )

		*!*	Some of that code originated from Christof Wollenhaupt with a number of
		*!*	modifications made to support wait operations and easier access to the command line parameters.

		*!*	To support piping etc. wwIPStuff.dll (part of West Wind Internet Protocols or West Wind Client Tools)
		*!*	includes a wrapper that does something like this:

	Endfunc

	************************************************************************
	* wwAPI :: CreateprocessEx
	****************************************
	***  Function: Calls the CreateProcess API to run a Windows application
	***    Assume: Gets around RUN limitations which has command line
	***            length limits and problems with long filenames.
	***            Can do Redirection
	***            Requires wwIPStuff.dll to run!
	***      Pass: lcExe - Name of the Exe
	***            lcCommandLine - Any command line arguments
	***    Return: .t. or .f.
	************************************************************************
	Function CreateProcessEx ( lcExe, lcCommandLine, lcStartDirectory, lnShowWindow, llWaitForCompletion, lcStdOutputFilename )

		Local lnResult As Number, ;
			lnWait As Number
		Declare Integer wwCreateProcess In wwIPStuff.Dll As _wwCreateProcess ;
			String lcExe, String lcCommandLine, Integer lnShowWindow, ;
			Integer llWaitForCompletion, String lcStartupDirectory, String StdOutFile

		If Empty (lcStdOutputFilename)
			lcStdOutputFilename = Null
		Endif
		If Empty (lcStartDirectory)
			lcStartDirectory = Chr(0)
		Endif

		If !Empty (lcCommandLine)
			lcCommandLine = ["] + lcExe + [" ] + lcCommandLine
		Else
			lcCommandLine = ''
		Endif

		If llWaitForCompletion
			lnWait = 1
		Else
			lnWait = 0
		Endif
		If Empty (lnShowWindow)
			lnShowWindow = 4
		Endif

		lnResult = _wwCreateProcess (lcExe, lcCommandLine, lnShowWindow, lnWait, lcStartDirectory, lcStdOutputFilename)

		Return Iif (lnResult == 1, .T., .F.)
	Endfunc

	* AbEnd
	Procedure AbEnd() As Void

		Local lnHProc As Number, ;
			lnHWnd As Number, ;
			lnProcId As Number, ;
			loErr As Object

		*!*	The main reason for this routine is the ability to write Standard output to a file.
		*!*	I use this in a number of applications like Help Builder for example, where I run the
		*!*	help compiler and need to capture the output from the execution of the compiler and display it later


		* Abend
		* Ejecutar una salida no programada (Abnormal End) de la aplicacion actual. Al invocarse
		* esta funcion la aplicacion actual finalizara inmediatamente.
		*
		* Perform an Abnormal End of the current application. When this function is called the
		* current application will be terminated immediately.
		*
		* http://www.victorespina.com.ve/wiki/index.php?title=Finalizar_la_aplicacion_actual_mediante_un_Abend_%28VFP%29

		Try
			* API Declaration
			Declare Integer GetWindowThreadProcessId In user32 Integer HWnd, Integer@ nProcID
			Declare Integer GetActiveWindow In user32
			Declare Integer OpenProcess In kernel32 Integer dwDesiredAccess, Integer blnheritHandle, Integer dwAppProcessId
			Declare Integer TerminateProcess In kernel32 Integer nPID, Integer exitcode
			Declare Integer CloseHandle In kernel32 Integer hObject

			* Get current app's HWnd
			If '06.' $ Version()
				lnHWnd = GetActiveWindow()

			Else && '06.' $ Version()
				lnHWnd = _Screen.HWnd

			Endif && '06.' $ Version()

			* Get app's process ID
			lnProcId = 0
			GetWindowThreadProcessId ( lnHWnd, @lnProcId )

			* Close all open tables, cursors and ODBC connections
			Close Database All
			SQLDisconnect(0)

			* Kill app's process
			Store 0 To lnHProc
			lnHProc = OpenProcess(1, 0, lnProcId)
			If lnHProc > 0
				TerminateProcess ( lnHProc, 0 )
				CloseHandle ( lnHProc )

			Endif && lnHProc > 0

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry
		*
	Endproc && AbEnd


	*
	* aProcesses_Access
	Protected Procedure aProcesses_Access()

		*		If Isnull( This.aProcesses )
		Local Array laProcesses( 1, 4 )
		Local lnProcesses As Integer,;
			i As Integer

		Local lcCommand As String

		Try

			lcCommand = ""
			Dimension laProcesses[ 1 ]

			lnProcesses = This.LoadProcesses( @laProcesses )

			If lnProcesses > 0

				*!*						Dimension This.aProcesses[ lnProcesses, 4 ]
				*!*						Acopy( laProcesses, This.aProcesses )
				This.aProcesses = laProcesses
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		*Endif

		Return This.aProcesses

	Endproc && aProcesses_Access



	*
	* Carga los procesos activos
	Procedure LoadProcesses( laProcesses ) As Void;
			HELPSTRING "Carga los procesos activos"
		Local lcCommand As String,;
			lcBaseProcess As String,;
			lcProcess As String,;
			lcNombre As String

		Local lnCount As Integer,;
			lnSnapShot As Integer,;
			lnRes As Integer,;
			lnProcessID As Integer,;
			lnThreads As Integer,;
			lnParentProcessID  As Integer

		Try

			lcCommand = ""

			#Define TH32CS_SNAPHEAPLIST   0x1
			#Define TH32CS_SNAPPROCESS    0x2
			#Define TH32CS_SNAPTHREAD     0x4
			#Define TH32CS_SNAPMODULE     0x8
			#Define TH32CS_SNAPALL        Bitor(Bitor(Bitor(0x1, 0x2), 0x4), 0x8)
			#Define TH32CS_INHERIT        0x80000000
			#Define MAX_PATH              260


			Declare Long CreateToolhelp32Snapshot In Win32API Long nFlags, Long nID
			Declare Integer Process32First In Win32API Long nHandle, String @lcProcess
			Declare Integer Process32Next In Win32API Long nHandle, String @lcProcess
			Declare Integer CloseHandle In Win32API Long nHandle


			lcBaseProcess = ""
			lcBaseProcess = lcBaseProcess + This.APINumtoStr(0, 4)
			lcBaseProcess = lcBaseProcess + This.APINumtoStr(0, 4)
			lcBaseProcess = lcBaseProcess + This.APINumtoStr(0, 4)
			lcBaseProcess = lcBaseProcess + This.APINumtoStr(0, 4)
			lcBaseProcess = lcBaseProcess + This.APINumtoStr(0, 4)
			lcBaseProcess = lcBaseProcess + This.APINumtoStr(0, 4)
			lcBaseProcess = lcBaseProcess + This.APINumtoStr(0, 4)
			lcBaseProcess = lcBaseProcess + This.APINumtoStr(0, 4)
			lcBaseProcess = lcBaseProcess + Space(MAX_PATH)
			lcBaseProcess = This.APINumtoStr(Len(lcBaseProcess) + 4, 4) + lcBaseProcess


			lcProcess = lcBaseProcess
			lnSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0)
			lnRes = Process32First(lnSnapShot, @lcProcess)
			lnCount = 0

			Do While lnRes <> 0
				lcNombre = Lower( Alltrim( Strtran( Right( lcProcess, 260), Chr(0), "")))
				lnProcessID = This.APIStrtoNum(Substr(lcProcess, 9, 4))
				lnThreads = This.APIStrtoNum(Substr(lcProcess, 21, 4))
				lnParentProcessID = This.APIStrtoNum(Substr(lcProcess, 25, 4))

				lnCount = lnCount + 1
				Dimension laProcesses[lnCount, 4]
				laProcesses[lnCount, 1] = lcNombre
				laProcesses[lnCount, 2] = lnProcessID
				laProcesses[lnCount, 3] = lnThreads
				laProcesses[lnCount, 4] = lnParentProcessID

				If Val(Os(3)) >= 5
					lcProcess = lcBaseProcess
				Endif

				lnRes = Process32Next(lnSnapShot, @lcProcess)
			Enddo

			CloseHandle(lnSnapShot)

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lnCount

	Endproc && LoadProcesses


	*
	*
	Procedure KillProcess( nID As Integer ) As Integer
		Local lcCommand As String
		Local lnHandle As Integer,;
			lnReturn As Integer

		Try

			lcCommand = ""
			lnReturn = 0

			Declare Long OpenProcess In Win32API Long DesiredAccess, Long InheritHandle, Long ProcId
			Declare Long TerminateProcess In Win32API Long hProcess, Long uExitCode
			Declare Integer CloseHandle In Win32API Long nHandle

			lnHandle = OpenProcess( PROCESS_TERMINATE, 0, nID )

			If lnHandle <> 0
				lnReturn = TerminateProcess( lnHandle, 0 )
			Endif

			CloseHandle( lnHandle )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lnReturn

	Endproc && KillProcess

	*
	*
	Procedure APINumtoStr( lnNum As Integer, lnLength As Integer ) As String
		Local lcCommand As String,;
			lcRes As String

		Local i As Integer,;
			lnTmp As Integer,;
			lnMax As Integer

		Try

			lcCommand = ""

			lnMax = (256 ^ lnLength) - 1

			If lnNum < 0
				lnNum = (2 ^ (lnLength * 8)) + lnNum
			Endif

			lnNum = Bitand(lnNum, lnMax)

			lcRes = ""
			For i = (lnLength - 1) To 0 Step -1
				lnTmp = Int(lnNum / 256 ^ i)
				lnNum = lnNum - lnTmp * (256 ^ i)
				lcRes = Chr(lnTmp) + lcRes
			Next

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lcRes

	Endproc && APINumtoStr



	*
	*
	Procedure APIStrtoNum( lcNumber As String ) As Integer
		Local lcCommand As String
		Local lnRes As Integer , ;
			lnCont As Integer , ;
			lnLength As Integer , ;
			lcTmp As Integer , ;
			lnPower As Integer

		Try

			lcCommand = ""


			lnRes = 0
			lnLength = Len(lcNumber)
			lnPower = 1

			For lnCont = 1 To lnLength
				nTmp = Asc(Substr(lcNumber, lnCont, 1))
				lnRes = lnRes + (nTmp * lnPower)
				lnPower = lnPower * 256
			Next



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lnRes

	Endproc && APIStrtoNum


Enddefine && SystemNameSpace
