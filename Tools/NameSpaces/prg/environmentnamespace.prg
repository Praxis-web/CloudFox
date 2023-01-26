#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
	Do 'Tools\namespaces\prg\EnvLib.prg'
Endif

* EnvironmentNameSpace
Define Class EnvironmentNameSpace As NameSpaceBase Of 'Tools\namespaces\prg\ObjectNamespace.prg' 

	#If .F.
		Local This As EnvironmentNameSpace Of Tools\namespaces\prg\EnvironmentNameSpace.prg

	#Endif

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "setalternate" type = "method" display = "SetAlternate" />] ;
		+ [<memberdata name = "setansi" type = "method" display = "SetAnsi" />] ;
		+ [</VFPData>]

	* SetAlternate
	Function SetAlternate ( tcOnOff As String, tcTo As String, tcOption As String, tlNoReset As Boolean ) As SetAlternate Of 'Tools\namespaces\prg\EnvLib.prg'

		Try
			loRet = _Newobject ('SetAlternate', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcOnOff, m.tcTo, m.tcOption, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcOnOff, tcTo, tcOption, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetAlternate

	* SetAnsi
	Function SetAnsi ( tcValue As String, tlNoReset As Boolean ) As SetAnsi Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetAnsi', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetAnsi

	* SetAsserts
	Function SetAsserts ( tcValue As String, tlNoReset As Boolean ) As SetAsserts Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetAsserts', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetAsserts

	* SetAutoIncError
	Function SetAutoIncError ( tcValue As String, tlNoReset As Boolean ) As SetAutoIncError Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetAutoIncError', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetAutoIncError

	* SetAutosave
	Function SetAutosave ( tcValue, tlNoReset ) As SetAutosave Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetAutosave', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetAutosave

	* SetBell
	Function SetBell ( tcValue As String, tlNoReset As Boolean ) As SetBell Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetBell', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetBell

	* SetBlocksize
	Function SetBlocksize ( tnValue As Number, tlNoReset As Boolean ) As SetBlocksize Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetBlocksize', 'Tools\namespaces\prg\EnvLib.prg', '', m.tnValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetBlocksize

	* SetBrstatus
	Function SetBrstatus ( tcValue As String, tlNoReset As Boolean ) As SetBrstatus Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetBrstatus', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetBrstatus

	* SetCarry
	Function SetCarry ( tcValue As String, tlNoReset As Boolean ) As SetCarry Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetCarry', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetCarry

	* SetCentury
	Function SetCentury ( tcValue As String, tlNoReset As Boolean ) As SetCentury Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetCentury', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetCentury

	* SetClassLib
	Function SetClassLib ( tcValue As String, tcOption As String, tlNoReset As Boolean ) As SetClassLib Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetClassLib', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tcOption, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tcOption, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetClassLib

	* SetClear
	Function SetClear ( tcValue As String, tlNoReset As Boolean ) As SetClear Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetClear', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset  )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetClear

	* SetClock
	Function SetClock ( tcValue As String, tlNoReset As Boolean ) As SetClock Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetClock', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetClock

	* SetCollate
	Function SetCollate ( tnValue As Number, tlNoReset As Boolean ) As SetCollate Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetCollate', 'Tools\namespaces\prg\EnvLib.prg', '', m.tnValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetCollate

	* SetCoverage
	Function SetCoverage ( tcValue As String, tcOption As String, tlNoReset As Boolean ) As SetCoverage Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetCoverage', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tcOption, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tcOption , tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetCoverage

	* SetColor
	Function SetColor ( tcValue As String, tlNoReset As Boolean ) As SetColor Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetColor', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetColor

	* SetCompatible
	Function SetCompatible ( tcOnOff As String, tcPrompt As String, tlNoReset As Boolean ) As SetCompatible Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetCompatible', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcOnOff, m.tcPrompt, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcOnOff, tcPrompt, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetCompatible

	* SetConfirm
	Function SetConfirm ( tcValue As String, tlNoReset As Boolean ) As SetConfirm Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetConfirm', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetConfirm

	* SetConsole
	Function SetConsole ( tcValue As String,  tlNoReset As Boolean ) As SetConsole Of 'Tools\namespaces\prg\EnvLib.prg'

		Try

			loRet = _Newobject ( 'SetConsole', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetConsole

	* SetCpcompile
	Function SetCpcompile ( tnValue As Number, tlNoReset As Boolean ) As SetCpcompile Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetCpcompile', 'Tools\namespaces\prg\EnvLib.prg', '', m.tnValue, m.tlNoReset )

	Endfunc

	* SetCpdialog
	Function SetCpdialog ( tcValue As String, tlNoReset As Boolean ) As SetCpdialog Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetCpdialog', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetCurrency
	Function SetCurrency ( tcLeftRight As String, tcTo As String, tlNoReset As Boolean ) As SetCurrency Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetCurrency', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcLeftRight, m.tcTo, m.tlNoReset  )

	Endfunc

	* SetCursor
	Function SetCursor ( tcValue As String, tlNoReset As Boolean ) As SetCursor Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetCursor', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetDatabase
	Function SetDatabase ( tcValue As String, tlNoReset As Boolean ) As SetDatabase Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDatabase', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetDataSession
	Function SetDataSession ( tnValue As Number, tlNoReset As Boolean ) As SetDataSession Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDataSession', 'Tools\namespaces\prg\EnvLib.prg', '', m.tnValue, m.tlNoReset  )

	Endfunc

	* SetDate
	Function SetDate ( tcValue As String, tlNoReset As Boolean ) As SetDate Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDate', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetDebug
	Function SetDebug ( tcValue As String, tlNoReset As Boolean ) As SetDebug Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDebug', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetDebugout
	Function SetDebugout ( tcValue As String, tcOption As String, tlNoReset As Boolean ) As SetDebugout Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDebugout', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tcOption, m.tlNoReset )

	Endfunc

	* SetDecimals
	Function SetDecimals ( tnValue As Number, tlNoReset As Boolean ) As SetDecimals Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDecimals', 'Tools\namespaces\prg\EnvLib.prg', '', m.tnValue, m.tlNoReset )

	Endfunc

	* SetDefault
	Function SetDefault ( tcValue As String, tlNoReset As Boolean ) As SetDefault Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDefault', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetDeleted
	Function SetDeleted ( tcValue As String, tlNoReset As Boolean ) As SetDeleted Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDeleted', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetDelimiters
	Function SetDelimiters ( tcOnOff As String, tcDelimiter As String, tlNoReset As Boolean ) As SetDelimiters Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDelimiters', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcOnOff, m.tcDelimiter, m.tlNoReset )

	Endfunc

	* SetDevelopment
	Function SetDevelopment ( tcValue As String, tlNoReset As Boolean ) As SetDevelopment Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDevelopment', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetDisplay
	Function SetDisplay ( tnValue As Number, tlNoReset As Boolean ) As SetDisplay Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDisplay', 'Tools\namespaces\prg\EnvLib.prg', '', m.tnValue, m.tlNoReset )

	Endfunc

	* SetDohistory
	Function SetDohistory (  tcValue As String, tlNoReset As Boolean ) As SetDohistory Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetDohistory', 'Tools\namespaces\prg\EnvLib.prg', '',  m.tcValue, m.tlNoReset )

	Endfunc

	* SetEcho
	Function SetEcho ( tcValue As String, tlNoReset As Boolean ) As SetEcho Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetEcho', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetEngineBehavior
	Function SetEngineBehavior ( tcValue As String, tlNoReset As Boolean ) As SetEngineBehavior Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetEngineBehavior', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetEscape
	Function SetEscape ( tcValue As String, tlNoReset As Boolean ) As SetEscape Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetEscape', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetExact
	Function SetExact ( tcValue As String, tlNoReset As Boolean ) As SetExact Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetExact', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetExclusive
	Function SetExclusive ( tcValue As String, tlNoReset As Boolean ) As SetExclusive Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetExclusive', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetFdow
	Function SetFdow ( tnValue As Number, tlNoReset As Boolean ) As SetFdow Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetFdow', 'Tools\namespaces\prg\EnvLib.prg', '', m.tnValue, m.tlNoReset )

	Endfunc

	* SetFixed
	Function SetFixed ( tcValue As String, tlNoReset As Boolean ) As SetFixed Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetFixed', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetFullPath
	Function SetFullPath ( tcValue As String, tlNoReset As Boolean ) As SetFullPath Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetFullPath', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetFweek
	Function SetFweek ( tnValue As Number, tlNoReset As Boolean ) As SetFweek Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetFweek', 'Tools\namespaces\prg\EnvLib.prg', '', m.tnValue, m.tlNoReset )

	Endfunc

	* SetHeadings
	Function SetHeadings ( tcValue As String, tlNoReset As Boolean ) As SetHeadings Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetHeadings', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetHelp
	Function SetHelp ( tcOnOff As String, tcTo As String, tlNoReset As Boolean ) As SetHelp Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetHelp', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcOnOff, m.tcTo, m.tlNoReset )


	Endfunc

	* SetHelpfilter
	Function SetHelpfilter ( tcValue As String, tlNoReset As Boolean ) As SetHelpfilter Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetHelpfilter', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetHours
	Function SetHours ( tnValue As Number, tlNoReset As Boolean ) As SetHours Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetHours', 'Tools\namespaces\prg\EnvLib.prg', '', m.tnValue, m.tlNoReset )

	Endfunc

	* SetIntensity
	Function SetIntensity ( tcValue As String, tlNoReset As Boolean ) As SetIntensity Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetIntensity', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetKeycomp
	Function SetKeycomp ( tcValue As String, tlNoReset As Boolean ) As SetKeycomp Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetKeycomp', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetLibrary
	Function SetLibrary ( tcValue As String, tcOption As String, tlNoReset As Boolean ) As SetLibrary Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetLibrary', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tcOption, m.tlNoReset )

	Endfunc

	* SetLock
	Function SetLock ( tcValue As String, tlNoReset As Boolean ) As SetLock Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetLock', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset  )

	Endfunc

	* SetLogErrors
	Function SetLogErrors ( tcValue, tlNoReset ) As SetLogErrors Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetLogErrors', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset  )

	Endfunc

	* SetMargin
	Function SetMargin ( tnValue As Number, tlNoReset As Boolean ) As SetMargin Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetMargin', 'Tools\namespaces\prg\EnvLib.prg', '', m.tnValue, m.tlNoReset )

	Endfunc
	Function SetMackey ( ) As SetMackey Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetMackey', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetMark ( ) As SetMark Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetMark', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetMemoWidth ( ) As SetMemoWidth Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetMemoWidth', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetMessage ( ) As SetMessage Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetMessage', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetMultiLocks ( ) As SetMultiLocks Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetMultiLocks', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetNear ( ) As SetNear Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetNear', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetNotify ( ) As SetNotify Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetNotify', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetNull ( ) As SetNull Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetNull', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetNullDisplay ( ) As SetNullDisplay Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetNullDisplay', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetOdometer ( ) As SetOdometer Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetOdometer', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetOLEObject ( ) As SetOLEObject Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetOLEObject', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetOptimize ( ) As SetOptimize Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetOptimize', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetPalette ( ) As SetPalette Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetPalette', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	* SetPath
	Function SetPath ( tcValue As String, tcOption As String, tlNoReset As Boolean ) As SetPath Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetPath', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tcOption, m.tlNoReset )

	Endfunc
	Function SetPrinter ( ) As SetPrinter Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetPrinter', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetPoint ( ) As SetPoint Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetPoint', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	* SetProcedure
	Function SetProcedure ( tcValue As String, tcOption As String, tlNoReset As Boolean ) As SetProcedure Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetProcedure', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tcOption, m.tlNoReset )

	Endfunc

	Function SetReadBorder ( ) As SetReadBorder Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetReadBorder', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetRefresh ( ) As SetRefresh Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetRefresh', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetReprocess ( ) As SetReprocess Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetReprocess', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetResource ( ) As SetResource Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetResource', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetResourceCreate ( ) As SetResourceCreate Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetResourceCreate', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	* SetSafety
	Function SetSafety ( tcValue As String, tlNoReset As Boolean ) As SetSafety Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetSafety', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	Function SetSeconds ( ) As SetSeconds Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetSeconds', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetSeparator ( ) As SetSeparator Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetSeparator', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetSpace ( ) As SetSpace Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetSpace', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetStatus ( ) As SetStatus Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetStatus', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetStatusBar ( ) As SetStatusBar Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetStatusBar', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetStep ( ) As SetStep Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetStep', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetSysFormats ( ) As SetSysFormats Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetSysFormats', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetSysMenu ( ) As SetSysMenu Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetSysMenu', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetTableValidate ( ) As SetTableValidate Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetTableValidate', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetTalk ( ) As SetTalk Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetTalk', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetTopic ( ) As SetTopic Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetTopic', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetTrBetween ( ) As SetTrBetween Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetTrBetween', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetTypeahead ( ) As SetTypeahead Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetTypeahead', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetUdfParms ( ) As SetUdfParms Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetUdfParms', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetUnique ( ) As SetUnique Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetUnique', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetVarcharMapping ( ) As SetVarcharMapping Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetVarcharMapping', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	* SetView
	Function SetView ( tcValue, tlNoReset ) As SetView Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetView', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SetWindowOfMemo
	Function SetWindowOfMemo ( tcValue, tlNoReset ) As SetWindowOfMemo Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetWindowOfMemo', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	Function SetVfpDefaults ( ) As SetVfpDefaults Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetVfpDefaults', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	* OnError
	Function OnError ( tcValue As String, tlNoReset As Boolean ) As OnError Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('OnError', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* OnKey
	Function OnKey (  tcValue As String, tlNoReset As Boolean ) As OnKey Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('OnKey', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* OnKeyLabel
	Function OnKeyLabel ( tcLabel As String, tcValue As String, tlNoReset As Boolean ) As OnKeyLabel Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('OnKeyLabel', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcLabel, m.tcValue, m.tlNoReset )

	Endfunc

	* OnShutDown
	Function OnShutDown ( tcValue As String, tlNoReset As Boolean ) As OnShutDown Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('OnShutDown', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcValue, m.tlNoReset )

	Endfunc

	* SaveArea
	Function SaveArea ( tuArea As Variant ) As SaveArea Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SaveArea', 'Tools\namespaces\prg\EnvLib.prg', '', m.tuArea  )

	Endfunc

	Function SaveUsedArea ( ) As SaveUsedArea Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SaveUsedArea', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	Function SaveSelect ( ) As SaveSelect Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SaveSelect', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	* SetSelect
	* Selecciona el area nueva preservando la anterior seleccionada.
	Function SetSelect ( tcCursor As String ) As SetSelect Of 'Tools\namespaces\prg\EnvLib.prg' HelpString 'Selecciona el area nueva preservando la anterior seleccionada.'
		Return _Newobject ('SetSelect', 'Tools\namespaces\prg\EnvLib.prg', m.tcCursor )

	Endfunc

	Function SaveBuffering ( ) As SaveBuffering Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SaveBuffering', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetBuffering ( ) As SetBuffering Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetBuffering', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SaveRecno ( ) As SaveRecno Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SaveRecno', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SaveOrder ( ) As SaveOrder Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SaveOrder', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	* SetOrder
	Function SetOrder ( tuOrder, tuNewArea, tlDescending ) As SetOrder Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetOrder', 'Tools\namespaces\prg\EnvLib.prg', '', m.tuOrder, m.tuNewArea, m.tlDescending )

	Endfunc

	Function SaveFilter ( ) As SaveFilter Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SaveFilter', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc
	Function SetFilter ( ) As SetFilter Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetFilter', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	Function SaveRelation ( ) As SaveRelation Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SaveRelation', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	Function SetRelation ( ) As SetRelation Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetRelation', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	Function SaveTable ( ) As SaveTable Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SaveTable', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	Function SaveAllTables ( ) As SaveAllTables Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SaveAllTables', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	Function OpenAliasCheckpoint ( ) As OpenAliasCheckpoint Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('OpenAliasCheckpoint', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	Function SaveProperty ( ) As SaveProperty Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SaveProperty', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	Function SetProperty ( ) As SetProperty Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetProperty', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	Function SetSysVar ( ) As SetSysVar Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetSysVar', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	Function MessageTimer ( ) As MessageTimer Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('MessageTimer', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	Function SetLockScreen ( ) As SetLockScreen Of 'Tools\namespaces\prg\EnvLib.prg'
		Return _Newobject ('SetLockScreen', 'Tools\namespaces\prg\EnvLib.prg' )
	Endfunc

	* SetCursorProp
	Function SetCursorProp ( tcProp As String, tuValue As String, tvAlias As Variant, tlNoReset As Boolean ) As SetCursorProp Of 'Tools\namespaces\prg\EnvLib.prg'

		Try
			loRet = _Newobject ( 'SetCursorProp', 'Tools\namespaces\prg\EnvLib.prg', '', m.tcProp, m.tuValue, m.tvAlias, m.tlNoReset )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcProp, tuValue, tvAlias, tlNoReset
			THROW_EXCEPTION

		Endtry

		Return loRet

	Endfunc && SetCursorProp

Enddefine && EnvironmentNameSpace