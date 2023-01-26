Lparameters toParam As Object, tnLevel As Number, tlNativas As Boolean

Local loControl As Control
Local loPage As Page
Local lcRet As String
Try
	If Empty( tnLevel )
		tnLevel = 1

	Endif && Empty( tnLevel )
	lcRet = ''

	If Vartype( toParam ) = 'O'

		Do Case
			Case Lower( toParam.BaseClass ) = 'form'
				lcRet = VerProperty( toParam, tnLevel, tlNativas )
				For Each loControl As Control In toParam.Objects
					lcRet = lcRet + VerProperties( loControl, tnLevel + 1, tlNativas ) + Chr( 13 )

				Endfor

			Case Lower( toParam.BaseClass ) = 'pageframe'
				lcRet = VerProperty( toParam, tnLevel, tlNativas )

				For Each loPage As Page In toParam.Pages
					lcRet = lcRet + VerProperties( loControl, tnLevel + 1, tlNativas ) + Chr( 13 )

				Endfor

			Case Lower( toParam.BaseClass ) = 'page'
				lcRet = VerProperty( toParam, tnLevel, tlNativas )

				For Each loControl As Control In toParam.Objects
					lcRet = lcRet + VerProperties( loControl, tnLevel + 1, tlNativas ) + Chr( 13 )

				Endfor

			Case Lower( toParam.BaseClass ) = 'container'
				lcRet = VerProperty( toParam, tnLevel, tlNativas )

				For Each loControl As Control In toParam.Objects
					lcRet = lcRet + VerProperties( loControl, tnLevel + 1, tlNativas ) + Chr( 13 )

				Endfor

			Otherwise
				lcRet = VerProperty( toParam, tnLevel, tlNativas )

		Endcase

	Endif && Vartype( toParam ) = 'O'


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError
	If tnLevel # 1
		Throw loError

	Endif && tnLevel # 1

Finally
	loError = Null
	loControl = Null
	loPage = Null

Endtry

Return lcRet


Function VerProperty( toParam As Object, tnLevel As Number, tlNativas As Boolean ) As String
	Local lcRet As String
	Local laMembers[ 1 ]
	Local lcProp As String
	Local lcVartype As String
	Local oErr as Exception 

	If tlNativas And Pemstatus( toParam, 'Class', 5 )
		lnCnt = Amembers( laMembers, toParam.BaseClass )

	Else
		lnCnt = Amembers( laMembers, toParam )

	Endif && tlNativas And Pemstatus( toParam, 'Class', 5 )

	lcRet = Space( tnLevel ) + toParam.Name +  Chr( 13 )

	For i = 1 To lnCnt
		lcProp = laMembers[ i ]
		Try
			lcVartype = Vartype( toParam.&lcProp. )
		Catch To oErr
			lcVartype = Type( 'toParam.' + lcProp )
		Finally
		Endtry

		lcRet = lcRet + Space( tnLevel + 4 )+ Proper( lcProp ) + ': (' + lcVartype + ') '
		Try
			Do Case
				Case Inlist( lcVartype, 'C', 'N', 'D', 'T', 'L', 'Y' )
					lcRet = lcRet + Transform( toParam.&lcProp. )
				Otherwise

			Endcase
		Catch To oErr
			lcRet = lcRet + ' ( ' + oErr.Message + ' ) ' 
		Finally
		Endtry

		lcRet = lcRet +  Chr( 13 )

	Endfor

	Return lcRet

Endfunc && VerProperty
