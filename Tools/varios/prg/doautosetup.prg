*
* Dimensiona el formulario que se encuentra en el diseñador
Procedure DoAutosetup(  ) As Void;
		HELPSTRING "Dimensiona el formulario que se encuentra en el diseñador"


	#If .F.
		TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Dimensiona el formulario que se encuentra en el diseñador
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Martes 30 de Junio de 2009 (16:48:57)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
		ENDTEXT
	#Endif

	Local loDesignForm As ABMGenericForm Of FW\Comunes\Vcx\prxMainForm.Vcx
	Local loRuningForm As ABMGenericForm Of FW\Comunes\Vcx\prxMainForm.Vcx
	Local lcXML As String
	Local lcFileName As String
	Local lcAuxFile As String
	Local lnWindowType As Integer
	Local llPerformAutosetup As Boolean

	Try

		If .F.

			Aselobj( laobj, 3 )
			loDesignForm = laobj[ 1 ]

			lnWindowType = loDesignForm.WindowType

			loDesignForm.WindowType = 0
			lcFileName = Addbs( Justpath( laobj[ 2 ] ) ) + Juststem( laobj[ 2 ] )
			* lcAuxFile = Addbs( Justpath( lcFileName ) ) + Sys( 2015 ) + Juststem( lcFileName )
			lcAuxFile = Addbs( Justpath( lcFileName ) ) + '_TEMPDAS' + Sys( 2015 ) + Juststem( lcFileName )
			TEXT To lcCommand NoShow TextMerge Pretext 15
 			Modify Form '<<lcFileName>>.scx' Nowait Save
			ENDTEXT
			loError.Remark = 'Command: ' + lcCommand
			&lcCommand
			DoEvents

			* Cierro el archivo
			Sys( 1500, '_MFI_CLOSE', '_MFILE' )

			TEXT To lcCommand NoShow TextMerge
			Copy File '<<lcFileName>>.scx' TO '<<lcAuxFile>>.scx'
			ENDTEXT
			loError.Remark = 'Command: ' + lcCommand
			&lcCommand

			TEXT To lcCommand NoShow TextMerge
 			Copy File '<<lcFileName>>.sct' TO '<<lcAuxFile>>.sct'
			ENDTEXT
			loError.Remark = 'Command: ' + lcCommand
			&lcCommand

			TEXT To lcCommand NoShow TextMerge Pretext 15
	 		Modify Form '<<lcFileName>>.scx' Nowait
			ENDTEXT
			loError.Remark = 'Command: ' + lcCommand
			&lcCommand
			DoEvents

			Aselobj( laobj, 3 )

			loDesignForm = laobj[ 1 ]

			Do Form ( lcAuxFile ) Name loRuningForm

			loRuningForm.Top = 0
			loRuningForm.Left = 0

			ClonObject( loRuningForm, loDesignForm )

			loDesignForm.WindowType = lnWindowType

			loRuningForm.Release()
			loRuningForm = Null

			Wait Window "Proceso Terminado" Nowait


		Else
			lcFileName = Getfile( "scx" )

			If !Empty( lcFileName )

				lcFileName = Addbs( Justpath( lcFileName )) + Juststem( lcFileName )
				lcAuxFile = Addbs( Justpath( lcFileName ) ) + '_TEMPDAS' + Sys( 2015 ) + Juststem( lcFileName )

				TEXT To lcCommand NoShow TextMerge
				Copy File '<<lcFileName>>.scx' TO '<<lcAuxFile>>.scx'
				ENDTEXT
				loError.Remark = 'Command: ' + lcCommand
				&lcCommand

				TEXT To lcCommand NoShow TextMerge
 				Copy File '<<lcFileName>>.sct' TO '<<lcAuxFile>>.sct'
				ENDTEXT
				loError.Remark = 'Command: ' + lcCommand
				&lcCommand

				TEXT To lcCommand NoShow TextMerge Pretext 15
	 			Modify Form '<<lcFileName>>.scx' Nowait
				ENDTEXT
				loError.Remark = 'Command: ' + lcCommand
				&lcCommand
				DoEvents

				Aselobj( laobj, 3 )

				loDesignForm = laobj[ 1 ]
				lnWindowType = loDesignForm.WindowType
				llPerformAutosetup = loDesignForm.lPerformAutoSetup

				loDesignForm.WindowType = 0
				loDesignForm.lPerformAutoSetup = .T.

				Do Form ( lcAuxFile ) Name loRuningForm

				loRuningForm.Top = 0
				loRuningForm.Left = 0

				ClonObject( loRuningForm, loDesignForm )

				loDesignForm.WindowType = lnWindowType
				loDesignForm.lPerformAutoSetup = llPerformAutosetup

				loRuningForm.Release()
				loRuningForm = Null

				Wait Window "Proceso Terminado" Nowait

			Endif
		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loDesignForm = Null
		loRuningForm = Null
		TEXT To lcCommand NoShow TextMerge Pretext 15
 			Erase "<<lcAuxFile>>.scx"
		ENDTEXT

		Try
			&lcCommand
		Catch To oErr
		Endtry

		TEXT To lcCommand NoShow TextMerge Pretext 15
 			Erase "<<lcAuxFile>>.sct"
		ENDTEXT

		Try
			&lcCommand
		Catch To oErr
		Endtry

	Endtry

