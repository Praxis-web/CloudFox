* Program: EnvLib.prg
* Classes: Many definitions, see below.
*   Bases: All abstract classes are based on Custom.
*  Notice: The author releases all rights to the public domain
*        : subject to the Warranty Disclaimer below.
*  Author: Tom Rettig
*        : Rettig Micro Corporation
*        : First released (Version 1.0) July 15, 1995
* Updates: Steven Black
*        : Steven Black Consulting
*        : http://stevenblack.com
* Version: EnvLib for VFP 9, Beta 0.1, February 5, 2012
*  Action: Save, set, and restore SET, ON, open table, system variable,
*        :    and object property environments.
*   Usage: See Env.doc for examples.
*Requires: Visual FoxPro for Windows version 3.0 or later
*   Notes: - May be freely used, modified, and distributed in
*        : compiled and/or source code form.
*        : - The author appreciates acknowledgment in commercial
*        : products and publications that use or learn from this class.
*        : - Technical support is not officially provided.  The
*        : author is very interested in hearing about problems
*        : or enhancement requests you have, and will try to be
*        : helpful within reasonable limits.  Email or fax preferred.
*        : - Warranty Disclaimer: NO WARRANTY!!!
*        : THE AUTHOR RELEASES TO THE PUBLIC DOMAIN ALL CLAIMS TO ANY
*        : RIGHTS IN THIS PROGRAM AND FREELY PROVIDES IT “AS IS” WITHOUT
*        : WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, INCLUDING, BUT NOT
*        : LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*        : FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL THE AUTHOR, OR ANY
*        : OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE THIS PROGRAM, BE
*        : LIABLE FOR ANY COMMERCIAL, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
*        : DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM
*        : INCLUDING, BUT NOT LIMITED TO, LOSS OF DATA OR DATA BEING
*        : RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR LOSSES
*        : SUSTAINED BY THIRD PARTIES OR A FAILURE OF THE PROGRAM TO
*        : OPERATE WITH ANY OTHER PROGRAMS, EVEN IF YOU OR OTHER PARTIES
*        : HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

*************************************************************
* SET Parent Classes
*************************************************************

*------------------------------------------------------------------------------
Define Class Set As Custom  && abstract class
	*------------------------------------------------------------------------------
	Protected uDefault
	Protected uOldSet
	Protected uNewSet
	Protected lNoReset

	Function GetOld()
		Return This.uOldSet

	Endfunc

	Function GetNew()
		Return This.uNewSet

	Endfunc

	Function GetDefault()
		Return This.uDefault

	Endfunc

	Protected Procedure Init ( tcSet As String, tuValue As Variant )

		This.uOldSet = Set ( m.tcSet )
		This.uNewSet = Nvl ( m.tuValue, This.uDefault )

	Endproc

Enddefine


*------------------------------------------------------------------------------
Define Class SetTwo As Set   && abstract class
	*------------------------------------------------------------------------------
	Protected uDefaultTwo
	Protected uOldSetTwo
	Protected uNewSetTwo
	Protected cSet

	Function GetOldTwo()
		Return This.uOldSetTwo

	Endfunc

	Function GetNewTwo()
		Return This.uNewSetTwo

	Endfunc

	Function GetDefaultTwo()
		Return This.uDefaultTwo

	Endfunc

	Protected Procedure Init ( tcSet, tuValueOne, tuValueTwo, tnParams )
		Do Case  && of which to set
			Case Empty ( m.tnParams )
				Error 11  &&  was: cnVF_ERR_PARAM_INVALID
				Return .F.  && early exit

			Case tnParams == 1
				This.cSet = '1'

			Case Empty ( m.tuValueOne )  && never a valid value
				This.cSet = '2'

			Otherwise
				This.cSet = '3'

		Endcase  && of which to set

		* Primary value as returned by SET( "whatever" ).
		If Inlist ( This.cSet, '1', '3' )
			= DoDefault ( m.tcSet, m.tuValueOne )

		Endif

		* Secondary value as returned by SET( "whatever", 1 ).
		If Inlist ( This.cSet, '2', '3' )

			This.uOldSetTwo = Set ( m.tcSet, 1 )
			This.uNewSetTwo = Nvl ( m.tuValueTwo, This.uDefaultTwo )

		Endif

	Endproc

Enddefine

*------------------------------------------------------------------------------
Define Class SetOnOff As Set   && abstract class
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tcSet, tcValue )
		Do Case
			Case Isnull ( m.tcValue )
				= DoDefault ( m.tcSet, m.tcValue )

			Case ! Inlist ( Upper ( Alltrim ( m.tcValue )), 'ON', 'OFF' )
				Error 231  &&  was: cnVF_ERR_SETARGINVALID
				Return .F.  && early exit

			Otherwise
				= DoDefault ( m.tcSet, Upper ( Alltrim ( m.tcValue )) )
		Endcase

	Endproc

Enddefine


*------------------------------------------------------------------------------
Define Class SetOnOffTwo As SetTwo   && abstract class
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tcSet, tcValueOne, tuValueTwo, tnParams )
		Do Case
			Case Isnull ( tcValueOne )
				= DoDefault ( m.tcSet, tcValueOne,  m.tuValueTwo, m.tnParams )

			Case ! Inlist ( Upper ( Alltrim ( m.tcValueOne ) ), 'ON', 'OFF' )
				Error 231  &&  was: cnVF_ERR_SETARGINVALID
				Return .F.  && early exit

			Otherwise
				= DoDefault ( m.tcSet, Upper ( Alltrim ( m.tcValueOne )), m.tuValueTwo, m.tnParams )
		Endcase

	Endproc

Enddefine


*************************************************************
* SET Classes
*************************************************************

