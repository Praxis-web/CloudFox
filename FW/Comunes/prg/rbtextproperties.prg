#INCLUDE "Tools\ReportBuilder\Include\OOReportBuilder.h"

*!* ///////////////////////////////////////////////////////
*!* Class.........: rbTextProperties
*!* ParentClass...: TextProperties
*!* BaseClass.....: Session
*!* Description...:
*!* Date..........: Miércoles 10 de Octubre de 2007 (09:29:25)
*!* Author........: Ricardo Aidelman
*!* Project.......: OOReport Builder
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*


Define Class rbTextProperties As TextProperties Of "Comun\Prg\TxtProperties.prg"

	#If .F.
		Local This As rbTextProperties Of "Tools\ReportBuilder\Source\Prg\rbTextProperties.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Function......: Process
	*!* Description...: Recibe un objeto y calcula el ancho y el alto necesarios
	*!* Date..........: Miércoles 10 de Octubre de 2007 (09:39:48)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: OOReport Builder
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!* tnExtraLen: Ancho extra (en cantidad de caracteres)
	*!* tnExtraHeight = Alto extra (en porcentaje)


	Function Process( toObj As Object,;
			tnExtraLen As Integer,;
			tnExtraHeight ) As Boolean;
			HELPSTRING "Recibe un objeto y calcula el ancho y el alto necesarios"


		Local lcText As String
		Local lcFontName As String
		Local lcFontStyle As String
		Local lnFontSize As Number
		Local lnLen As Number
		Local lnExtraHeight As Integer
		Local llValue As Boolean
		Local lcOldCentury As String
		Local lcOldCentury As String
		Local lcChar as Character 

		Try
			With This As TextProperties Of fw\comunes\prg\txtproperties.prg
				If Vartype( toObj ) # "O"
					.lIsOk = .F.
					Assert .lIsOk Message "Se esperaba un Objeto"

				Endif && Vartype( toObj ) # "O"

				If .lIsOk
					*!* Validar propiedad
					llValue = .F.
					tnExtraLen = IfEmpty( tnExtraLen, 0 )
					tnExtraHeight = IfEmpty( tnExtraHeight, 1 )

					lnLen = 0

					Do Case
						Case Pemstatus( toObj, "Caption", 5 ) And ! Empty( toObj.Caption )
							lcText = toObj.Caption

                        Case Pemstatus( toObj, "Format", 5 ) And ! Empty( toObj.Format)
	                       	lcText = toObj.Format 
	                       	
	                       	lcChar = Substr( lcText, 1, 1 )
	                       	
	                       	If InList( lcChar, ['], ["], "[" ) 
								lcText = Strtran( toObj.Format , lcChar, "" )  
	                       	EndIf

							If PemStatus( toObj, "DataType", 5 )
								If InList( toObj.DataType, "N", "I", "Y" )
									lcText = lcText + Replicate( "9", 3 )
								EndIf
							EndIf

						Case Pemstatus( toObj, "nLength", 5 ) And ! Empty( toObj.nLength )
							lnLen = toObj.nLength
							
							If PemStatus( toObj, "DataType", 5 )
								If InList( toObj.DataType, "N", "I", "Y" )
									lcText = Replicate( "9", lnLen )
									
								Else 
									lcText = Replicate( "X", lnLen )
									
								EndIf

							Else
								lcText = Replicate( "X", lnLen )
								
							EndIf
							
							
						Case Pemstatus( toObj, "Value", 5 )
							llValue = .T.
							Do Case
								Case Vartype( toObj.Value ) == "C"
									lcText = toObj.Value

								Case Vartype( toObj.Value ) == "D"
									lcOldCentury = "SET CENTURY " + Set( "Century" )
									Do Case
										Case toObj.Century = 0
											Set Century Off

										Case toObj.Century = 1
											Set Century On

									Endcase
									lcText = Dtoc( toObj.Value )
									&lcOldCentury

								Case Vartype( toObj.Value ) == "T"
									lcOldCentury = "SET CENTURY " + Set( "Century" )
									Do Case
										Case toObj.Century = 0
											Set Century Off

										Case toObj.Century = 1
											Set Century On

									Endcase
									lcText = Ttoc( toObj.Value )
									&lcOldCentury

								Otherwise
									This.lIsOk = .F.
									Assert .lIsOk Message "La propiedad VALUE no es de un tipo valido"

							Endcase
						Otherwise
							*!* Fuerza un error para que lo atrape el Catch
							Error "No es posible calcular las dimensiones del control " + toObj.Name

					Endcase

					If .lIsOk
						lcFontName = toObj.FontName
						lnFontSize = toObj.FontSize
						lcFontStyle = .FontStyle( toObj )

						lnLen = Max( Txtwidth( lcText, ;
							lcFontName, ;
							lnFontSize, ;
							lcFontStyle ), lnLen )

						.nAverageCharacterWidth = Fontmetric( TM_AVECHARWIDTH, ;
							lcFontName, ;
							lnFontSize, ;
							lcFontStyle ) && * 1.1

						.nTxtwidth = Ceiling( .nAverageCharacterWidth * ( lnLen + tnExtraLen ) )

						.nTxtHeight = Ceiling( Fontmetric( TM_HEIGHT, ;
							lcFontName, ;
							lnFontSize, ;
							lcFontStyle ) * tnExtraHeight )

					Endif

					toObj.Height = .nTxtHeight
					toObj.Width = .nTxtwidth

				Endif
			Endwith

			toObj.Height = Convert2Any( This.nTxtHeight, FRX_PIXELS, toObj.nMeasurementUnits )
			toObj.Width = Convert2Any( This.nTxtWidth, FRX_PIXELS, toObj.nMeasurementUnits )

		Catch To oErr
			This.lIsOk = .F.
			This.oError = oErr

		Finally
			toObj = .F.

		Endtry

		Return This.lIsOk

	Endfunc
	*!*
	*!* END FUNCTION Process
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: RBTextProperties
*!*
*!* ///////////////////////////////////////////////////////
