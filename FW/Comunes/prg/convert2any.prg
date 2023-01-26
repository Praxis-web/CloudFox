*-- Conversion values
#define FRX_POINTS_PER_INCH     	72
#define FRX_FRU_PER_INCH     		10000
#define FRX_PIXELS_PER_INCH 		96
#define FRX_MILIMETERS_PER_INCH 	25.4

#define FRX_FRU_PER_PIXEL        	FRX_FRU_PER_INCH / FRX_PIXELS_PER_INCH

#define FRX_PIXELS_PER_MILIMETER 	FRX_PIXELS_PER_INCH / FRX_MILIMETERS_PER_INCH
#define FRX_FRU_PER_MILIMETER 		FRX_FRU_PER_INCH / FRX_MILIMETERS_PER_INCH 

#define FRX_BAND_HEIGHT             20 * FRX_FRU_PER_PIXEL

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Convert2Any
	*!* Description...: Convierte un valor en una unidad de medida a otra
	*!* Date..........: Viernes 21 de Septiembre de 2007 (10:39:11)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: OOReport Builder
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Convert2Any( nValue As Number, ;
			nInput As Integer, ;
			nOutput As Integer ) As Number;
			HELPSTRING "Convierte un valor en una unidad de medida a otra"

		Try

			Local lnReturn As Number

			Local lnPointsPerInch As Number,;
				lnFruPerInch As Number,;
				lnPixelsPerInch As Number,;
				lnMilimetersPerInch As Number

			lnFruPerInch 		= FRX_FRU_PER_INCH
			lnPointsPerInch 	= FRX_POINTS_PER_INCH
			lnPixelsPerInch 	= FRX_PIXELS_PER_INCH
			lnMilimetersPerInch = FRX_MILIMETERS_PER_INCH


			Do Case
				Case nInput = FRX_FRU
					Do Case
						Case nOutput = FRX_FRU
							lnReturn = nValue

						Case nOutput = FRX_INCHES
							lnReturn = nValue / lnFruPerInch

						Case nOutput = FRX_MILIMETERS
							lnReturn = nValue / lnFruPerInch * lnMilimetersPerInch

						Case nOutput = FRX_PIXELS
							lnReturn = nValue / lnFruPerInch * lnPixelsPerInch

						Otherwise
							Error "Output value not suported"

					Endcase

				Case nInput = FRX_INCHES
					Do Case
						Case nOutput = FRX_FRU
							lnReturn = nValue * lnFruPerInch

						Case nOutput = FRX_INCHES
							lnReturn = nValue

						Case nOutput = FRX_MILIMETERS
							lnReturn = nValue * lnMilimetersPerInch

						Case nOutput = FRX_PIXELS
							lnReturn = nValue * lnPixelsPerInch

						Otherwise
							Error "Output value not suported"

					Endcase

				Case nInput = FRX_MILIMETERS
					Do Case
						Case nOutput = FRX_FRU
							lnReturn = nValue * lnFruPerInch / lnMilimetersPerInch

						Case nOutput = FRX_INCHES
							lnReturn = nValue / lnMilimetersPerInch

						Case nOutput = FRX_MILIMETERS
							lnReturn = nValue

						Case nOutput = FRX_PIXELS
							lnReturn = nValue * lnPixelsPerInch / lnMilimetersPerInch

						Otherwise
							Error "Output value not suported"

					Endcase

				Case nInput = FRX_PIXELS
					Do Case
						Case nOutput = FRX_FRU
							lnReturn = nValue * lnFruPerInch / lnPixelsPerInch

						Case nOutput = FRX_INCHES
							lnReturn = nValue / lnPixelsPerInch

						Case nOutput = FRX_MILIMETERS
							lnReturn = nValue * lnMilimetersPerInch / lnPixelsPerInch

						Case nOutput = FRX_PIXELS
							lnReturn = nValue

						Otherwise
							Error "Output value not suported"

					Endcase

				Otherwise
					Error "Input value not suported"

			Endcase

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return Round( lnReturn, 3 )

	Endproc
	*!*
	*!* END PROCEDURE Convert2Any
	*!*
	*!* ///////////////////////////////////////////////////////