*------------------------------------------------------------------------------
Define Class SetAlternate As SetOnOffTwo
	*------------------------------------------------------------------------------
	uDefault    = 'OFF'
	uDefaultTwo = ''

	Protected Procedure Init ( tcOnOff, tcTo, tcOption, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif

		Do Case  && of primary set
			Case ! DoDefault ( 'ALTERNATE', tcOnOff, tcTo, Parameters() )
				Return .F.  && early exit
			Case ! Inlist ( This.cSet, '1', '3' )
				* Do nothing.
			Case This.uNewSet == 'ON'
				Set Alternate On
			Otherwise
				Set Alternate Off
		Endcase  && of primary set

		Do Case  && of secondary set
			Case ! Inlist ( This.cSet, '2', '3' )
				* Do nothing.
			Case Empty ( This.uNewSetTwo )
				Set Alternate To
			Case ( ! Empty ( tcOption )) And ;
					Upper ( Alltrim ( tcOption )) == 'ADDITIVE'
				Set Alternate To ( This.uNewSetTwo ) Additive
				If This.uNewSet == 'ON'
					Set Alternate On
				Endif
			Otherwise
				Set Alternate To ( This.uNewSetTwo )
				If This.uNewSet == 'ON'
					Set Alternate On
				Endif
		Endcase  && of secondary set
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Do Case  && of primary set
				Case ! Inlist ( This.cSet, '1', '3' )
					* Do nothing.
				Case This.uOldSet == 'ON'
					Set Alternate On
				Otherwise
					Set Alternate Off
			Endcase  && of primary set

			Do Case  && of secondary set
				Case ! Inlist ( This.cSet, '2', '3' )
					* Do nothing.
				Case Empty ( This.uOldSetTwo )
					Set Alternate To
				Otherwise
					Set Alternate To ( This.uOldSetTwo )
			Endcase  && of secondary set
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetAnsi As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'ANSI', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Ansi On
			Otherwise
				Set Ansi Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Ansi On
			Otherwise
				Set Ansi Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetAsserts As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'Asserts', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Asserts On
			Otherwise
				Set Asserts Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Asserts On
			Otherwise
				Set Asserts Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetAutoIncError As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'AutoIncError', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Autoincerror On
			Otherwise
				Set Autoincerror Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Autoincerror On
			Otherwise
				Set Autoincerror Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetAutosave As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'AUTOSAVE', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Autosave On
			Otherwise
				Set Autosave Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Autosave On
			Otherwise
				Set Autosave Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetBell As SetOnOff
	*------------------------------------------------------------------------------
	* Limit - no way to get SET BELL TO <freq|.wav>, <sec>
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'BELL', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Bell On
			Otherwise
				Set Bell Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Bell On
			Otherwise
				Set Bell Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetBlocksize As Set
	*------------------------------------------------------------------------------
	uDefault = 64

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'BLOCKSIZE', tnValue )
			Set Blocksize To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Blocksize To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetBrstatus As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'BRSTATUS', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Brstatus On
			Otherwise
				Set Brstatus Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Brstatus On
			Otherwise
				Set Brstatus Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetCarry As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'CARRY', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Carry On
			Otherwise
				Set Carry Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Carry On
			Otherwise
				Set Carry Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetCentury As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'CENTURY', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Century On
			Otherwise
				Set Century Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Century On
			Otherwise
				Set Century Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetClassLib As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tcOption, tlNoReset )
		Local lcTemp As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'CLASSLIB', tcValue )
			lcTemp = This.uNewSet
			If ( ! Empty ( tcOption )) And ;
					( Upper ( Alltrim ( tcOption )) = 'ADDITIVE' )
				Set Classlib To &lcTemp Additive
			Else
				Set Classlib To &lcTemp
			Endif
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTemp As String
		If ! This.lNoReset
			lcTemp = This.uOldSet
			Set Classlib To &lcTemp
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetClear As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'CLEAR', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Clear On
			Otherwise
				Set Clear Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Clear On
			Otherwise
				Set Clear Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetClock As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'CLOCK', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Clock On
			Case This.uNewSet == 'STATUS'
				Set Clock Status
			Otherwise
				Set Clock Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Clock On
			Case This.uOldSet == 'STATUS'
				Set Clock Status
			Otherwise
				Set Clock Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetCollate As Set
	*------------------------------------------------------------------------------
	uDefault = 'MACHINE'

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'COLLATE', tnValue )
			Set Collate To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Collate To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetCoverage As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tcOption, tlNoReset )
		Local lcTemp As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'Coverage', tcValue )
			lcTemp = This.uNewSet
			If ( ! Empty ( tcOption )) And ;
					( Upper ( Alltrim ( tcOption )) = 'ADDITIVE' )
				Set Coverage To &lcTemp Additive
			Else
				Set Coverage To &lcTemp
			Endif
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTemp As String
		If ! This.lNoReset
			lcTemp = This.uOldSet
			Set Coverage To &lcTemp
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetColor As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'COLOR', tcValue )
			Set Color To ( This.uNewSet )
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Color To ( This.uOldSet )
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetCompatible As SetOnOffTwo
	*------------------------------------------------------------------------------
	uDefault    = 'OFF'
	uDefaultTwo = 'PROMPT'

	Protected Procedure Init ( tcOnOff, tcPrompt, tlNoReset )
		Local lcOnOff As String, ;
			lcPrompt As String
		If tlNoReset
			This.lNoReset = .T.
		Endif

		lcOnOff  = Iif ( Isnull ( tcOnOff ), tcOnOff, Upper ( Alltrim ( tcOnOff )) )
		lcPrompt = Iif ( Isnull ( tcPrompt ), tcPrompt, Upper ( Alltrim ( tcPrompt )) )
		Do Case
			Case Parameters() > 1 And Empty ( tcOnOff )
				lcOnOff = Set ( 'COMPATIBLE' )
			Case lcOnOff == 'FOXPLUS'
				lcOnOff = 'OFF'
			Case lcOnOff == 'DB4'
				lcOnOff = 'ON'
		Endcase

		Do Case  && of primary set
			Case ! DoDefault ( 'COMPATIBLE', ;
					lcOnOff, lcPrompt, ;
					Parameters() )
				Return .F.  && early exit
			Case ! This.cSet == '1'
				* Do nothing.
			Case This.uNewSet == 'ON'
				Set Compatible On
			Otherwise
				Set Compatible Off
		Endcase  && of primary set

		Do Case  && of secondary set
			Case ! Inlist ( This.cSet, '2', '3' )
				* Do nothing.
			Case This.uNewSetTwo == 'PROMPT'
				If This.uNewSet == 'ON'
					Set Compatible On Prompt
				Else
					Set Compatible Off Prompt
				Endif
			Case This.uNewSetTwo == 'NOPROMPT'
				If This.uNewSet == 'ON'
					Set Compatible On Noprompt
				Else
					Set Compatible Off Noprompt
				Endif
			Otherwise
				Error 231  &&  was: cnVF_ERR_SETARGINVALID
				Return .F.  && early exit
		Endcase  && of secondary set
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Do Case  && of primary set
				Case ! This.cSet == '1'
					* Do nothing.
				Case This.uOldSet == 'ON'
					Set Compatible On
				Otherwise
					Set Compatible Off
			Endcase  && of primary set

			Do Case  && of secondary set
				Case ! Inlist ( This.cSet, '2', '3' )
					* Do nothing.
				Case This.uOldSetTwo == 'NOPROMPT'
					If This.uOldSet == 'ON'
						Set Compatible On Noprompt
					Else
						Set Compatible Off Noprompt
					Endif
				Otherwise
					If This.uOldSet == 'ON'
						Set Compatible On Prompt
					Else
						Set Compatible Off Prompt
					Endif
			Endcase  && of secondary set
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetConfirm As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'CONFIRM', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Confirm On
			Otherwise
				Set Confirm Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Confirm On
			Otherwise
				Set Confirm Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetConsole As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'CONSOLE', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Console On
			Otherwise
				Set Console Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Console On
			Otherwise
				Set Console Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetCpcompile As Set
	*------------------------------------------------------------------------------
	uDefault = Cpcurrent()

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'CPCOMPILE', tnValue )
			Set Cpcompile To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Cpcompile To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetCpdialog As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'CPDIALOG', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Cpdialog On
			Otherwise
				Set Cpdialog Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Cpdialog On
			Otherwise
				Set Cpdialog Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetCurrency As SetTwo
	*------------------------------------------------------------------------------
	uDefault    = 'LEFT'
	uDefaultTwo = '$'

	Protected Procedure Init ( tcLeftRight, tcTo, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif

		Do Case  && of primary set
			Case ! DoDefault ( 'CURRENCY', ;
					Iif ( Isnull ( tcLeftRight ), ;
					tcLeftRight, ;
					Upper ( Alltrim ( tcLeftRight )) ), ;
					tcTo, ;
					Parameters() )
			Case ! Inlist ( This.cSet, '1', '3' )
				* Do nothing.
			Case ! Inlist ( This.uNewSet, 'LEFT', 'RIGHT' )
				Error 231  &&  was: cnVF_ERR_SETARGINVALID
				Return .F.  && early exit
			Case This.uNewSet == 'LEFT'
				Set Currency Left
			Otherwise
				Set Currency Right
		Endcase  && of primary set

		* Secondary set.
		If Inlist ( This.cSet, '2', '3' )
			Set Currency To ( This.uNewSetTwo )
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Do Case  && of primary set
				Case ! Inlist ( This.cSet, '1', '3' )
					* Do nothing.
				Case This.uOldSet == 'LEFT'
					Set Currency Left
				Otherwise
					Set Currency Right
			Endcase  && of primary set

			* Secondary set.
			If Inlist ( This.cSet, '2', '3' )
				Set Currency To ( This.uOldSetTwo )
			Endif
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetCursor As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'CURSOR', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Cursor On
			Otherwise
				Set Cursor Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Cursor On
			Otherwise
				Set Cursor Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetDatabase As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'DATABASE', tcValue )
				Return .F.  && early exit
			Case Empty ( This.uNewSet )
				Set Database To
			Otherwise
				Set Database To ( This.uNewSet )
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case Empty ( This.uOldSet )
				Set Database To
			Otherwise
				Set Database To ( This.uOldSet )
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetDataSession As Set
	*------------------------------------------------------------------------------
	uDefault = 1

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'DATASESSION', tnValue )
			If ! Empty ( tnValue )
				Set DataSession To This.uNewSet
			Endif
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set DataSession To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetDate As Set
	*------------------------------------------------------------------------------
	uDefault = 'AMERICAN'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'DATE', tcValue )
			Set Date To ( This.uNewSet )
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Date To ( This.uOldSet )
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetDebug As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'DEBUG', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Debug On
			Otherwise
				Set Debug Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Debug On
			Otherwise
				Set Debug Off
		Endcase
	Endproc
Enddefine

*------------------------------------------------------------------------------
Define Class SetDebugout  As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tcOption, tlNoReset )
		Local lcTemp As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'Debugout', tcValue )
			lcTemp = This.uNewSet
			If ( ! Empty ( tcOption )) And ;
					( Upper ( Alltrim ( tcOption )) = 'ADDITIVE' )
				Set Debugout  To &lcTemp Additive
			Else
				Set Debugout  To &lcTemp
			Endif
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTemp As String
		If ! This.lNoReset
			lcTemp = This.uOldSet
			Set Debugout  To &lcTemp
		Endif
	Endproc
Enddefine

