#INCLUDE "FW\Comunes\Include\Praxis.h"

#Define DEBUGMODE .F.

* loAutoSetUp = CreateObject( 'AutoSetUp' )
* loAutoSetUp.Process( loAutoSetUp )

* Define Class AutoSetUp As Session
Define Class AutoSetUp As Custom

	#If .F.
		TEXT
 *:Help Documentation
 *:Description:
 Alínea todos los controles contenidos en el objeto pasado como parámetro
 *:Project:
 Praxis
 *:Autor:
 Ricardo Aidelman
 *:Date:
 Miércoles 24 de Mayo de 2006 (16:24:48)
 *:ModiSummary:
 R/0001 -
 *:Parameters:
 *:Remarks:
 *:Returns:
 *:Example:
 *:SeeAlso:
 *:Events:
 *:KeyWords:
 *:Inherits:
 *:Exceptions:
 *:NameSpace:
 praxis.com
 *:EndHelp
		ENDTEXT
	#Endif

	#If .F.
		Local This As AutoSetUp Of "Comun\Prg\AutoSetUp.prg"
	#Endif

	*!* Manejador de Errores
	oError = Null

	*!* Semáforo
	lIsOk = .T.

	*!* Propiedades del objeto error en formato XML
	cXMLoError = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="getpositionandsize" type="method" display="GetPositionAndSize" />] + ;
		[<memberdata name="fittoparent" type="method" display="FitToParent" />] + ;
		[<memberdata name="oerror" type="property" display="oError" />] + ;
		[<memberdata name="lIsOk" type="property" display="lIsOk" />] + ;
		[<memberdata name="cXMLoError" type="property" display="cXMLoError" />] + ;
		[<memberdata name="modulename" type="property" display="ModuleName" />] + ;
		[</VFPData>]

	Procedure Process( toObj As Object, ;
			tnTopPadding As Integer, ;
			tnLeftPadding As Integer, ;
			tnRightPadding As Integer, ;
			tnBottomPadding As Integer, ;
			tnGap As Integer ) As Boolean ;
			HELPSTRING "Procesa el objeto"

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Procesa el objeto
				 *:Project:
				 Praxis
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Miércoles 24 de Mayo de 2006 (16:28:27)
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 praxis.com
				 *:EndHelp
			ENDTEXT
		#Endif

		Local lnTop As Integer
		Local lnWidth As Integer
		Local lnHeight As Integer
		Local lnLeft As Integer
		Local lnRight As Integer
		Local lnBottom As Integer
		Local lnGap As Integer
		Local lnCurrentCol As Integer
		Local lnCurrentRow As Integer
		Local lnCols As Integer
		Local lnRows As Integer
		Local Array laCols[ 1 ] As ControlMeasures Of fw\comunes\prg\AutoSetUp.prg
		Local Array laRows[ 1 ] As ControlMeasures Of fw\comunes\prg\AutoSetUp.prg
		Local Array laMtx[ 1, 1 ] As Object
		Local loCtrl As prxcontrol Of fw\comunes\vcx\prxbase.vcx
		Local loPrevious As Object
		Local llSameRow As Boolean
		Local lnIncremento As Integer
		Local lFirstTime As Boolean
		Local lnCtrlHeight As Number
		Local lnCtrlWidth As Number
		Local loCtrlRef As SpanControl Of 'fw\comunes\prg\autosetup.prg'
		Local loCtrlMeasures As ControlMeasures Of 'fw\comunes\prg\autosetup.prg'
		Local oErr As Exception
		Local loColSpan As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local lnMaxWidth As Number
		Local lnMaxHeight As Number
		Local lnRowGap As Integer

		Try

			lnWidth = 0
			lnHeight = 0
			lnGap = IfEmpty( tnGap, 0 )
			lnTop = IfEmpty( tnTopPadding, 0 )
			lnLeft = IfEmpty( tnLeftPadding, 0 )
			lnRight = IfEmpty( tnRightPadding, 0 )
			lnBottom = IfEmpty( tnBottomPadding, 0 )
			lnRowGap = 2

			* Referencia al control anterior
			loPrevious = Null
			loColSpan = Newobject( "PrxCollection", "PrxBaseLibrary.prg" )
			* Ubica los controles en las filas, y calcula el Nº de columna en el que
			* se encuentra cada uno.
			lnCurrentCol = 1
			lnCurrentRow = 1
			lnRows = 1
			lnCols = 1

			lFirstTime = .T.

			lnMaxWidth = 0
			lnMaxHeight = 0

			#If DEBUGMODE
				* DAE 2009-08-18(14:35:19)
				VerBordes( toObj )

				If Lower( toObj.BaseClass ) == 'form'
					toObj.Show()


				Endif && Lower( toObj.BaseClass ) == 'form'

				Assert Vartype( toObj.oColObjects.Count ) = 'N' Message 'La colección no tiene elementos'
				Assert toObj.oColObjects.Count # 0 Message 'La colección no tiene elementos'
			#Endif

			For Each loCtrl In toObj.oColObjects

				If Vartype( loCtrl ) = 'O'
					* Verifico el RowSpan y el ColSpan
					loCtrl.nRowSpan = Max( Iif( Vartype( loCtrl.nRowSpan ) = 'N', loCtrl.nRowSpan, 1 ), 1 )
					loCtrl.nColSpan = Max( Iif( Vartype( loCtrl.nColSpan ) = 'N', loCtrl.nColSpan, 1 ), 1 )

					#If DEBUGMODE
						DoEvents Force
						If Pemstatus( toObj, 'Refresh', 5 )
							toObj.Refresh()

						Endif && Pemstatus( toObj, 'Refresh', 5 )

					#Endif

					If Pemstatus( loCtrl, 'lPerformAutosetup', 5 )

						If loCtrl.lPerformAutosetup
							loCtrl.AutoSetUp()

						Endif && loCtrl.lPerformAutosetup

					Else
						If Pemstatus( loCtrl, 'Autosetup', 5 )
							loCtrl.AutoSetUp()

						Endif && Pemstatus( loCtrl, 'Autosetup', 5 )

					Endif && Pemstatus( loCtrl, 'lPerformAutosetup', 5 )

					#If DEBUGMODE
						DoEvents Force
						If Pemstatus( loCtrl, 'Refresh', 5 )
							loCtrl.Refresh()

						Endif && Pemstatus( loCtrl, 'Refresh', 5 )

						DoEvents Force
						If Pemstatus( toObj, 'Refresh', 5 )
							toObj.Refresh()

						Endif && Pemstatus( toObj, 'Refresh', 5 )

					#Endif

					Try
						llSameRow = loCtrl.lSameRowAsPrevious And Vartype( loPrevious ) = 'O'
					Catch
						llSameRow = .F.
					Finally
					Endtry

					If llSameRow

						* Obtengo la referencia del control anterior de esta fila
						loAnt = laMtx[ lnCurrentRow, lnCurrentCol ]
						* Chequeo si el objeto
						If Vartype( loAnt ) = 'O' And Pemstatus( loAnt, "oRef", 5 )
							loAnt = loAnt.oRef

						Endif && Vartype( loAnt ) = 'O' And Pemstatus( loAnt, "oRef", 5 )

						If Vartype( loAnt ) = 'O' And Pemstatus( loAnt, 'nColSpan', 5 )
							lnIncremento = loAnt.nColSpan

						Else
							lnIncremento = 1

						Endif && Vartype( loAnt ) = 'O' And Pemstatus( loAnt, 'nColSpan', 5 )

						* Incremento la columna
						lnCurrentCol = lnCurrentCol + lnIncremento
						If lnCurrentCol <= lnCols
							lnDesplazamiento = 0
							lnNewPos = lnCurrentCol + lnDesplazamiento
							Do While lnNewPos <= lnCols And Vartype( laMtx[ lnCurrentRow, lnNewPos ] ) = 'O'
								lnDesplazamiento = lnDesplazamiento + 1
								lnNewPos = lnCurrentCol + lnDesplazamiento

							Enddo
							lnCurrentCol = lnNewPos

						Endif
					Else
						If ! lFirstTime
							* Primer control de cada fila a partir de la segunda
							lnCurrentCol = 1
							loAnt = laMtx[ lnCurrentRow, lnCurrentCol ]

							* Chequeo si el objeto
							If Vartype( loAnt ) = 'O' And Pemstatus( loAnt, 'oRef', 5 )
								loAnt = loAnt.oRef

							Endif && Vartype( loAnt ) = 'O' And Pemstatus( loAnt, 'oRef', 5 )

							If Vartype( loAnt ) = 'O' And Pemstatus( loAnt, 'nRowSpan', 5 )
								lnIncremento = loAnt.nRowSpan

							Else
								lnIncremento = 1

							Endif && Vartype( loAnt ) = 'O' And Pemstatus( loAnt, 'nRowSpan', 5 )

							* Incremento la columna
							lnCurrentRow = lnCurrentRow + lnIncremento
							If lnCurrentRow <= lnRows
								lnDesplazamiento = 0
								lnNewPos = lnCurrentRow + lnDesplazamiento
								Do While lnNewPos <= lnRows And Vartype( laMtx[ lnNewPos, lnCurrentCol ] ) = 'O'
									lnDesplazamiento = lnDesplazamiento + 1
									lnNewPos = lnCurrentRow + lnDesplazamiento

								Enddo
								lnCurrentRow = lnNewPos

							Endif && lnCurrentRow <= lnRows

						Else
							lFirstTime = .F.

						Endif && ! lFirstTime

					Endif && llSameRow

					* Guardo la referencia al control previo
					loPrevious = loCtrl
					* Calculo el maximo de filas
					lnRows = Max( lnRows, lnCurrentRow + loCtrl.nRowSpan - 1)
					* Calculo el maximo de columnas
					lnCols = Max( lnCols, lnCurrentCol + loCtrl.nColSpan - 1 )

					* Redimensiono el Array con los altos maximos de las filas
					Dimension laRows[ lnRows ] As Object
					* Redimensiono el Array con los anchos maximos de las columnas
					Dimension laCols[ lnCols ] As Object
					* Redimensiono la matriz de los controles
					Dimension laMtx[ lnRows, lnCols ] As Object

					If ( loCtrl.nColSpan > 1 ) Or ( loCtrl.nRowSpan > 1 )
						* Creo la referencia para el Span
						loCtrlRef = Createobject( 'SpanControl' )
						loCtrlRef.oRef = loCtrl
						* Creo una referencia al control que ocupa estos espacios
						For jQ = lnCurrentRow To lnCurrentRow + loCtrl.nRowSpan - 1
							For iQ = lnCurrentCol To lnCurrentCol + loCtrl.nColSpan -1
								laMtx[ jQ, iQ ] = loCtrlRef

							Endfor

						Endfor
						* Agrego el control a la colección de Span
						loColSpan.AddItem( loCtrl, Lower( loCtrl.Name ) )

					Endif
					* Grabo el Objeto en la Matriz
					laMtx[ lnCurrentRow, lnCurrentCol ] = loCtrl
					loCtrl.nRow = lnCurrentRow
					loCtrl.nCol = lnCurrentCol

					loCtrlMeasures = loCtrl.GetMeasures()

					* Busco el maximo para la fila y para la columna
					If Vartype( laRows[ lnCurrentRow ] ) # 'O'
						laRows[ lnCurrentRow ] = Createobject( 'ControlMeasures' )
						laRows[ lnCurrentRow ].Top = 0
						laRows[ lnCurrentRow ].Height = 0
						laRows[ lnCurrentRow ].nLabelHeight = 0
						laRows[ lnCurrentRow ].nDatoHeight = 0

					Endif && Vartype( laRows[ lnCurrentRow ] ) # 'O'

					* Si no tiene RowSpan calculo el Maximo
					If loCtrl.nRowSpan = 1
						laRows[ lnCurrentRow ].Height = Max( laRows[ lnCurrentRow ].Height, loCtrlMeasures.Height )
						laRows[ lnCurrentRow ].nLabelHeight = Max( laRows[ lnCurrentRow ].nLabelHeight, loCtrlMeasures.nLabelHeight )
						laRows[ lnCurrentRow ].nDatoHeight = Max( laRows[ lnCurrentRow ].nDatoHeight, loCtrlMeasures.nDatoHeight )
					Endif && loCtrl.nRowSpan = 1


					If Vartype( laCols[ lnCurrentCol ] ) # 'O'
						laCols[ lnCurrentCol ] = Createobject( 'ControlMeasures' )
						laCols[ lnCurrentCol ].Left = 0
						laCols[ lnCurrentCol ].Width = 0
						laCols[ lnCurrentCol ].nLabelWidth = 0
						laCols[ lnCurrentCol ].nDatoWidth = 0

					Endif && Vartype( laCols[ lnCurrentCol ] ) # 'O'


					* Si no tiene ColSpan calculo el Maximo
					laCols[ lnCurrentCol ].nLabelWidth = Max( laCols[ lnCurrentCol ].nLabelWidth, loCtrlMeasures.nLabelWidth )
					laCols[ lnCurrentCol ].nDatoWidth  = Max( laCols[ lnCurrentCol ].nDatoWidth, loCtrlMeasures.nDatoWidth )


					If loCtrl.nColSpan = 1
						* laCols[ lnCurrentCol ].Width = Max( laCols[ lnCurrentCol ].Width, loCtrlMeasures.Width )
						*!* laCols[ lnCurrentCol ].nLabelWidth = Max( laCols[ lnCurrentCol ].nLabelWidth, loCtrlMeasures.nLabelWidth )
						If Empty( loCtrlMeasures.nDatoWidth + loCtrlMeasures.nLabelWidth )
							laCols[ lnCurrentCol ].Width = Max( laCols[ lnCurrentCol ].Width, loCtrlMeasures.Width )

						Else
							laCols[ lnCurrentCol ].nDatoWidth = Max( laCols[ lnCurrentCol ].nDatoWidth, loCtrlMeasures.nDatoWidth )

							If Pemstatus( loCtrl, "lLabelOnTop", 5 ) And loCtrl.lLabelOnTop
								laCols[ lnCurrentCol ].Width = Max( laCols[ lnCurrentCol ].Width, laCols[ lnCurrentCol ].nDatoWidth )

							Else
								laCols[ lnCurrentCol ].Width = Max( laCols[ lnCurrentCol ].Width, laCols[ lnCurrentCol ].nLabelWidth + laCols[ lnCurrentCol ].nDatoWidth )

							Endif

						Endif



					Endif && loCtrl.nColSpan = 1

				Endif

			Endfor

			* Verifico si los controles con Span tienen el espacio suficiente
			* Si no distribuyo el tamaño del control
			For iQ = 1 To loColSpan.Count
				loCtrl = loColSpan.Item( iQ )

				If loCtrl.nRowSpan > 1
					lnRowHeightMax = 0
					jQ = loCtrl.nRow
					Do While ( lnRowHeightMax < loCtrl.Height ) ;
							And ( jQ < ( loCtrl.nRow + loCtrl.nRowSpan ) )
						lnRowHeightMax = lnRowHeightMax + laRows[ jQ ].Height
						jQ = jQ + 1

					Enddo
					If lnRowHeightMax < loCtrl.Height
						* Distribuyo el alto entre las filas afectadas
						*!*	lnRowHeightSum = 0
						*!*	lnRowHeightPartial = Floor( ( loCtrl.Height - lnRowHeightMax ) / loCtrl.nRowSpan )

						laRows[ loCtrl.nRow + loCtrl.nRowSpan - 1 ].Height = ;
							laRows[ loCtrl.nRow + loCtrl.nRowSpan - 1 ].Height ;
							+ ( loCtrl.Height - lnRowHeightMax )

						* DA 2009-08-20(12:17:51) By DAE
						*!*	For jQ = loCtrl.nRow To ( loCtrl.nRow + loCtrl.nRowSpan - 1 )
						*!*		laRows[ jQ ].Height = laRows[ jQ ].Height + lnRowHeightPartial
						*!*		lnRowHeightSum = lnRowHeightSum + laRows[ jQ ].Height

						*!*	Endfor

						*!*	* Si la sumatoria da menos que lo esperado
						*!*	* agrego la diferencia a la ultima Fila.
						*!*	If lnRowHeightSum < loCtrl.Height
						*!*	    laRows[ loCtrl.nRow + loCtrl.nRowSpan - 1 ].Height = ;
						*!*	        laRows[ loCtrl.nRow + loCtrl.nRowSpan - 1 ].Height ;
						*!*	        + ( loCtrl.Height - lnRowHeightSum )

						*!*	Endif && lnRowHeightSum < loCtrl.Height

					Endif

				Endif

				If loCtrl.nColSpan > 1
					lnColMaxWidth = 0
					jQ = loCtrl.nCol
					If Pemstatus( loCtrl, "Dato", 5 )
						loCtrl.Width = Max( ( loCtrl.Dato.Width + laCols[ jQ ].nLabelWidth ), loCtrl.Width )
					Endif

					Do While ( lnColMaxWidth < loCtrl.Width ) ;
							And ( jQ < ( loCtrl.nCol + loCtrl.nColSpan ) )
						lnColMaxWidth = lnColMaxWidth + laCols[ jQ ].Width
						jQ = jQ + 1

					Enddo
					If lnColMaxWidth < loCtrl.Width
						* Distribuyo el alto entre las Columnas afectadas
						* lnColWidthSum = 0
						* DA 2009-08-20(12:17:51) By DAE
						laCols[ loCtrl.nCol + loCtrl.nColSpan - 1 ].Width = ;
							laCols[ loCtrl.nCol + loCtrl.nColSpan - 1 ].Width ;
							+ ( loCtrl.Width - lnColMaxWidth )
						*!*	lnColWidthPartial = Floor( ( loCtrl.Width - lnColMaxWidth ) / loCtrl.nColSpan )
						*!*	For jQ = loCtrl.nCol To ( loCtrl.nCol + loCtrl.nColSpan - 1 )
						*!*	    laCols[ jQ ].Width = laCols[ jQ ].Width + lnColWidthPartial
						*!*	    lnColWidthSum = lnColWidthSum + laCols[ jQ ].Width

						*!*	Endfor
						*!*	* Si la sumatoria da menos que lo esperado
						*!*	* agrego la diferencia a la ultima Columna.
						*!*	If lnColWidthSum < loCtrl.Width
						*!*	    laCols[ loCtrl.nCol + loCtrl.nColSpan - 1 ].Width = ;
						*!*	        laCols[ loCtrl.nCol + loCtrl.nColSpan - 1 ].Width ;
						*!*	        + ( loCtrl.Width - lnColWidthSum )

						*!*	Endif && lnColWidthSum < loCtrl.Width

					Endif

				Endif

			Endfor

			If toObj.oColObjects.Count > 0
				* Calculo las posiciones y los valores maximos
				laRows[ 1 ].Top = lnTop
				lnLen = Alen( laRows )
				For iQ = 2 To lnLen
					*!*						laRows[ iQ ].Top = laRows[ iQ - 1 ].Top + laRows[ iQ - 1 ].Height + lnGap
					laRows[ iQ ].Top = laRows[ iQ - 1 ].Top + laRows[ iQ - 1 ].Height + lnRowGap
				Endfor
				lnMaxHeight = laRows[ lnLen ].Top + laRows[ lnLen ].Height

				laCols[ 1 ].Left = lnLeft
				lnLen = Alen( laCols )
				For iQ = 2 To lnLen
					laCols[ iQ ].Left = laCols[ iQ - 1 ].Left + laCols[ iQ - 1 ].Width + lnGap

				Endfor
				lnMaxWidth = laCols[ lnLen ].Left + laCols[ lnLen ].Width

				For Each loCtrl In toObj.oColObjects

					* Guardo el Anchor de los controles contenidos
					If Pemstatus( loCtrl, "AnchorStatus", 5 )
						loCtrl.AnchorStatus( .T. )

					Endif && Pemstatus( loCtrl, "AnchorStatus", 5 )

					If Pemstatus( loCtrl, 'lPerformAutosetup', 5 ) And loCtrl.lPerformAutosetup
						If Pemstatus( loCtrl, 'lAlignLabel', 5 ) And loCtrl.lAlignLabel
							If Pemstatus( loCtrl, 'label', 5 )
								loCtrl.Label.Width = laCols[ loCtrl.nCol ].nLabelWidth

							Endif && Pemstatus( loCtrl, 'label', 5 )

							lnSumWidth = 0
							For jQ = loCtrl.nCol To ( loCtrl.nCol + loCtrl.nColSpan - 1 )
								If loCtrl.lLabelOnTop
									lnSumWidth = lnSumWidth ;
										+ Max( laCols[ jQ ].nLabelWidth, laCols[ jQ ].nDatoWidth ) ;
										+ lnGap

								Else
									* lnSumWidth = lnSumWidth + laCols[ jQ ].nLabelWidth ;
									+ laCols[ jQ ].nDatoWidth + lnGap

									lnSumWidth = lnSumWidth + laCols[ jQ ].Width + lnGap

								Endif && loCtrl.lLabelOnTop

							Endfor
							loCtrl.Width = Max( lnSumWidth, loCtrl.Width )

							lnSumHeight = 0
							For jQ = loCtrl.nRow To ( loCtrl.nRow + loCtrl.nRowSpan - 1 )
								If loCtrl.lLabelOnTop
									*!*										lnSumHeight = lnSumHeight + laRows[ jQ ].nLabelHeight ;
									*!*											+ laRows[ jQ ].nDatoHeight + lnGap

									lnSumHeight = lnSumHeight + laRows[ jQ ].nLabelHeight ;
										+ laRows[ jQ ].nDatoHeight + lnRowGap

								Else
									*!*										lnSumHeight = lnSumHeight ;
									*!*											+ Max( laRows[ jQ ].nLabelHeight, laRows[ jQ ].nDatoHeight );
									*!*											+ lnGap
									lnSumHeight = lnSumHeight ;
										+ Max( laRows[ jQ ].nLabelHeight, laRows[ jQ ].nDatoHeight );
										+ lnRowGap


								Endif && loCtrl.lLabelOnTop

							Endfor
							loCtrl.Height = Max( lnSumHeight, loCtrl.Height )

							#If DEBUGMODE
								DoEvents Force
								If Pemstatus( loCtrl, 'Refresh', 5 )
									loCtrl.Refresh()

								Endif && Pemstatus( loCtrl, 'Refresh', 5 )

								DoEvents Force
								If Pemstatus( toObj, 'Refresh', 5 )
									toObj.Refresh()

								Endif && Pemstatus( toObj, 'Refresh', 5 )

							#Endif

							* Acomodo los controles
							loCtrl.AutoSetUp( .T. )

							#If DEBUGMODE
								DoEvents Force
								If Pemstatus( loCtrl, 'Refresh', 5 )
									loCtrl.Refresh()

								Endif && Pemstatus( loCtrl, 'Refresh', 5 )

								DoEvents Force
								If Pemstatus( toObj, 'Refresh', 5 )
									toObj.Refresh()

								Endif && Pemstatus( toObj, 'Refresh', 5 )

							#Endif

						Endif
					Endif

					* Posiciono el control
					loCtrl.Top = laRows[ loCtrl.nRow ].Top
					loCtrl.Left = laCols[ loCtrl.nCol ].Left

					#If DEBUGMODE
						DoEvents Force
						If Pemstatus( loCtrl, 'Refresh', 5 )
							loCtrl.Refresh()

						Endif && Pemstatus( loCtrl, 'Refresh', 5 )

						DoEvents Force
						If Pemstatus( toObj, 'Refresh', 5 )
							toObj.Refresh()

						Endif && Pemstatus( toObj, 'Refresh', 5 )

					#Endif

					* Restauro el Anchor de los controles contenidos
					If Pemstatus( loCtrl, "AnchorStatus", 5 )
						loCtrl.AnchorStatus( .F. )

					Endif && Pemstatus( loCtrl, "AnchorStatus", 5 )

				Endfor

			Endif && toObj.oColObjects.Count > 0

			lnWidth = lnMaxWidth + lnRight
			lnHeight = lnMaxHeight + lnBottom

			Try
				toObj.Width = lnWidth
				toObj.Height = lnHeight

			Catch To oErr
				toObj.nWidth = lnWidth
				toObj.nHeight = lnHeight

			Finally
				Try
					toObj.nWidth = lnWidth
					toObj.nHeight = lnHeight
				Catch To oErr
				Endtry
			Endtry

			#If DEBUGMODE
				DoEvents Force
				If Pemstatus( toObj, 'Refresh', 5 )
					toObj.Refresh()

				Endif && Pemstatus( toObj, 'Refresh', 5 )

			#Endif

		Catch To oErr
			This.lIsOk = .F.
			This.oError = oErr

		Finally
			Store .F. To laRows
			Store .F. To laCols
			Store .F. To laMtx
			toObj = Null
			loPrevious = Null
			loCtrl = Null
			loAnt = Null
			loCtrl = Null
			loCtrlRef = Null

		Endtry

		Return This.lIsOk

	Endproc && Process

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: FitToParent
	*!* Description...:
	*!* Date..........: Viernes 21 de Agosto de 2009 (15:19:33)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure FitToParent( toObj As Object ) As Void

		Local lnLeft As Integer
		Local lnTop As Integer
		Local lnDifWidth As Integer
		Local lnDifHeight As Integer

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loCtl As Control
		Local lnOldAnchor As Number
		Local i As Integer

		Try

			lnLeft = 0
			lnTop = 0
			lnDifWidth = 0
			lnDifHeight = 0

			With toObj As Object

				If Pemstatus( toObj, 'lFitToParent', 5 ) And Pemstatus( toObj, 'nFitMode', 5 )

					If .lFitToParent
						lnOldAnchor = .Anchor
						.Anchor = 0

						If Empty( .nFitMode ) Or Vartype( .nFitMode ) # "N"
							.nFitMode = FULL_FIT

						Endif && Empty( .nFitMode ) Or Vartype( .nFitMode ) # "N"

						If BitOn( .nFitMode, FIT_LEFT )
							This.GetPositionAndSize( toObj, @lnLeft, @lnTop, @lnDifWidth, @lnDifHeight )
							.Left = lnLeft
							.Width = .Width + lnDifWidth - .Parent.nLeftPadding

						Endif && BitOn( .nFitMode, FIT_LEFT )

						If BitOn( .nFitMode, FIT_TOP )
							This.GetPositionAndSize( toObj, @lnLeft, @lnTop, @lnDifWidth, @lnDifHeight )
							.Top = lnTop
							.Height = .Height + lnDifHeight - .Parent.nTopPadding

						Endif && BitOn( .nFitMode, FIT_TOP )

						If BitOn( .nFitMode, FIT_RIGHT )
							This.GetPositionAndSize( toObj, @lnLeft, @lnTop, @lnDifWidth, @lnDifHeight )
							.Width = .Width + lnDifWidth - .Parent.nRightPadding

						Endif && BitOn( .nFitMode, FIT_RIGHT )

						If BitOn( .nFitMode, FIT_BOTTOM )
							This.GetPositionAndSize( toObj, @lnLeft, @lnTop, @lnDifWidth, @lnDifHeight )
							.Height = .Height + lnDifHeight - .Parent.nRightPadding

						Endif && BitOn( .nFitMode, FIT_BOTTOM )

						*!*	If BitOn( .nFitMode, FIT_WIDTH )
						*!*		.Left = lnLeft
						*!*		.Width = lnWidth

						*!*	Endif && BitOn( .nFitMode, FIT_WIDTH )

						*!*	If BitOn( .nFitMode, FIT_HEIGHT )
						*!*		.Top = lnTop
						*!*		.Height = lnHeight

						*!*	Endif && BitOn( .nFitMode, FIT_HEIGHT )


						If Empty( lnOldAnchor )
							.Anchor = ANCHOR_Top_Absolute + ANCHOR_Left_Absolute ;
								+ ANCHOR_Bottom_Absolute + ANCHOR_Right_Absolute

						Else
							.Anchor = lnOldAnchor

						Endif && Empty( lnOldAnchor )

					Endif && .lFitToParent

				Endif && PemStatus( toObj, 'lFitToParent', 5 ) ANd PemStatus( toObj, 'nFitMode', 5 )

				If Lower( toObj.BaseClass ) = 'pageframe'

					For i = 1 To .PageCount
						loPage = .Pages[ i ]
						If Pemstatus( loPage, 'FitToParent', 5 )
							loPage.FitToParent()

						Else
							For j = 1 To loPage.Objects.Count
								loCtl = loPage.Objects[ j ]
								If Pemstatus( loCtl, 'lFitToParent', 5 )
									loCtl.FitToParent()

								Endif && Pemstatus( loCtl, 'lFitToParent', 5 )

							Endfor

						Endif && Pemstatus( loPage, 'FitToParent', 5 )

					Endfor

				Else
					If Pemstatus( toObj, 'Objects', 5 )

						For i = 1 To .Objects.Count
							loCtl = .Objects[ i ]
							If Pemstatus( loCtl, 'lFitToParent', 5 ) && And loCtl.lFitToParent
								loCtl.FitToParent()

							Endif && Pemstatus( loCtl, 'lFitToParent', 5 )

						Endfor

					Endif && PemStatus( toObj, 'Objects', 5 )

				Endif && Lower( toObj.BaseClass ) = 'pageframe'

			Endwith

		Catch To oErr
			This.lIsOk = .F.
			This.oError = oErr

		Finally
			loCtl = Null
			loPage = Null

		Endtry

		Return This.lIsOk

	Endproc && FitToParent

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetPositionAndSize
	*!* Description...: Calcula la posicion y el tamaño para el control
	*!* Date..........: Viernes 21 de Agosto de 2009 (16:23:39)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure GetPositionAndSize( toObj As Object, ;
			tnLeft As Number @, ;
			tnTop As Number @, ;
			tnDifWidth As Number @, ;
			tnDifHeight As Number @ ) As Void ;
			HelpString "Calcula la posicion y el tamaño para el control"

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try
			With toObj As Object

				tnLeft = .Parent.nLeftPadding
				tnTop = .Parent.nTopPadding

				If Lower( .Parent.BaseClass ) = "page"
					* tnDifWidth = .Parent.nWidth - ( .Left + .Width )
					tnDifWidth = .Parent.Parent.Width - ( .Left + .Width )
					* tnDifHeight = .Parent.nHeight - ( .Top + .Height )
					tnDifHeight = .Parent.Parent.Height - ( .Top + .Height )
					If .Parent.Parent.Tabs
						tnDifHeight = tnDifHeight - ( TABS_HEIGHT * .Parent.Parent.nTabsRows )

					Endif && .Parent.Parent.Tabs
				Else
					tnDifWidth = .Parent.Width - ( .Left + .Width )
					tnDifHeight = .Parent.Height - ( .Top + .Height )

				Endif && Lower( .Parent.BaseClass ) = "page"

			Endwith

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

	Endproc && GetPositionAndSize

