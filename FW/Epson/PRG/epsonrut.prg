Declare Integer ConfigurarRetardoAlEnviarComando IN "s:\EpsonFiscalInterface.dll" integer velocidad

Declare Integer CargarPago IN "s:\EpsonFiscalInterface.dll"   Integer id_modificador,;
 															  Integer codigo_forma_pago,;
 															  Integer cantidad_cuotas,;
															  String monto,;
															  String descripción_cupones,;
															  String descripcion,;
															  String descripcion_extra1,;
															  String descripcion_extra2 															   


Declare INTEGER  DetenerLog IN "s:\EpsonFiscalInterface.dll" 

Declare Integer ComenzarLog IN "s:\EpsonFiscalInterface.dll"  

DECLARE INTEGER Desconectar IN "s:\EpsonFiscalInterface.dll"

Declare Integer EstablecerCola IN "s:\EpsonFiscalInterface.dll"  Integer numero_cola, String descripcion

Declare Integer EstablecerEncabezado  IN "s:\EpsonFiscalInterface.dll" Integer numero_encabezado, String descripcion 

DECLARE INTEGER ImprimirCierreZ IN "s:\EpsonFiscalInterface.dll"

Declare Integer ConsultarNumeroPuntoDeVenta IN "s:\EpsonFiscalInterface.dll"  String @respuesta, Integer respuesta_largo_maximo

Declare integer ConsultarNumeroComprobanteUltimo IN "s:\EpsonFiscalInterface.dll"  String tipo_de_comprobante,  String @respuesta, Integer respuesta_largo_maximo 


DECLARE INTEGER ObtenerEstadoFiscal IN "s:\EpsonFiscalInterface.dll"
        
DECLARE INTEGER ObtenerEstadoImpresora IN "s:\EpsonFiscalInterface.dll"        

DECLARE INTEGER ConfigurarVelocidad IN "s:\EpsonFiscalInterface.dll" INTEGER velocidad
        
DECLARE INTEGER ConfigurarPuerto IN "s:\EpsonFiscalInterface.dll" STRING puerto


DECLARE INTEGER Conectar IN "s:\EpsonFiscalInterface.dll"

DECLARE INTEGER AbrirComprobante IN "s:\EpsonFiscalInterface.dll" integer tipo_comprobante

Declare Integer CerrarComprobante IN "s:\EpsonFiscalInterface.dll" 


Declare Integer CargarTextoExtra in "s:\epsonfiscalinterface.dll"  String descripcion    

Declare Integer CargarDatosCliente IN "s:\EpsonFiscalInterface.dll"   ;
					String nombre_o_razon_social1,;
					String nombre_o_razon_social2,;
					String domicilio1,;
					String domicilio2,;
					String domicilio3,;
					Integer id_tipo_documento,;
					String numero_documento,;
					Integer id_responsabilidad_iva 
					
Declare Integer ImprimirSubTotal IN "s:\EpsonFiscalInterface.dll" 


Declare Integer ImprimirItem IN "s:\EpsonFiscalInterface.dll"   Integer id_modificador,;
															 	String descripcion,;
															  	String cantidad,;
															   	String precio,;
															    Integer id_tasa_iva,;
															    Integer ii_id,;
															    String ii_valor,;
															    Integer id_codigo,;
															    String codigo,;
															    String codigo_unidad_matrix,;
															    Integer código_unidad_medida 
					



Declare Integer Cancelar in  "s:\epsonfiscalinterface.dll" 

Declare Integer ConsultarSubTotalBrutoComprobanteActual IN "s:\EpsonFiscalInterface.dll" String @respuesta, Integer respuesta_largo_maximo 

Declare Integer ConsultarSubTotalNetoComprobanteActual in "s:\EpsonFiscalInterface.dll" String @respuesta, Integer respuesta_largo_maximo 


Declare Integer CargarAjuste IN "s:\EpsonFiscalInterface.dll"  Integer id_modificador,;
															   String descripcion,;
															   String monto