*------------------------------------------------------------------------------
Define Class SetDecimals As Set
	*------------------------------------------------------------------------------
	uDefault = 2

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'DECIMALS', tnValue )
			Set Decimals To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Decimals To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetDefault As Set
	*------------------------------------------------------------------------------
	uDefault = Sys ( 5 ) + Curdir()

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .F.   && Note: this is different than some other classes here.
		Endif

		This.uOldSet = Sys ( 5 ) + Curdir()
		This.uNewSet = Evl ( tcValue, This.uDefault )
		Cd ( This.uNewSet )
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Cd ( This.uOldSet )
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetDeleted As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'DELETED', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Deleted On
			Otherwise
				Set Deleted Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Deleted On
			Otherwise
				Set Deleted Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetDelimiters As SetOnOffTwo
	*------------------------------------------------------------------------------
	uDefault    = 'OFF'
	uDefaultTwo = ':'

	Protected Procedure Init ( tcOnOff, tcDelimiter, tlNoReset )
		Local lcDelimiter As String, ;
			lcOnOff As String
		If tlNoReset
			This.lNoReset = .T.
		Endif

		lcOnOff  = Iif ( Isnull ( tcOnOff ), tcOnOff, Upper ( Alltrim ( tcOnOff )) )
		lcDelimiter = Nvl ( tcDelimiter, '' )
		If Parameters() > 1 And Empty ( tcOnOff )
			lcOnOff = Set ( 'DELIMITERS' )
		Endif

		Do Case  && of primary set
			Case ! DoDefault ( 'DELIMITERS', ;
					lcOnOff, lcDelimiter, ;
					Parameters() )
				Return .F.  && early exit
			Case ! This.cSet == '1'
				* Do nothing.
			Case This.uNewSet == 'ON'
				Set Delimiters On
			Otherwise
				Set Delimiters Off
		Endcase  && of primary set

		If ! Empty ( lcDelimiter )
			Set Delimiters To lcDelimiter
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset

			Do Case  && of primary set
				Case ! Inlist ( This.cSet, '1', '3' )
					* Do nothing.
				Case This.uOldSet == 'ON'
					Set Delimiters On
				Otherwise
					Set Delimiters Off
			Endcase  && of primary set

			Do Case  && of secondary set
				Case ! Inlist ( This.cSet, '2', '3' )
					* Do nothing.
				Case ! Empty ( This.uOldSetTwo )
					Set Delimiters To ( This.uOldSetTwo )
				Otherwise
					If This.uOldSet == 'ON'
						Set Delimiters On
					Else
						Set Delimiters Off
					Endif
			Endcase  && of secondary set
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetDevelopment As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'DEVELOPMENT', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Development On
			Otherwise
				Set Development Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Development On
			Otherwise
				Set Development Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetDisplay As Set
	*------------------------------------------------------------------------------
	uDefault = 'VGA25'

	Protected Procedure Init ( tnValue, tlNoReset )
		Local lcTemp As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'DISPLAY', tnValue )
			lcTemp = This.uNewSet
			Set Display To &lcTemp
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTemp As String
		If ! This.lNoReset
			lcTemp = This.uOldSet
			Set Display To &lcTemp
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetDohistory As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'DOHISTORY', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Dohistory On
			Otherwise
				Set Dohistory Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Dohistory On
			Otherwise
				Set Dohistory Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetEcho As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'ECHO', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Echo On
			Otherwise
				* Must RELEASE WINDOW TRACE to set ECHO OFF
				Release Window TRACE
				Set Echo Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Echo On
			Otherwise
				* Must RELEASE WINDOW TRACE to set ECHO OFF
				Release Window TRACE
				Set Echo Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetEngineBehavior As Set
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'EngineBehavior', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == '70'
				Set EngineBehavior 70
			Case This.uNewSet == '80'
				Set EngineBehavior 80
			Case This.uNewSet == '90'
				Set EngineBehavior 90
			Otherwise
				Set EngineBehavior 90
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == '70'
				Set EngineBehavior 70
			Case This.uOldSet == '80'
				Set EngineBehavior 80
			Case This.uOldSet == '90'
				Set EngineBehavior 90
			Otherwise
				Set EngineBehavior 90
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetEscape As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'ESCAPE', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Escape On
			Otherwise
				Set Escape Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Escape On
			Otherwise
				Set Escape Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetExact As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'EXACT', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Exact On
			Otherwise
				Set Exact Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Exact On
			Otherwise
				Set Exact Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetExclusive As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'EXCLUSIVE', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Exclusive On
			Otherwise
				Set Exclusive Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Exclusive On
			Otherwise
				Set Exclusive Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetFdow As Set
	*------------------------------------------------------------------------------
	uDefault = 1

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'FDOW', tnValue )
			Set Fdow To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Fdow To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetFixed As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'FIXED', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Fixed On
			Otherwise
				Set Fixed Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Fixed On
			Otherwise
				Set Fixed Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetFullPath As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'FULLPATH', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Fullpath On
			Otherwise
				Set Fullpath Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Fullpath On
			Otherwise
				Set Fullpath Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetFweek As Set
	*------------------------------------------------------------------------------
	uDefault = 1

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'FWEEK', tnValue )
			Set Fweek To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Fweek To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetHeadings As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'HEADINGS', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Headings On
			Otherwise
				Set Headings Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Headings On
			Otherwise
				Set Headings Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetHelp As SetOnOffTwo
	*------------------------------------------------------------------------------
	uDefault    = 'ON'
	uDefaultTwo = ''

	Protected Procedure Init ( tcOnOff, tcTo, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif

		Do Case  && of primary set
			Case ! DoDefault ( 'HELP', ;
					tcOnOff, tcTo, ;
					Parameters() )
				Return .F.  && early exit
			Case ! Inlist ( This.cSet, '1', '3' )
				* Do nothing.
			Case This.uNewSet == 'ON'
				Set Help On
			Otherwise
				Set Help Off
		Endcase  && of primary set

		Do Case  && of secondary set
			Case ! Inlist ( This.cSet, '2', '3' )
				* Do nothing.
			Case Empty ( This.uNewSetTwo )
				Set Help To
			Otherwise
				Set Help To ( This.uNewSetTwo )
		Endcase  && of secondary set
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Do Case  && of primary set
				Case ! Inlist ( This.cSet, '1', '3' )
					* Do nothing.
				Case This.uOldSet == 'ON'
					Set Help On
				Otherwise
					Set Help Off
			Endcase  && of primary set

			Do Case  && of secondary set
				Case ! Inlist ( This.cSet, '2', '3' )
					* Do nothing.
				Case Empty ( This.uOldSetTwo )
					Set Help To
				Otherwise
					Set Help To ( This.uOldSetTwo )
			Endcase  && of secondary set
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetHelpfilter As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tlNoReset )
		Local lcTemp As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'HELPFILTER', tcValue )
			lcTemp = This.uNewSet
			Set Helpfilter To &lcTemp
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTemp As String
		If ! This.lNoReset
			lcTemp = This.uOldSet
			Set Helpfilter To &lcTemp
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetHours As Set
	*------------------------------------------------------------------------------
	uDefault = 12

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'HOURS', tnValue )
				* No op?
			Case Isnull ( This.uNewSet ) Or Empty ( This.uNewSet )
				Set Hours To  && will default to 12
				* SET HOURS ignores decimals, i.e. 12.5 is legal
			Case ! Type ( 'This.uNewSet' ) = 'N' Or ;
					! Inlist ( Int ( This.uNewSet ), 12, 24 )
				Error 231  &&  was: cnVF_ERR_SETARGINVALID
				Return .F.  && early exit
			Otherwise
				Set Hours To This.uNewSet
		Endcase
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			* SET( "hours" ) can only return 12 or 24 - never EMPTY()
			Set Hours To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetIntensity As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'INTENSITY', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Intensity On
			Otherwise
				Set Intensity Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Intensity On
			Otherwise
				Set Intensity Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetKeycomp As Set
	*------------------------------------------------------------------------------
	* Cannot initialize uDefault in the class body because DO CASE
	* logic is invalid here.  Done at start of Init instead.

	Protected Procedure Init ( tcValue, tlNoReset )
		Do Case
			Case _Windows
				This.uDefault = 'WINDOWS'
			Case _Mac
				This.uDefault = 'MAC'
			Case _Dos
				This.uDefault = 'DOS'
			Otherwise  && should never happen
				Error 'Unknown operating system'
		Endcase
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'KEYCOMP', tcValue )
				Return .F.
			Case ! Inlist ( Upper ( This.uNewSet ), 'DOS', 'WIND', ;
					'WINDO', 'WINDOW', 'WINDOWS' )
				Error 231  &&  was: cnVF_ERR_SETARGINVALID
				Return .F.  && early exit
			Case 'DOS' $ This.uNewSet
				Set Keycomp To Dos
			Otherwise
				Set Keycomp To Windows
		Endcase
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			If 'DOS' $ This.uOldSet
				Set Keycomp To Dos
			Else
				Set Keycomp To Windows
			Endif
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetLibrary As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tcOption, tlNoReset )
		Local lcTemp As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'LIBRARY', tcValue )
			lcTemp = This.uNewSet
			If ( ! Empty ( tcOption )) And ;
					( Upper ( Alltrim ( tcOption )) = 'ADDITIVE' )
				Set Library To &lcTemp Additive
			Else
				Set Library To &lcTemp
			Endif
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTemp As String
		If ! This.lNoReset
			lcTemp = This.uOldSet
			Set Library To &lcTemp
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetLock As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'LOCK', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Lock On
			Otherwise
				Set Lock Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Lock On
			Otherwise
				Set Lock Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetLogErrors As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'LOGERRORS', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Logerrors On
			Otherwise
				Set Logerrors Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Logerrors On
			Otherwise
				Set Logerrors Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetMargin As Set
	*------------------------------------------------------------------------------
	uDefault = 0

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		* VFP sets a maximum of 256 when given a higher number.
		If DoDefault ( 'MARGIN', Min ( 256, Nvl ( tnValue, This.uDefault )) )
			Set Margin To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Margin To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetMackey As Set
	*------------------------------------------------------------------------------
	uDefault = 'SHIFT+F10'

	Protected Procedure Init ( tcValue, tlNoReset )
		Local lcTemp As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'MACKEY', tcValue )
			lcTemp = This.uNewSet
			Set Mackey To &lcTemp
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTemp As String
		If ! This.lNoReset
			lcTemp = This.uOldSet
			Set Mackey To &lcTemp
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetMark As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'MARK', tcValue )
			Set Mark To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Mark To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetMemoWidth As Set
	*------------------------------------------------------------------------------
	uDefault = 50

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		* VFP sets a maximum of 8192 when given a higher number.
		If DoDefault ( 'MEMOWIDTH', Min ( 8192, Nvl ( tnValue, This.uDefault )) )
			Set Memowidth To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Memowidth To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetMessage As SetTwo
	*------------------------------------------------------------------------------
	uDefaultTwo = ''  && using #2 for SET( ... , 1 ) to save

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'MESSAGE', , tcValue, 2 )
			If Empty ( This.uNewSetTwo )
				Set Message To
			Else
				Set Message To This.uNewSetTwo
			Endif
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			If Empty ( This.uOldSetTwo )
				Set Message To
			Else
				Set Message To This.uOldSetTwo
			Endif
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetMultiLocks As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'MULTILOCKS', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Multilocks On
			Otherwise
				Set Multilocks Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Multilocks On
			Otherwise
				Set Multilocks Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetNear As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'NEAR', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Near On
			Otherwise
				Set Near Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Near On
			Otherwise
				Set Near Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetNotify As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'NOTIFY', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Notify On
			Otherwise
				Set Notify Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Notify On
			Otherwise
				Set Notify Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetNull As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'NULL', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Null On
			Otherwise
				Set Null Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Null On
			Otherwise
				Set Null Off
		Endcase
	Endproc
Enddefine

