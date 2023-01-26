Lparameters toObj As Object, tcPath As String

#Define CR Chr( 13 )

Local locontrol As Control
Local lcRet As String
lcRet = ''
tcPath = Iif( Empty( tcPath ), toObj.Name, tcPath + '.' + toObj.Name )
If Vartype( toObj ) = 'O'
    If Pems( toObj, 'Name', 5 )
        lcRet = lcRet + tcPath + '.Name = ' + '"' + Trans( toObj.Name ) + '"' + CR
    Endif

    If Pems( toObj, 'Caption', 5 )
        lcRet = lcRet + tcPath + '.Caption = ' + '"' + Trans( toObj.Caption ) + '"' + CR
    Endif

    If Pems( toObj, 'Class', 5 )
        lcRet = lcRet + tcPath + '.Class = ' + '"' + Trans( toObj.Class ) + '"' + CR
    Endif

    If Pems( toObj, 'ClassLibrary', 5 )
        lcRet = lcRet + tcPath + '.ClassLibrary = ' + '"' + Trans( toObj.ClassLibrary ) + '"' + CR
    Endif

    If Pems( toObj, 'Enabled', 5 )
        lcRet = lcRet + tcPath + '.Enabled = ' + Trans( toObj.Enabled ) + CR
    Endif

    If Pems( toObj, 'Visible', 5 )
        lcRet = lcRet + tcPath + '.Visible = ' + Trans( toObj.Visible ) + CR
    Endif

    If Pems( toObj, 'ReadOnly', 5 )
        lcRet = lcRet + tcPath + '.ReadOnly = ' + Trans( toObj.ReadOnly ) + CR
    Endif

    If Pems( toObj, 'Width', 5 )
        lcRet = lcRet + tcPath + '.Width = ' + Trans( toObj.Width ) + CR
    Endif

    If Pems( toObj, 'MaxWidth', 5 )
        lcRet = lcRet + tcPath + '.MaxWidth = ' + Trans( toObj.MaxWidth ) + CR
    Endif

    If Pems( toObj, 'MinWidth', 5 )
        lcRet = lcRet + tcPath + '.MinWidth = ' + Trans( toObj.MinWidth ) + CR
    Endif

    If Pems( toObj, 'Height', 5 )
        lcRet = lcRet + tcPath + '.Height = ' + Trans( toObj.Height ) + CR
    Endif

    If Pems( toObj, 'MaxHeight', 5 )
        lcRet = lcRet + tcPath + '.MaxHeight = ' + Trans( toObj.MaxHeight ) + CR
    Endif

    If Pems( toObj, 'MinHeight', 5 )
        lcRet = lcRet + tcPath + '.MinHeight = ' + Trans( toObj.MinHeight ) + CR
    Endif

    If Pems( toObj, 'Left', 5 )
        lcRet = lcRet + tcPath + '.Left = ' + Trans( toObj.Left ) + CR
    Endif

    If Pems( toObj, 'Top', 5 )
        lcRet = lcRet + tcPath + '.Top = ' + Trans( toObj.Top ) + CR
    Endif

    If Pems( toObj, 'TabIndex', 5 )
        lcRet = lcRet + tcPath + '.TabIndex = ' + Trans( toObj.TabIndex ) + CR
    Endif

    If Pems( toObj, 'Comment', 5 )
        lcRet = lcRet + tcPath + '.Comment = ' + '"' + Trim( toObj.Comment ) + '"' + CR
    Endif

    Do Case
        Case Inlist( Lower( toObj.BaseClass ), 'form', 'page', 'container', 'column' )
            For Each locontrol In toObj.Controls
                lcRet = lcRet + ListarControles( locontrol, tcPath ) + CR
            Next
        Case Lower( toObj.BaseClass ) = 'pageframe'
            For Each locontrol In toObj.Pages
                lcRet = lcRet + ListarControles( locontrol, tcPath ) + CR
            Next
        Case Lower( toObj.BaseClass ) = 'grid'
            For Each locontrol In toObj.Columns
                lcRet = lcRet + ListarControles( locontrol, tcPath ) + CR
            Next
        Otherwise

    Endcase
Endif

Return Trim( lcRet )
