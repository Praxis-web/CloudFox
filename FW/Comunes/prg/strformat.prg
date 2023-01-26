Note: Transformar la oracion en may£scula o Min£scula
* SINTAXIS: STRFORMAT(sSTRING,nTIPO)

* sSTRING	Oraci¢n
* nTIPO=1	Tipo oracion
* nTIPO=2	min£sculas
* nTIPO=3	MAYÈSCULAS
* nTIPO=4	Tipo T°tulo
* nTIPO=5	tIPO iNVERSO


Para sSTRING,nTIPO
Priv sRETU,cCHAR,nI,nLEN,nJ,lMAY
sRETU=sSTRING
sSTRING=Default("sSTRING","")
nTIPO  =Default("nTIPO",0)
nLEN   =Len(sSTRING)
If nTIPO>5
	nTIPO=0
Endif
If !Empty(sSTRING)
	Do Case
		Case nTIPO=1 && Tipo oracion
			For nI=1 To nLEN
				If !Empty(Substr(sSTRING,nI,1))
					sRETU = Space(nI-1)+Uppe(Substr(sSTRING,nI,1))+Lower(Substr(sSTRING,nI+1))
					Exit
				Endif
			Next

		Case nTIPO=2 && min£sculas
			sRETU = Lower(sSTRING)

		Case nTIPO=3 && MAYÈSCULAS
			sRETU = Upper(sSTRING)

		Case nTIPO=4 && Tipo T°tulo
			sRETU=Proper(sSTRING)

		Case nTIPO=5 && tIPO iNVERSO
			For nI=1 To nLEN
				cCHAR=Substr(sSTRING,nI,1)
				If !Empty(cCHAR)
					lMAY=Islower(cCHAR)
					sSTRING=Stuff(sSTRING,nI,1,Iif(lMAY,Uppe(cCHAR),Lowe(cCHAR)))
				Endif
			Next
			sRETU=sSTRING

		Otherwise
			sRETU = Uppe(Substr(sSTRING,1,1))+Substr(sSTRING,2)
	Endcase

Endif
Retu sRETU
