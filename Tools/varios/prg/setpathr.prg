Procedure SetPathR( tcDir As String )
    Local lnCnt As Number
    Local lcDir As String
    lnCnt = 0
    tcDir = IfEmpty( tcDir, Addbs( Set( "Default" ) ) + Curdir() )
    lcDir = Curdir()
    Chdir &tcDir
    For i = 1 To Adir( ladir, '*.*', 'D' )
        If ladir( i, 5 ) # 'D'
            lnCnt = lnCnt + 1
        Else
            SetPathR( Addbs( tcDir ) + ladir( i, 1 ) )
        Endif
    Next
    If lnCnt > 0
        Set Path To &tcDir Additive
    Endif
    Chdir &lcDir
Endproc
