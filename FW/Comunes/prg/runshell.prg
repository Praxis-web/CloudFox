Lparameters cFileName, cCommandLine, lWaitForCompletion, nShowWindow

Return CreateProcess( cFileName, cCommandLine, nShowWindow, lWaitForCompletion )


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
Function CreateProcess(lcExe,lcCommandLine,lnShowWindow,llWaitForCompletion)

	Local hProcess, cProcessInfo, cStartupInfo

	Declare Integer CreateProcess In kernel32 As _CreateProcess;
		STRING   lpApplicationName,;
		STRING   lpCommandLine,;
		INTEGER  lpProcessAttributes,;
		INTEGER  lpThreadAttributes,;
		INTEGER  bInheritHandles,;
		INTEGER  dwCreationFlags,;
		INTEGER  lpEnvironment,;
		STRING   lpCurrentDirectory,;
		STRING   lpStartupInfo,;
		STRING @ lpProcessInformation


	cProcessInfo = Replicate(Chr(0),128)
	cStartupInfo = GetStartupInfo(lnShowWindow)

	If !Empty(lcCommandLine)
		lcCommandLine = ["] + lcExe + [" ]+ lcCommandLine
	Else
		lcCommandLine = ""
	Endif

	lnResult =  _CreateProcess(lcExe,lcCommandLine,0,0,1,0,0,;
		SYS(5)+Curdir(),cStartupInfo,@cProcessInfo)

	lhProcess = CHARTOBIN( Substr(cProcessInfo,1,4) )


	If llWaitForCompletion
		#Define WAIT_TIMEOUT 0x00000102
		Declare Integer WaitForSingleObject In kernel32.Dll ;
			INTEGER hHandle, Integer dwMilliseconds

		Do While .T.
			*** Update every 100 milliseconds
			If WaitForSingleObject(lhProcess, 100) != WAIT_TIMEOUT
				Exit
			Else
				DoEvents
			Endif
		Enddo
	Endif


	Declare Integer CloseHandle In kernel32.Dll ;
		INTEGER hObject

	CloseHandle(lhProcess)

	Return Iif(lnResult=1,.T.,.F.)

Function GetStartupInfo(lnShowWindow)
	Local lnFlags
	* creates the STARTUP structure to specify main window
	* properties if a new window is created for a new process

	If Empty(lnShowWindow)
		lnShowWindow = 1
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

	Return binToChar(80) +;
		binToChar(0) + binToChar(0) + binToChar(0) +;
		binToChar(0) + binToChar(0) + binToChar(0) + binToChar(0) +;
		binToChar(0) + binToChar(0) + binToChar(0) +;
		binToChar(lnFlags) +;
		binToWordChar(lnShowWindow) +;
		binToWordChar(0) + binToChar(0) +;
		binToChar(0) + binToChar(0) + binToChar(0) + Replicate(Chr(0),30)

	************************************************************************
Function CHARTOBIN(lcBinString,llSigned)
	****************************************
	***  Function: Binary Numeric conversion routine.
	***            Converts DWORD or Unsigned Integer string
	***            to Fox numeric integer value.
	***      Pass: lcBinString -  String that contains the binary data
	***            llSigned    -  if .T. uses signed conversion
	***                           otherwise value is unsigned (DWORD)
	***    Return: Fox number
	************************************************************************
	Local m.i, lnWord

	lnWord = 0
	For m.i = 1 To Len(lcBinString)
		lnWord = lnWord + (Asc(Substr(lcBinString, m.i, 1)) * (2 ^ (8 * (m.i - 1))))
	Endfor

	If llSigned And lnWord > 0x80000000
		lnWord = lnWord - 1 - 0xFFFFFFFF
	Endif

	Return lnWord
	*  wwAPI :: CharToBin

	************************************************************************
Function binToChar(lnValue)
	****************************************
	***  Function: Creates a DWORD value from a number
	***      Pass: lnValue - VFP numeric integer (unsigned)
	***    Return: binary string
	************************************************************************
	Local byte(4)
	If lnValue < 0
		lnValue = lnValue + 4294967296
	Endif
	byte(1) = lnValue % 256
	byte(2) = Bitrshift(lnValue, 8) % 256
	byte(3) = Bitrshift(lnValue, 16) % 256
	byte(4) = Bitrshift(lnValue, 24) % 256
	Return Chr(byte(1))+Chr(byte(2))+Chr(byte(3))+Chr(byte(4))
	*  wwAPI :: BinToChar

	************************************************************************
Function binToWordChar(lnValue)
	****************************************
	***  Function: Creates a DWORD value from a number
	***      Pass: lnValue - VFP numeric integer (unsigned)
	***    Return: binary string
	************************************************************************
	Return Chr(Mod(m.lnValue,256)) + Chr(Int(m.lnValue/256))

	*!*	Some of that code originated from Christof Wollenhaupt with a number of
	*!*	modifications made to support wait operations and easier access to the command line parameters.

	*!*	To support piping etc. wwIPStuff.dll (part of West Wind Internet Protocols or West Wind Client Tools)
	*!*	includes a wrapper that does something like this:

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
Function CreateProcessEx(lcExe,lcCommandLine,lcStartDirectory,;
		lnShowWindow,llWaitForCompletion,lcStdOutputFilename)

	Declare Integer wwCreateProcess In wwIPStuff.Dll As _wwCreateProcess  ;
		String lcExe, String lcCommandLine, Integer lnShowWindow,;
		INTEGER llWaitForCompletion, String lcStartupDirectory, String StdOutFile

	If Empty(lcStdOutputFilename)
		lcStdOutputFilename = Null
	Endif
	If Empty(lcStartDirectory)
		lcStartDirectory = Chr(0)
	Endif

	If !Empty(lcCommandLine)
		lcCommandLine = ["] + lcExe + [" ]+ lcCommandLine
	Else
		lcCommandLine = ""
	Endif

	If llWaitForCompletion
		lnWait = 1
	Else
		lnWait = 0
	Endif
	If Empty(lnShowWindow)
		lnShowWindow = 4
	Endif

	lnResult = _wwCreateProcess(lcExe,lcCommandLine,lnShowWindow,lnWait,;
		lcStartDirectory,lcStdOutputFilename)

	Return Iif(lnResult == 1, .T. , .F.)
Endfunc

*!*	The main reason for this routine is the ability to write Standard output to a file.
*!*	I use this in a number of applications like Help Builder for example, where I run the
*!*	help compiler and need to capture the output from the execution of the compiler and display it later
