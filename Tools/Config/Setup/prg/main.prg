Local lcCommand As String

Try

	lcCommand = ""

	If IsRuntime()
		_Screen.Visible = .F.
	Endif

	Close Databases All

	lcCommand = ""

	SetGlobales()


	Set Procedure To Rutinas\Rutina.prg

	If !FileExist( "Urls.dbf" )
		Create Table Urls Free ( Id I, Alias C(30),Url C(200), Orden I )
		Index On Id Tag Id Candidate
		Index On Upper( Alias ) Tag Alias Candidate
		Use In Urls
	Endif

	Do Form "v:\CloudFox\Tools\Config\Setup\scx\Setup.scx"

	Read Events

Catch To loErr

	Try
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )

	Catch To oErr
		ShowError( oErr )

	Finally
		Clear Events

	Endtry

Finally
	*!*		_Screen.Visible = .T.


Endtry

*
*
Procedure SetGlobales(  ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""

		Public Aborta,Confirma

		Aborta		= 'prxAborta()'
		Confirma	= 'prxConfirma()'

		Public Cero,Uno,Dos,Tres,Cuatro,Mas,Menos,Enter,Escape,PgUp,PgDn,CtrlPgUp,;
			CtrlPgDn,Space,Back,Abajo,Arriba,Fin,Hogar,F2,F3,F4,F5,F6,F7,F8,F9,F10,;
			Izquierda,Cinco,F1,F11,F12,Derecha,ShiftTab,TabKey

		Cero		= 48
		Uno			= 49
		Dos			= 50
		Tres		= 51
		Cuatro		= 52
		Cinco		= 53

		Mas			= 43
		Menos		= 45

		Enter		= 13
		Escape		= 27
		PgUp		= 18
		PgDn		= 03
		CtrlPgUp	= 31
		CtrlPgDn	= 30
		Space		= 32
		Back		= 08
		Abajo		= 24
		Arriba		= 05
		Fin			= 06
		Hogar		= 01
		F1			= 28
		F2			=-01
		F3			=-02
		F4			=-03
		F5			=-04
		F6			=-05
		F7			=-06
		F8			=-07
		F9			=-08
		F10			=-09
		F11			=133
		F12			=134
		Izquierda	= 19
		Derecha		= 04
		TabKey		= 09
		ShiftTab	= 15

		Public 	DEMO, ASTERISCO

		DEMO		= .F.
		ASTERISCO	= .T.
		
		Set Multilocks On


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && SetGlobales




