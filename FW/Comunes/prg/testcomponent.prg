*!* ///////////////////////////////////////////////////////
*!* Procedure.....: TestComponent
*!*
*!*

Lparameters  tcXML As String

Try


	Local lcIdentifier As String

	If Vartype( tcXML ) = "C"


		lcIdentifier = ParseXML( tcXML, 1 )

		Do Case

			Case !Empty( lcIdentifier )
				Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Process( tcXML )

			Otherwise


				loMyXA = Newobject("prxXMLAdapter",;
					"prxXMLAdapter.prg" )


				* Loads the XML
				loMyXA.LoadXML( tcXML, .F. )
				For Each oTable In loMyXA.Tables
					* Extract each of the tables' cursor
					Use In Select( oTable.Alias )
					oTable.ToCursor( .F. )
				Endfor
				loMyXA = .F.

				Browse


		EndCase
	Else
		If Used( Alias())
			Browse 
		Else
			=MessageBox( "Return Value = " + Any2Char( tcXML ) )	
		EndIf	

	Endif


Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )

Finally

Endtry


Endproc
*!*
*!* END PROCEDURE TestComponent
*!*
*!* ///////////////////////////////////////////////////////