*------------------------------------------------------------------------------
Define Class SetNullDisplay As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'NULLDISPLAY', tcValue )
			Set NullDisplay To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set NullDisplay To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetOdometer As Set
	*------------------------------------------------------------------------------
	uDefault = 100

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'ODOMETER', tnValue )
			Set Odometer To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Odometer To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetOLEObject As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'OLEOBJECT', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Oleobject On
			Otherwise
				Set Oleobject Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Oleobject On
			Otherwise
				Set Oleobject Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetOptimize As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'OPTIMIZE', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Optimize On
			Otherwise
				Set Optimize Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Optimize On
			Otherwise
				Set Optimize Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetPalette As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'PALETTE', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Palette On
			Otherwise
				Set Palette Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Palette On
			Otherwise
				Set Palette Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetPath As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tcOption, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'PATH', tcValue )
			If ( ! Empty ( tcOption )) And Upper ( Alltrim ( tcOption )) == 'ADDITIVE'
				Set Path To ( This.uNewSet ) Additive
			Else
				Set Path To ( This.uNewSet )
			Endif
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Path To ( This.uOldSet )
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetPrinter As SetOnOffTwo
	*------------------------------------------------------------------------------
	* Limit: No way to get SET PRINTER FONT|STYLE settings
	* or COM port settings.
	uDefault    = 'OFF'
	uDefaultTwo = ''

	Protected Procedure Init ( tcOnOff, tcTo, tcOption, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif

		Do Case  && of primary set
			Case ! DoDefault ( 'PRINTER', ;
					tcOnOff, tcTo, ;
					Parameters() )
				Return .F.  && early exit
			Case ! Inlist ( This.cSet, '1', '3' )
				* Do nothing.
			Case This.uNewSet == 'ON'
				Set Printer On
			Otherwise
				Set Printer Off
		Endcase  && of primary set

		Do Case  && of secondary set
			Case ! Inlist ( This.cSet, '2', '3' )
				* Do nothing.
			Case Empty ( This.uNewSetTwo ) Or This.uOldSetTwo == 'PRN'
				Set Printer To
			Case ( ! Empty ( tcOption )) And ;
					Upper ( Alltrim ( tcOption )) == 'ADDITIVE'
				Set Printer To &tcTo Additive
			Otherwise  && macros used to enable setting COM port specs
				Set Printer To &tcTo
		Endcase  && of secondary set
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Do Case  && of primary set
				Case ! Inlist ( This.cSet, '1', '3' )
					* Do nothing.
				Case This.uOldSet == 'ON'
					Set Printer On
				Otherwise
					Set Printer Off
			Endcase  && of primary set

			Do Case  && of secondary set
				Case ! Inlist ( This.cSet, '2', '3' )
					* Do nothing.
				Case Empty ( This.uOldSetTwo ) Or This.uOldSetTwo == 'PRN'
					Set Printer To
				Otherwise  && macro won't help here
					Set Printer To ( This.uOldSetTwo )
			Endcase  && of secondary set
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetPoint As Set
	*------------------------------------------------------------------------------
	uDefault = '.'

	Protected Procedure Init ( tcValue, tlNoReset )
		Local lcTemp As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'POINT', tcValue )
			lcTemp = This.uNewSet
			Set Point To &lcTemp
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTemp As String
		If ! This.lNoReset
			lcTemp = This.uOldSet
			Set Point To &lcTemp
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetProcedure As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tcOption, tlNoReset )
		Local lcTemp As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'PROCEDURE', tcValue )
			If Empty ( This.uNewSet )
				Set Procedure To
			Else
				lcTemp = This.uNewSet
				If ( ! Empty ( tcOption )) And ;
						( Upper ( Alltrim ( tcOption )) = 'ADDITIVE' )
					Set Procedure To &lcTemp Additive
				Else
					Set Procedure To &lcTemp
				Endif
			Endif
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTemp As String
		If ! This.lNoReset
			lcTemp = This.uOldSet
			Set Procedure To &lcTemp
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetReadBorder As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'READBORDER', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Readborder On
			Otherwise
				Set Readborder Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Readborder On
			Otherwise
				Set Readborder Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetRefresh As SetTwo
	*------------------------------------------------------------------------------
	uDefault    = 0
	uDefaultTwo = 5

	Protected Procedure Init ( tnEditSeconds, tnBufferSeconds, tlNoReset )
		Local lnTemp As Number
		If tlNoReset
			This.lNoReset = .T.
		Endif

		*-- Bounds for the first parameter is 0...3600
		If Vartype ( tnEditSeconds ) # 'N'
			tnEditSeconds= This.uDefault
		Endif
		tnEditSeconds= Min ( Max ( tnEditSeconds, 0 ), 3600 )

		If Vartype ( tnBufferSeconds ) # 'N'
			tnEditSeconds= This.uDefaultTwo
		Endif
		tnEditSeconds= Min ( Max ( tnEditSeconds, -1 ), 3600 )

		Do Case
			Case ! DoDefault ( 'REFRESH', tnEditSeconds, ;
					tnBufferSeconds, Parameters() )
				* Do nothing.
			Case ! Inlist ( This.cSet, '1', '3' )
				* Do nothing.
			Case Isnull ( tnEditSeconds ) And Isnull ( tnBufferSeconds )
				* Do nothing.
			Case tnEditSeconds < 0 Or tnBufferSeconds < 0
				Error 231  &&  was: cnVF_ERR_SETARGINVALID
				Return .F.  && early exit
			Case tnEditSeconds >= 0 And tnBufferSeconds >= 0
				* Set both
				Set Refresh To tnEditSeconds, tnBufferSeconds
			Case tnEditSeconds >= 0
				* Set first only
				Set Refresh To tnEditSeconds
			Case tnBufferSeconds >= 0
				* Must set both to set the second
				lnTemp = Set ( 'REFRESH' )
				Set Refresh To lnTemp, tnBufferSeconds
			Otherwise
				Error 'CASE...OTHERWISE: Unexpected.'
		Endcase
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Do Case
				Case This.uOldSet >= 0 And This.uOldSetTwo >= 0
					* Set both
					Set Refresh To This.uOldSet, This.uOldSetTwo
				Case This.uOldSet >= 0
					* Set first only
					Set Refresh To This.uOldSet
				Otherwise
					Error 'CASE...OTHERWISE: Unexpected.'
			Endcase
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetReprocess As Set
	*------------------------------------------------------------------------------
	* If the old set is to <n> SECONDS, it will be reset as just <n>
	* because DISPLAY STATUS is the only way in VFP to detect when set
	* to SECONDS.

	uDefault = 0

	Protected cType

	Protected Procedure Init ( tuValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		This.cType = Type ( 'tuValue' )
		Do Case
			Case Isnull ( tuValue )
				= DoDefault ( 'REPROCESS', tuValue )
			Case ( ! This.cType $ 'CN' ) Or ;
					( ! DoDefault ( 'REPROCESS', ;
					Iif ( This.cType == 'C', ;
					Upper ( Alltrim ( tuValue )), ;
					tuValue )) )
				Error 231  &&  was: cnVF_ERR_SETARGINVALID
				Return .F.  && early exit
			Case This.cType == 'C'
				Do Case
					Case This.uNewSet == 'AUTOMATIC'
						Set Reprocess To Automatic
					Case Right ( This.uNewSet, 7 ) == 'SECONDS'
						Set Reprocess To Val ( This.uNewSet ) Seconds
					Otherwise
						Error 231  &&  was: cnVF_ERR_SETARGINVALID
						Return .F.  && early exit
				Endcase
			Otherwise
				Set Reprocess To This.uNewSet
		Endcase
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Reprocess To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetResource As SetOnOffTwo
	*------------------------------------------------------------------------------
	uDefault    = 'ON'
	uDefaultTwo = ''

	Protected Procedure Init ( tcOnOff, tcTo, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif

		* SET RESOURCE TO is first because it also sets it ON.
		Do Case  && of secondary set
			Case ! DoDefault ( 'RESOURCE', ;
					tcOnOff, tcTo, ;
					Parameters() )
				Return .F.  && early exit
			Case ! Inlist ( This.cSet, '2', '3' )
				* Do nothing.
			Case Empty ( This.uNewSetTwo )
				Set Resource To
			Otherwise
				Set Resource To ( This.uNewSetTwo )
		Endcase  && of secondary set

		Do Case  && of primary set
			Case ! Inlist ( This.cSet, '1', '3' )
				* Do nothing.
			Case This.uNewSet == 'ON'
				Set Resource On
			Otherwise
				Set Resource Off
		Endcase  && of primary set
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			* SET RESOURCE TO is first because it also sets it ON.
			Do Case  && of secondary set
				Case ! Inlist ( This.cSet, '2', '3' )
					* Do nothing.
				Case Empty ( This.uOldSetTwo )
					Set Resource To
				Otherwise
					Set Resource To ( This.uOldSetTwo )
			Endcase  && of secondary set

			Do Case  && of primary set
				Case ! Inlist ( This.cSet, '1', '3' )
					* Do nothing.
				Case This.uOldSet == 'ON'
					Set Resource On
				Otherwise
					Set Resource Off
			Endcase  && of primary set
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetResourceCreate As SetResource
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tcOnOff, tcTo, tlNoReset )
		Local lcTo As String
		lcTo = Iif ( Empty ( tcTo ), ;
			Home() + 'FoxUser.dbf', ;
			Trim ( tcTo ) + Iif ( '.' $ tcTo, '', '.dbf' ))
		If ! ( File ( lcTo ) Or This.CreateResource ( lcTo ))
			Return .F.
		Else
			Return DoDefault ( tcOnOff, tcTo, tlNoReset )
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTo As String
		If ( ! This.lNoReset ) And Inlist ( This.cSet, '2', '3' )
			lcTo = Iif ( Empty ( This.uOldSetTwo ), ;
				Home() + 'FoxUser.dbf', ;
				Trim ( This.uOldSetTwo ) + Iif ( '.' $ This.uOldSetTwo, ;
				'', '.dbf' ))
			If ! ( File ( lcTo ) Or This.CreateResource ( lcTo ))
				Return
			Else
				DoDefault()
			Endif
		Endif
	Endproc

	Protected Function CreateResource ( tcTable )
		Local llReturn As Boolean, ;
			loSaveSelect As Object
		loSaveSelect = Createobject ( 'SaveSelect' )
		Create Table ( tcTable ) Free ;
			( Type     C ( 12 ), ;
			Id       C ( 12 ), ;
			Name     C ( 24 ), ;
			ReadOnly L, ;
			CkVal    N ( 6 ), ;
			Data     M, ;
			Updated  D )
		llReturn = Upper ( tcTable ) $ Fullpath ( Dbf() )
		Use
		Return llReturn
	Endfunc   && CreateResource
Enddefine


*------------------------------------------------------------------------------
Define Class SetSafety As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'SAFETY', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Safety On
			Otherwise
				Set Safety Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Safety On
			Otherwise
				Set Safety Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetSeconds As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'SECONDS', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Seconds On
			Otherwise
				Set Seconds Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Seconds On
			Otherwise
				Set Seconds Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetSeparator As Set
	*------------------------------------------------------------------------------
	uDefault = ', '   && "" will not work!

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'SEPARATOR', tcValue )
			Set Separator To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Separator To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetSpace As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'SPACE', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Space On
			Otherwise
				Set Space Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Space On
			Otherwise
				Set Space Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetStatus As SetOnOff
	*------------------------------------------------------------------------------
	* Limit:  no way to get SET STATUS TIMEOUT TO <n> value
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'STATUS', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Status On
			Otherwise
				Set Status Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Status On
			Otherwise
				Set Status Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetStatusBar As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'STATUS BAR', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Status Bar On
			Otherwise
				Set Status Bar Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Status Bar On
			Otherwise
				Set Status Bar Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetStep As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'STEP', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Step On
			Otherwise
				Set Step Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Step On
			Otherwise
				Set Step Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetSysFormats As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'SYSFORMATS', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Sysformats On
			Otherwise
				Set Sysformats Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Sysformats On
			Otherwise
				Set Sysformats Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetSysMenu As Set
	*------------------------------------------------------------------------------
	* Handles only ON, OFF, and AUTOMATIC.  Does not handle SET TO.

	uDefault = 'AUTOMATIC'

	Protected Procedure Init ( tcValue, tlNoReset )
		Local lcValue As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case Isnull ( tcValue )
				= DoDefault ( 'SYSMENU', tcValue )
			Case ! Inlist ( Upper ( Alltrim ( tcValue )), ;
					'ON', 'OFF', 'AUTOMATIC' )
				Error 231  &&  was: cnVF_ERR_SETARGINVALID
				Return .F.  && early exit
			Otherwise
				lcValue = Upper ( Alltrim ( tcValue ))
				= DoDefault ( 'SYSMENU', lcValue )
				Do Case
					Case lcValue == 'AUTOMATIC'
						Set Sysmenu Automatic
					Case lcValue == 'ON'
						Set Sysmenu On
					Case lcValue == 'OFF'
						Set Sysmenu Off
				Endcase
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'AUTOMATIC'
				Set Sysmenu Automatic
			Case This.uOldSet == 'ON'
				Set Sysmenu On
			Case This.uOldSet == 'OFF'
				Set Sysmenu Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetTableValidate As Set
	*------------------------------------------------------------------------------
	uDefault = 2

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'TableValidate', tnValue )
			Set TableValidate To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set TableValidate To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetTalk As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'TALK', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Talk On
			Otherwise
				Set Talk Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Talk On
			Otherwise
				Set Talk Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetTopic As SetTwo
	*------------------------------------------------------------------------------
	uDefault    = ''
	uDefaultTwo = 0

	Protected Procedure Init ( tcTopic, tcID, tlNoReset )
		Local lcTopic As String
		If tlNoReset
			This.lNoReset = .T.
		Endif

		Do Case  && of primary set
			Case ! DoDefault ( 'TOPIC', ;
					tcTopic, ;
					tcID, ;
					Parameters() )
			Case ! Inlist ( This.cSet, '1', '3' )
				* Do nothing.
			Otherwise
				lcTopic = This.uNewSet
				Set Topic To &lcTopic
		Endcase  && of primary set

		* Secondary set.
		If Inlist ( This.cSet, '2', '3' )
			Set Topic Id To This.uNewSetTwo
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTopic As String
		If ! This.lNoReset
			Do Case  && of primary set
				Case ! Inlist ( This.cSet, '1', '3' )
					* Do nothing.
				Otherwise
					lcTopic = This.uOldSet
					Set Topic To &lcTopic
			Endcase  && of primary set

			* Secondary set.
			If Inlist ( This.cSet, '2', '3' )
				Set Topic Id To This.uOldSetTwo
			Endif
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetTrBetween As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'TRBETWEEN', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Trbetween On
			Otherwise
				Set Trbetween Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Trbetween On
			Otherwise
				Set Trbetween Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetTypeahead As Set
	*------------------------------------------------------------------------------
	uDefault = 20

	Protected Procedure Init ( tnValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'TYPEAHEAD', tnValue )
			Set Typeahead To This.uNewSet
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If ! This.lNoReset
			Set Typeahead To This.uOldSet
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetUdfParms As Set
	*------------------------------------------------------------------------------
	uDefault = 'VALUE'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'UDFPARMS', ;
					Iif ( Isnull ( tcValue ), ;
					tcValue, Upper ( Alltrim ( tcValue )) ))
				Return .F.  && early exit
			Case This.uNewSet == 'VALUE'
				Set Udfparms Value
			Case This.uNewSet == 'REFERENCE'
				Set Udfparms Reference
			Otherwise
				Error 231  &&  was: cnVF_ERR_SETARGINVALID
				Return .F.  && early exit
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'VALUE'
				Set Udfparms Value
			Otherwise
				Set Udfparms Reference
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetUnique As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'UNIQUE', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set Unique On
			Otherwise
				Set Unique Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set Unique On
			Otherwise
				Set Unique Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetVarcharMapping As SetOnOff
	*------------------------------------------------------------------------------
	uDefault = 'ON'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'VarcharMapping', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set VarcharMapping On
			Otherwise
				Set VarcharMapping Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set VarcharMapping On
			Otherwise
				Set VarcharMapping Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetView As SetOnOff
	*------------------------------------------------------------------------------
	* Does not handle SET VIEW TO.
	uDefault = 'OFF'

	Protected Procedure Init ( tcValue, tlNoReset )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		Do Case
			Case ! DoDefault ( 'VIEW', tcValue )
				Return .F.  && early exit
			Case This.uNewSet == 'ON'
				Set View On
			Otherwise
				Set View Off
		Endcase
	Endproc

	Protected Procedure Destroy
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case This.uOldSet == 'ON'
				Set View On
			Otherwise
				Set View Off
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetWindowOfMemo As Set
	*------------------------------------------------------------------------------
	uDefault = ''

	Protected Procedure Init ( tcValue, tlNoReset )
		Local lcTemp As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If DoDefault ( 'WINDOW', tcValue )
			lcTemp = This.uNewSet
			Set Window Of Memo To &lcTemp
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTemp As String
		If ! This.lNoReset
			lcTemp = This.uOldSet
			Set Window Of Memo To &lcTemp
		Endif
	Endproc
