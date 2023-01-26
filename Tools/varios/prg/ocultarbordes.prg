Lparameters toParam As Object, tnLevel As Number

Local loControl As Control
Local loPage As Page

Try
	If Empty( tnLevel )
		tnLevel = 1

	Endif && Empty( tnLevel )

	If Vartype( toParam ) = 'O'

		Do Case
			Case Lower( toParam.BaseClass ) = 'form'
				For Each loControl As Control In toParam.Objects
					OcultarBordes( loControl, tnLevel + 1 )

				Endfor

			Case Lower( toParam.BaseClass ) = 'pageframe'
				If Pemstatus( toParam, 'OldVisible', 5 )
					toParam.Visible = toParam.OldVisible
					Removeproperty( toParam, 'OldVisible' )

				Endif && Pemstatus( toParam, 'OldVisible', 5 )
				For Each loPage As Page In toParam.Pages
					OcultarBordes( loPage, tnLevel + 1 )

				Endfor

			Case Lower( toParam.BaseClass ) = 'page'
				If Pemstatus( toParam, 'OldVisible', 5 )
					toParam.Visible = toParam.OldVisible
					Removeproperty( toParam, 'OldVisible' )

				Endif && Pemstatus( toParam, 'OldVisible', 5 )
				For Each loControl As Control In toParam.Objects
					OcultarBordes( loControl, tnLevel + 1 )

				Endfor

			Case Lower( toParam.BaseClass ) = 'container'
				If Pemstatus( toParam, 'OldBorderColor', 5 )
					toParam.BorderColor = toParam.OldBorderColor
					Removeproperty( toParam, 'OldBorderColor' )

				Endif && Pemstatus( toParam, 'OldBorderColor', 5 )

				If Pemstatus( toParam, 'OldBorderWidth', 5 )
					toParam.BorderWidth = toParam.OldBorderWidth
					Removeproperty( toParam, 'OldBorderWidth' )

				Endif && Pemstatus( toParam, 'OldBorderColor', 5 )

				If Pemstatus( toParam, 'OldVisible', 5 )
					toParam.Visible = toParam.OldVisible
					Removeproperty( toParam, 'OldVisible' )

				Endif && Pemstatus( toParam, 'OldVisible', 5 )

				If Pemstatus( toParam, 'OldWidth', 5 )
					toParam.Width = toParam.OldWidth
					Removeproperty( toParam, 'OldWidth' )

				Endif

				If Pemstatus( toParam, 'OldHeight', 5 )
					toParam.Height = toParam.OldHeight
					Removeproperty( toParam, 'OldHeight' )

				Endif

				For Each loControl As Control In toParam.Objects
					OcultarBordes( loControl, tnLevel + 1 )

				Endfor

			Case Lower( toParam.BaseClass ) = 'shape'
				If Pemstatus( toParam, 'OldBorderColor', 5 )
					toParam.BorderColor = toParam.OldBorderColor
					Removeproperty( toParam, 'OldBorderColor' )

				Endif && Pemstatus( toParam, 'OldBorderColor', 5 )

				If Pemstatus( toParam, 'OldBorderStyle', 5 )
					toParam.BorderStyle = toParam.OldBorderStyle
					Removeproperty( toParam, 'OldBorderStyle' )

				Endif && Pemstatus( toParam, 'OldVisible', 5 )

				If Pemstatus( toParam, 'OldVisible', 5 )
					toParam.Visible = toParam.OldVisible
					Removeproperty( toParam, 'OldVisible' )

				Endif && Pemstatus( toParam, 'OldVisible', 5 )


			Case Lower( toParam.BaseClass ) = 'label'
				If Pemstatus( toParam, 'OldVisible', 5 )
					toParam.Visible = toParam.OldVisible
					Removeproperty( toParam, 'OldVisible' )

				Endif && Pemstatus( toParam, 'OldVisible', 5 )

				If Pemstatus( toParam, 'OldCaption', 5 )
					toParam.Caption = toParam.OldCaption
					Removeproperty( toParam, 'OldCaption' )

				Endif && Pemstatus( toParam, 'OldVisible', 5 )

			Otherwise

		Endcase

	Endif && Vartype( toParam ) = 'O'


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	If tnLevel # 1
		Throw loError

	Endif && tnLevel # 1

Finally
	loError = Null
	loControl = Null
	loPage = Null

Endtry
