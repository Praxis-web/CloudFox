
Local lcCode As String
TEXT To lcCode NoShow
	Lparameter oFoxcode As Object
	
	If oFoxcode.Location = 0
		Define Pad _s1012hsid Of _Msysmenu Prompt 'Praxis' Color Scheme 3 ;
			KEY Alt+X, ''
		On Pad _s1012hsid Of _Msysmenu Activate Popup Praxis

		Define Popup Praxis Margin Relative Shadow Color Scheme 4
		Define Bar 1 Of Praxis Prompt '\<Liberar entorno' && Key Ctrl-Alt-L
		Define Bar 2 Of Praxis Prompt '\<Autosetup'
		Define Bar 3 Of Praxis Prompt '\<Run Active Sync'
		
		On Selection Bar 1 Of Praxis Do liberarEntorno In 'Tools\Varios\prg\LiberarEntorno.prg'
		On Selection Bar 2 Of Praxis Do DoAutosetup In 'Tools\Varios\prg\DoAutosetup.prg'
		On Selection Bar 3 Of Praxis Do RunActiveSync In 'Tools\Varios\prg\RunActiveSync.prg'
		
	EndIf

    return oFoxcode.UserTyped
    
ENDTEXT

Use (_Foxcode) In 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And ABBREV == '_ide'
Insert Into UdpFoxCode (Type, ABBREV, cmd, Data)  Values ( 'U', '_ide', '{}', lcCode )
Use In Select( 'UdpFoxCode' )
