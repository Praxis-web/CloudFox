*!* CodeParserSetup @  llAlreadyParsed @ .T.
*!* CodeParserSetup @  llParsePrivate @ .F.


Try

	Set Sysmenu Off
	Do Form "FW\Hasar\Scx\frmHasarUtils.Scx"

Catch To OERR
	Local LOERROR As ERRORHANDLER Of "TOOLS\ERRORHANDLER\PRG\ERRORHANDLER.PRG"

	LOERROR = Newobject( "ERRORHANDLER", "TOOLS\ERRORHANDLER\PRG\ERRORHANDLER.PRG" )
	LOERROR.Process( OERR )
	Throw LOERROR

Finally
	Close Databases All
	Set Sysmenu Automatic

Endtry

Return






* FACIERRE.PRG  [02c]
* RICARDO	-  06/03/2001
* Emision de Auditorias

Para nOpcion
Priv aOpciones[09],cPrg

Inici02c()
Panta02c()
Do Proce&cPrg
Retu

Note: Inicializar Vector

Proc Inici02c
aOpciones[ 01 ]   =  "Cierre Diario 'Z'"
aOpciones[ 02 ]   =  "Cierre Diario 'X'"
aOpciones[ 03 ]   =  "Reporte Diario por Rango de Fechas"
aOpciones[ 04 ]   =  "Reporte Diario por Rango de 'Z'"
aOpciones[ 05 ]   =  "Reporte Global por Rango de Fechas"
aOpciones[ 06 ]   =  "Reporte Global por Rango de 'Z'"
aOpciones[ 07 ]   =  "Reporte Cierre 'Z' Individual"
aOpciones[ 08 ]   =  "Reporte Estado Cierres Diarios 'Z'"
aOpciones[ 09 ]   =  "Consulta de memoria de trabajo"

cPrg=StrZero(nOpcion,2)
Retu

Note: Pantalla

Proc Panta02C
S_Clear(00,00,24,79)
S_TitPro("AUDITORIA: "+aOpciones[nOpcion],FechaHoy)
S_Line23(Msg8)
Retu

Note: Cierre Diario 'Z'

Proc Proce01
PRIV cACT,dFECH,cHORA
cACT="N"
dFECH=GetDateTime("D")
cHORA=GetDateTime("T")
IF cHORA="::"
   cHORA="  :  :  "
ENDIF

@ 09,10 Say "Actualiza Fecha/Hora:"
@ 10,10 Say "Fecha...............:"
@ 11,10 Say "Hora................:"


@ 10,32 SAY dFECH
@ 11,32 SAY cHORA

@ 09,32 GET cACT PICT "!" VALID I_VALSTR(cACT,"SN")
READ

IF cACT="S"
   @ 09,32 SAY "Si"
   F_Get(@dFech,10,32,"I_ValObl(dFech)")
   If !&aborta
	  S_LINE24("Ingrese Hora en formato HH:MM:SS")
	  @ 11,32 GET cHORA PICT "99:99:99" VALID VALTIME(cHORA)
	  READ
   Endif
ENDIF
IF !&ABORTA
   If V_Confir()
	  S_LINE23(MSG14)
	  *!*@24,00
	  Enviar( DailyClose(  "Z" ) )
	  IF cACT="S"
		 SetDateTime(dFECH,cHORA)
	  ENDIF
   Endi
Endi
Retu

FUNC VALTIME
PARA cHORA
PRIV lVALID,nHH,nMM,nSS
nHH=VAL(SUBSTR(cHORA,1,2))
nMM=VAL(SUBSTR(cHORA,4,2))
nSS=VAL(SUBSTR(cHORA,7,2))
lVALID=I_VALRAN(nHH,00,23)
IF lVALID
   lVALID=I_VALRAN(nMM,00,59)
ENDIF
IF lVALID
   lVALID=I_VALRAN(nSS,00,59)
ENDIF
RETU lVALID

Note: Cierre Diario 'X'

Proc Proce02
If V_Confir()
   S_LINE23(MSG14)
   *!*@24,00
   Enviar( DailyClose(	"X" ) )
Endif
Retu

Note: Reporte Diario por Rango de Fechas

Proc Proce03
Priv dFeci,dFecf
dFeci=Ctod("")
dFecf=Ctod("")
If FRango(@dFeci,@dFecf)
   S_LINE23(MSG14)
   *!*@24,00
   Enviar( CloseByDate( dFeci, dFecf, "D"))
endif
Retu

Note: Reporte Diario por Rango de 'Z'

Proc Proce04
Priv nZIni,nZFin
nZIni=0
nZFin=0
If NRango(@nZIni,@nZFin)
   S_LINE23(MSG14)
   *!*@24,00
   Enviar(CloseByNumber( nZIni, nZFin, "D") )
Endif
Retu

Note: Reporte Global por Rango de Fechas

Proc Proce05
Priv dFeci,dFecf
dFeci=Ctod("")
dFecf=Ctod("")
If FRango(@dFeci,@dFecf)
   S_LINE23(MSG14)
   *!*@24,00
   Enviar( CloseByDate( dFeci, dFecf, "T"))
Endif
Retu

Note: Reporte Global por Rango de 'Z'

Proc Proce06
Priv nZIni,nZFin
nZIni=0
nZFin=0
If NRango(@nZIni,@nZFin)
   S_LINE23(MSG14)
   *!*@24,00
   Enviar(CloseByNumber( nZIni, nZFin, "T") )
Endif
Retu

Note: Reporte Cierre 'Z' Individual

Proc Proce07
Priv nZIni,cReturn
nZIni  =0
cReturn=""
@ 10,10 Say "N£mero ..........:"
S_AclNro( 4 )
@ 10,29 Get nZIni Pict "@Z 9999" Valid I_ValMay(nZIni,0)
Read
If V_Confir()
   GetDailyReport( "Z", nZIni )
Endif
Retu

Note: Reporte Estado Cierres Diarios 'Z'

Proc Proce08
Priv dZIni,cReturn
dZIni  =Ctod("")
cReturn=""
@ 10,10 Say "Fecha ...........:"
F_Get(@dZIni,10,29,"I_ValObl(dZIni)")
If V_Confir()
   GetDailyReport( "T", dZIni )
Endif
Read

Note: Consulta de memoria de trabajo

Proc Proce09
If V_Confir()
   GetWorkingMemory()
Endi
Retu


Note: Ingreso de Rango de fechas

Func FRango
@ 10,10 Say "Fecha Inicial....:"
@ 11,10 Say "Fecha Final......:"
F_Get(@dFeci,10,29,"I_ValObl(dFeci)")
If !&aborta
   F_Get(@dFecf,11,29,"I_ValMoi(dFecf,dFeci)")
Endif
Retu If(&Aborta,.F.,V_Confir())


Note: Ingreso de Rango de Numeros

Func NRango
@ 10,10 Say "N£mero Inicial...:"
@ 11,10 Say "N£mero Final.....:"
S_AclNro( 4 )
@ 10,29 Get nZIni Pict "@Z 9999" Valid I_ValMay(nZIni,0)
Read
If !&aborta
   @ 11,29 Get nZFin Pict "@Z 9999" Valid I_ValMoi(nZFin,nZIni)
   Read
Endif
Retu If(&Aborta,.F.,V_Confir())