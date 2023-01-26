
Local Array laDir[ 1 ]


Clear
Try
	lcCurDir = Curdir()

	Cd "v:\sistemaspraxisv2\tools\intellisense\"

	For i = 1 To Adir( laDir, '_*.prg' )

		? laDir[ i, 1 ]

		If Lower( Justext( laDir[ i, 1 ] ) ) = 'prg'
			TEXT To lcCommand NoShow TextMerge Pretext 15
				Do '<<laDir[ i, 1 ]>>'
			ENDTEXT
			Try
				&lcCommand
			Catch To oErr
			Endtry
		Endif && Lower( JustExt( laDir[ i, 1 ] ) ) = 'prg'

	Endfor

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	Cd (lcCurDir)
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError


Finally
	loError = Null

	Cd (lcCurDir)

	Store .F. To laDir
Endtry