Endproc && DoAutosetup


*
* Clona algunas propiedades entre dos objetos
Procedure ClonObject( toRuning As Object, toDesign As Object )As Void;
		HELPSTRING "Clona algunas propiedades entre dos objetos"


	#If .F.
		TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Clona algunas propiedades entre dos objetos
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Martes 30 de Junio de 2009 (16:52:48)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
		ENDTEXT
	#Endif

	Local lcName As String
	Local loClon As Object

	Try

		Try
			toDesign.Top = toRuning.Top
			toDesign.Left = toRuning.Left
			toDesign.Width = toRuning.Width
			toDesign.Height = toRuning.Height

		Catch To oErr
		Endtry

		If Pemstatus( toDesign, "Caption", 5 )
			toDesign.Caption = toRuning.Caption
		Endif

		*!*			If Pemstatus( toDesign, "Format", 5 )
		*!*				toDesign.Format = toRuning.Format
		*!*			Endif


		*!*			If Pemstatus( toDesign, "nLength", 5 )
		*!*				toDesign.nLength = toRuning.nLength
		*!*			Endif

		*!*			If Pemstatus( toDesign, "InputMask", 5 )
		*!*				toDesign.InputMask = toRuning.InputMask
		*!*			Endif

		*!*			If Pemstatus( toDesign, "cErrorMessage", 5 )
		*!*				toDesign.cErrorMessage = toRuning.cErrorMessage
		*!*			Endif

		*!*			If Pemstatus( toDesign, "lRequired", 5 )
		*!*				toDesign.lRequired = toRuning.lRequired
		*!*			Endif

		*!*			If Pemstatus( toDesign, "ToolTipText", 5 )
		*!*				toDesign.ToolTipText = toRuning.ToolTipText
		*!*			Endif

		*!*			If Pemstatus( toDesign, "StatusBarText", 5 )
		*!*				toDesign.StatusBarText = toRuning.StatusBarText
		*!*			Endif

		If Pemstatus( toDesign, 'Objects', 5 ) And Pemstatus( toRuning, 'Objects', 5 )
			For Each loRuningCtrl In toRuning.Objects
				lcName = loRuningCtrl.Name
				Try
					loDesignCtrl = toDesign.&lcName.
					ClonObject( loRuningCtrl, loDesignCtrl )
				Catch To oErr
				Endtry
			Endfor
		Endif

	Catch To oErr
		Throw oErr

	Finally

	Endtry

Endproc && ClonObject
