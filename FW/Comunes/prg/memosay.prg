*
* Imprime un String proveniente de un campo Memo 
* en una porcion de la pantalla con @ ... Say
Procedure MemoSay( cMemoStr As String,;
		nTop As Integer,;
		nLeft As Integer,;
		nBottom As Integer,;
		nRight As Integer ) As Void
		
	Local lcCommand As String,;
		lcStr As String,;
		lcAlias As String

	Local lnLine As Integer,;
		lnLen As Integer,;
		lnLines As Integer,;
		lnMemoWidth As Integer,;
		i As Integer

	Local Array laLines(1)

	Try

		lcCommand = ""

		If Vartype( pnMaxRow ) # "N"
			pnMaxRow = 24
		Endif

		If Vartype( pnMaxCol ) # "N"
			pnMaxCol = 80
		Endif

		If Empty( nTop )
			nTop = 0
		Endif

		If Empty( nLeft )
			nLeft = 0
		Endif

		If Empty( nBottom )
			nBottom = pnMaxRow
		Endif

		If Empty( nRight )
			nRight = pnMaxCol
		Endif

		S_Clear( nTop, nLeft, nBottom, nRight )

		If !IsEmpty( cMemoStr )

			lnLen = nRight - nLeft

			lcAlias = Alias()
			lnLines = Alines( laLines, cMemoStr, 1 + 4 )

			lnMemoWidth = Set("Memowidth")
			Set Memowidth To lnLen

			cMemoStr = ""
			For i = 1 To lnLines
				cMemoStr = cMemoStr + Alltrim( laLines[ i ] ) + " "
			Endfor

			Create Cursor cDummy ( MemoStr M )
			Append Blank
			Replace MemoStr With cMemoStr

			lnLines = Memlines( cDummy.MemoStr )

			_Mline = 0
			For i = nTop To Min( nBottom, nTop + lnLines - 1 )
				lcStr = Mline( cDummy.MemoStr, 1, _Mline )
				@ i, nLeft Say Padr( Alltrim( lcStr ), lnLen )
			Endfor

			Set Memowidth To lnMemoWidth
			Use In Select( "cDummy" )
			Select Alias( lcAlias )

		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && MemoSay

