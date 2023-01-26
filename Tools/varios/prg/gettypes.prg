Lparameters tcFileName As String, tlCopyToClipboard as Boolean

Local lcData As String
Local lcCampo  As String
Local lcRet As String
Local Array lAProcInfo[ 1 ]

If Empty( tcFileName )
	tcFileName = Getfile( 'prg' )

Endif
lcData = [* <<lcCampo>> ] + Chr( 13 ) ;
	+ [Text To lcCode NoShow] + Chr( 13 ) ;
	+ [<<lcCampo>> Of "Tools\Sincronizador\colDataBases.prg"] + Chr( 13 ) ;
	+ [EndText] + Chr( 13 ) + Chr( 13 ) ;
	+ [Delete From UdpFoxCode Where TYPE = 'T' And '<<Lower( lcCampo )>>' $ Lower( data )] + Chr( 13 ) ;
	+ [insert into UdpFoxCode (TYPE, DATA)  Values ( 'T', lcCode )] + Chr( 13 ) + Chr( 13 )

If ! Empty( tcFileName )
	lcRet = ''
	For i = 1 To Aprocinfo( lAProcInfo, "Tools\Sincronizador\colDataBases.prg", 1 )
		lcCampo = lAProcInfo[ i, 1 ]
		lcRet = lcRet + Textmerge( lcData )

	Next
	If tlCopyToClipboard
	_Cliptext = lcRet
	
	EndIf

Endif

Return lcRet