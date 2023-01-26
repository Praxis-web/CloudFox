* RA 18/04/2016(10:37:42)
Note: abrir un archivo con sus indices en un area específica

* nSELE  Area donde se abre el archivo
* cFILE  Ruta+Nombre del archivo
* nINDE  Cantidad de Indices del Archivo (Default = 0)
* lEXCL  Exclusivo (Default = .F.)
* cAlias

Para nSELE,cFILE,nINDE,lEXCL,cAlias
Private F001,F002,F003,F004,F005,F006,F007,F008,F009,F010,F011
Private FF05,FF06,FF07,FF08,FF09,FF10,FF11,FF12
Private lVALID

Store Null To F001,F002,F003,F004,F005,F006,F007,F008,F009,F010,F011
Store Null To FF05,FF06,FF07,FF08,FF09,FF10,FF11,FF12
Store Null To lVALID

Local lcCommand As String


nINDE=IfEmpty( nINDE, 0 )
lEXCL=IfEmpty( lEXCL, .F. )
cAlias=IfEmpty( cAlias, Juststem( cFILE ))

lcCommand = ""

If nINDE < 0
	lcCommand = "nINDE = Adir ( laDummy, '" + cFILE + "*.IDX' )"

	&lcCommand
Endif


If Type("nSELE")="C"
	nSELE=Uppe(nSELE)
	nSELE=Asc(nSELE)-Asc("A")+1
Endif

Sele (nSELE)

* Cerrar cualquier archivo que se encuentre abierto en el area seleccionada
Use

lVALID=.F.

If lEXCL
	Use ( cFILE ) Exclusive

Else
	Use ( cFILE ) Shared

Endif

lVALID=.T.

F005=cFILE+'1'
F006=cFILE+'2'
F007=cFILE+'3'
F008=cFILE+'4'
F009=cFILE+'5'
F010=cFILE+'6'
F011=cFILE+'7'
FF05=cFILE+'8'
FF06=cFILE+'9'
FF07=cFILE+'A'
FF08=cFILE+'B'
FF09=cFILE+'C'
FF10=cFILE+'D'
FF11=cFILE+'E'
FF12=cFILE+'F'

Do Case
	Case nINDE=1
		*lcCommand =  [Set Index To '&F005']
		Set Index To '&F005'

	Case nINDE=2
		*lcCommand = [Set Index To '&F005','&F006']
		Set Index To '&F005','&F006'

	Case nINDE=3
		*lcCommand = [Set Index To '&F005','&F006','&F007']
		Set Index To '&F005','&F006','&F007'

	Case nINDE=4
		*lcCommand = [Set Index To '&F005','&F006','&F007','&F008']
		Set Index To '&F005','&F006','&F007','&F008'

	Case nINDE=5
		*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009']
		Set Index To '&F005','&F006','&F007','&F008','&F009'

	Case nINDE=6
		*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010']
		Set Index To '&F005','&F006','&F007','&F008','&F009','&F010'

	Case nINDE=7
		*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011']
		Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011'

	Case nINDE=8
		*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05']
		Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
			'&FF05'

	Case nINDE=9
		*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06']
		Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
			'&FF05','&FF06'

	Case nINDE=10
		*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07']
		Set Index To '&F005','&F006','&F007','&F008,'&F009','&F010','&F011',;
						'&FF05','&FF06','&FF07'

	Case nINDE=11
		*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07','&FF08']
		Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
			'&FF05','&FF06','&FF07','&FF08'

	Case nINDE=12
		*lcCommand = [Set Index To '&F005',&F006,'&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07','&FF08','&FF09']
		Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
			'&FF05','&FF06','&FF07','&FF08','&FF09'

	Case nINDE=13
		*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07','&FF08','&FF09','&FF10']
		Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
			'&FF05','&FF06','&FF07','&FF08','&FF09','&FF10'

	Case nINDE=14
		*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07','&FF08','&FF09','&FF10','&FF11']
		Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
			'&FF05','&FF06','&FF07','&FF08','&FF09','&FF10','&FF11'

	Case nINDE=15
		*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07','&FF08','&FF09','&FF10','&FF11','&FF12']
		Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
			'&FF05','&FF06','&FF07','&FF08','&FF09','&FF10','&FF11','&FF12'
EndCase

Set Order To 

Return 



function IfEmpty
Lparameters  txEvaluate As Variant, txReturnIfEmpty As Variant

Return Iif( IsEmpty( txEvaluate ), txReturnIfEmpty, txEvaluate )


function IsEmpty
Lparameters tuValue

* Al evaluar una variable de tipo objeto, se considera vacia si esta nula
Return Iif( Type( "tuValue" ) == "O", Isnull( tuValue ), Empty( tuValue ) Or Isnull( tuValue ) )