Enddefine && AutoSetUp

* Define Class ControlMeasures As Session
Define Class ControlMeasures As Custom
	#If .F.
		Local This As ControlMeasures Of 'fw\comunes\prg\autosetup.prg'
	#Endif
	Width = 0
	Height = 0
	Left = 0
	Top = 0
	nLabelWidth = 0
	nDatoWidth = 0
	nLabelHeight = 0
	nDatoHeight = 0
	lLabelOnTop = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="width" type="property" display="Width" />] + ;
		[<memberdata name="height" type="property" display="Height" />] + ;
		[<memberdata name="left" type="property" display="Left" />] + ;
		[<memberdata name="top" type="property" display="Top" />] + ;
		[<memberdata name="nlabelwidth" type="property" display="nLabelWidth" />] + ;
		[<memberdata name="ndatowidth" type="property" display="nDatoWidth" />] + ;
		[<memberdata name="nlabelheight" type="property" display="nLabelHeight" />] + ;
		[<memberdata name="ndatoheight" type="property" display="nDatoHeight" />] + ;
		[<memberdata name="llabelontop" type="property" display="lLabelOnTop" />] + ;
		[</VFPData>]
Enddefine && ControlMeasures

Define Class SpanControl As ControlMeasures Of 'fw\comunes\prg\autosetup.prg'
	#If .F.
		Local This As ControlMeasures Of 'fw\comunes\prg\autosetup.prg'
	#Endif
	nColSpan = 1
	nRowSpan = 1
	oRef = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ncolspan" type="property" display="nColSpan" />] + ;
		[<memberdata name="nrowspan" type="property" display="nRowSpan" />] + ;
		[<memberdata name="oref" type="property" display="oRef" />] + ;
		[</VFPData>]

	Procedure Destroy () As Void
		This.oRef = Null

	Endproc

Enddefine && SpanControl