Enddefine


*************************************************************
* SET Default Classes
*************************************************************

*------------------------------------------------------------------------------
Define Class SetVfpDefaults As Custom
	*------------------------------------------------------------------------------
	* Visual FoxPro Defaults.
	Protected Procedure Init ( tlNoReset )
		This.AddObject ( 'SetAlternate', 'SetAlternate', .Null., .Null., tlNoReset )
		This.AddObject ( 'SetAnsi', 'SetAnsi', .Null., tlNoReset )
		This.AddObject ( 'SetAutosave', 'SetAutosave', .Null., tlNoReset )
		This.AddObject ( 'SetBell', 'SetBell', .Null., tlNoReset )
		This.AddObject ( 'SetBlocksize', 'SetBlocksize', .Null., tlNoReset )
		This.AddObject ( 'SetBrstatus', 'SetBrstatus', .Null., tlNoReset )
		This.AddObject ( 'SetCarry', 'SetCarry', .Null., tlNoReset )
		This.AddObject ( 'SetCentury', 'SetCentury', .Null., tlNoReset )
		This.AddObject ( 'SetClear', 'SetClear', .Null., tlNoReset )
		This.AddObject ( 'SetClock', 'SetClock', .Null., tlNoReset )
		This.AddObject ( 'SetCollate', 'SetCollate', .Null., tlNoReset )
		This.AddObject ( 'SetColor', 'SetColor', .Null., tlNoReset )
		This.AddObject ( 'SetCompatible', 'SetCompatible', .Null., .Null., tlNoReset )
		This.AddObject ( 'SetConfirm', 'SetConfirm', .Null., tlNoReset )
		This.AddObject ( 'SetConsole', 'SetConsole', .Null., tlNoReset )
		This.AddObject ( 'SetCpcompile', 'SetCpcompile', .Null., tlNoReset )
		This.AddObject ( 'SetCpdialog', 'SetCpdialog', .Null., tlNoReset )
		This.AddObject ( 'SetCurrency', 'SetCurrency', .Null., .Null., tlNoReset )
		This.AddObject ( 'SetCursor', 'SetCursor', .Null., tlNoReset )
		This.AddObject ( 'SetDatabase', 'SetDatabase', .Null., tlNoReset )
		This.AddObject ( 'SetDataSession', 'SetDataSession', .Null., tlNoReset )
		This.AddObject ( 'SetDate', 'SetDate', .Null., tlNoReset )
		This.AddObject ( 'SetDebug', 'SetDebug', .Null., tlNoReset )
		This.AddObject ( 'SetDecimals', 'SetDecimals', .Null., tlNoReset )
		This.AddObject ( 'SetDefault', 'SetDefault', .Null., tlNoReset )
		This.AddObject ( 'SetDeleted', 'SetDeleted', .Null., tlNoReset )
		This.AddObject ( 'SetDelimiters', 'SetDelimiters', .Null., .Null., tlNoReset )
		This.AddObject ( 'SetDevelopment', 'SetDevelopment', .Null., tlNoReset )
		This.AddObject ( 'SetDisplay', 'SetDisplay', .Null., tlNoReset )
		This.AddObject ( 'SetDohistory', 'SetDohistory', .Null., tlNoReset )
		This.AddObject ( 'SetEcho', 'SetEcho', .Null., tlNoReset )
		This.AddObject ( 'SetEscape', 'SetEscape', .Null., tlNoReset )
		This.AddObject ( 'SetExact', 'SetExact', .Null., tlNoReset )
		This.AddObject ( 'SetExclusive', 'SetExclusive', .Null., tlNoReset )
		This.AddObject ( 'SetFdow', 'SetFdow', .Null., tlNoReset )
		This.AddObject ( 'SetFixed', 'SetFixed', .Null., tlNoReset )
		This.AddObject ( 'SetFullPath', 'SetFullPath', .Null., tlNoReset )
		This.AddObject ( 'SetFweek', 'SetFweek', .Null., tlNoReset )
		This.AddObject ( 'SetHeadings', 'SetHeadings', .Null., tlNoReset )
		This.AddObject ( 'SetHelp', 'SetHelp', .Null., .Null., tlNoReset )
		This.AddObject ( 'SetHelpFilter', 'SetHelpFilter', .Null., tlNoReset )
		This.AddObject ( 'SetHours', 'SetHours', .Null., tlNoReset )
		This.AddObject ( 'SetIntensity', 'SetIntensity', .Null., tlNoReset )
		This.AddObject ( 'SetKeycomp', 'SetKeycomp', .Null., tlNoReset )
		This.AddObject ( 'SetLibrary', 'SetLibrary', .Null., .Null., tlNoReset )
		This.AddObject ( 'SetLock', 'SetLock', .Null., tlNoReset )
		This.AddObject ( 'SetLogErrors', 'SetLogErrors', .Null., tlNoReset )
		This.AddObject ( 'SetMargin', 'SetMargin', .Null., tlNoReset )
		This.AddObject ( 'SetMackey', 'SetMackey', .Null., tlNoReset )
		This.AddObject ( 'SetMark', 'SetMark', .Null., tlNoReset )
		This.AddObject ( 'SetMemoWidth', 'SetMemoWidth', .Null., tlNoReset )
		This.AddObject ( 'SetMultiLocks', 'SetMultiLocks', .Null., tlNoReset )
		This.AddObject ( 'SetNear', 'SetNear', .Null., tlNoReset )
		This.AddObject ( 'SetNotify', 'SetNotify', .Null., tlNoReset )
		This.AddObject ( 'SetNull', 'SetNull', .Null., tlNoReset )
		This.AddObject ( 'SetOdometer', 'SetOdometer', .Null., tlNoReset )
		This.AddObject ( 'SetOLEObject', 'SetOLEObject', .Null., tlNoReset )
		This.AddObject ( 'SetOptimize', 'SetOptimize', .Null., tlNoReset )
		This.AddObject ( 'SetPalette', 'SetPalette', .Null., tlNoReset )
		This.AddObject ( 'SetPath', 'SetPath', .Null., tlNoReset )
		This.AddObject ( 'SetPrinter', 'SetPrinter', .Null., .Null., tlNoReset )
		This.AddObject ( 'SetPoint', 'SetPoint', .Null., tlNoReset )
		This.AddObject ( 'SetProcedure', 'SetProcedure', .Null., .Null., tlNoReset )
		This.AddObject ( 'SetReadBorder', 'SetReadBorder', .Null., tlNoReset )
		This.AddObject ( 'SetRefresh', 'SetRefresh', .Null., .Null., tlNoReset )
		This.AddObject ( 'SetReprocess', 'SetReprocess', .Null., tlNoReset )
		This.AddObject ( 'SetResource', 'SetResource', .Null., .Null., tlNoReset )
		This.AddObject ( 'SetSafety', 'SetSafety', .Null., tlNoReset )
		This.AddObject ( 'SetSeconds', 'SetSeconds', .Null., tlNoReset )
		This.AddObject ( 'SetSeparator', 'SetSeparator', .Null., tlNoReset )
		This.AddObject ( 'SetSpace', 'SetSpace', .Null., tlNoReset )
		This.AddObject ( 'SetStatus', 'SetStatus', .Null., tlNoReset )
		This.AddObject ( 'SetStatusBar', 'SetStatusBar', .Null., tlNoReset )
		This.AddObject ( 'SetStep', 'SetStep', .Null., tlNoReset )
		This.AddObject ( 'SetSysFormats', 'SetSysFormats', .Null., tlNoReset )
		This.AddObject ( 'SetSysMenu', 'SetSysMenu', .Null., tlNoReset )
		This.AddObject ( 'SetTalk', 'SetTalk', .Null., tlNoReset )
		This.AddObject ( 'SetTrBetween', 'SetTrBetween', .Null., tlNoReset )
		This.AddObject ( 'SetTopic', 'SetTopic', .Null., .Null., tlNoReset )
		This.AddObject ( 'SetTypeAhead', 'SetTypeAhead', .Null., tlNoReset )
		This.AddObject ( 'SetUdfParms', 'SetUdfParms', .Null., tlNoReset )
		This.AddObject ( 'SetUnique', 'SetUnique', .Null., tlNoReset )
		This.AddObject ( 'SetView', 'SetView', .Null., tlNoReset )
		This.AddObject ( 'SetWindowOfMemo', 'SetWindowOfMemo', ;
			.Null., tlNoReset )
		* SetClassLib must be last if this is a VCX.  Could be smarter
		* and keep itself in memory or ignore this if we're a VCX.
		This.AddObject ( 'SetClassLib', 'SetClassLib', .Null., .Null., tlNoReset )
		Return .F.
	Endproc
