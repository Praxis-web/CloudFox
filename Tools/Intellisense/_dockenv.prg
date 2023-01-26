Local lcCode As String
TEXT To lcCode NoShow
	Lparameter oFoxcode As Object
	Local i As Number
	Local llOk as Boolean
	Local loForm as Form

	If oFoxcode.Location = 0
		oFoxcode.valuetype = 'V'

		If Wexist( 'frmPaneManager' )
			WDockable( 'frmPaneManager', .T. )
			i = 1
			llOk = .F.
			Do While i <= _screen.FormCount And ! llOk
			    If Lower( _screen.Forms( i ).Name ) == 'frmpanemanager'
			        loForm = _screen.Forms( i )
			        llOk = .T.
			    Else
			        i = i + 1
			    EndIf
			EndDo
			loForm.Move( 0, 0 )
			loForm = Null
		EndIf

		If Wexist( 'Command' )
			Wdockable( 'Command', .T. )
			Dock Window Command Position 3
		Endif

		If Wexist( 'Properties' )
			Wdockable( 'Properties', .T. )
			Dock Window Properties Position 2
		Endif

		If Wexist( 'Document' )
			Wdockable( 'Document', .T. )
			Dock Window Document Position 2
		Endif

		If Wexist( 'Document' ) And Wexist( 'Properties' )
			Dock Window Properties Position 4 Window Document
		EndIf


		If Wexist( 'Debugger' )

			Zoom Window 'Debugger' Max

		    If Wexist( 'Watch' )
		    	Wdockable( 'Watch', .T. )
		        Dock Window 'Watch' Position 2
		    EndIf

		    If Wexist( 'Trace' )
				Wdockable( 'Trace', .T. )
		        Dock Window 'Trace' Position 0
		    EndIf

	
		    If Wexist( 'Call Stack' )
			    Wdockable( 'Call Stack', .T. )
		        Dock Window 'Call Stack' Position 1
	    	EndIf	    	
	    
	    	If Wexist( 'Locals' )
	    		Wdockable( 'Locals', .T. )
		        Dock Window 'Locals' Position 2
		    EndIf

		    If Wexist( 'Debug Output' )
				Wdockable( 'Debug Output', .T. )
		        Dock Window 'Debug Output' Position 3
		    EndIf

		EndIf

	EndIf
    Return oFoxcode.UserTyped

ENDTEXT

Use (_Foxcode) In 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And ABBREV == '_dockenv'
Insert Into UdpFoxCode (Type, ABBREV, cmd, Data)  Values ( 'U', '_dockenv', '{}', lcCode )
Use In Select( 'UdpFoxCode' )
