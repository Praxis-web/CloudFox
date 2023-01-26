
*!*	o = Createobject( 'BlowFish' )
*!*	*!* EJEMPLO CodificarSimple y DecodificarSimple

*!*	lcCadenaA = o.CodificarSimple( Replicate( 'X', 30 ), 'PraxisComputación')
*!*	Messagebox( lcCadenaA )
*!*	Messagebox( Len( lcCadenaA ) )
*!*	lcCadenaB = o.DecodificarSimple(lcCadenaA, 'PraxisComputación')
*!*	Messagebox( lcCadenaB )
*!*	Messagebox( Len( lcCadenaB ) )

* BlowFish
Define Class BlowFish As Custom
	#If .F.
		Local This As BlowFish Of fw\comunes\prg\BlowFish.prg
	#Endif

	Name = 'BlowFish'

	*Hidden aP
	Dimension aP[ 18 ]

	*Hidden aS1
	Dimension aS1[ 256 ]

	*Hidden aS2
	Dimension aS2[ 256 ]

	*Hidden aS3
	Dimension aS3[ 256 ]

	*Hidden aS4
	Dimension aS4[ 256 ]

	* - - XML Metadatos para propiedades personalizables.
	Hidden _MemberData
	_MemberData = [ < VFPData > ] ;
		+ [<memberdata name = "codificar" type = "method" display = "Codificar"/>] ;
		+ [<memberdata name = "decodificar" type = "method" display = "Decodificar"/>] ;
		+ [<memberdata name = "codificadorsimple" type = "method" display = "CodificadorSimple"/>] ;
		+ [<memberdata name = "decodificadorsimple" type = "method" display = "DecodificadorSimple"/>] ;
		+ [<memberdata name = "desencriptar" type = "method" display = "Desencriptar"/>] ;
		+ [<memberdata name = "encriptar" type = "method" display = "Encriptar"/>] ;
		+ [<memberdata name = "blosfishconstantes" type = "method" display = "BlosfishConstantes"/>] ;
		+ [<memberdata name = "xor" type = "method" display = "xOr"/>] ;
		+ [<memberdata name = "blosfishinicializar" type = "method" display = "BlosfishInicializar"/>] ;
		+ [<memberdata name = "BlowFishdesencriptar" type = "method" display = "BlowFishDesencriptar"/>] ;
		+ [<memberdata name = "BlowFishencriptar" type = "method" display = "BlowFishEncriptar"/>] ;
		+ [<memberdata name = "BlowFishredondear" type = "method" display = "BlowFishRedondear"/>] ;
		+ [<memberdata name = "decodificarpalabra" type = "method" display = "DecodificarPalabra"/>] ;
		+ [<memberdata name = "codificarpalabra" type = "method" display = "CodificarPalabra"/>] ;
		+ [<memberdata name = "bytepalabra1" type = "method" display = "BytePalabra1"/>] ;
		+ [<memberdata name = "bytepalabra2" type = "method" display = "BytePalabra2"/>] ;
		+ [<memberdata name = "bytepalabra3" type = "method" display = "BytePalabra3"/>] ;
		+ [<memberdata name = "bytepalabra4" type = "method" display = "BytePalabra4"/>] ;
		+ [<memberdata name = "decodificarBlowFish" type = "method" display = "DecodificarBlowFish"/>] ;
		+ [<memberdata name = "codificarBlowFish" type = "method" display = "CodificarBlowFish"/>] ;
		+ [<memberdata name = "BlowFishIniciado" type = "property" display = "BlowFishIniciado"/>] ;
		+ [<memberdata name = "maxllavebytes" type = "property" display = "MaxLlaveBytes"/>] ;
		+ [<memberdata name = "parxl" type = "property" display = "ParXL"/>] ;
		+ [<memberdata name = "parxr" type = "property" display = "ParXR"/>] ;
		+ [<memberdata name = "version" type = "property" display = "Version"/>] ;
		+ [<memberdata name = "_memberdata" type = "property" display = "_MemberData"/>] ;
		+ [<memberdata name = "codificarsimple" type = "method" display = "CodificarSimple"/>] ;
		+ [<memberdata name = "decodificarsimple" type = "method" display = "DecodificarSimple"/>] ;
		+ [</VFPData>]

	* - - Par de trabajo XL para BlowFish
	Hidden parxl
	parxl = 0
	* - - Par de trabajo XR para BlowFish
	Hidden parxr
	parxr = 0
	Hidden BlowFishIniciado
	BlowFishIniciado = 0
	* - - Version de la clase
	Version = "'1.3'"
	* - - Numero maximo de caracteres para la Llave o clave
	Hidden maxllavebytes
	maxllavebytes = 56
	Name = "BlowFish"
	Hidden ClassLibrary
	Hidden AddObject
	Hidden AddProperty
	Hidden BaseClass
	Hidden Class
	Hidden CloneObject
	Hidden Comment
	Hidden ControlCount
	Hidden Controls
	Hidden Destroy
	Hidden Error
	Hidden Height
	Hidden HelpContextID
	Hidden Newobject
	Hidden Objects
	Hidden Parent
	Hidden ParentClass
	Hidden Picture
	Hidden ReadExpression
	Hidden ReadMethod
	Hidden RemoveObject
	Hidden ResetToDefault
	Hidden SaveAsClass
	Hidden ShowWhatsThis
	Hidden Tag
	Hidden WhatsThisHelpID
	Hidden Width
	Hidden WriteExpression
	Hidden WriteMethod


	* - - Codifica
	Procedure Codificar( tcTexto As String ) As String
		Local lnTemporalA As Integer
		Local lnTemporalB As Integer
		Local lnTemporalC As Integer
		Local lcResultado As String
		Local lnContador As Integer
		Local lnLen As Integer

		lnTemporalA = 0
		lnTemporalB = 0
		lnTemporalC = 0
		lcResultado = ""

		lnLen = Len( tcTexto )
		For lnContador = 1 To lnLen

			lnTemporalA = Asc( Substr( tcTexto, lnContador, 1 ) )
			lnTemporalB = Floor( lnTemporalA/16 )
			lnTemporalC = lnTemporalA % 16

			If	lnTemporalB < 10
				lnTemporalB = lnTemporalB + 48

			Else
				lnTemporalB = lnTemporalB + 55

			Endif

			If	lnTemporalC < 10
				lnTemporalC = lnTemporalC + 48

			Else
				lnTemporalC = lnTemporalC + 55

			Endif

			lcResultado = lcResultado + Chr( lnTemporalB ) + Chr( lnTemporalC )

		Endfor

		Return lcResultado

	Endproc && Codificar


	* - - Decodificacion
	Procedure Decodificar( tcTexto As String ) As String

		Local lnTemporalA As Integer
		Local lnTemporalB As Integer
		Local lnTemporalC As Integer
		Local lcResultado As String
		Local lnContador As Integer
		Local lnLen As Integer

		Try

			lnTemporalA = 0
			lnTemporalB = 0
			lnTemporalC = 0
			lcResultado = ""

			lnLen = Len( tcTexto )
			For lnContador = 1 To lnLen

				lnTemporalB = Asc( Substr( tcTexto, lnContador, 1 ) )
				lnContador = lnContador + 1
				lnTemporalC = Asc( Substr( tcTexto, lnContador, 1 ) )

				lnTemporalB = Iif( lnTemporalB = 0, 48, lnTemporalB )

				If lnTemporalB < 58
					lnTemporalB = lnTemporalB - 48
				Else
					If lnTemporalB > 96
						lnTemporalB = lnTemporalB - 87
						
					Else
						lnTemporalB = lnTemporalB - 55

					Endif && lnTemporalB > 96

				Endif

				If lnTemporalC < 58
					lnTemporalC = lnTemporalC - 48
				Else
					If lnTemporalC > 96
						lnTemporalC = lnTemporalC - 87
					Else
						lnTemporalC = lnTemporalC - 55
					Endif
				Endif

				lnTemporalA = ( lnTemporalB * 16 ) + lnTemporalC

				Try
				
					lcResultado = lcResultado + Chr( lnTemporalA )					
				
				Catch To oErr

				Finally

				EndTry

			Endfor


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry


		* Está decodificando mal
		* por ahora no muestro la clave decodificada
		lcResultado = ""

		Return lcResultado

	Endproc && Decodificar

	* - - Codifica de forma simple
	Procedure CodificarSimple( tcTexto As String, tcPalabraClave As String ) As String
		Local lnDelta As Integer
		Local lnTemporalA As Integer
		Local lcSalidaDato As String
		Local i As Integer
		Local j As Integer
		Local lnLen As Integer
		Local lnLenPC As Integer

		Try


			lnDelta = 5
			lnTemporalA = 0
			lcSalidaDato = ""
			j = 1

			lnLenPC = Len( tcPalabraClave )
			If lnLenPC = 0
				lcSalidaDato = This.Codificar( tcTexto )

			Else
				lnLen = Len( tcTexto )
				For i = 1 To lnLen
					If j = lnLenPC
						j = 1

					Endif

					lnTemporalA = Asc( Substr( tcTexto, i, 1 ) )
					lnTemporalA = lnTemporalA + Asc( Substr( tcPalabraClave, j, 1 ) )

					If lnTemporalA > 255
						lnTemporalA = lnTemporalA - 256

					Endif && lnTemporalA > 255

					If lnTemporalA < lnDelta
						lcSalidaDato = lcSalidaDato + Chr( lnDelta )
						lnTemporalA = lnTemporalA + lnDelta

					Endif && lnTemporalA < lnDelta

					lcSalidaDato = lcSalidaDato + Chr( lnTemporalA )
					j = j + 1

				Endfor

				lcSalidaDato = This.Codificar( lcSalidaDato )

			Endif && Len( tcPalabraClave ) = 0


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcSalidaDato

	Endproc && CodificarSimple


	* - - Decodifica una cadena simple
	Procedure DecodificarSimple( tcTexto As String, tcPalabraClave As String )
		Local delta
		Local lnTemporalA As Integer
		Local lcSalidaDato As String
		Local i As Integer
		Local j As Integer
		Local lnLen As Integer
		Local lnLenPC As Integer

		Try

			lnDelta = 5
			lnTemporalA = 0
			lcSalidaDato = ""
			j = 1

			With This As BlowFish Of fw\comunes\prg\BlowFish.prg
				lnLenPC = Len( tcPalabraClave )
				If lnLenPC = 0
					lcSalidaDato = .Decodificar( tcTexto ) && myunescape( tcTexto )

				Else
					tcTexto = .Decodificar( tcTexto ) && myunescape( tcTexto )
					lnLen = Len( tcTexto )
					For i = 1 To lnLen

						If j = lnLenPC
							j = 1

						Endif && j = lnLenPC

						lnTemporalA = Asc( Substr( tcTexto, i, 1 ) )
						If lnTemporalA = lnDelta
							i = i + 1
							lnTemporalA = Asc( Substr( tcTexto, i, 1 ) )
							slnTemporalA = lnTemporalA - lnDelta

						Endif && lnTemporalA = lnDelta

						lnTemporalA = lnTemporalA - Asc( Substr( tcPalabraClave, j, 1 ) )

						If lnTemporalA < 0
							lnTemporalA = lnTemporalA + 256

						Endif && lnTemporalA < 0

						lcSalidaDato = lcSalidaDato + Chr( lnTemporalA )
						j = j + 1

					Endfor

				Endif

			Endwith


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcSalidaDato

	Endproc && DecodificarSimple


	* - - Inicia las constanes del algoritmo de BlowFish
	Hidden Procedure BlosFishConstantes() As VOID
		* ! * ATENCION LAS LINEAS SIGUIENTES SON VALORES CONSTANTES.
		* ! * NO CAMBIE NINGUNO DE LOS ANTERIORES

		* - - - -
		With This As BlowFish Of fw\comunes\prg\BlowFish.prg
			Store 0x243f6a88 To .aP[ 1 ]
			Store 0x85a308d3 To .aP[ 2 ]
			Store 0x13198a2e To .aP[ 3 ]
			Store 0x03707344 To .aP[ 4 ]
			Store 0xa4093822 To .aP[ 5 ]
			Store 0x299f31d0 To .aP[ 6 ]
			Store 0x082efa98 To .aP[ 7 ]
			Store 0xec4e6c89 To .aP[ 8 ]
			Store 0x452821e6 To .aP[ 9 ]
			Store 0x38d01377 To .aP[ 10 ]
			Store 0xbe5466cf To .aP[ 11 ]
			Store 0x34e90c6c To .aP[ 12 ]
			Store 0xc0ac29b7 To .aP[ 13 ]
			Store 0xc97c50dd To .aP[ 14 ]
			Store 0x3f84d5b5 To .aP[ 15 ]
			Store 0xb5470917 To .aP[ 16 ]
			Store 0x9216d5d9 To .aP[ 17 ]
			Store 0x8979fb1b To .aP[ 18 ]

			* - - -
			Store 0xd1310ba6 To .aS1[ 1 ]
			Store 0x98dfb5ac To .aS1[ 2 ]
			Store 0x2ffd72db To .aS1[ 3 ]
			Store 0xd01adfb7 To .aS1[ 4 ]
			Store 0xb8e1afed To .aS1[ 5 ]
			Store 0x6a267e96 To .aS1[ 6 ]
			Store 0xba7c9045 To .aS1[ 7 ]
			Store 0xf12c7f99 To .aS1[ 8 ]
			Store 0x24a19947 To .aS1[ 9 ]
			Store 0xb3916cf7 To .aS1[ 10 ]
			Store 0x0801f2e2 To .aS1[ 11 ]
			Store 0x858efc16 To .aS1[ 12 ]
			Store 0x636920d8 To .aS1[ 13 ]
			Store 0x71574e69 To .aS1[ 14 ]
			Store 0xa458fea3 To .aS1[ 15 ]
			Store 0xf4933d7e To .aS1[ 16 ]
			Store 0x0d95748f To .aS1[ 17 ]
			Store 0x728eb658 To .aS1[ 18 ]
			Store 0x718bcd58 To .aS1[ 19 ]
			Store 0x82154aee To .aS1[ 20 ]
			Store 0x7b54a41d To .aS1[ 21 ]
			Store 0xc25a59b5 To .aS1[ 22 ]
			Store 0x9c30d539 To .aS1[ 23 ]
			Store 0x2af26013 To .aS1[ 24 ]
			Store 0xc5d1b023 To .aS1[ 25 ]
			Store 0x286085f0 To .aS1[ 26 ]
			Store 0xca417918 To .aS1[ 27 ]
			Store 0xb8db38ef To .aS1[ 28 ]
			Store 0x8e79dcb0 To .aS1[ 29 ]
			Store 0x603a180e To .aS1[ 30 ]
			Store 0x6c9e0e8b To .aS1[ 31 ]
			Store 0xb01e8a3e To .aS1[ 32 ]
			Store 0xd71577c1 To .aS1[ 33 ]
			Store 0xbd314b27 To .aS1[ 34 ]
			Store 0x78af2fda To .aS1[ 35 ]
			Store 0x55605c60 To .aS1[ 36 ]
			Store 0xe65525f3 To .aS1[ 37 ]
			Store 0xaa55ab94 To .aS1[ 38 ]
			Store 0x57489862 To .aS1[ 39 ]
			Store 0x63e81440 To .aS1[ 40 ]
			Store 0x55ca396a To .aS1[ 41 ]
			Store 0x2aab10b6 To .aS1[ 42 ]
			Store 0xb4cc5c34 To .aS1[ 43 ]
			Store 0x1141e8ce To .aS1[ 44 ]
			Store 0xa15486af To .aS1[ 45 ]
			Store 0x7c72e993 To .aS1[ 46 ]
			Store 0xb3ee1411 To .aS1[ 47 ]
			Store 0x636fbc2a To .aS1[ 48 ]
			Store 0x2ba9c55d To .aS1[ 49 ]
			Store 0x741831f6 To .aS1[ 50 ]
			Store 0xce5c3e16 To .aS1[ 51 ]
			Store 0x9b87931e To .aS1[ 52 ]
			Store 0xafd6ba33 To .aS1[ 53 ]
			Store 0x6c24cf5c To .aS1[ 54 ]
			Store 0x7a325381 To .aS1[ 55 ]
			Store 0x28958677 To .aS1[ 56 ]
			Store 0x3b8f4898 To .aS1[ 57 ]
			Store 0x6b4bb9af To .aS1[ 58 ]
			Store 0xc4bfe81b To .aS1[ 59 ]
			Store 0x66282193 To .aS1[ 60 ]
			Store 0x61d809cc To .aS1[ 61 ]
			Store 0xfb21a991 To .aS1[ 62 ]
			Store 0x487cac60 To .aS1[ 63 ]
			Store 0x5dec8032 To .aS1[ 64 ]
			Store 0xef845d5d To .aS1[ 65 ]
			Store 0xe98575b1 To .aS1[ 66 ]
			Store 0xdc262302 To .aS1[ 67 ]
			Store 0xeb651b88 To .aS1[ 68 ]
			Store 0x23893e81 To .aS1[ 69 ]
			Store 0xd396acc5 To .aS1[ 70 ]
			Store 0x0f6d6ff3 To .aS1[ 71 ]
			Store 0x83f44239 To .aS1[ 72 ]
			Store 0x2e0b4482 To .aS1[ 73 ]
			Store 0xa4842004 To .aS1[ 74 ]
			Store 0x69c8f04a To .aS1[ 75 ]
			Store 0x9e1f9b5e To .aS1[ 76 ]
			Store 0x21c66842 To .aS1[ 77 ]
			Store 0xf6e96c9a To .aS1[ 78 ]
			Store 0x670c9c61 To .aS1[ 79 ]
			Store 0xabd388f0 To .aS1[ 80 ]
			Store 0x6a51a0d2 To .aS1[ 81 ]
			Store 0xd8542f68 To .aS1[ 82 ]
			Store 0x960fa728 To .aS1[ 83 ]
			Store 0xab5133a3 To .aS1[ 84 ]
			Store 0x6eef0b6c To .aS1[ 85 ]
			Store 0x137a3be4 To .aS1[ 86 ]
			Store 0xba3bf050 To .aS1[ 87 ]
			Store 0x7efb2a98 To .aS1[ 88 ]
			Store 0xa1f1651d To .aS1[ 89 ]
			Store 0x39af0176 To .aS1[ 90 ]
			Store 0x66ca593e To .aS1[ 91 ]
			Store 0x82430e88 To .aS1[ 92 ]
			Store 0x8cee8619 To .aS1[ 93 ]
			Store 0x456f9fb4 To .aS1[ 94 ]
			Store 0x7d84a5c3 To .aS1[ 95 ]
			Store 0x3b8b5ebe To .aS1[ 96 ]
			Store 0xe06f75d8 To .aS1[ 97 ]
			Store 0x85c12073 To .aS1[ 98 ]
			Store 0x401a449f To .aS1[ 99 ]
			Store 0x56c16aa6 To .aS1[ 100 ]
			Store 0x4ed3aa62 To .aS1[ 101 ]
			Store 0x363f7706 To .aS1[ 102 ]
			Store 0x1bfedf72 To .aS1[ 103 ]
			Store 0x429b023d To .aS1[ 104 ]
			Store 0x37d0d724 To .aS1[ 105 ]
			Store 0xd00a1248 To .aS1[ 106 ]
			Store 0xdb0fead3 To .aS1[ 107 ]
			Store 0x49f1c09b To .aS1[ 108 ]
			Store 0x075372c9 To .aS1[ 109 ]
			Store 0x80991b7b To .aS1[ 110 ]
			Store 0x25d479d8 To .aS1[ 111 ]
			Store 0xf6e8def7 To .aS1[ 112 ]
			Store 0xe3fe501a To .aS1[ 113 ]
			Store 0xb6794c3b To .aS1[ 114 ]
			Store 0x976ce0bd To .aS1[ 115 ]
			Store 0x04c006ba To .aS1[ 116 ]
			Store 0xc1a94fb6 To .aS1[ 117 ]
			Store 0x409f60c4 To .aS1[ 118 ]
			Store 0x5e5c9ec2 To .aS1[ 119 ]
			Store 0x196a2463 To .aS1[ 120 ]
			Store 0x68fb6faf To .aS1[ 121 ]
			Store 0x3e6c53b5 To .aS1[ 122 ]
			Store 0x1339b2eb To .aS1[ 123 ]
			Store 0x3b52ec6f To .aS1[ 124 ]
			Store 0x6dfc511f To .aS1[ 125 ]
			Store 0x9b30952c To .aS1[ 126 ]
			Store 0xcc814544 To .aS1[ 127 ]
			Store 0xaf5ebd09 To .aS1[ 128 ]
			Store 0xbee3d004 To .aS1[ 129 ]
			Store 0xde334afd To .aS1[ 130 ]
			Store 0x660f2807 To .aS1[ 131 ]
			Store 0x192e4bb3 To .aS1[ 132 ]
			Store 0xc0cba857 To .aS1[ 133 ]
			Store 0x45c8740f To .aS1[ 134 ]
			Store 0xd20b5f39 To .aS1[ 135 ]
			Store 0xb9d3fbdb To .aS1[ 136 ]
			Store 0x5579c0bd To .aS1[ 137 ]
			Store 0x1a60320a To .aS1[ 138 ]
			Store 0xd6a100c6 To .aS1[ 139 ]
			Store 0x402c7279 To .aS1[ 140 ]
			Store 0x679f25fe To .aS1[ 141 ]
			Store 0xfb1fa3cc To .aS1[ 142 ]
			Store 0x8ea5e9f8 To .aS1[ 143 ]
			Store 0xdb3222f8 To .aS1[ 144 ]
			Store 0x3c7516df To .aS1[ 145 ]
			Store 0xfd616b15 To .aS1[ 146 ]
			Store 0x2f501ec8 To .aS1[ 147 ]
			Store 0xad0552ab To .aS1[ 148 ]
			Store 0x323db5fa To .aS1[ 149 ]
			Store 0xfd238760 To .aS1[ 150 ]
			Store 0x53317b48 To .aS1[ 151 ]
			Store 0x3e00df82 To .aS1[ 152 ]
			Store 0x9e5c57bb To .aS1[ 153 ]
			Store 0xca6f8ca0 To .aS1[ 154 ]
			Store 0x1a87562e To .aS1[ 155 ]
			Store 0xdf1769db To .aS1[ 156 ]
			Store 0xd542a8f6 To .aS1[ 157 ]
			Store 0x287effc3 To .aS1[ 158 ]
			Store 0xac6732c6 To .aS1[ 159 ]
			Store 0x8c4f5573 To .aS1[ 160 ]
			Store 0x695b27b0 To .aS1[ 161 ]
			Store 0xbbca58c8 To .aS1[ 162 ]
			Store 0xe1ffa35d To .aS1[ 163 ]
			Store 0xb8f011a0 To .aS1[ 164 ]
			Store 0x10fa3d98 To .aS1[ 165 ]
			Store 0xfd2183b8 To .aS1[ 166 ]
			Store 0x4afcb56c To .aS1[ 167 ]
			Store 0x2dd1d35b To .aS1[ 168 ]
			Store 0x9a53e479 To .aS1[ 169 ]
			Store 0xb6f84565 To .aS1[ 170 ]
			Store 0xd28e49bc To .aS1[ 171 ]
			Store 0x4bfb9790 To .aS1[ 172 ]
			Store 0xe1ddf2da To .aS1[ 173 ]
			Store 0xa4cb7e33 To .aS1[ 174 ]
			Store 0x62fb1341 To .aS1[ 175 ]
			Store 0xcee4c6e8 To .aS1[ 176 ]
			Store 0xef20cada To .aS1[ 177 ]
			Store 0x36774c01 To .aS1[ 178 ]
			Store 0xd07e9efe To .aS1[ 179 ]
			Store 0x2bf11fb4 To .aS1[ 180 ]
			Store 0x95dbda4d To .aS1[ 181 ]
			Store 0xae909198 To .aS1[ 182 ]
			Store 0xeaad8e71 To .aS1[ 183 ]
			Store 0x6b93d5a0 To .aS1[ 184 ]
			Store 0xd08ed1d0 To .aS1[ 185 ]
			Store 0xafc725e0 To .aS1[ 186 ]
			Store 0x8e3c5b2f To .aS1[ 187 ]
			Store 0x8e7594b7 To .aS1[ 188 ]
			Store 0x8ff6e2fb To .aS1[ 189 ]
			Store 0xf2122b64 To .aS1[ 190 ]
			Store 0x8888b812 To .aS1[ 191 ]
			Store 0x900df01c To .aS1[ 192 ]
			Store 0x4fad5ea0 To .aS1[ 193 ]
			Store 0x688fc31c To .aS1[ 194 ]
			Store 0xd1cff191 To .aS1[ 195 ]
			Store 0xb3a8c1ad To .aS1[ 196 ]
			Store 0x2f2f2218 To .aS1[ 197 ]
			Store 0xbe0e1777 To .aS1[ 198 ]
			Store 0xea752dfe To .aS1[ 199 ]
			Store 0x8b021fa1 To .aS1[ 200 ]
			Store 0xe5a0cc0f To .aS1[ 201 ]
			Store 0xb56f74e8 To .aS1[ 202 ]
			Store 0x18acf3d6 To .aS1[ 203 ]
			Store 0xce89e299 To .aS1[ 204 ]
			Store 0xb4a84fe0 To .aS1[ 205 ]
			Store 0xfd13e0b7 To .aS1[ 206 ]
			Store 0x7cc43b81 To .aS1[ 207 ]
			Store 0xd2ada8d9 To .aS1[ 208 ]
			Store 0x165fa266 To .aS1[ 209 ]
			Store 0x80957705 To .aS1[ 210 ]
			Store 0x93cc7314 To .aS1[ 211 ]
			Store 0x211a1477 To .aS1[ 212 ]
			Store 0xe6ad2065 To .aS1[ 213 ]
			Store 0x77b5fa86 To .aS1[ 214 ]
			Store 0xc75442f5 To .aS1[ 215 ]
			Store 0xfb9d35cf To .aS1[ 216 ]
			Store 0xebcdaf0c To .aS1[ 217 ]
			Store 0x7b3e89a0 To .aS1[ 218 ]
			Store 0xd6411bd3 To .aS1[ 219 ]
			Store 0xae1e7e49 To .aS1[ 220 ]
			Store 0x00250e2d To .aS1[ 221 ]
			Store 0x2071b35e To .aS1[ 222 ]
			Store 0x226800bb To .aS1[ 223 ]
			Store 0x57b8e0af To .aS1[ 224 ]
			Store 0x2464369b To .aS1[ 225 ]
			Store 0xf009b91e To .aS1[ 226 ]
			Store 0x5563911d To .aS1[ 227 ]
			Store 0x59dfa6aa To .aS1[ 228 ]
			Store 0x78c14389 To .aS1[ 229 ]
			Store 0xd95a537f To .aS1[ 230 ]
			Store 0x207d5ba2 To .aS1[ 231 ]
			Store 0x02e5b9c5 To .aS1[ 232 ]
			Store 0x83260376 To .aS1[ 233 ]
			Store 0x6295cfa9 To .aS1[ 234 ]
			Store 0x11c81968 To .aS1[ 235 ]
			Store 0x4e734a41 To .aS1[ 236 ]
			Store 0xb3472dca To .aS1[ 237 ]
			Store 0x7b14a94a To .aS1[ 238 ]
			Store 0x1b510052 To .aS1[ 239 ]
			Store 0x9a532915 To .aS1[ 240 ]
			Store 0xd60f573f To .aS1[ 241 ]
			Store 0xbc9bc6e4 To .aS1[ 242 ]
			Store 0x2b60a476 To .aS1[ 243 ]
			Store 0x81e67400 To .aS1[ 244 ]
			Store 0x08ba6fb5 To .aS1[ 245 ]
			Store 0x571be91f To .aS1[ 246 ]
			Store 0xf296ec6b To .aS1[ 247 ]
			Store 0x2a0dd915 To .aS1[ 248 ]
			Store 0xb6636521 To .aS1[ 249 ]
			Store 0xe7b9f9b6 To .aS1[ 250 ]
			Store 0xff34052e To .aS1[ 251 ]
			Store 0xc5855664 To .aS1[ 252 ]
			Store 0x53b02d5d To .aS1[ 253 ]
			Store 0xa99f8fa1 To .aS1[ 254 ]
			Store 0x08ba4799 To .aS1[ 255 ]
			Store 0x6e85076a To .aS1[ 256 ]

			* - - - -
			Store 0x4b7a70e9 To .aS2[ 1 ]
			Store 0xb5b32944 To .aS2[ 2 ]
			Store 0xdb75092e To .aS2[ 3 ]
			Store 0xc4192623 To .aS2[ 4 ]
			Store 0xad6ea6b0 To .aS2[ 5 ]
			Store 0x49a7df7d To .aS2[ 6 ]
			Store 0x9cee60b8 To .aS2[ 7 ]
			Store 0x8fedb266 To .aS2[ 8 ]
			Store 0xecaa8c71 To .aS2[ 9 ]
			Store 0x699a17ff To .aS2[ 10 ]
			Store 0x5664526c To .aS2[ 11 ]
			Store 0xc2b19ee1 To .aS2[ 12 ]
			Store 0x193602a5 To .aS2[ 13 ]
			Store 0x75094c29 To .aS2[ 14 ]
			Store 0xa0591340 To .aS2[ 15 ]
			Store 0xe4183a3e To .aS2[ 16 ]
			Store 0x3f54989a To .aS2[ 17 ]
			Store 0x5b429d65 To .aS2[ 18 ]
			Store 0x6b8fe4d6 To .aS2[ 19 ]
			Store 0x99f73fd6 To .aS2[ 20 ]
			Store 0xa1d29c07 To .aS2[ 21 ]
			Store 0xefe830f5 To .aS2[ 22 ]
			Store 0x4d2d38e6 To .aS2[ 23 ]
			Store 0xf0255dc1 To .aS2[ 24 ]
			Store 0x4cdd2086 To .aS2[ 25 ]
			Store 0x8470eb26 To .aS2[ 26 ]
			Store 0x6382e9c6 To .aS2[ 27 ]
			Store 0x021ecc5e To .aS2[ 28 ]
			Store 0x09686b3f To .aS2[ 29 ]
			Store 0x3ebaefc9 To .aS2[ 30 ]
			Store 0x3c971814 To .aS2[ 31 ]
			Store 0x6b6a70a1 To .aS2[ 32 ]
			Store 0x687f3584 To .aS2[ 33 ]
			Store 0x52a0e286 To .aS2[ 34 ]
			Store 0xb79c5305 To .aS2[ 35 ]
			Store 0xaa500737 To .aS2[ 36 ]
			Store 0x3e07841c To .aS2[ 37 ]
			Store 0x7fdeae5c To .aS2[ 38 ]
			Store 0x8e7d44ec To .aS2[ 39 ]
			Store 0x5716f2b8 To .aS2[ 40 ]
			Store 0xb03ada37 To .aS2[ 41 ]
			Store 0xf0500c0d To .aS2[ 42 ]
			Store 0xf01c1f04 To .aS2[ 43 ]
			Store 0x0200b3ff To .aS2[ 44 ]
			Store 0xae0cf51a To .aS2[ 45 ]
			Store 0x3cb574b2 To .aS2[ 46 ]
			Store 0x25837a58 To .aS2[ 47 ]
			Store 0xdc0921bd To .aS2[ 48 ]
			Store 0xd19113f9 To .aS2[ 49 ]
			Store 0x7ca92ff6 To .aS2[ 50 ]
			Store 0x94324773 To .aS2[ 51 ]
			Store 0x22f54701 To .aS2[ 52 ]
			Store 0x3ae5e581 To .aS2[ 53 ]
			Store 0x37c2dadc To .aS2[ 54 ]
			Store 0xc8b57634 To .aS2[ 55 ]
			Store 0x9af3dda7 To .aS2[ 56 ]
			Store 0xa9446146 To .aS2[ 57 ]
			Store 0x0fd0030e To .aS2[ 58 ]
			Store 0xecc8c73e To .aS2[ 59 ]
			Store 0xa4751e41 To .aS2[ 60 ]
			Store 0xe238cd99 To .aS2[ 61 ]
			Store 0x3bea0e2f To .aS2[ 62 ]
			Store 0x3280bba1 To .aS2[ 63 ]
			Store 0x183eb331 To .aS2[ 64 ]
			Store 0x4e548b38 To .aS2[ 65 ]
			Store 0x4f6db908 To .aS2[ 66 ]
			Store 0x6f420d03 To .aS2[ 67 ]
			Store 0xf60a04bf To .aS2[ 68 ]
			Store 0x2cb81290 To .aS2[ 69 ]
			Store 0x24977c79 To .aS2[ 70 ]
			Store 0x5679b072 To .aS2[ 71 ]
			Store 0xbcaf89af To .aS2[ 72 ]
			Store 0xde9a771f To .aS2[ 73 ]
			Store 0xd9930810 To .aS2[ 74 ]
			Store 0xb38bae12 To .aS2[ 75 ]
			Store 0xdccf3f2e To .aS2[ 76 ]
			Store 0x5512721f To .aS2[ 77 ]
			Store 0x2e6b7124 To .aS2[ 78 ]
			Store 0x501adde6 To .aS2[ 79 ]
			Store 0x9f84cd87 To .aS2[ 80 ]
			Store 0x7a584718 To .aS2[ 81 ]
			Store 0x7408da17 To .aS2[ 82 ]
			Store 0xbc9f9abc To .aS2[ 83 ]
			Store 0xe94b7d8c To .aS2[ 84 ]
			Store 0xec7aec3a To .aS2[ 85 ]
			Store 0xdb851dfa To .aS2[ 86 ]
			Store 0x63094366 To .aS2[ 87 ]
			Store 0xc464c3d2 To .aS2[ 88 ]
			Store 0xef1c1847 To .aS2[ 89 ]
			Store 0x3215d908 To .aS2[ 90 ]
			Store 0xdd433b37 To .aS2[ 91 ]
			Store 0x24c2ba16 To .aS2[ 92 ]
			Store 0x12a14d43 To .aS2[ 93 ]
			Store 0x2a65c451 To .aS2[ 94 ]
			Store 0x50940002 To .aS2[ 95 ]
			Store 0x133ae4dd To .aS2[ 96 ]
			Store 0x71dff89e To .aS2[ 97 ]
			Store 0x10314e55 To .aS2[ 98 ]
			Store 0x81ac77d6 To .aS2[ 99 ]
			Store 0x5f11199b To .aS2[ 100 ]
			Store 0x043556f1 To .aS2[ 101 ]
			Store 0xd7a3c76b To .aS2[ 102 ]
			Store 0x3c11183b To .aS2[ 103 ]
			Store 0x5924a509 To .aS2[ 104 ]
			Store 0xf28fe6ed To .aS2[ 105 ]
			Store 0x97f1fbfa To .aS2[ 106 ]
			Store 0x9ebabf2c To .aS2[ 107 ]
			Store 0x1e153c6e To .aS2[ 108 ]
			Store 0x86e34570 To .aS2[ 109 ]
			Store 0xeae96fb1 To .aS2[ 110 ]
			Store 0x860e5e0a To .aS2[ 111 ]
			Store 0x5a3e2ab3 To .aS2[ 112 ]
			Store 0x771fe71c To .aS2[ 113 ]
			Store 0x4e3d06fa To .aS2[ 114 ]
			Store 0x2965dcb9 To .aS2[ 115 ]
			Store 0x99e71d0f To .aS2[ 116 ]
			Store 0x803e89d6 To .aS2[ 117 ]
			Store 0x5266c825 To .aS2[ 118 ]
			Store 0x2e4cc978 To .aS2[ 119 ]
			Store 0x9c10b36a To .aS2[ 120 ]
			Store 0xc6150eba To .aS2[ 121 ]
			Store 0x94e2ea78 To .aS2[ 122 ]
			Store 0xa5fc3c53 To .aS2[ 123 ]
			Store 0x1e0a2df4 To .aS2[ 124 ]
			Store 0xf2f74ea7 To .aS2[ 125 ]
			Store 0x361d2b3d To .aS2[ 126 ]
			Store 0x1939260f To .aS2[ 127 ]
			Store 0x19c27960 To .aS2[ 128 ]
			Store 0x5223a708 To .aS2[ 129 ]
			Store 0xf71312b6 To .aS2[ 130 ]
			Store 0xebadfe6e To .aS2[ 131 ]
			Store 0xeac31f66 To .aS2[ 132 ]
			Store 0xe3bc4595 To .aS2[ 133 ]
			Store 0xa67bc883 To .aS2[ 134 ]
			Store 0xb17f37d1 To .aS2[ 135 ]
			Store 0x018cff28 To .aS2[ 136 ]
			Store 0xc332ddef To .aS2[ 137 ]
			Store 0xbe6c5aa5 To .aS2[ 138 ]
			Store 0x65582185 To .aS2[ 139 ]
			Store 0x68ab9802 To .aS2[ 140 ]
			Store 0xeecea50f To .aS2[ 141 ]
			Store 0xdb2f953b To .aS2[ 142 ]
			Store 0x2aef7dad To .aS2[ 143 ]
			Store 0x5b6e2f84 To .aS2[ 144 ]
			Store 0x1521b628 To .aS2[ 145 ]
			Store 0x29076170 To .aS2[ 146 ]
			Store 0xecdd4775 To .aS2[ 147 ]
			Store 0x619f1510 To .aS2[ 148 ]
			Store 0x13cca830 To .aS2[ 149 ]
			Store 0xeb61bd96 To .aS2[ 150 ]
			Store 0x0334fe1e To .aS2[ 151 ]
			Store 0xaa0363cf To .aS2[ 152 ]
			Store 0xb5735c90 To .aS2[ 153 ]
			Store 0x4c70a239 To .aS2[ 154 ]
			Store 0xd59e9e0b To .aS2[ 155 ]
			Store 0xcbaade14 To .aS2[ 156 ]
			Store 0xeecc86bc To .aS2[ 157 ]
			Store 0x60622ca7 To .aS2[ 158 ]
			Store 0x9cab5cab To .aS2[ 159 ]
			Store 0xb2f3846e To .aS2[ 160 ]
			Store 0x648b1eaf To .aS2[ 161 ]
			Store 0x19bdf0ca To .aS2[ 162 ]
			Store 0xa02369b9 To .aS2[ 163 ]
			Store 0x655abb50 To .aS2[ 164 ]
			Store 0x40685a32 To .aS2[ 165 ]
			Store 0x3c2ab4b3 To .aS2[ 166 ]
			Store 0x319ee9d5 To .aS2[ 167 ]
			Store 0xc021b8f7 To .aS2[ 168 ]
			Store 0x9b540b19 To .aS2[ 169 ]
			Store 0x875fa099 To .aS2[ 170 ]
			Store 0x95f7997e To .aS2[ 171 ]
			Store 0x623d7da8 To .aS2[ 172 ]
			Store 0xf837889a To .aS2[ 173 ]
			Store 0x97e32d77 To .aS2[ 174 ]
			Store 0x11ed935f To .aS2[ 175 ]
			Store 0x16681281 To .aS2[ 176 ]
			Store 0x0e358829 To .aS2[ 177 ]
			Store 0xc7e61fd6 To .aS2[ 178 ]
			Store 0x96dedfa1 To .aS2[ 179 ]
			Store 0x7858ba99 To .aS2[ 180 ]
			Store 0x57f584a5 To .aS2[ 181 ]
			Store 0x1b227263 To .aS2[ 182 ]
			Store 0x9b83c3ff To .aS2[ 183 ]
			Store 0x1ac24696 To .aS2[ 184 ]
			Store 0xcdb30aeb To .aS2[ 185 ]
			Store 0x532e3054 To .aS2[ 186 ]
			Store 0x8fd948e4 To .aS2[ 187 ]
			Store 0x6dbc3128 To .aS2[ 188 ]
			Store 0x58ebf2ef To .aS2[ 189 ]
			Store 0x34c6ffea To .aS2[ 190 ]
			Store 0xfe28ed61 To .aS2[ 191 ]
			Store 0xee7c3c73 To .aS2[ 192 ]
			Store 0x5d4a14d9 To .aS2[ 193 ]
			Store 0xe864b7e3 To .aS2[ 194 ]
			Store 0x42105d14 To .aS2[ 195 ]
			Store 0x203e13e0 To .aS2[ 196 ]
			Store 0x45eee2b6 To .aS2[ 197 ]
			Store 0xa3aaabea To .aS2[ 198 ]
			Store 0xdb6c4f15 To .aS2[ 199 ]
			Store 0xfacb4fd0 To .aS2[ 200 ]
			Store 0xc742f442 To .aS2[ 201 ]
			Store 0xef6abbb5 To .aS2[ 202 ]
			Store 0x654f3b1d To .aS2[ 203 ]
			Store 0x41cd2105 To .aS2[ 204 ]
			Store 0xd81e799e To .aS2[ 205 ]
			Store 0x86854dc7 To .aS2[ 206 ]
			Store 0xe44b476a To .aS2[ 207 ]
			Store 0x3d816250 To .aS2[ 208 ]
			Store 0xcf62a1f2 To .aS2[ 209 ]
			Store 0x5b8d2646 To .aS2[ 210 ]
			Store 0xfc8883a0 To .aS2[ 211 ]
			Store 0xc1c7b6a3 To .aS2[ 212 ]
			Store 0x7f1524c3 To .aS2[ 213 ]
			Store 0x69cb7492 To .aS2[ 214 ]
			Store 0x47848a0b To .aS2[ 215 ]
			Store 0x5692b285 To .aS2[ 216 ]
			Store 0x095bbf00 To .aS2[ 217 ]
			Store 0xad19489d To .aS2[ 218 ]
			Store 0x1462b174 To .aS2[ 219 ]
			Store 0x23820e00 To .aS2[ 220 ]
			Store 0x58428d2a To .aS2[ 221 ]
			Store 0x0c55f5ea To .aS2[ 222 ]
			Store 0x1dadf43e To .aS2[ 223 ]
			Store 0x233f7061 To .aS2[ 224 ]
			Store 0x3372f092 To .aS2[ 225 ]
			Store 0x8d937e41 To .aS2[ 226 ]
			Store 0xd65fecf1 To .aS2[ 227 ]
			Store 0x6c223bdb To .aS2[ 228 ]
			Store 0x7cde3759 To .aS2[ 229 ]
			Store 0xcbee7460 To .aS2[ 230 ]
			Store 0x4085f2a7 To .aS2[ 231 ]
			Store 0xce77326e To .aS2[ 232 ]
			Store 0xa6078084 To .aS2[ 233 ]
			Store 0x19f8509e To .aS2[ 234 ]
			Store 0xe8efd855 To .aS2[ 235 ]
			Store 0x61d99735 To .aS2[ 236 ]
			Store 0xa969a7aa To .aS2[ 237 ]
			Store 0xc50c06c2 To .aS2[ 238 ]
			Store 0x5a04abfc To .aS2[ 239 ]
			Store 0x800bcadc To .aS2[ 240 ]
			Store 0x9e447a2e To .aS2[ 241 ]
			Store 0xc3453484 To .aS2[ 242 ]
			Store 0xfdd56705 To .aS2[ 243 ]
			Store 0x0e1e9ec9 To .aS2[ 244 ]
			Store 0xdb73dbd3 To .aS2[ 245 ]
			Store 0x105588cd To .aS2[ 246 ]
			Store 0x675fda79 To .aS2[ 247 ]
			Store 0xe3674340 To .aS2[ 248 ]
			Store 0xc5c43465 To .aS2[ 249 ]
			Store 0x713e38d8 To .aS2[ 250 ]
			Store 0x3d28f89e To .aS2[ 251 ]
			Store 0xf16dff20 To .aS2[ 252 ]
			Store 0x153e21e7 To .aS2[ 253 ]
			Store 0x8fb03d4a To .aS2[ 254 ]
			Store 0xe6e39f2b To .aS2[ 255 ]
			Store 0xdb83adf7 To .aS2[ 256 ]

			* - - -
			Store 0xe93d5a68 To .aS3[ 1 ]
			Store 0x948140f7 To .aS3[ 2 ]
			Store 0xf64c261c To .aS3[ 3 ]
			Store 0x94692934 To .aS3[ 4 ]
			Store 0x411520f7 To .aS3[ 5 ]
			Store 0x7602d4f7 To .aS3[ 6 ]
			Store 0xbcf46b2e To .aS3[ 7 ]
			Store 0xd4a20068 To .aS3[ 8 ]
			Store 0xd4082471 To .aS3[ 9 ]
			Store 0x3320f46a To .aS3[ 10 ]
			Store 0x43b7d4b7 To .aS3[ 11 ]
			Store 0x500061af To .aS3[ 12 ]
			Store 0x1e39f62e To .aS3[ 13 ]
			Store 0x97244546 To .aS3[ 14 ]
			Store 0x14214f74 To .aS3[ 15 ]
			Store 0xbf8b8840 To .aS3[ 16 ]
			Store 0x4d95fc1d To .aS3[ 17 ]
			Store 0x96b591af To .aS3[ 18 ]
			Store 0x70f4ddd3 To .aS3[ 19 ]
			Store 0x66a02f45 To .aS3[ 20 ]
			Store 0xbfbc09ec To .aS3[ 21 ]
			Store 0x03bd9785 To .aS3[ 22 ]
			Store 0x7fac6dd0 To .aS3[ 23 ]
			Store 0x31cb8504 To .aS3[ 24 ]
			Store 0x96eb27b3 To .aS3[ 25 ]
			Store 0x55fd3941 To .aS3[ 26 ]
			Store 0xda2547e6 To .aS3[ 27 ]
			Store 0xabca0a9a To .aS3[ 28 ]
			Store 0x28507825 To .aS3[ 29 ]
			Store 0x530429f4 To .aS3[ 30 ]
			Store 0x0a2c86da To .aS3[ 31 ]
			Store 0xe9b66dfb To .aS3[ 32 ]
			Store 0x68dc1462 To .aS3[ 33 ]
			Store 0xd7486900 To .aS3[ 34 ]
			Store 0x680ec0a4 To .aS3[ 35 ]
			Store 0x27a18dee To .aS3[ 36 ]
			Store 0x4f3ffea2 To .aS3[ 37 ]
			Store 0xe887ad8c To .aS3[ 38 ]
			Store 0xb58ce006 To .aS3[ 39 ]
			Store 0x7af4d6b6 To .aS3[ 40 ]
			Store 0xaace1e7c To .aS3[ 41 ]
			Store 0xd3375fec To .aS3[ 42 ]
			Store 0xce78a399 To .aS3[ 43 ]
			Store 0x406b2a42 To .aS3[ 44 ]
			Store 0x20fe9e35 To .aS3[ 45 ]
			Store 0xd9f385b9 To .aS3[ 46 ]
			Store 0xee39d7ab To .aS3[ 47 ]
			Store 0x3b124e8b To .aS3[ 48 ]
			Store 0x1dc9faf7 To .aS3[ 49 ]
			Store 0x4b6d1856 To .aS3[ 50 ]
			Store 0x26a36631 To .aS3[ 51 ]
			Store 0xeae397b2 To .aS3[ 52 ]
			Store 0x3a6efa74 To .aS3[ 53 ]
			Store 0xdd5b4332 To .aS3[ 54 ]
			Store 0x6841e7f7 To .aS3[ 55 ]
			Store 0xca7820fb To .aS3[ 56 ]
			Store 0xfb0af54e To .aS3[ 57 ]
			Store 0xd8feb397 To .aS3[ 58 ]
			Store 0x454056ac To .aS3[ 59 ]
			Store 0xba489527 To .aS3[ 60 ]
			Store 0x55533a3a To .aS3[ 61 ]
			Store 0x20838d87 To .aS3[ 62 ]
			Store 0xfe6ba9b7 To .aS3[ 63 ]
			Store 0xd096954b To .aS3[ 64 ]
			Store 0x55a867bc To .aS3[ 65 ]
			Store 0xa1159a58 To .aS3[ 66 ]
			Store 0xcca92963 To .aS3[ 67 ]
			Store 0x99e1db33 To .aS3[ 68 ]
			Store 0xa62a4a56 To .aS3[ 69 ]
			Store 0x3f3125f9 To .aS3[ 70 ]
			Store 0x5ef47e1c To .aS3[ 71 ]
			Store 0x9029317c To .aS3[ 72 ]
			Store 0xfdf8e802 To .aS3[ 73 ]
			Store 0x04272f70 To .aS3[ 74 ]
			Store 0x80bb155c To .aS3[ 75 ]
			Store 0x05282ce3 To .aS3[ 76 ]
			Store 0x95c11548 To .aS3[ 77 ]
			Store 0xe4c66d22 To .aS3[ 78 ]
			Store 0x48c1133f To .aS3[ 79 ]
			Store 0xc70f86dc To .aS3[ 80 ]
			Store 0x07f9c9ee To .aS3[ 81 ]
			Store 0x41041f0f To .aS3[ 82 ]
			Store 0x404779a4 To .aS3[ 83 ]
			Store 0x5d886e17 To .aS3[ 84 ]
			Store 0x325f51eb To .aS3[ 85 ]
			Store 0xd59bc0d1 To .aS3[ 86 ]
			Store 0xf2bcc18f To .aS3[ 87 ]
			Store 0x41113564 To .aS3[ 88 ]
			Store 0x257b7834 To .aS3[ 89 ]
			Store 0x602a9c60 To .aS3[ 90 ]
			Store 0xdff8e8a3 To .aS3[ 91 ]
			Store 0x1f636c1b To .aS3[ 92 ]
			Store 0x0e12b4c2 To .aS3[ 93 ]
			Store 0x02e1329e To .aS3[ 94 ]
			Store 0xaf664fd1 To .aS3[ 95 ]
			Store 0xcad18115 To .aS3[ 96 ]
			Store 0x6b2395e0 To .aS3[ 97 ]
			Store 0x333e92e1 To .aS3[ 98 ]
			Store 0x3b240b62 To .aS3[ 99 ]
			Store 0xeebeb922 To .aS3[ 100 ]
			Store 0x85b2a20e To .aS3[ 101 ]
			Store 0xe6ba0d99 To .aS3[ 102 ]
			Store 0xde720c8c To .aS3[ 103 ]
			Store 0x2da2f728 To .aS3[ 104 ]
			Store 0xd0127845 To .aS3[ 105 ]
			Store 0x95b794fd To .aS3[ 106 ]
			Store 0x647d0862 To .aS3[ 107 ]
			Store 0xe7ccf5f0 To .aS3[ 108 ]
			Store 0x5449a36f To .aS3[ 109 ]
			Store 0x877d48fa To .aS3[ 110 ]
			Store 0xc39dfd27 To .aS3[ 111 ]
			Store 0xf33e8d1e To .aS3[ 112 ]
			Store 0x0a476341 To .aS3[ 113 ]
			Store 0x992eff74 To .aS3[ 114 ]
			Store 0x3a6f6eab To .aS3[ 115 ]
			Store 0xf4f8fd37 To .aS3[ 116 ]
			Store 0xa812dc60 To .aS3[ 117 ]
			Store 0xa1ebddf8 To .aS3[ 118 ]
			Store 0x991be14c To .aS3[ 119 ]
			Store 0xdb6e6b0d To .aS3[ 120 ]
			Store 0xc67b5510 To .aS3[ 121 ]
			Store 0x6d672c37 To .aS3[ 122 ]
			Store 0x2765d43b To .aS3[ 123 ]
			Store 0xdcd0e804 To .aS3[ 124 ]
			Store 0xf1290dc7 To .aS3[ 125 ]
			Store 0xcc00ffa3 To .aS3[ 126 ]
			Store 0xb5390f92 To .aS3[ 127 ]
			Store 0x690fed0b To .aS3[ 128 ]
			Store 0x667b9ffb To .aS3[ 129 ]
			Store 0xcedb7d9c To .aS3[ 130 ]
			Store 0xa091cf0b To .aS3[ 131 ]
			Store 0xd9155ea3 To .aS3[ 132 ]
			Store 0xbb132f88 To .aS3[ 133 ]
			Store 0x515bad24 To .aS3[ 134 ]
			Store 0x7b9479bf To .aS3[ 135 ]
			Store 0x763bd6eb To .aS3[ 136 ]
			Store 0x37392eb3 To .aS3[ 137 ]
			Store 0xcc115979 To .aS3[ 138 ]
			Store 0x8026e297 To .aS3[ 139 ]
			Store 0xf42e312d To .aS3[ 140 ]
			Store 0x6842ada7 To .aS3[ 141 ]
			Store 0xc66a2b3b To .aS3[ 142 ]
			Store 0x12754ccc To .aS3[ 143 ]
			Store 0x782ef11c To .aS3[ 144 ]
			Store 0x6a124237 To .aS3[ 145 ]
			Store 0xb79251e7 To .aS3[ 146 ]
			Store 0x06a1bbe6 To .aS3[ 147 ]
			Store 0x4bfb6350 To .aS3[ 148 ]
			Store 0x1a6b1018 To .aS3[ 149 ]
			Store 0x11caedfa To .aS3[ 150 ]
			Store 0x3d25bdd8 To .aS3[ 151 ]
			Store 0xe2e1c3c9 To .aS3[ 152 ]
			Store 0x44421659 To .aS3[ 153 ]
			Store 0x0a121386 To .aS3[ 154 ]
			Store 0xd90cec6e To .aS3[ 155 ]
			Store 0xd5abea2a To .aS3[ 156 ]
			Store 0x64af674e To .aS3[ 157 ]
			Store 0xda86a85f To .aS3[ 158 ]
			Store 0xbebfe988 To .aS3[ 159 ]
			Store 0x64e4c3fe To .aS3[ 160 ]
			Store 0x9dbc8057 To .aS3[ 161 ]
			Store 0xf0f7c086 To .aS3[ 162 ]
			Store 0x60787bf8 To .aS3[ 163 ]
			Store 0x6003604d To .aS3[ 164 ]
			Store 0xd1fd8346 To .aS3[ 165 ]
			Store 0xf6381fb0 To .aS3[ 166 ]
			Store 0x7745ae04 To .aS3[ 167 ]
			Store 0xd736fccc To .aS3[ 168 ]
			Store 0x83426b33 To .aS3[ 169 ]
			Store 0xf01eab71 To .aS3[ 170 ]
			Store 0xb0804187 To .aS3[ 171 ]
			Store 0x3c005e5f To .aS3[ 172 ]
			Store 0x77a057be To .aS3[ 173 ]
			Store 0xbde8ae24 To .aS3[ 174 ]
			Store 0x55464299 To .aS3[ 175 ]
			Store 0xbf582e61 To .aS3[ 176 ]
			Store 0x4e58f48f To .aS3[ 177 ]
			Store 0xf2ddfda2 To .aS3[ 178 ]
			Store 0xf474ef38 To .aS3[ 179 ]
			Store 0x8789bdc2 To .aS3[ 180 ]
			Store 0x5366f9c3 To .aS3[ 181 ]
			Store 0xc8b38e74 To .aS3[ 182 ]
			Store 0xb475f255 To .aS3[ 183 ]
			Store 0x46fcd9b9 To .aS3[ 184 ]
			Store 0x7aeb2661 To .aS3[ 185 ]
			Store 0x8b1ddf84 To .aS3[ 186 ]
			Store 0x846a0e79 To .aS3[ 187 ]
			Store 0x915f95e2 To .aS3[ 188 ]
			Store 0x466e598e To .aS3[ 189 ]
			Store 0x20b45770 To .aS3[ 190 ]
			Store 0x8cd55591 To .aS3[ 191 ]
			Store 0xc902de4c To .aS3[ 192 ]
			Store 0xb90bace1 To .aS3[ 193 ]
			Store 0xbb8205d0 To .aS3[ 194 ]
			Store 0x11a86248 To .aS3[ 195 ]
			Store 0x7574a99e To .aS3[ 196 ]
			Store 0xb77f19b6 To .aS3[ 197 ]
			Store 0xe0a9dc09 To .aS3[ 198 ]
			Store 0x662d09a1 To .aS3[ 199 ]
			Store 0xc4324633 To .aS3[ 200 ]
			Store 0xe85a1f02 To .aS3[ 201 ]
			Store 0x09f0be8c To .aS3[ 202 ]
			Store 0x4a99a025 To .aS3[ 203 ]
			Store 0x1d6efe10 To .aS3[ 204 ]
			Store 0x1ab93d1d To .aS3[ 205 ]
			Store 0x0ba5a4df To .aS3[ 206 ]
			Store 0xa186f20f To .aS3[ 207 ]
			Store 0x2868f169 To .aS3[ 208 ]
			Store 0xdcb7da83 To .aS3[ 209 ]
			Store 0x573906fe To .aS3[ 210 ]
			Store 0xa1e2ce9b To .aS3[ 211 ]
			Store 0x4fcd7f52 To .aS3[ 212 ]
			Store 0x50115e01 To .aS3[ 213 ]
			Store 0xa70683fa To .aS3[ 214 ]
			Store 0xa002b5c4 To .aS3[ 215 ]
			Store 0x0de6d027 To .aS3[ 216 ]
			Store 0x9af88c27 To .aS3[ 217 ]
			Store 0x773f8641 To .aS3[ 218 ]
			Store 0xc3604c06 To .aS3[ 219 ]
			Store 0x61a806b5 To .aS3[ 220 ]
			Store 0xf0177a28 To .aS3[ 221 ]
			Store 0xc0f586e0 To .aS3[ 222 ]
			Store 0x006058aa To .aS3[ 223 ]
			Store 0x30dc7d62 To .aS3[ 224 ]
			Store 0x11e69ed7 To .aS3[ 225 ]
			Store 0x2338ea63 To .aS3[ 226 ]
			Store 0x53c2dd94 To .aS3[ 227 ]
			Store 0xc2c21634 To .aS3[ 228 ]
			Store 0xbbcbee56 To .aS3[ 229 ]
			Store 0x90bcb6de To .aS3[ 230 ]
			Store 0xebfc7da1 To .aS3[ 231 ]
			Store 0xce591d76 To .aS3[ 232 ]
			Store 0x6f05e409 To .aS3[ 233 ]
			Store 0x4b7c0188 To .aS3[ 234 ]
			Store 0x39720a3d To .aS3[ 235 ]
			Store 0x7c927c24 To .aS3[ 236 ]
			Store 0x86e3725f To .aS3[ 237 ]
			Store 0x724d9db9 To .aS3[ 238 ]
			Store 0x1ac15bb4 To .aS3[ 239 ]
			Store 0xd39eb8fc To .aS3[ 240 ]
			Store 0xed545578 To .aS3[ 241 ]
			Store 0x08fca5b5 To .aS3[ 242 ]
			Store 0xd83d7cd3 To .aS3[ 243 ]
			Store 0x4dad0fc4 To .aS3[ 244 ]
			Store 0x1e50ef5e To .aS3[ 245 ]
			Store 0xb161e6f8 To .aS3[ 246 ]
			Store 0xa28514d9 To .aS3[ 247 ]
			Store 0x6c51133c To .aS3[ 248 ]
			Store 0x6fd5c7e7 To .aS3[ 249 ]
			Store 0x56e14ec4 To .aS3[ 250 ]
			Store 0x362abfce To .aS3[ 251 ]
			Store 0xddc6c837 To .aS3[ 252 ]
			Store 0xd79a3234 To .aS3[ 253 ]
			Store 0x92638212 To .aS3[ 254 ]
			Store 0x670efa8e To .aS3[ 255 ]
			Store 0x406000e0 To .aS3[ 256 ]

			* - - - -
			Store 0x3a39ce37 To .aS4[ 1 ]
			Store 0xd3faf5cf To .aS4[ 2 ]
			Store 0xabc27737 To .aS4[ 3 ]
			Store 0x5ac52d1b To .aS4[ 4 ]
			Store 0x5cb0679e To .aS4[ 5 ]
			Store 0x4fa33742 To .aS4[ 6 ]
			Store 0xd3822740 To .aS4[ 7 ]
			Store 0x99bc9bbe To .aS4[ 8 ]
			Store 0xd5118e9d To .aS4[ 9 ]
			Store 0xbf0f7315 To .aS4[ 10 ]
			Store 0xd62d1c7e To .aS4[ 11 ]
			Store 0xc700c47b To .aS4[ 12 ]
			Store 0xb78c1b6b To .aS4[ 13 ]
			Store 0x21a19045 To .aS4[ 14 ]
			Store 0xb26eb1be To .aS4[ 15 ]
			Store 0x6a366eb4 To .aS4[ 16 ]
			Store 0x5748ab2f To .aS4[ 17 ]
			Store 0xbc946e79 To .aS4[ 18 ]
			Store 0xc6a376d2 To .aS4[ 19 ]
			Store 0x6549c2c8 To .aS4[ 20 ]
			Store 0x530ff8ee To .aS4[ 21 ]
			Store 0x468dde7d To .aS4[ 22 ]
			Store 0xd5730a1d To .aS4[ 23 ]
			Store 0x4cd04dc6 To .aS4[ 24 ]
			Store 0x2939bbdb To .aS4[ 25 ]
			Store 0xa9ba4650 To .aS4[ 26 ]
			Store 0xac9526e8 To .aS4[ 27 ]
			Store 0xbe5ee304 To .aS4[ 28 ]
			Store 0xa1fad5f0 To .aS4[ 29 ]
			Store 0x6a2d519a To .aS4[ 30 ]
			Store 0x63ef8ce2 To .aS4[ 31 ]
			Store 0x9a86ee22 To .aS4[ 32 ]
			Store 0xc089c2b8 To .aS4[ 33 ]
			Store 0x43242ef6 To .aS4[ 34 ]
			Store 0xa51e03aa To .aS4[ 35 ]
			Store 0x9cf2d0a4 To .aS4[ 36 ]
			Store 0x83c061ba To .aS4[ 37 ]
			Store 0x9be96a4d To .aS4[ 38 ]
			Store 0x8fe51550 To .aS4[ 39 ]
			Store 0xba645bd6 To .aS4[ 40 ]
			Store 0x2826a2f9 To .aS4[ 41 ]
			Store 0xa73a3ae1 To .aS4[ 42 ]
			Store 0x4ba99586 To .aS4[ 43 ]
			Store 0xef5562e9 To .aS4[ 44 ]
			Store 0xc72fefd3 To .aS4[ 45 ]
			Store 0xf752f7da To .aS4[ 46 ]
			Store 0x3f046f69 To .aS4[ 47 ]
			Store 0x77fa0a59 To .aS4[ 48 ]
			Store 0x80e4a915 To .aS4[ 49 ]
			Store 0x87b08601 To .aS4[ 50 ]
			Store 0x9b09e6ad To .aS4[ 51 ]
			Store 0x3b3ee593 To .aS4[ 52 ]
			Store 0xe990fd5a To .aS4[ 53 ]
			Store 0x9e34d797 To .aS4[ 54 ]
			Store 0x2cf0b7d9 To .aS4[ 55 ]
			Store 0x022b8b51 To .aS4[ 56 ]
			Store 0x96d5ac3a To .aS4[ 57 ]
			Store 0x017da67d To .aS4[ 58 ]
			Store 0xd1cf3ed6 To .aS4[ 59 ]
			Store 0x7c7d2d28 To .aS4[ 60 ]
			Store 0x1f9f25cf To .aS4[ 61 ]
			Store 0xadf2b89b To .aS4[ 62 ]
			Store 0x5ad6b472 To .aS4[ 63 ]
			Store 0x5a88f54c To .aS4[ 64 ]
			Store 0xe029ac71 To .aS4[ 65 ]
			Store 0xe019a5e6 To .aS4[ 66 ]
			Store 0x47b0acfd To .aS4[ 67 ]
			Store 0xed93fa9b To .aS4[ 68 ]
			Store 0xe8d3c48d To .aS4[ 69 ]
			Store 0x283b57cc To .aS4[ 70 ]
			Store 0xf8d56629 To .aS4[ 71 ]
			Store 0x79132e28 To .aS4[ 72 ]
			Store 0x785f0191 To .aS4[ 73 ]
			Store 0xed756055 To .aS4[ 74 ]
			Store 0xf7960e44 To .aS4[ 75 ]
			Store 0xe3d35e8c To .aS4[ 76 ]
			Store 0x15056dd4 To .aS4[ 77 ]
			Store 0x88f46dba To .aS4[ 78 ]
			Store 0x03a16125 To .aS4[ 79 ]
			Store 0x0564f0bd To .aS4[ 80 ]
			Store 0xc3eb9e15 To .aS4[ 81 ]
			Store 0x3c9057a2 To .aS4[ 82 ]
			Store 0x97271aec To .aS4[ 83 ]
			Store 0xa93a072a To .aS4[ 84 ]
			Store 0x1b3f6d9b To .aS4[ 85 ]
			Store 0x1e6321f5 To .aS4[ 86 ]
			Store 0xf59c66fb To .aS4[ 87 ]
			Store 0x26dcf319 To .aS4[ 88 ]
			Store 0x7533d928 To .aS4[ 89 ]
			Store 0xb155fdf5 To .aS4[ 90 ]
			Store 0x03563482 To .aS4[ 91 ]
			Store 0x8aba3cbb To .aS4[ 92 ]
			Store 0x28517711 To .aS4[ 93 ]
			Store 0xc20ad9f8 To .aS4[ 94 ]
			Store 0xabcc5167 To .aS4[ 95 ]
			Store 0xccad925f To .aS4[ 96 ]
			Store 0x4de81751 To .aS4[ 97 ]
			Store 0x3830dc8e To .aS4[ 98 ]
			Store 0x379d5862 To .aS4[ 99 ]
			Store 0x9320f991 To .aS4[ 100 ]
			Store 0xea7a90c2 To .aS4[ 101 ]
			Store 0xfb3e7bce To .aS4[ 102 ]
			Store 0x5121ce64 To .aS4[ 103 ]
			Store 0x774fbe32 To .aS4[ 104 ]
			Store 0xa8b6e37e To .aS4[ 105 ]
			Store 0xc3293d46 To .aS4[ 106 ]
			Store 0x48de5369 To .aS4[ 107 ]
			Store 0x6413e680 To .aS4[ 108 ]
			Store 0xa2ae0810 To .aS4[ 109 ]
			Store 0xdd6db224 To .aS4[ 110 ]
			Store 0x69852dfd To .aS4[ 111 ]
			Store 0x09072166 To .aS4[ 112 ]
			Store 0xb39a460a To .aS4[ 113 ]
			Store 0x6445c0dd To .aS4[ 114 ]
			Store 0x586cdecf To .aS4[ 115 ]
			Store 0x1c20c8ae To .aS4[ 116 ]
			Store 0x5bbef7dd To .aS4[ 117 ]
			Store 0x1b588d40 To .aS4[ 118 ]
			Store 0xccd2017f To .aS4[ 119 ]
			Store 0x6bb4e3bb To .aS4[ 120 ]
			Store 0xdda26a7e To .aS4[ 121 ]
			Store 0x3a59ff45 To .aS4[ 122 ]
			Store 0x3e350a44 To .aS4[ 123 ]
			Store 0xbcb4cdd5 To .aS4[ 124 ]
			Store 0x72eacea8 To .aS4[ 125 ]
			Store 0xfa6484bb To .aS4[ 126 ]
			Store 0x8d6612ae To .aS4[ 127 ]
			Store 0xbf3c6f47 To .aS4[ 128 ]
			Store 0xd29be463 To .aS4[ 129 ]
			Store 0x542f5d9e To .aS4[ 130 ]
			Store 0xaec2771b To .aS4[ 131 ]
			Store 0xf64e6370 To .aS4[ 132 ]
			Store 0x740e0d8d To .aS4[ 133 ]
			Store 0xe75b1357 To .aS4[ 134 ]
			Store 0xf8721671 To .aS4[ 135 ]
			Store 0xaf537d5d To .aS4[ 136 ]
			Store 0x4040cb08 To .aS4[ 137 ]
			Store 0x4eb4e2cc To .aS4[ 138 ]
			Store 0x34d2466a To .aS4[ 139 ]
			Store 0x0115af84 To .aS4[ 140 ]
			Store 0xe1b00428 To .aS4[ 141 ]
			Store 0x95983a1d To .aS4[ 142 ]
			Store 0x06b89fb4 To .aS4[ 143 ]
			Store 0xce6ea048 To .aS4[ 144 ]
			Store 0x6f3f3b82 To .aS4[ 145 ]
			Store 0x3520ab82 To .aS4[ 146 ]
			Store 0x011a1d4b To .aS4[ 147 ]
			Store 0x277227f8 To .aS4[ 148 ]
			Store 0x611560b1 To .aS4[ 149 ]
			Store 0xe7933fdc To .aS4[ 150 ]
			Store 0xbb3a792b To .aS4[ 151 ]
			Store 0x344525bd To .aS4[ 152 ]
			Store 0xa08839e1 To .aS4[ 153 ]
			Store 0x51ce794b To .aS4[ 154 ]
			Store 0x2f32c9b7 To .aS4[ 155 ]
			Store 0xa01fbac9 To .aS4[ 156 ]
			Store 0xe01cc87e To .aS4[ 157 ]
			Store 0xbcc7d1f6 To .aS4[ 158 ]
			Store 0xcf0111c3 To .aS4[ 159 ]
			Store 0xa1e8aac7 To .aS4[ 160 ]
			Store 0x1a908749 To .aS4[ 161 ]
			Store 0xd44fbd9a To .aS4[ 162 ]
			Store 0xd0dadecb To .aS4[ 163 ]
			Store 0xd50ada38 To .aS4[ 164 ]
			Store 0x0339c32a To .aS4[ 165 ]
			Store 0xc6913667 To .aS4[ 166 ]
			Store 0x8df9317c To .aS4[ 167 ]
			Store 0xe0b12b4f To .aS4[ 168 ]
			Store 0xf79e59b7 To .aS4[ 169 ]
			Store 0x43f5bb3a To .aS4[ 170 ]
			Store 0xf2d519ff To .aS4[ 171 ]
			Store 0x27d9459c To .aS4[ 172 ]
			Store 0xbf97222c To .aS4[ 173 ]
			Store 0x15e6fc2a To .aS4[ 174 ]
			Store 0x0f91fc71 To .aS4[ 175 ]
			Store 0x9b941525 To .aS4[ 176 ]
			Store 0xfae59361 To .aS4[ 177 ]
			Store 0xceb69ceb To .aS4[ 178 ]
			Store 0xc2a86459 To .aS4[ 179 ]
			Store 0x12baa8d1 To .aS4[ 180 ]
			Store 0xb6c1075e To .aS4[ 181 ]
			Store 0xe3056a0c To .aS4[ 182 ]
			Store 0x10d25065 To .aS4[ 183 ]
			Store 0xcb03a442 To .aS4[ 184 ]
			Store 0xe0ec6e0e To .aS4[ 185 ]
			Store 0x1698db3b To .aS4[ 186 ]
			Store 0x4c98a0be To .aS4[ 187 ]
			Store 0x3278e964 To .aS4[ 188 ]
			Store 0x9f1f9532 To .aS4[ 189 ]
			Store 0xe0d392df To .aS4[ 190 ]
			Store 0xd3a0342b To .aS4[ 191 ]
			Store 0x8971f21e To .aS4[ 192 ]
			Store 0x1b0a7441 To .aS4[ 193 ]
			Store 0x4ba3348c To .aS4[ 194 ]
			Store 0xc5be7120 To .aS4[ 195 ]
			Store 0xc37632d8 To .aS4[ 196 ]
			Store 0xdf359f8d To .aS4[ 197 ]
			Store 0x9b992f2e To .aS4[ 198 ]
			Store 0xe60b6f47 To .aS4[ 199 ]
			Store 0x0fe3f11d To .aS4[ 200 ]
			Store 0xe54cda54 To .aS4[ 201 ]
			Store 0x1edad891 To .aS4[ 202 ]
			Store 0xce6279cf To .aS4[ 203 ]
			Store 0xcd3e7e6f To .aS4[ 204 ]
			Store 0x1618b166 To .aS4[ 205 ]
			Store 0xfd2c1d05 To .aS4[ 206 ]
			Store 0x848fd2c5 To .aS4[ 207 ]
			Store 0xf6fb2299 To .aS4[ 208 ]
			Store 0xf523f357 To .aS4[ 209 ]
			Store 0xa6327623 To .aS4[ 210 ]
			Store 0x93a83531 To .aS4[ 211 ]
			Store 0x56cccd02 To .aS4[ 212 ]
			Store 0xacf08162 To .aS4[ 213 ]
			Store 0x5a75ebb5 To .aS4[ 214 ]
			Store 0x6e163697 To .aS4[ 215 ]
			Store 0x88d273cc To .aS4[ 216 ]
			Store 0xde966292 To .aS4[ 217 ]
			Store 0x81b949d0 To .aS4[ 218 ]
			Store 0x4c50901b To .aS4[ 219 ]
			Store 0x71c65614 To .aS4[ 220 ]
			Store 0xe6c6c7bd To .aS4[ 221 ]
			Store 0x327a140a To .aS4[ 222 ]
			Store 0x45e1d006 To .aS4[ 223 ]
			Store 0xc3f27b9a To .aS4[ 224 ]
			Store 0xc9aa53fd To .aS4[ 225 ]
			Store 0x62a80f00 To .aS4[ 226 ]
			Store 0xbb25bfe2 To .aS4[ 227 ]
			Store 0x35bdd2f6 To .aS4[ 228 ]
			Store 0x71126905 To .aS4[ 229 ]
			Store 0xb2040222 To .aS4[ 230 ]
			Store 0xb6cbcf7c To .aS4[ 231 ]
			Store 0xcd769c2b To .aS4[ 232 ]
			Store 0x53113ec0 To .aS4[ 233 ]
			Store 0x1640e3d3 To .aS4[ 234 ]
			Store 0x38abbd60 To .aS4[ 235 ]
			Store 0x2547adf0 To .aS4[ 236 ]
			Store 0xba38209c To .aS4[ 237 ]
			Store 0xf746ce76 To .aS4[ 238 ]
			Store 0x77afa1c5 To .aS4[ 239 ]
			Store 0x20756060 To .aS4[ 240 ]
			Store 0x85cbfe4e To .aS4[ 241 ]
			Store 0x8ae88dd8 To .aS4[ 242 ]
			Store 0x7aaaf9b0 To .aS4[ 243 ]
			Store 0x4cf9aa7e To .aS4[ 244 ]
			Store 0x1948c25c To .aS4[ 245 ]
			Store 0x02fb8a8c To .aS4[ 246 ]
			Store 0x01c36ae4 To .aS4[ 247 ]
			Store 0xd6ebe1f9 To .aS4[ 248 ]
			Store 0x90d4f869 To .aS4[ 249 ]
			Store 0xa65cdea0 To .aS4[ 250 ]
			Store 0x3f09252d To .aS4[ 251 ]
			Store 0xc208e69f To .aS4[ 252 ]
			Store 0xb74e6132 To .aS4[ 253 ]
			Store 0xce77e25b To .aS4[ 254 ]
			Store 0x578fdfe3 To .aS4[ 255 ]
			Store 0x3ac372e6 To .aS4[ 256 ]

		Endwith

	Endproc && BlosFishConstantes


	* - - Compara a nivel de bist dos valores
	Hidden Procedure XOR( tnValor1 As Number, tnValor2 As Number )

		Local lnResultado As Integer
		Local lnMaximo32 As Integer

		lnResultado = Bitxor( tnValor1, tnValor2 )
		lnMaximo32 = 0xffffffff

		If lnResultado < 0
			lnResultado = lnMaximo32 + 1 + lnResultado

		Endif && lnResultado < 0

		Return lnResultado

	Endproc && XOR


	* - - Inicializa todo para BlowFish
	Hidden Procedure BlosFishInicializar( tcPalabraClave As String ) As VOID
		Local lnLlaveBytes As Integer
		Local lcLlave As String
		Local lnDato As Integer
		Local i As Integer
		Local j As Integer
		Local lnLenPC As Integer

		lnLlaveBytes = Len( tcPalabraClave )
		lcLlave = ''
		lnDato = 0x00000000
		i = 0
		j = 0

		With This As BlowFish Of fw\comunes\prg\BlowFish.prg
			If lnLlaveBytes = 0
				.BlowFishIniciado = 0
			Else
				lnLenPC = Len( tcPalabraClave )
				If lnLenPC > .maxllavebytes
					lcLlave = Alltrim( Substr( tcPalabraClave, 1, .maxllavebytes ) )

				Else
					lcLlave = Alltrim( tcPalabraClave )

				Endif && lnLenPC > .maxllavebytes

				* - - - Iniciando las constantes de BlowFish en arreglo
				.BlosFishConstantes()

				j = 0
				For i = 1 To 18
					lnDato = ( ( Asc( Substr( lcLlave, ( j + 0 ) % lnLlaveBytes + 1, 1 ) ) * 256 ;
						+ Asc( Substr( lcLlave, ( j + 1 ) % lnLlaveBytes + 1, 1 ) ) ) * 256 ;
						+ Asc( Substr( lcLlave, ( j + 2 ) % lnLlaveBytes + 1, 1 ) ) ) * 256 ;
						+ Asc( Substr( lcLlave, ( j + 3 ) % lnLlaveBytes + 1, 1 ) )

					.aP[ i ] = .XOR( .aP[ i ], lnDato )
					j = ( j + 4 ) % lnLlaveBytes
				Endfor

				lcLlave = .Codificar( lcLlave )

				.parxl = 0x00000000
				.parxr = 0x00000000

				For i = 1 To 18 Step 2
					.BlowFishEncriptar()
					.aP[ i ] = .parxl
					.aP[ i + 1 ] = .parxr
				Endfor

				For j = 1 To 256 Step 2
					.BlowFishEncriptar()
					.aS1[ j ] = .parxl
					.aS1[ j + 1 ] = .parxr

					.BlowFishEncriptar()
					.aS2[ j ] = .parxl
					.aS2[ j + 1 ] = .parxr

					.BlowFishEncriptar()
					.aS3[ j ] = .parxl
					.aS3[ j + 1 ] = .parxr

					.BlowFishEncriptar()
					.aS4[ j ] = .parxl
					.aS4[ j + 1 ] = .parxr
				Endfor

				.BlowFishIniciado = 1

			Endif

		Endwith

		Return .BlowFishIniciado

	Endproc && BlosFishInicializar


	* - - Desencripta una cadena de BlowFish
	Hidden Procedure BlowFishDesEncriptar
		Local xl
		Local xr

		With This As BlowFish Of fw\comunes\prg\BlowFish.prg
			xl = .parxl
			xr = .parxr
			xl = .XOR( xl, .aP[ 18 ] )
			xr = .BlowFishRedondear( xr, xl, 17 )
			xl = .BlowFishRedondear( xl, xr, 16 )
			xr = .BlowFishRedondear( xr, xl, 15 )
			xl = .BlowFishRedondear( xl, xr, 14 )
			xr = .BlowFishRedondear( xr, xl, 13 )
			xl = .BlowFishRedondear( xl, xr, 12 )
			xr = .BlowFishRedondear( xr, xl, 11 )
			xl = .BlowFishRedondear( xl, xr, 10 )
			xr = .BlowFishRedondear( xr, xl, 9 )
			xl = .BlowFishRedondear( xl, xr, 8 )
			xr = .BlowFishRedondear( xr, xl, 7 )
			xl = .BlowFishRedondear( xl, xr, 6 )
			xr = .BlowFishRedondear( xr, xl, 5 )
			xl = .BlowFishRedondear( xl, xr, 4 )
			xr = .BlowFishRedondear( xr, xl, 3 )
			xl = .BlowFishRedondear( xl, xr, 2 )
			xr = .XOR( xr, .aP[ 1 ] )

			.parxl = xr
			.parxr = xl

		Endwith

	Endproc && BlowFishDesEncriptar


	* - - Encripta por BlowFish
	Hidden Procedure BlowFishEncriptar () As VOID
		Local xl As Integer
		Local xr As Integer

		With This As BlowFish Of fw\comunes\prg\BlowFish.prg
			xl = .parxl
			xr = .parxr
			xl = .XOR( xl, .aP[ 1 ] )
			xr = .BlowFishRedondear( xr, xl, 2 )
			xl = .BlowFishRedondear( xl, xr, 3 )
			xr = .BlowFishRedondear( xr, xl, 4 )
			xl = .BlowFishRedondear( xl, xr, 5 )
			xr = .BlowFishRedondear( xr, xl, 6 )
			xl = .BlowFishRedondear( xl, xr, 7 )
			xr = .BlowFishRedondear( xr, xl, 8 )
			xl = .BlowFishRedondear( xl, xr, 9 )
			xr = .BlowFishRedondear( xr, xl, 10 )
			xl = .BlowFishRedondear( xl, xr, 11 )
			xr = .BlowFishRedondear( xr, xl, 12 )
			xl = .BlowFishRedondear( xl, xr, 13 )
			xr = .BlowFishRedondear( xr, xl, 14 )
			xl = .BlowFishRedondear( xl, xr, 15 )
			xr = .BlowFishRedondear( xr, xl, 16 )
			xl = .BlowFishRedondear( xl, xr, 17 )
			xr = .XOR( xr, .aP[ 18 ] )

			.parxl = xr
			.parxr = xl
		Endwith

	Endproc && BlowFishEncriptar

	* BlowFishRedondear
	Hidden Procedure BlowFishRedondear( tnValorA As Integer, tnValorB As Integer, tnValorN As Integer ) As Integer
		Local lnResultado As Number
		With This As BlowFish Of fw\comunes\prg\BlowFish.prg
			lnResultado = ( .XOR( tnValorA, .XOR( ( ( .XOR( ( .aS1[ .BytePalabra1( tnValorB ) ] + .aS2[ .BytePalabra2( tnValorB ) ] ), .aS3[ .BytePalabra3( tnValorB ) ] ) ) + .aS4[ .BytePalabra4( tnValorB ) ] ), .aP[ tnValorN ] ) ) )

		Endwith
		Return lnResultado

	Endproc && BlowFishRedondear


	* - - Decodifica una palabra por bloques
	Hidden Procedure DecodificarPalabra( tnPalabra As Integer )
		Local lcResultado As String
		Local lnTemporalA As Integer
		Local lnTemporalB As Integer
		Local i As Integer

		lcResultado = 0
		lnTemporalA = 0
		lnTemporalB = 0
		&& reverse byteorder for intel systems

		For i = 7 To 1 Step - 2
			lnTemporalA = Asc( Substr( tnPalabra, i, 1 ) )
			lnTemporalB = Asc( Substr( tnPalabra, i + 1, 1 ) )

			If lnTemporalA < 58
				lnTemporalA = lnTemporalA - 48
			Else
				lnTemporalA = lnTemporalA - 55
			Endif

			If lnTemporalB < 58
				lnTemporalB = lnTemporalB - 48

			Else
				lnTemporalB = lnTemporalB - 55

			Endif

			lcResultado = lcResultado * 256 + ( ( lnTemporalA * 16 ) + lnTemporalB )

		Endfor

		Return lcResultado

	Endproc && DecodificarPalabra


	* - - Codifica un bloque de palabras
	Hidden Procedure codificarpalabra
		Lparameters tnPalabra
		Local lcResultado, lnTemporalA, lnTemporalB, i
		Local Array laBytes[ 4 ]

		lcResultado = ""
		lnTemporalA = 0
		lnTemporalB = 0
		i = 0

		With This
			Store .BytePalabra1( tnPalabra ) - 1 To laBytes[ 1 ]
			Store .BytePalabra2( tnPalabra ) - 1 To laBytes[ 2 ]
			Store .BytePalabra3( tnPalabra ) - 1 To laBytes[ 3 ]
			Store .BytePalabra4( tnPalabra ) - 1 To laBytes[ 4 ]

			For i = 4 To 1 Step - 1
				lnTemporalA = Floor( laBytes[ i ]/16 )
				lnTemporalB = laBytes[ i ] % 16

				If lnTemporalA < 10
					lnTemporalA = lnTemporalA + 48
				Else
					lnTemporalA = lnTemporalA + 55
				Endif

				If lnTemporalB < 10
					lnTemporalB = lnTemporalB + 48
				Else
					lnTemporalB = lnTemporalB + 55
				Endif

				lcResultado = lcResultado + Chr( lnTemporalA ) + Chr( lnTemporalB )
			Endfor
		Endwith

		Return lcResultado
	Endproc

	*
	* BytePalabra1
	Hidden Procedure BytePalabra1( tnPalabra As Integer )
		Return ( ( Floor( Floor( Floor( tnPalabra/256 )/256 )/256 ) % 256 ) + 1 )

	Endproc && BytePalabra1

	*
	* BytePalabra2
	Hidden Procedure BytePalabra2( tnPalabra As Integer )
		Return ( ( Floor( Floor( tnPalabra/256 )/256 ) % 256 ) + 1 )

	Endproc && BytePalabra2

	*
	* BytePalabra3
	Hidden Procedure BytePalabra3( tnPalabra )
		Return ( ( Floor( tnPalabra/256 ) % 256 ) + 1 )

	Endproc && BytePalabra3

	*
	* BytePalabra4
	Hidden Procedure BytePalabra4( tnPalabra As Integer )
		Return ( ( tnPalabra % 256 ) + 1 )

	Endproc && BytePalabra4

	* - - Decodifica por el metodo de BlowFish
	Procedure DecodificarBlowFish( tcMensaje As String, tcPalabraClave As String ) As String
		Local lcPalabraClaveBackup As String
		Local lnLongitudMensaje As Integer
		Local lcSalidaDato As String
		Local i As Integer

		lcPalabraClaveBackup = ""
		lnLongitudMensaje = 0
		lcSalidaDato = ""
		i = 0
		tcMensaje = Alltrim( tcMensaje )
		tcPalabraClave = Alltrim( tcPalabraClave )

		With This
			If lcPalabraClaveBackup = "" Or tcPalabraClave != lcPalabraClaveBackup
				.BlowFishIniciado = 0
				lcPalabraClaveBackup = tcPalabraClave

			Endif && lcPalabraClaveBackup = "" Or tcPalabraClave != lcPalabraClaveBackup

			If .BlowFishIniciado = 1 Or .BlosFishInicializar( tcPalabraClave ) = 1
				lnLongitudMensaje = Len( tcMensaje )

				For i = 1 To ( ( lnLongitudMensaje - Int( lnLongitudMensaje/16 ) * 16 ) * Mod( lnLongitudMensaje, 16 ) + ( Int( lnLongitudMensaje/16 ) * 16 ) ) - lnLongitudMensaje
					tcMensaje = tcMensaje + "0"

				Endfor

				lnLongitudMensaje = Len( tcMensaje )
				lcSalidaDato = ""
				For i = 1 To lnLongitudMensaje Step 16
					.parxr = .DecodificarPalabra( Substr( tcMensaje, i, 8 ) )
					.parxl = .DecodificarPalabra( Substr( tcMensaje, i + 8, 8 ) )
					.BlowFishDesEncriptar()
					lcSalidaDato = lcSalidaDato + .codificarpalabra( .parxr ) + .codificarpalabra( .parxl )

				Endfor

				lcSalidaDato = .Decodificar( lcSalidaDato )

			Endif && .BlowFishIniciado = 1 Or .BlosFishInicializar( tcPalabraClave ) = 1

			lcSalidaDato = Strtran( lcSalidaDato, Chr( 208 ) + Chr( 204 ) + Chr( 208 ) + Padr( '', 3, Chr( 204 ) ) )

		Endwith

		Return Strtran( lcSalidaDato, Chr( 0 ), '' )

	Endproc && DecodificarBlowFish

	* - - Codifica por BlowFish
	Procedure CodificarBlowFish( tcMensaje As String, tcPalabraClave As String )
		Local lcPalabraClaveBackup As String
		Local lnLongitudMensaje As Integer
		Local lcSalidaDato As String
		Local i As Integer

		lcPalabraClaveBackup = ""
		lnLongitudMensaje = 0
		lcSalidaDato = ""
		i = 0
		tcMensaje = Alltrim( tcMensaje )
		tcPalabraClave = Alltrim( tcPalabraClave )

		With This
			If lcPalabraClaveBackup = "" Or tcPalabraClave != lcPalabraClaveBackup
				.BlowFishIniciado = 0
				lcPalabraClaveBackup = tcPalabraClave
			Endif

			If .BlowFishIniciado = 1 Or .BlosFishInicializar( tcPalabraClave ) = 1
				tcMensaje = .Codificar( tcMensaje )

				lnLongitudMensaje = Len( tcMensaje )

				For i = 1 To ( ( lnLongitudMensaje - Int( lnLongitudMensaje/16 ) * 16 ) * Mod( lnLongitudMensaje, 16 ) + ( Int( lnLongitudMensaje/16 ) * 16 ) ) - lnLongitudMensaje
					tcMensaje = tcMensaje + "0"

				Endfor


				lcSalidaDato = ""

				For i = 1 To Len( tcMensaje ) Step 16
					.parxr = .DecodificarPalabra( Substr( tcMensaje, i, 8 ) )
					.parxl = .DecodificarPalabra( Substr( tcMensaje, i + 8, 8 ) )
					.BlowFishEncriptar()
					lcSalidaDato = lcSalidaDato + .codificarpalabra( .parxr ) + .codificarpalabra( .parxl )

				Endfor

			Endif && .BlowFishIniciado = 1 Or .BlosFishInicializar( tcPalabraClave ) = 1

		Endwith

		Return lcSalidaDato

	Endproc && CodificarBlowFish

	*
	* Init
	Hidden Procedure Init() As VOID
		DoDefault()
		*!*	This.AddProperty( 'aP[ 18 ]' )
		*!*	This.AddProperty( 'aS1[ 256 ]' )
		*!*	This.AddProperty( 'aS2[ 256 ]' )
		*!*	This.AddProperty( 'aS3[ 256 ]' )
		*!*	This.AddProperty( 'aS4[ 256 ]' )

		This.BlosFishConstantes()

	Endproc && Init

	*
	* Init
	Hidden Procedure Destroy() As VOID

		Store 0 To This.aP
		Store 0 To This.aS1
		Store 0 To This.aS2
		Store 0 To This.aS3
		Store 0 To This.aS4

		*!*	Removeproperty( This,'aP[ 18 ]' )
		*!*	Removeproperty( This,'aS1[ 256 ]' )
		*!*	Removeproperty( This,'aS2[ 256 ]' )
		*!*	Removeproperty( This,'aS3[ 256 ]' )
		*!*	Removeproperty( This, 'aS4[ 256 ]' )


		DoDefault()

	Endproc && Destroy

Enddefine && BlowFish