Lparameters tcProjectPath As String

Local loProject  As VisualFoxpro.IFoxProject
Local loFile As VisualFoxpro.IFoxPrjFile
Local lcProjectPath As String
Local lcProjectName As String
Local loError As UserTierError Of "fw\Actual\ErrorHandler\UserTierError.prg"
Local oErr As Exception

Try
	loProject = _vfp.ActiveProject
	
	If Vartype( loProject ) = 'O'
		If Vartype( loProject.ProjectHook ) = 'O' ;
				And Pemstatus( loProject.ProjectHook, 'GetProjectName', 5 )
			lcProjectName = loProject.ProjectHook.GetProjectName()
			
		Else
			lcProjectName = Justfname( loProject.Name )
			
		EndIf
		
		lcProjectPath = tcProjectPath
		
		If Empty( lcProjectPath )
			If Vartype( loProject.ProjectHook ) = 'O' ;
					And Pemstatus( loProject.ProjectHook, 'cProjectPath', 5 ) ;
					And ! Empty( loProject.ProjectHook.cProjectPath )
				lcProjectPath = loProject.ProjectHook.cProjectPath
				
			Else
				lcProjectPath = Getdir( loProject.HomeDir, 'Selecione el direcctorio para el proyecto ' + lcProjectName )
				
			Endif
		EndIf
		
		lcProjectPath = IfEmpty( lcProjectPath, Justpath( loProject.Name ) )
		
		For Each loFile In loProject.Files
			If Inlist( loFile.Type, 'K', 'R', 'B', 'V', 'P','M','T', 'T', 'x' )
			
				Do Case
				Case ! ( Lower( Justpath( lcProjectPath ) ) $ Lower( Justpath( loFile.Name ) ) )
					loFile.Exclude = .T.
					
				Case ( Left( Justfname( loFile.Name ), 1 ) == '_' ) 
					loFile.Exclude = .T.
					
				Case ( Lower( JustExt( loFile.Name )) == 'h' ) 
					loFile.Exclude = .T.
					
				Otherwise
					loFile.Exclude = .F.

				EndCase
				
			Endif
		Next
		
		Messagebox( "Proceso Terminado", 0, "Excluir " + JustStem( lcProjectName ), 3000 )
		
	Else	
		Messagebox( "No hay ningun Proyecto activo", 0, _Screen.Caption, 3000 )
	EndIf
	
	
	
Catch To oErr
	lcError = ''
	lcError = 'Message: ' + oErr.Message + Chr( 13 ) ;
		+ 'Lineno: ' + Transform( oErr.Lineno ) + Chr( 13 ) ;
		+ 'LineContents: ' + oErr.LineContents + Chr( 13 ) ;
		+ 'Details: ' + oErr.Details + Chr( 13 )
	Messagebox( lcError, 0, _Screen.Caption, 3000 )
	
Finally
	loProject = Null
	loFile = Null
	
Endtry