Enddefine


*************************************************************
* ON Parent Classes
*************************************************************

*------------------------------------------------------------------------------
Define Class On As Custom  && abstract class

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "getold" type = "method" display = "GetOld" />] ;
		+ [<memberdata name = "getnew" type = "method" display = "GetNew" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	Protected cOldOn, ;
		cNewOn, ;
		lNoReset

	Function GetOld
		Return This.cOldOn
	Endfunc

	Function GetNew
		Return This.cNewOn
	Endfunc

	Protected Procedure Init ( tcOn, tcValue )
		This.cOldOn = On ( tcOn )
		This.cNewOn = Nvl ( tcValue, '' )
	Endproc
Enddefine


*************************************************************
* ON Classes
*************************************************************

*------------------------------------------------------------------------------
Define Class OnError As On
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tcValue, tlNoReset )
		Local lcError As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		= DoDefault ( 'ERROR', tcValue )
		If Empty ( This.cNewOn )
			On Error
		Else
			lcError = This.cNewOn
			On Error &lcError
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcError As String
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case Empty ( This.cOldOn )
				On Error
			Otherwise
				lcError = This.cOldOn
				On Error &lcError
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class OnKey As On
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tcValue, tlNoReset )
		Local lcKey As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		= DoDefault ( 'KEY', tcValue )
		If Empty ( This.cNewOn )
			On Key
		Else
			lcKey = This.cNewOn
			On Key &lcKey
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcKey As String
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case Empty ( This.cOldOn )
				On Key
			Otherwise
				lcKey = This.cOldOn
				On Key &lcKey
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class OnKeyLabel As On
	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "getlabel" type = "method" display = "GetLabel" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	Protected cLabel
	Function GetLabel
		Return This.cLabel
	Endfunc

	Protected Procedure Init ( tcLabel, tcValue, tlNoReset )
		* Override parent class.
		Local lcKey As String
		This.cLabel = tcLabel
		This.cOldOn = On ( 'KEY', tcLabel )
		This.cNewOn = Nvl ( tcValue, '' )
		If tlNoReset
			This.lNoReset = .T.
		Endif
		If Empty ( This.cNewOn )
			On Key Label ( This.cLabel )
		Else
			lcKey = This.cNewOn
			On Key Label ( This.cLabel ) &lcKey
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcKey As String
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case Empty ( This.cOldOn )
				On Key Label ( This.cLabel )
			Otherwise
				lcKey = This.cOldOn
				On Key Label ( This.cLabel ) &lcKey
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class OnShutDown As On
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tcValue, tlNoReset )
		Local lcShutDown As String
		If tlNoReset
			This.lNoReset = .T.
		Endif
		= DoDefault ( 'SHUTDOWN', tcValue )
		If Empty ( This.cNewOn )
			On Shutdown
		Else
			lcShutDown = This.cNewOn
			On Shutdown &lcShutDown
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcShutDown As String
		Do Case
			Case This.lNoReset
				* Do nothing.
			Case Empty ( This.cOldOn )
				On Shutdown
			Otherwise
				lcShutDown = This.cOldOn
				On Shutdown &lcShutDown
		Endcase
	Endproc
Enddefine


*************************************************************
* Save/Restore Table Parent Classes
*************************************************************

*------------------------------------------------------------------------------
Define Class SaveArea As Custom  && abstract class

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "getselect" type = "method" display = "GetSelect" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	Protected nSelect

	Function GetSelect
		Return This.nSelect
	Endfunc

	Protected Procedure Init ( tuArea )  && character or numeric
		Do Case
			Case Empty ( tuArea ) Or Isnull ( tuArea )
				This.nSelect = Select ( 0 )
			Case Type ( 'tuArea' ) == 'N'
				This.nSelect = Max ( 0, tuArea )
			Otherwise  && assumes character or error will prevent init
				This.nSelect = Select ( tuArea )
		Endcase
		If Empty ( This.nSelect )
			Error 17  &&  was: cnVF_ERR_TABLE_NUMINVALID
			Return .F.
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SaveUsedArea As SaveArea  && abstract class
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tuArea )  && character or numeric
		Do Case
			Case ! DoDefault ( tuArea )
				Return .F.  && early exit
			Case ! Used ( This.nSelect )
				Error 52  &&  was: cnVF_ERR_TABLE_NOTOPEN
				Return .F.  && early exit
		Endcase
	Endproc

	Protected Procedure Destroy
		Return Used ( This.nSelect )
	Endproc
