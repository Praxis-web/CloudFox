Local lcCommand As String, lcMsg As String

Try

	lcCommand = ""
	Close Databases All

	drComun = "s:\Fenix\Dbf\Central\Dbf\"
	DRVA 	= "s:\Fenix\Dbf\Srl\Dbf\"

	* RA 11/12/2021(11:22:35)
	* Genera las tablas auxiliares y luego importa la Cta. Ctte.

	Organizaciones()



Catch To loErr

	Do While Vartype( loErr.UserValue ) == "O"
		loErr = loErr.UserValue
	Enddo

	lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  METODO   ] " + loErr.Procedure + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  LINEA Nº ] " + Transform(loErr.Lineno) + Chr( 13 ) + Chr( 10 )
	If Substr( loErr.LineContents, 2 ) = "lcCommand"
		lcMsg = lcMsg + "[  COMANDO  ] " + lcCommand + Chr( 13 ) + Chr( 10 )
	Else
		lcMsg = lcMsg + "[  COMANDO  ] " + loErr.LineContents + Chr( 13 ) + Chr( 10 )
	Endif
	lcMsg = lcMsg + "[  ERROR    ] " + Transform(loErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  MENSAJE  ] " + loErr.Message + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  DETALLE  ] " + loErr.Details + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )

	Strtofile( lcMsg, "ErrorLog9.txt" )

	Messagebox( lcMsg, 16, "Error", -1 )


Finally
	Close Databases All


Endtry

*
*
Procedure Organizaciones(  ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""
		Close Databases All

		Use ( drComun + "ar4Var" ) Shared In 0

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select 	Tipo4,
				Codi4,
				Upper( Nomb4 ) as Nombre,
				Space( 6 ) as Alias_C,
				Space( 6 ) as Alias_P,
				Cuit4,
				Insc4,
				loca4,
				zona4,
				.F. as Borrado,
				.F. as Unificado
			From ar4Var
			Where !Deleted()
			And InList( Tipo4, '1', '2' )
			And ( Insc4 # 2 )
			And !InList( Substr( Alltrim( Nomb4 ), 1, 1 ), '*', '.' )
			Into Cursor cOrganizaciones ReadWrite
		ENDTEXT

		&lcCommand
		lcCommand = ""

		Locate
		Scan

			If Tipo4 = '1'
				Replace Alias_C With StrZero( Codi4, 6, 0 )
			Endif

			If Tipo4 = '2'
				Replace Alias_P With StrZero( Codi4, 6, 0 )
			Endif


		Endscan

		*Browse

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select * from cOrganizaciones
			Where InList( Substr( Alltrim( Cuit4 ), 1, 3 ), "33-", "30-", "27-", "23-", "20-" )
				And Len( Alltrim( Cuit4 )) > 5
			Into Cursor cOrganizaciones ReadWrite
		ENDTEXT

		&lcCommand
		lcCommand = ""

		Select cOrganizaciones
		Index On Cuit4 + Tipo4 Tag Cuit

		Locate
		lnCant = 0

		lcCuit = Replicate( "&", 10 )
		lcTipo = " "
		Do While !Eof()
			If lcCuit # Cuit4
				lcCuit = Cuit4
				lcTipo = Tipo4

			Else
				If lcTipo # Tipo4
					Replace Unificado With .T.
					*Browse
					lnCant = lnCant + 1
					lcTipo = Tipo4


				Else
					Replace Borrado With .T.

				Endif

			EndIf
			
			If Substr( Nombre, 1, 1 ) == '"' 
				Replace Nombre with Substr( Nombre, 2 )
			EndIf

			Skip

		Enddo

		*Inform( "Terminado " + Transform( lnCant ) )

		Select cOrganizaciones
		Set Order To

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select *
			From cOrganizaciones
			Where Unificado
			Into Cursor cUnificados ReadWrite
		ENDTEXT

		&lcCommand
		lcCommand = ""

		Select cUnificados
		Index On Cuit4 Tag Cuit4 Candidate

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select 	Cast( 0 as I ) as Id,
		 		Nombre,
		 		Alias_C,
		 		Alias_P,
				loca4,
				zona4,
		 		Cuit4,
		 		Insc4
			From cOrganizaciones
			Where !Borrado And !Unificado
			Into Table ( drComun + "Organizaciones" )
		ENDTEXT

		&lcCommand
		lcCommand = ""

		Select Organizaciones
		Replace All Id With Recno()
		Locate

		Scan
			If Seek( Organizaciones.Cuit4, "cUnificados", "Cuit4" )
				Replace Alias_P With cUnificados.Alias_P
			Endif

		Endscan

		*!*			Browse
		*!*
		*!*			Select distin Insc4 From Organizaciones
		*!*			Select * from Organizaciones Where Insc4 = 2
		*!*			Select * from Organizaciones Where Insc4 = 5
		*!*			Select * from Organizaciones Where Insc4 = 7
		*!*			Select * from Organizaciones Where Insc4 = 3

		* Consumidor Final

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select 	Tipo4,
				Codi4,
				Upper( Nomb4 ) as Nombre,
				Space( 6 ) as Alias_C,
				Space( 6 ) as Alias_P,
				Cuit4,
				Insc4,
				loca4,
				zona4,
				.F. as Borrado,
				.F. as Unificado
			From ar4Var
			Where !Deleted()
			And InList( Tipo4, '1', '2' )
			And ( Insc4 = 2 )
			And !InList( Substr( Alltrim( Nomb4 ), 1, 1 ), '*', '.' )
			Into Cursor cConsumidorFinal ReadWrite
		ENDTEXT

		&lcCommand
		lcCommand = ""

		Locate
		Scan

			If Tipo4 = '1'
				Replace Alias_C With StrZero( Codi4, 6, 0 )
			Endif

			If Tipo4 = '2'
				Replace Alias_P With StrZero( Codi4, 6, 0 )
			Endif


		Endscan

		Browse

		Select * From cConsumidorFinal Where .F. Into Cursor cCF Readwrite
		Select cCF
		Index On Cuit4 Tag Cuit Candidate
		Index On Nombre Tag Nombre Candidate

		Select cConsumidorFinal
		Locate

		Scan

			If !Empty( Nombre ) And Substr( Alltrim( Nombre ), 1, 1 ) # '*'


				i = 0
				lcCuit = Cuit4
				If Seek( lcCuit, "cCF", "Cuit" ) Or Empty( lcCuit )
					lcCuit = Tipo4+Alltrim( Alias_C ) + Alltrim( Alias_P ) + Alltrim( Cuit4 )
				EndIf
				
				lcNombre = Nombre
				Do While Seek( lcNombre, "cCF", "Nombre" ) 
					i = i + 1 
					lcNombre = Alltrim( Nombre ) + " (" + Transform( i ) + ")" 
				EndDo

				Try

					Replace Cuit4 With lcCuit,;
						Nombre With lcNombre
						
					Scatter Name loReg

					Select cCF
					Append Blank
					Gather Name loReg

				Catch To oErr
					Select cConsumidorFinal
					Replace Borrado With .T.


				Finally
					Select cConsumidorFinal

				Endtry

			Endif


		Endscan

		Select * From cCF
		Select * From cConsumidorFinal Where Borrado Order By Nombre


		Select Organizaciones
		Append From Dbf( "cCF" )

		Replace All Id With Recno()
		Browse
		
		Select * from Organizaciones Order by Nombre


	Catch To loErr
		Throw loErr

	Finally

	Endtry

Endproc && Organizaciones



