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
					VerBordes( loControl, tnLevel + 1 )

				Endfor

			Case Lower( toParam.BaseClass ) = 'pageframe'
				If ! Pemstatus( toParam, 'OldVisible', 5 )
					AddProperty( toParam, 'OldVisible', toParam.Visible )

				Endif
				toParam.Visible = .T.
				For Each loPage As Page In toParam.Pages
					VerBordes( loPage, tnLevel + 1 )

				Endfor

			Case Lower( toParam.BaseClass ) = 'page'
				If Pemstatus( toParam, 'OldVisible', 5 )
					toParam.Visible = toParam.OldVisible
					Removeproperty( toParam, 'OldVisible' )

				Endif && Pemstatus( toParam, 'OldVisible', 5 )
				For Each loControl As Control In toParam.Objects
					VerBordes( loControl, tnLevel + 1 )

				Endfor

			Case Lower( toParam.BaseClass ) = 'container'
				If ! Pemstatus( toParam, 'OldBorderColor', 5 )
					AddProperty( toParam, 'OldBorderColor', toParam.BorderColor )

				Endif

				If ! Pemstatus( toParam, 'OldWidth', 5 )
					AddProperty( toParam, 'OldWidth', toParam.Width )

				Endif

				If ! Pemstatus( toParam, 'OldHeight', 5 )
					AddProperty( toParam, 'OldHeight', toParam.Height )

				Endif

				If toParam.Width > 0 And toParam.Height > 0
					toParam.BorderColor = Rgb( 255, 0, 0 )
					
				Else
					toParam.Width = 15
					toParam.Height = 15
					toParam.BorderColor = Rgb( 0, 128, 255 )

				Endif

				If ! Pemstatus( toParam, 'OldBorderWidth', 5 )
					AddProperty( toParam, 'OldBorderWidth', toParam.BorderWidth )

				Endif
				toParam.BorderWidth = 1

				If ! Pemstatus( toParam, 'OldVisible', 5 )
					AddProperty( toParam, 'OldVisible', toParam.Visible )

				Endif
				If ! toParam.OldVisible
					toParam.ZOrder()

				Endif && ! toParam.OldVisible
				toParam.Visible = .T.

				For Each loControl As Control In toParam.Objects
					VerBordes( loControl, tnLevel + 1 )

				Endfor

			Case Lower( toParam.BaseClass ) = 'shape'
				If ! Pemstatus( toParam, 'OldBorderColor', 5 )
					AddProperty( toParam, 'OldBorderColor', toParam.BorderColor )

				Endif

				If ! Pemstatus( toParam, 'OldWidth', 5 )
					AddProperty( toParam, 'OldWidth', toParam.Width )

				Endif

				If ! Pemstatus( toParam, 'OldHeight', 5 )
					AddProperty( toParam, 'OldHeight', toParam.Height )

				Endif

				If toParam.Width > 0 And toParam.Height > 0
					toParam.BorderColor = Rgb( 255, 128, 0 )
					
				Else
					toParam.Width = 10
					toParam.Height = 10
					toParam.BorderColor = Rgb( 0, 0, 255 )

				Endif


				If ! Pemstatus( toParam, 'OldBorderStyle', 5 )
					AddProperty( toParam, 'OldBorderStyle', toParam.BorderStyle)

				Endif
				toParam.BorderStyle = 1

				If ! Pemstatus( toParam, 'OldVisible', 5 )
					AddProperty( toParam, 'OldVisible', toParam.Visible )

				Endif && ! Pemstatus( toParam, 'OldVisible' 5 )

				If ! toParam.OldVisible
					toParam.ZOrder()

				Endif && ! toParam.OldVisible
				toParam.Visible = .T.


			Case Lower( toParam.BaseClass ) = 'label'
				If ! Pemstatus( toParam, 'OldVisible', 5 )
					AddProperty( toParam, 'OldVisible', toParam.Visible )

				Endif && ! Pemstatus( toParam, 'OldVisible' 5 )

				If ! toParam.OldVisible
					toParam.ZOrder()

				Endif && ! toParam.OldVisible
				toParam.Visible = .T.

				AddProperty( toParam, 'OldCaption', toParam.Caption )
				If Empty( toParam.Caption )
					toParam.Caption = Sys( 2015 ) + Sys( 2015 )

				Endif

			Otherwise

		Endcase

	Endif && Vartype( toParam ) = 'O'


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	If tnLevel # 1
		Throw loError

	Endif && tnLevel # 1

Finally
	loError = Null
	loControl = Null
	loPage = Null

Endtry
