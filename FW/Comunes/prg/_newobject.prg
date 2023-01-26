* _Newobject
Procedure _Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21, tvParameter22, tvParameter23, tvParameter24, tvParameter25, tvParameter26 )

	* Newobject

	Assert Vartype( tcClass ) == 'C' Message 'tcClass no es una cadena.'
	Assert Vartype( tcModule ) == 'C' Message 'tcModule no es una cadena.'

	lnPcounts = Pcount()

	Try


		If Upper( tcClass ) = "ERRORHANDLER"
			loNewObject = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )

		Else
			Do Case
				Case Inlist( lnPcounts, 1, 2, 3 )
					loNewObject = Createobject( tcClass )

				Case lnPcounts == 4
					loNewObject = Createobject( tcClass, tvParameter1 )

				Case lnPcounts == 5
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2 )

				Case lnPcounts == 6
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3 )

				Case lnPcounts == 7
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4 )

				Case lnPcounts == 8
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5 )

				Case lnPcounts == 9
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6 )

				Case lnPcounts == 10
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7 )

				Case lnPcounts == 11
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8 )

				Case lnPcounts == 12
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9 )

				Case lnPcounts == 13
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10 )

				Case lnPcounts == 14
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11 )

				Case lnPcounts == 15
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12 )

				Case lnPcounts == 16
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13 )

				Case lnPcounts == 17
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14 )

				Case lnPcounts == 18
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15 )

				Case lnPcounts == 19
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16 )

				Case lnPcounts == 20
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17 )

				Case lnPcounts == 21
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18 )

				Case lnPcounts == 22
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19 )

				Case lnPcounts == 23
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20 )

				Case lnPcounts == 24
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21 )

				Case lnPcounts == 25
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21, tvParameter22 )

				Case lnPcounts == 26
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21, tvParameter22, tvParameter23 )

				Case lnPcounts == 27
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21, tvParameter22, tvParameter23, tvParameter24 )

				Case lnPcounts == 28
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21, tvParameter22, tvParameter23, tvParameter24, tvParameter25 )

				Otherwise
					loNewObject = Createobject( tcClass )

			Endcase
		Endif

	Catch To loErr1

		Try

			Set Procedure To ( tcModule ) Additive
			Do Case
				Case Inlist( lnPcounts, 1, 2, 3 )
					loNewObject = Createobject( tcClass )

				Case lnPcounts == 4
					loNewObject = Createobject( tcClass, tvParameter1 )

				Case lnPcounts == 5
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2 )

				Case lnPcounts == 6
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3 )

				Case lnPcounts == 7
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4 )

				Case lnPcounts == 8
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5 )

				Case lnPcounts == 9
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6 )

				Case lnPcounts == 10
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7 )

				Case lnPcounts == 11
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8 )

				Case lnPcounts == 12
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9 )

				Case lnPcounts == 13
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10 )

				Case lnPcounts == 14
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11 )

				Case lnPcounts == 15
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12 )

				Case lnPcounts == 16
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13 )

				Case lnPcounts == 17
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14 )

				Case lnPcounts == 18
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15 )

				Case lnPcounts == 19
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16 )

				Case lnPcounts == 20
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17 )

				Case lnPcounts == 21
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18 )

				Case lnPcounts == 22
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19 )

				Case lnPcounts == 23
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20 )

				Case lnPcounts == 24
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21 )

				Case lnPcounts == 25
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21, tvParameter22 )

				Case lnPcounts == 26
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21, tvParameter22, tvParameter23 )

				Case lnPcounts == 27
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21, tvParameter22, tvParameter23, tvParameter24 )

				Case lnPcounts == 28
					loNewObject = Createobject( tcClass, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21, tvParameter22, tvParameter23, tvParameter24, tvParameter25 )

				Otherwise
					loNewObject = Createobject( tcClass )

			Endcase

		Catch To loErr2

			Do Case
				Case lnPcounts == 1
					loNewObject = Newobject( tcClass )

				Case lnPcounts == 2
					loNewObject = Newobject( tcClass, tcModule )

				Case lnPcounts == 3
					loNewObject = Newobject( tcClass, tcModule, tcInApplication )

				Case lnPcounts == 4
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1 )

				Case lnPcounts == 5
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2 )

				Case lnPcounts == 6
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3 )

				Case lnPcounts == 7
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4 )

				Case lnPcounts == 8
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5 )

				Case lnPcounts == 9
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6 )

				Case lnPcounts == 10
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7 )

				Case lnPcounts == 11
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8 )

				Case lnPcounts == 12
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9 )

				Case lnPcounts == 13
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10 )

				Case lnPcounts == 14
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11 )

				Case lnPcounts == 15
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12 )

				Case lnPcounts == 16
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13 )

				Case lnPcounts == 17
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14 )

				Case lnPcounts == 18
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15 )

				Case lnPcounts == 19
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16 )

				Case lnPcounts == 20
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17 )

				Case lnPcounts == 21
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18 )

				Case lnPcounts == 22
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19 )

				Case lnPcounts == 23
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20 )

				Case lnPcounts == 24
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21 )

				Case lnPcounts == 25
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21, tvParameter22 )

				Case lnPcounts == 26
					loNewObject = Newobject( tcClass, tcModule, tcInApplication, tvParameter1, tvParameter2, tvParameter3, tvParameter4, tvParameter5, tvParameter6, tvParameter7, tvParameter8, tvParameter9, tvParameter10, tvParameter11, tvParameter12, tvParameter13, tvParameter14, tvParameter15, tvParameter16, tvParameter17, tvParameter18, tvParameter19, tvParameter20, tvParameter21, tvParameter22, tvParameter23 )

				Otherwise
					loNewObject = Newobject( tcClass, tcModule, tcInApplication )

			Endcase
		Finally

		Endtry

	Finally

	Endtry

	Assert Vartype( loNewObject ) == 'O' Message 'loNewObject no es un objeto.'

	Return loNewObject

Endproc && _Newobject