PROCEDURE get_info_tck
	Private nRespuesta
	
	If !lEpson
	
	
		Return 
	

	EndIf
	
	nRespuesta = 0
  

	  ConfigurarVelocidad (9600)
	  
	  cPuertoEpson = GetValue( "puerto", "ar0eps", "0" )
	  
	  ConfigurarPuerto (cPuertoEpson)     && "0".- USB PORT
  
  
  desconectar()  
  
  nRespuesta = conectar()
  


  If nRespuesta <> 0 
  
  	cError = Str(nRespuesta,10)

	StrToFile(Chr(13) + Dtos(Datetime())+ "   " +Time() + " " + "Conectar "+ cError, "s:\logEpson.txt")
  
  
  
  	S_Alert("NO ES POSIBLE CONECTARSE CON LA IMPRESORA FISCAL")
  	
	S_alert(cerrar)   && fuerzo error
	
	
	
  
  

  EndIf


  		Try


  	
  			comenzarlog()
  			
*  			ConfigurarRetardoAlEnviarComando(900)
  			
  			EstablecerCola(1,"")
			EstablecerCola(2,"")
			EstablecerCola(3,"")
			EstablecerCola(4,"")
			EstablecerCola(5,"")
			EstablecerCola(6,"")
			EstablecerCola(7,"")
			EstablecerCola(8,"")
			EstablecerCola(9,"")
			EstablecerCola(10,"")
			

		
			EstablecerEncabezado(1,"")
			EstablecerEncabezado(2,"")
			EstablecerEncabezado(3,"")
			EstablecerEncabezado(4,"")
			EstablecerEncabezado(5,"")
			EstablecerEncabezado(6,"")
			
			err = ObtenerEstadoFiscal ()
 		    err = ObtenerEstadoImpresora ()
  
		    Cancelar()
			
			
  			

  		Catch To oErr
  		
  		  	cError = "Limpiando Encabezado y leyendas al pie"

			StrToFile(Chr(13) + Dtos(Datetime())+ "   " +Time()+ " " + Str(wnume,8) + cError,"s:\logEpson.txt")
  		
  		
  		
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Remark = lcCommand
			loError.Process( oErr )
			Throw loError

  		Finally

  		EndTry


  			

			
		
			

  
 

Return 


Function GetNumeroEpson
Parameters nComp, cTipo
Private cCodigoComp


*	get_info_tck()


	Do case
		Case nComp = 1
			Do case 
				Case  cTipo = "B"

					cCodigoComp = "082"

				Case  cTipo = "A" && "A"			
				
					cCodigoComp = "081"
					
				Case cTipo = "T" 	
					cCodigoComp = "083"
					
				
			EndCase 
			
			
		Case nComp = 2
		
			Do case 
				Case  cTipo = "B"

					cCodigoComp = "116"

				Case  cTipo = "A" && "A"			
				
					cCodigoComp = "115"
					
				Case cTipo = "T" 	
					cCodigoComp = "116"  && no hay nota de debito tipo "T"
					
				
			EndCase 
		
		
		
		
		Case nComp = 3
			Do case 
				Case  cTipo = "B"

					cCodigoComp = "113"

				Case  cTipo = "A" && "A"			
				
					cCodigoComp = "112"
					
				Case cTipo = "T" 	
					cCodigoComp = "110"
					
				
			EndCase 
		
		
		
		
	EndCase 
						

		
		
			cNumero = Space(8)
			nLenRespuesta = 8
			
			
			
			If ConsultarNumeroComprobanteUltimo(cCodigoComp,@cNumero,nLenRespuesta) <> 0 .and. lEpson

					s_alert("No se puede obtener el ultimo numero de comprobante")
	

					
			EndIf 
			


			
	Return Val(cNumero)    &&  GetNumeroEpson




****************************************
*1 – Tique.
*• 2 – Tique factura A/B/C/M.
*• 3 – Tique nota de crédito, tique nota crédito A/B/C/M.
*• 4 – Tique nota de débito A/B/C/M.
*• 21 – Documento no fiscal homologado genérico.
*• 22 – Documento no fiscal homologado de uso interno.
*El tipo de comprobante que se abrirá (Ver capítulo Tipos de comprobantes) depende –en algunos casos- de la configuración de los datos del cliente previamente cargados. (Ver función CargarDatosCliente).



Function AbrirComprobanteEpson
Parameters nComp, cTipo


Private nCodigoComp
Do  case 
	
	Case nComp = 1   
	
		If WTIPO = "T"
			nCodigoComp = 1
		Else
			nCodigoComp = 2   && "B"
		EndIf
	
		


		
	
	Case nComp = 2
	
		nCodigoComp = 4
	
	
	Case ncomp = 3

		nCodigoComp = 3
	
	
EndCase 	



Return Abrircomprobante(nCodigoComp)