Enddefine


*************************************************************
* Set/Restore Table Classes
*************************************************************

*------------------------------------------------------------------------------
Define Class SaveSelect As SaveArea
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tuArea )  && character or numeric
		Return DoDefault ( tuArea )
	Endproc

	Protected Procedure Destroy
		Select ( This.nSelect )
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetSelect As SaveSelect
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tuNewArea )  && character or numeric
		If DoDefault()  && current area
			Select ( tuNewArea )
		Else
			Return .F.
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SaveBuffering As SaveUsedArea

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "getold" type = "method" display = "GetOld" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	Protected nBuffering

	Function GetOld
		Return This.nBuffering
	Endfunc

	Protected Procedure Init ( tuArea )
		If DoDefault ( tuArea )
			This.nBuffering = CursorGetProp ( 'Buffering', This.nSelect )
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		If DoDefault()
			= CursorSetProp ( 'Buffering', This.nBuffering, This.nSelect )
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetBuffering As SaveBuffering

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "getdefault" type = "method" display = "GetDefault" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	Protected nDefault
	nDefault = 1

	Protected Procedure GetDefault
		Return This.nDefault
	Endproc  && GetDefault

	Protected Procedure Init ( tnBuffering, tuNewArea )
		If DoDefault ( tuNewArea )
			= CursorSetProp ( 'Buffering', ;
				Nvl ( tnBuffering, This.nDefault ), ;
				This.nSelect )
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SaveRecno As SaveUsedArea

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "getold" type = "method" display = "GetOld" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	Protected nRecno

	Function GetOld
		Return This.nRecno
	Endfunc

	Protected Procedure Init ( tuArea )  && character or numeric
		If DoDefault ( tuArea )
			This.nRecno = Iif ( Eof ( This.nSelect ), ;
				.Null., Recno ( This.nSelect ))
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Do Case
			Case ! DoDefault()
				* Do nothing.
			Case Isnull ( This.nRecno )  && EOF()
				This.AddObject ( 'SetSelect', 'SetSelect', This.nSelect )
				Locate For .F.  && EOF()
			Case This.nRecno <= Reccount ( This.nSelect )
				*!*					Go This.nRecno In ( This.nSelect )
				GotoRecno( This.nRecno, Alias( This.nSelect ))

		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SaveOrder As SaveUsedArea

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "getold" type = "method" display = "GetOld" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	* Only handles CDX tags, not individual IDX.
	Protected cOrder, lDescending

	Function GetOld
		Return This.cOrder
	Endfunc

	Function GetDescending
		Return This.lDescending
	Endfunc

	Protected Procedure Init ( tuArea )  && character or numeric
		Local lnSelect As Number
		If DoDefault ( tuArea )
			lnSelect    = This.nSelect
			This.cOrder = Order ( lnSelect )
			If ! Empty ( This.cOrder )
				This.lDescending = Descending ( Tagno ( Order ( lnSelect ), ;
					Cdx ( 1, lnSelect ), ;
					lnSelect ), ;
					lnSelect )
			Endif
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Do Case
			Case ! DoDefault()
				* Do nothing.
			Case Empty ( This.cOrder )
				Set Order To 0 In ( This.nSelect )
			Case This.lDescending
				Set Order To ( This.cOrder ) In ( This.nSelect ) ;
					Descending
			Otherwise
				Set Order To ( This.cOrder ) In ( This.nSelect ) ;
					Ascending
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetOrder As SaveOrder
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tuOrder, tuNewArea, tlDescending )
		Do Case
			Case ! DoDefault ( tuNewArea )
				Return .F.  && early exit
			Case Empty ( tuOrder ) Or Isnull ( tuOrder )
				Set Order To 0 In ( This.nSelect )
			Case tlDescending
				Set Order To ( tuOrder ) In ( This.nSelect ) ;
					Descending
			Otherwise
				Set Order To ( tuOrder ) In ( This.nSelect )
		Endcase
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SaveFilter As SaveUsedArea

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "getold" type = "method" display = "GetOld" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	Protected cFilter

	Function GetOld
		Return This.cFilter
	Endfunc

	Protected Procedure Init ( tuArea )  && character or numeric
		If DoDefault ( tuArea )
			This.cFilter = Filter ( This.nSelect )
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcFilter As String
		If DoDefault()
			This.AddObject ( 'SetSelect', 'SetSelect', This.nSelect )
			If Empty ( This.cFilter )
				Set Filter To
			Else
				lcFilter = This.cFilter
				Set Filter To &lcFilter
			Endif
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetFilter As SaveFilter
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tcFilter, tuNewArea, tcAdditive )
		* tcAdditive ::= "AND" | "OR"
		Local lcFilter As String, ;
			loSelect As Object
		If DoDefault ( tuNewArea )
			loSelect = Createobject ( 'SetSelect', This.nSelect )
			Do Case
				Case Empty ( tcFilter ) Or Isnull ( tcFilter )
					Set Filter To
				Case Empty ( tcAdditive )
					Set Filter To &tcFilter
				Otherwise
					lcFilter = '( ' + Filter() + ' ) ' + tcAdditive + ;
						' ( ' + tcFilter + ' )'
					Set Filter To &lcFilter
			Endcase
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SaveRelation As SaveUsedArea

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "getold" type = "method" display = "GetOld" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	* Also handles SET SKIP.
	Protected cRelation, ;
		cSkip

	Function GetOld
		Return This.cRelation
	Endfunc

	Protected Procedure Init ( tuArea )  && character or numeric
		Local loSelect As Object
		If DoDefault ( tuArea )
			loSelect = Createobject ( 'SetSelect', This.nSelect )
			This.cRelation = Set ( 'RELATION' )
			This.cSkip     = Set ( 'SKIP' )
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		Local lcTemp As String, ;
			loSelect As Object
		If DoDefault()
			loSelect = Createobject ( 'SetSelect', This.nSelect )
			If Empty ( This.cRelation )
				Set Relation To
			Else
				lcTemp = This.cRelation
				Set Relation To &lcTemp
				If ! Empty ( This.cSkip )
					lcTemp = This.cSkip
					Set Skip To &lcTemp
				Endif
			Endif
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SetRelation As SaveRelation
	*------------------------------------------------------------------------------
	Protected Procedure Init ( tcRelation, tuNewArea, tcSkip )
		Local loSelect As Object
		If DoDefault ( tuNewArea )
			loSelect = Createobject ( 'SetSelect', This.nSelect )
			If Empty ( tcRelation ) Or Isnull ( tcRelation )
				Set Relation To
			Else
				Set Relation To &tcRelation
				If ! Empty ( tcSkip )
					Set Skip To &tcSkip
				Endif
			Endif
		Endif
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SaveTable As SaveUsedArea
	*------------------------------------------------------------------------------
	Protected cAlias, ;
		cFile, ;
		Clock

	Protected Procedure Init ( tuArea, tlNoDependencies )
		Local loFullPath As Object, ;
			loSelect As Object
		If DoDefault ( tuArea )
			loSelect   = Createobject ( 'SetSelect', This.nSelect )
			loFullPath = Createobject ( 'SetFullPath', 'ON' )
			This.AddObject ( 'SaveBuffering', 'SaveBuffering' )
			This.AddObject ( 'SaveRecno', 'SaveRecno' )
			This.AddObject ( 'SetDataSession', 'SetDataSession' )
			If ! tlNoDependencies
				* Order and filter could have references to other tables.
				This.AddObject ( 'SaveOrder', 'SaveOrder' )
				This.AddObject ( 'SaveFilter', 'SaveFilter' )
				This.AddObject ( 'SaveRelation', 'SaveRelation' )
			Endif
			This.cAlias = Alias()
			This.cFile  = Dbf()
			This.Clock  = Sys ( 2011 )
		Else
			Return .F.
		Endif
	Endproc

	Protected Procedure Destroy
		* Override parent class which checks for an open table.
		Local loSelect As Object
		loSelect = Createobject ( 'SetSelect', This.nSelect )
		If ! Alias() == This.cAlias
			This.RemoveObject ( 'SetDataSession', 'SetDataSession' )
			If Used ( This.cAlias )  && close if open in another area
				Use In ( This.cAlias )
			Endif
			If This.Clock == 'Exclusive'
				Use ( This.cFile ) Alias ( This.cAlias ) Again Exclusive
			Else
				Use ( This.cFile ) Alias ( This.cAlias ) Again Shared
				Do Case
					Case This.Clock == 'File Locked'
						= Flock()
					Case This.Clock == 'Record Locked'
						This.RemoveObject ( 'SaveRecno', 'SaveRecno' )
						= Rlock()
					Otherwise  && should never happen
						Error 'CASE...OTHERWISE: Unexpected.'
				Endcase
			Endif
		Endif  && NOT ALIAS() == This.cAlias
	Endproc
Enddefine


*------------------------------------------------------------------------------
Define Class SaveAllTables As Custom
	*------------------------------------------------------------------------------
	Add Object Protected SaveSelect As SaveSelect

	Protected Procedure Init
		Local laUsed[1], ;
			lnCounter As Number
		If Aused ( laUsed ) > 0
			* AUSED sorts from most recently opened to least recently opened.
			* Destruction is reversed; first constructed are last destructed,
			* so save the dependencies before the tables so all tables are
			* open when any potential dependencies are restored.
			For lnCounter = 1 To Alen ( laUsed, 1 )
				This.AddObject ( 'SaveRel' + Ltrim ( Str ( lnCounter )), ;
					'SaveRelation', ;
					laUsed[lnCounter, 2] )
				This.AddObject ( 'SaveFil' + Ltrim ( Str ( lnCounter )), ;
					'SaveFilter', ;
					laUsed[lnCounter, 2] )
			Endfor
			* Relations are dependent on order.
			For lnCounter = 1 To Alen ( laUsed, 1 )
				This.AddObject ( 'SaveOrd' + Ltrim ( Str ( lnCounter )), ;
					'SaveOrder', ;
					laUsed[lnCounter, 2] )
			Endfor
			* All dependencies are dependent on tables.
			For lnCounter = 1 To Alen ( laUsed, 1 )
				This.AddObject ( 'SaveTab' + Ltrim ( Str ( lnCounter )), ;
					'SaveTable', ;
					laUsed[lnCounter, 2], ;
					.T. )  && tables will be restored first
			Endfor
		Else
			Return .F.
		Endif
	Endproc
