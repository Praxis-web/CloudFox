***************************************************************
*Function VALNCUIT.PRG***Valida Nro. de CUIT
*  cCuit: Numero de cuit, caracter, en formato "99-99999999-9"
*  mVacio:	0: Permite ingreso vacio
*			1: Permite ingreso vacio, pero advierte que est  vacio
*			2: No Permite ingreso vacio
*  lMessage: .T. : Emite Mensaje
*			 .F. : No emite mensage


*Function ValidateCuit
Lparameter cCuit,mvacio,lMessage

Local nSuma,nr,cNewCuit,lOk,cFactor,nResto,nDigito
Local nKey
Local lcCuit as String 

Try

	If Pcount() < 3
		lMessage = .T.
	EndIf

	If Empty( mvacio )
		mvacio = 0
	EndIf	

	lcCuit = Strtran( cCuit, "-", "" )
	cCuit = Transform( lcCuit, "@R 99-99999999-9" ) 
	
	cCuit=Substr(Alltrim(cCuit)+Space(13),1,13)

	Store 0 To nSuma,nr
	Store Spac(13) To cNewCuit
	Store .T. To lOk
	Store '54-32765432' To cFactor
	For nr=1 To 11
		nSuma=nSuma+Val(Subst(cFactor,nr,1))*Val(Subst(cCuit,nr,1))
	Next
	nResto=Mod(nSuma,11)
	nDigito=Iif(nResto=0,nResto,11-nResto)

	If Str(nDigito,1)!=Right(cCuit,1)
		Do Case
			Case Empty(cCuit) .Or. cCuit='  -        - '
				Do Case
					Case mvacio=0
						lOk=.T.
						
					Case mvacio=1
						If lMessage
*!*								nKey=S_ALERT('* Debe  cargar  un número de CUIT o CUIL *')
*!*								Keyb Chr(nKey)
							Warning( "Debe  cargar  un número de CUIT o CUIL" )
						Endif
						lOk=.T.
						
					Case mvacio=2
						If lMessage
*!*								nKey=S_ALERT('* Debe  cargar  un número de CUIT o CUIL *')
*!*								Keyb Chr(nKey)
							Warning( "Debe  cargar  un número de CUIT o CUIL" )
						Endif
						lOk=.F.
				EndCase
				
			Otherwise
				If nDigito<10
					cNewCuit=Left(cCuit,11)+'-'+Str(nDigito,1)
					
				Else
					Do Case
						Case Left(cCuit,2)=='20'
							cNewCuit='23-'+Substr(cCuit,4,8)+'-9'
							
						Case Left(cCuit,2)=='27'
							cNewCuit='23-'+Substr(cCuit,4,8)+'-4'
							
						Case Left(cCuit,2)=='30'
							cNewCuit='33-'+Substr(cCuit,4,8)+'-9'
							
					Endc
				EndIf
				
				lOk=.F.
				If lMessage
*!*						nKey=S_ALERT('El Nº de CUIT/CUIL es incorrecto'+Iif(!Empty(cNewCuit),'; ** Nº probable '+cNewCuit+" **",''))
					Text To lcMsg NoShow TextMerge Pretext 03
					El Nº de CUIT/CUIL es incorrecto
					<<Iif(!Empty(cNewCuit),'** Nº probable '+cNewCuit+" **",'')>>
					EndText
					
					Warning( lcMsg )
				Endif
		Endcase
	Endif


Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return(lOk)