Enddefine

*------------------------------------------------------------------------------
Define Class OpenAliasCheckpoint As Custom
	* Quick and dirty class to close work areas that, upon destroy, were not
	* open at object creation time.
	*------------------------------------------------------------------------------
	Dimension aUsedAreas[1]
	aUsedAreas[1]=''

	*******************
	Function Init()
		*******************
		Aused ( This.aUsedAreas )  && Saving all the used workareas coming in.
		Return

		*******************
	Function Destroy()
		*******************
		*-- Cleaning up
		Local laUsedNow[1], ;
			lnK As Number
		Aused ( laUsedNow )
		For lnK = 1 To Alen ( laUsedNow, 1 )
			If  Ascan ( This.aUsedAreas, laUsedNow[ lnk, 1 ] ) = 0
				Use In ( laUsedNow[ lnk, 1 ] )
			Endif
		Endfor
		Return

Enddefine




*************************************************************
* Set/Restore Property Classes
*************************************************************

*------------------------------------------------------------------------------
Define Class SaveProperty As Custom

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "update" type = "method" display = "Update" />] ;
		+ [<memberdata name = "revert" type = "method" display = "Revert" />] ;
		+ [</VFPData>]

	* Use the Update method to save any changes.
	* Use the Revert method or destroy the object to discard unsaved changes.
	* Array properties: currently saves the first element only.
	*------------------------------------------------------------------------------
	Protected oObject, ;
		aProperties[1, 2], ;
		cProperty

	Protected Procedure Init ( toObject, tcProperty )  && arguments are optional
		* Object default order: 1 = parameter, 2 = PARENT, ( 3 ) _SCREEN.
		* Saves all properties unless tcProperty passed.
		Do Case
			Case Type ( 'toObject' ) == 'O'
				This.oObject = toObject
			Case Type ( 'This.PARENT' ) == 'O'
				This.oObject = This.Parent
			Otherwise
				This.oObject = _Screen
		Endcase
		If ! Empty ( tcProperty )
			This.cProperty = Alltrim ( tcProperty )
		Endif
		This.Update()
	Endproc

	Protected Procedure Destroy
		This.Revert()
	Endproc

	Procedure Update
		Local laProperties[1], ;
			lnCounter As Number
		If Empty ( This.cProperty )
			Dimension This.aProperties[AMEMBERS ( laProperties, This.oObject ), 2]
			For lnCounter = 1 To Alen ( laProperties )
				If Type ( 'This.oObject.' + laProperties[lnCounter] ) $ 'OU'
					This.aProperties[lnCounter, 1] = .Null.
				Else
					This.aProperties[lnCounter, 1] = laProperties[lnCounter]
					This.aProperties[lnCounter, 2] = ;
						Evaluate ( 'This.oObject.' + laProperties[lnCounter] )
				Endif
			Endfor
		Else
			Dimension This.aProperties[1, 2]
			This.aProperties[1, 1] = This.cProperty
			This.aProperties[1, 2] = Evaluate ( 'This.oObject.' + This.cProperty )
		Endif
	Endproc  && Update

	Procedure Revert
		Local lnCounter As Number
		For lnCounter = 1 To Alen ( This.aProperties, 1 )
			If ( ! Isnull ( This.aProperties[lnCounter, 1] )) And ;
					( Type ( 'This.aProperties[lnCounter, 2]' ) # ;
					Type ( 'This.oObject.' + This.aProperties[lnCounter, 1] ) Or ;
					This.aProperties[lnCounter, 2] # ;
					Evaluate ( 'This.oObject.' + ;
					This.aProperties[lnCounter, 1] ))
				Store This.aProperties[lnCounter, 2] ;
					To ( 'This.oObject.' + This.aProperties[lnCounter, 1] )
			Endif
		Endfor
	Endproc  && Revert
Enddefine


*------------------------------------------------------------------------------
Define Class SetProperty As SaveProperty
	*------------------------------------------------------------------------------
	Protected Procedure Init ( toObject, tcProperty, tuValue )
		DoDefault ( toObject, tcProperty )
		Store tuValue To ( 'This.oObject.' + This.cProperty )
	Endproc
Enddefine


*************************************************************
* Set/Restore System Variable Classes
*************************************************************

*------------------------------------------------------------------------------
Define Class SetSysVar As Custom

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "getold" type = "method" display = "GetOld" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	Protected cSysVar, ;
		uValue

	Function GetOld
		Return This.uValue
	Endfunc

	Protected Procedure Init ( tcSysVar, tuValue )
		This.cSysVar = tcSysVar
		This.uValue  = Evaluate ( tcSysVar )
		Store tuValue To ( tcSysVar )
	Endproc

	Protected Procedure Destroy
		Store This.uValue To ( This.cSysVar )
	Endproc
Enddefine


*************************************************************
* Timer Classes
*************************************************************

*------------------------------------------------------------------------------
Define Class MessageTimer As Timer

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "setintervaldefault " type = "method" display = "SetIntervalDefault " />] ;
		+ [<memberdata name = "setmessage" type = "method" display = "SetMessage" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	* This class works differently from most in this library because
	* it's not meant to be destroyed between message settings.  Instead,
	* the timer method resets the message and the class stays available
	* for another timed message.  This is similar to what a TIMEOUT clause
	* on SET MESSAGE would do.
	Protected Interval, ;
		nIntervalDefault, ;
		cMessage
	nIntervalDefault = 0
	cMessage = .Null.

	Procedure SetIntervalDefault ( tnSeconds )
		This.nIntervalDefault = Iif ( Empty ( tnSeconds ), ;
			0, tnSeconds * 1000 )
	Endproc

	Procedure SetMessage ( tcMessage, tnSeconds )
		If Isnull ( This.cMessage )  && don't get our timed message
			This.cMessage = Set ( 'MESSAGE', 1 )
		Endif
		This.Interval = Iif ( Parameters() < 2, ;
			This.nIntervalDefault, ;
			tnSeconds * 1000 )
		This.Reset()  && start over in case already in progress
		If Empty ( tcMessage )
			Set Message To
		Else
			Set Message To tcMessage
		Endif
	Endproc

	Protected Procedure Timer  && fires once to clear message
		If Empty ( This.cMessage )
			Set Message To
		Else
			Set Message To This.cMessage
		Endif
		This.cMessage = .Null.
		This.Interval = 0  && don't fire until new message is set
	Endproc

	Protected Procedure Destroy
		If ! Isnull ( This.cMessage )
			This.Timer()
		Endif
	Endproc
Enddefine


*************************************************************
* Lockscreen
*************************************************************

*------------------------------------------------------------------------------
Define Class SetLockScreen As Custom
	*-- Lockscreen management.  Doesn't completely fit with the envlib classes but
	*-- a-propos nonetheless because it resets when it goes out of scope.
	*------------------------------------------------------------------------------
	Protected lOldLockScreen, loForm
	loForm = .F.
	lOldLockScreen= .F.

	Function Init ( loCurrentForm, lNewSetting )
		This.loForm = loCurrentForm
		This.lOldLockScreen= loCurrentForm.LockScreen
		loCurrentForm.LockScreen = lNewSetting

	Function Destroy
		This.loForm.LockScreen = This.lOldLockScreen
Enddefine


*** EnvLib.prg **********************************************

Define Class SetCursorProp As Custom

	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "getold" type = "method" display = "GetOld" />] ;
		+ [<memberdata name = "getnew" type = "method" display = "GetNew" />] ;
		+ [<memberdata name = "getalias" type = "method" display = "GetAlias" />] ;
		+ [<memberdata name = "getproperty" type = "method" display = "GetProperty" />] ;
		+ [</VFPData>]

	*------------------------------------------------------------------------------
	Protected uOldSet, ;
		uNewSet, ;
		lNoReset, ;
		vAlias, ;
		cProp

	Function GetOld
		Return This.uOldSet
	Endfunc

	Function GetNew
		Return This.uNewSet
	Endfunc

	Function GetAlias
		Return This.vAlias
	Endfunc

	Function GetProperty
		Return This.cProp
	Endfunc

	* Init
	Procedure Init( tcProp As String, tuValue As String, tvAlias As Variant, tlNoReset As Boolean )
		Debugout Time(0), Program(),m.tcProp, m.tuValue, m.tvAlias, m.tlNoReset
		If m.tlNoReset
			This.lNoReset = .T.

		Endif

		If Empty( m.tvAlias )
			m.lvAlias = Alias()

		Else
			m.lvAlias = m.tvAlias

		Endif

		If ! Empty( m.lvAlias )
			This.cProp = m.tcProp
			This.uNewSet = m.tuValue
			This.vAlias = m.lvAlias
			This.uOldSet = CursorGetProp( This.cProp, This.vAlias )
			CursorSetProp( This.cProp, This.uNewSet, This.vAlias )

		Else && ! Empty( m.lvAlias )
			This.lNoReset = .T.

		Endif && ! Empty( m.lvAlias )

	Endproc

	* Destroy
	Protected Function Destroy()
		Debugout  Time(0), Program(),  This.cProp, This.uOldSet,This.uNewSet, This.vAlias
		If ! This.lNoReset
			CursorSetProp( This.cProp, This.uOldSet, This.vAlias )

		Endif && ! This.lNoReset

	Endfunc

Enddefine
