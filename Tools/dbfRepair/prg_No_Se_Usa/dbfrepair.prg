#Define Error_MemoFileIsMissing 		41
#Define Error_TableHasBecomeCorrupted 2091

Local loMain As DbfRepair Of "V:\Clipper2fox\Tools\Dbfrepair\Prg\DbfRepair.prg"
Local lcDbfFileName As String

Local lcCommand As String

Try

	lcCommand = ""

	Close Databases All

	lcDbfFileName = Getfile( "Dbf", "", "", 0, "DBF Repair - Seleccione Archivo Dañado" )

	If !Empty( lcDbfFileName )
		loMain = Newobject( "DbfRepair", "Tools\Dbfrepair\Prg\DbfRepair.prg" )
		loMain.Process( lcDbfFileName )
	Endif


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )


Finally
	Close Databases All
	loMain = Null

Endtry

*!* ///////////////////////////////////////////////////////
*!* Class.........: DbfRepair
*!* ParentClass...: prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....: Custom
*!* Description...: Repara una tabla DBF
*!* Date..........: Viernes 17 de Septiembre de 2010 (15:02:46)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class DbfRepair As Custom

	#If .F.
		Local This As DbfRepair Of "Tools\Dbfrepair\Prg\DbfRepair.prg"
	#Endif

	* Header del archivo
	cDbfHeader = ""

	* Cantidad de registros en la tabla
	nRecords = 0

	* Posicion del primer registro
	nFirstDataRecord = 0

	* Longitud de cada registro
	nRecordLength = 0

	* Longitud de la tabla
	nDBFLength = 0

	* Longitud del archivo Memo (FTP)
	nFTPLength = 0

	* Tarea cumplida
	lDone = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ldone" type="property" display="lDone" />] + ;
		[<memberdata name="nftplength" type="property" display="nFTPLength" />] + ;
		[<memberdata name="process" type="method" display="Process" />] + ;
		[<memberdata name="ndbflength" type="property" display="nDBFLength" />] + ;
		[<memberdata name="ndbflength_access" type="method" display="nDBFLength_Access" />] + ;
		[<memberdata name="nrecordlength" type="property" display="nRecordLength" />] + ;
		[<memberdata name="nfirstdatarecord" type="property" display="nFirstDataRecord" />] + ;
		[<memberdata name="nrecords" type="property" display="nRecords" />] + ;
		[<memberdata name="cdbfheader" type="property" display="cDbfHeader" />] + ;
		[<memberdata name="reparar" type="method" display="Reparar" />] + ;
		[<memberdata name="memofileismissing" type="method" display="MemoFileIsMissing" />] + ;
		[<memberdata name="memofilename" type="method" display="MemoFileName" />] + ;
		[<memberdata name="repararmemofile" type="method" display="RepararMemoFile" />] + ;
		[</VFPData>]

	*
	*
	Procedure Process( tcDbfFileName As String,;
			tlSilence As Boolean ) As Void

		Local lnFH As Integer,;
			lnHeaderLen As Integer,;
			i As Integer,;
			lnFileSize As Integer

		Local lcStr As String
		Local lcReparedFileName As String,;
			lcSaveAs As String,;
			lcCommand As String

		Local llCreateNew As Boolean

		Local oErr As Exception

		Try

			llCreateNew = .F.
			lcCommand 	= ""
			This.lDone 	= .F.
			
			Try

				Try

					Use (tcDbfFileName) Shared In 0

				Catch To oErr
					Do Case
						Case oErr.ErrorNo = 1707 && The structural index file associated with a table file could not be found.
							Use ( tcDbfFileName ) Shared In 0

						Case oErr.ErrorNo = 2091 && Tabla Corrupta

							TEXT To lcErrMsg NoShow TextMerge Pretext 03
							<<oErr.Message>>
							Se intentará repararla a Continuación
							ENDTEXT

							If !tlSilence
								Warning( lcErrMsg, "DbfRepair" )
							Endif

							Throw oErr


						Otherwise
							Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
							loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
							loError.cRemark = lcCommand
							loError.Process ( m.loErr )
							Throw loError


					Endcase

				Finally

				Endtry

				If !tlSilence
					Inform( "El archivo se abrió sin problemas" )
					Browse

					llCreateNew = Confirm( "¿Desea crear un nuevo archivo a partir de una estructura vacía?",, .T. )

				Endif

			Catch To oErr
				* Back Up
				
				lcReparedFileName = Addbs( Justpath( tcDbfFileName ) ) + Juststem( Sys(2015) ) + ".Rep"
				lcSaveAs = Juststem( tcDbfFileName )

				If !tlSilence
					lcSaveAs = Putfile( "", lcSaveAs, "Old" )
				Endif

*!*					Copy File( tcDbfFileName ) To ( lcReparedFileName )
				
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Copy File '<<tcDbfFileName>>' To '<<lcReparedFileName>>'
				ENDTEXT

				&lcCommand

				Try

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Copy File '<<This.MemoFileName( tcDbfFileName )>>' To '<<This.MemoFileName( lcReparedFileName )>>'
					ENDTEXT

					&lcCommand


				Catch To oErr

				Finally

				Endtry

				This.Reparar( lcReparedFileName, oErr.ErrorNo )

				If This.lDone

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Erase '<<lcSaveAs>>'
					ENDTEXT

					&lcCommand

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Erase '<<This.MemoFileName( lcSaveAs )>>'
					ENDTEXT

					&lcCommand

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Rename '<<tcDbfFileName>>' To '<<lcSaveAs>>'
					ENDTEXT

					&lcCommand

					Try

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Rename '<<This.MemoFileName( tcDbfFileName )>>' To  '<<This.MemoFileName( lcSaveAs )>>'
						ENDTEXT

						&lcCommand


					Catch To oErr

					Finally

					Endtry

					Rename ( lcReparedFileName ) To ( tcDbfFileName )

					Try
						TEXT To lcCommand NoShow TextMerge Pretext 15
						Rename '<<This.MemoFileName( lcReparedFileName )>>' To '<<This.MemoFileName( tcDbfFileName )>>'
						ENDTEXT

						&lcCommand

					Catch To oErr

					Finally

					Endtry


					TEXT To lcCommand NoShow TextMerge Pretext 15
					Erase '<<Addbs( Justpath( lcReparedFileName ) ) + Juststem( lcReparedFileName ) + ".Bak">>'
					ENDTEXT

					&lcCommand

					Use (tcDbfFileName) In 0

					If !tlSilence
						Inform( "El archivo ha sido reparado" )
						Browse
					Endif

				Endif

			Finally

			Endtry

			If llCreateNew

				lcSaveAs = Putfile( "", "", "Dbf" )
				If !Empty( lcSaveAs )
					lcReparedFileName = Sys( 2015 )

					CreateFromCursor( lcReparedFileName,;
						JustStem( tcDbfFileName ) )

					AppendFromCursor( Juststem( tcDbfFileName ),;
						JustStem( lcReparedFileName ))

					Use In Select( Juststem( tcDbfFileName ) )
					Select Alias( lcReparedFileName )

					Copy To ( lcSaveAs )

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Use '<<lcSaveAs>>' In 0 Alias <<JustStem( lcSaveAs )>>
					ENDTEXT

					&lcCommand

					Select Alias( Juststem( lcSaveAs ))
					Browse

				Endif

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

	Endproc && Process

	*
	* nDBFLength_Access
	Protected Procedure nDBFLength_Access()

		This.nDBFLength = ( This.nRecords * This.nRecordLength ) + This.nFirstDataRecord + 1

		Return This.nDBFLength

	Endproc && nDBFLength_Access




	*
	* Reparar
	Procedure Reparar( tcReparedFileName As String,;
			tnErrorNo As Integer ) As Void;
			HELPSTRING "Reparar"

		Local lnFH As Integer,;
			lnHeaderLen As Integer,;
			i As Integer,;
			lnFileSize As Integer

		Local lcStr As String,;
		lcAlias as String 

		Local oErr As Exception

		Local lcCommand As String

		Try

			lcCommand = ""
			lcAlias = JustStem( tcReparedFileName )
			
			Use in Select( lcAlias ) 
			
			lnFH = -1

			* Abrir el archivo
			lnFH = Fopen( tcReparedFileName, 2 )

			If lnFH > -1

				* Number of records in file ( bytes 4 - 7 )
				lcStr = ""
				For i = 7 To 4 Step -1
					Fseek( lnFH, i )
					lcStr = lcStr + Padl( int2Hex( Asc( Fread( lnFH, 1 ) ) ), 2, "0" )
				Endfor

				This.nRecords = Hex2Int( lcStr )

				* Position of first data record ( bytes 8 - 9 )
				lcStr = ""
				For i = 9 To 8 Step -1
					Fseek( lnFH, i )
					lcStr = lcStr + Padl( int2Hex( Asc( Fread( lnFH, 1 ) ) ), 2, "0" )
				Endfor

				This.nFirstDataRecord = Hex2Int( lcStr )

				* Length of one data record, including delete flag ( bytes 10 - 11 )
				lcStr = ""
				For i = 11 To 10 Step -1
					Fseek( lnFH, i )
					lcStr = lcStr + Padl( int2Hex( Asc( Fread( lnFH, 1 ) ) ), 2, "0" )
				Endfor

				This.nRecordLength = Hex2Int( lcStr )

				* Header
				Fseek( lnFH, 0 )
				This.cDbfHeader = Fread( lnFH, This.nFirstDataRecord - 1 )

				lnFileSize = Fseek( lnFH, 0, 2 )

				If lnFileSize # This.nDBFLength
					i = Fchsize( lnFH, This.nDBFLength )
					i = Fseek( lnFH, i - 1 )
					Fwrite( lnFH, Chr( Hex2Int( '0x1A' ) ) )
				Endif

				Fclose( lnFH )
				lnFH = -1

				Do Case
					Case tnErrorNo = Error_MemoFileIsMissing
						*This.MemoFileIsMissing( tcReparedFileName )
						This.RepararMemoFile( tcReparedFileName )

					Otherwise

						Try

							Select 0 
							Use ( tcReparedFileName ) 

						Catch To oErr
							Do Case
								Case oErr.ErrorNo = 1707 && The structural index file associated with a table file could not be found.
									Use ( tcReparedFileName ) 
				
								Case oErr.ErrorNo = Error_MemoFileIsMissing
									*This.MemoFileIsMissing( tcReparedFileName )
									This.RepararMemoFile( tcReparedFileName )

								Otherwise
									Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
									loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
									loError.cRemark = lcCommand
									loError.Process ( m.loErr )
									Throw loError


							Endcase

						Finally

						Endtry


				Endcase

				If lnFH # -1
					Fclose( lnFH )
				Endif


				Try

					
					If Used( lcAlias ) 
						Use in Select( lcAlias ) 
					EndIf
					
					Use ( tcReparedFileName ) Shared In 0
					This.lDone = .T.

				Catch To oErr
					This.lDone = .F.
					This.Reparar( tcReparedFileName, oErr.ErrorNo )

				Finally

				Endtry

			Else
				TEXT To lcCommand NoShow TextMerge Pretext 03
				dbfRepair no puede abrir
				'<<tcReparedFileName>>'

				Asegúrese que el mismo no esté
				bloqueado por otro proceso y
				vuelva a intentarlo
				ENDTEXT

				Stop( lcCommand, "dbfRepair" )
				This.lDone = .F.

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			If lnFH # -1
				Fclose( lnFH )
			Endif

*!*				Close Databases All
			Use in Select( lcAlias )

		Endtry

	Endproc && Repair


	*
	* RepararMemoFile

	* Memo files contain one header record and any number of block structures.
	* The header record contains a pointer to the next free block and the size of the block in bytes.
	* The size is determined by the SET BLOCKSIZE command when the file is created.
	* The header record starts at file position zero and occupies 512 bytes.
	* The SET BLOCKSIZE TO 0 command sets the block size width to 1.

	* Following the header record are the blocks that contain a block header and the text of the memo.
	* The table file contains block numbers that are used to reference the memo blocks.
	* The position of the block in the memo file is determined by multiplying the block number
	* by the block size (found in the memo file header record).
	* All memo blocks start at even block boundary addresses.
	* A memo block can occupy more than one consecutive block.

	* Byte offset	Description
	* 00 – 03	Location of next free block1 (Nº de orden del siguiente block)
	* 04 – 05	Unused
	* 06 – 07	Block size (bytes per block)1
	* 08 – 511	Unused
	* 1 Integers stored with the most significant byte first.

	* Para calcular el tamaño del archivo en bytes, multiplicar el Nº de orden del siguiente block por el
	* tamaño del block. (Ya están considerados los 511 bytes del header)

	* Memo Block Header and Memo Text
	* Byte offset	Description
	* 00 – 03	Block signature 1 (indicates the type of data in the block)
	* 0 – picture (picture field type)
	* 1 – text (memo field type)
	* 04 – 07	Length 1 of memo (in bytes)
	* 08 – n	Memo text (n = length)

	Procedure RepararMemoFile( tcReparedFileName As String ) As Void;
			HELPSTRING "RepararMemoFile"

		Local lnFH As Integer,;
			lnBlockSize As Integer,;
			lnNextBlock As Integer,;
			i As Integer,;
			lnCurrentFileSize As Integer,;
			lnFileSize As Integer

		Local lcStr As String,;
			lcMemoFileName As String,;
			lcAlias as String 

		Local oErr As Exception

		Local lcCommand As String

		Try

			lcCommand = ""
			lcAlias = ""


			lnFH = -1

			lcMemoFileName = This.MemoFileName( tcReparedFileName )

			If FileExist( lcMemoFileName )

				* Abrir el archivo
				lnFH = Fopen( lcMemoFileName, 2 )

				* Location of next free block ( bytes 00 - 03 )
				lcStr = ""
				For i = 0 To 3
					Fseek( lnFH, i )
					lcStr = lcStr + Padl( int2Hex( Asc( Fread( lnFH, 1 ) ) ), 2, "0" )
				Endfor

				lnNextBlock = Hex2Int( lcStr )

				* Block size (bytes per block) ( bytes 6 - 7 )
				lcStr = ""
				For i = 6 To 7
					Fseek( lnFH, i )
					lcStr = lcStr + Padl( int2Hex( Asc( Fread( lnFH, 1 ) ) ), 2, "0" )
				Endfor

				lnBlockSize = Hex2Int( lcStr )

				lnFileSize = lnBlockSize * lnNextBlock

				lnCurrentFileSize = Fseek( lnFH, 0, 2 )

				If lnCurrentFileSize # lnFileSize
					i = Fchsize( lnFH, lnFileSize )
				Endif

				Fclose( lnFH )
				lnFH = -1

			Else
				This.MemoFileIsMissing( tcReparedFileName )

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			If lnFH # -1
				Fclose( lnFH )
			EndIf
			
			Use in Select( lcAlias )

*!*				Close Databases All

		Endtry

	Endproc && RepararMemoFile

	*
	*
	Procedure MemoFileIsMissing( tcReparedFileName As String ) As Void

		Local lnFH As Integer,;
			lnEof As Integer,;
			lnHeaderLen As Integer,;
			lnFields As Integer

		Local lcHeader As String,;
			lcData As String,;
			lcByte As String,;
			lcField As String,;
			lcFieldList As String,;
			lcAlias as String 

		Local lcDbfFileName As String,;
			lcReparedFileName As nstr

		Local llDone As Boolean

		Local Array laFields[ 1 ]

		Local lcCommand As String

		Try

			lcCommand = ""
			lcAlias = ""

			lnFH = -1

			lnFH = Fopen( tcReparedFileName, 2 )

			*!*	Byte 0
			*!*	File type: 0x01
			*!*	FoxBASE: 0x02
			*!*	FoxBASE+/Dbase III plus, no memo: 0x2F
			*!*	Visual FoxPro: 0x30
			*!*	Visual FoxPro, autoincrement enabled: 0x31
			*!*	Visual FoxPro, Varchar, Varbinary, or Blob-enabled: 0x42
			*!*	dBASE IV SQL table files, no memo: 0x62
			*!*	dBASE IV SQL system files, no memo: 0x82
			*!*	FoxBASE+/dBASE III PLUS, with memo: 0x8A
			*!*	dBASE IV with memo: 0xCA
			*!*	dBASE IV SQL table files, with memo: 0xF4
			*!*	FoxPro 2.x (or earlier) with memo: 0xFA

			Fseek( lnFH, 0 )
			lcByte = Padl( int2Hex( Asc( Fread( lnFH, 1 ) ) ), 2, "0" )

			Fseek( lnFH, 0 )

			Do Case
				Case lcByte = "83"
					Fwrite( lnFH, Chr( Hex2Int( '0x03' ) ) )

				Otherwise
					Fwrite( lnFH, Chr( Hex2Int( '0x30' ) ) )

			Endcase


			*!*	Byte 28	Table flags:
			*!*	0x01   file has a structural .cdx
			*!*	0x02   file has a Memo field
			*!*	0x04   file is a database (.dbc)
			*!*	This byte can contain the sum of any of the above values.
			*!*	For example, the value 0x03 indicates the table has a structural .cdx and a Memo field.

			Fseek( lnFH, 28 )
			Fwrite( lnFH, Chr( 0 ) )


			llDone = .F.
			lnHeaderLen = This.nFirstDataRecord - 1

			lnFields = 0

			For i = 11 + 32 To lnHeaderLen Step 32

				Fseek( lnFH, i )
				lcByte = Fread( lnFH, 1 )

				If lcByte = "M"
					* Convertir los campos Memo en Character
					Fseek( lnFH, i )
					Fwrite( lnFH, "C" )

					Fseek( lnFH, i - 11 )

					lcField = Strtran( Fread( lnFH, 10 ), Chr(0), Space(0))

					lnFields = lnFields + 1

					Dimension laFields[ lnFields ]

					laFields[ lnFields ] = lcField

				Endif
			Endfor

			Fclose( lnFH )
			lnFH = -1

			Use ( tcReparedFileName ) Exclusive In 0
			lcAlias = JustStem( tcReparedFileName )

			For i = 1 To lnFields

				* Volver a Convertir los campos a Memo

				Try

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Alter Table "<<tcReparedFileName>>" Alter Column <<laFields[ i ]>> M
					ENDTEXT

					&lcCommand

				Catch To oErr
					Do Case
						Case oErr.ErrorNo = 12 && No se encuentra la variable ...

							Try
								TEXT To lcCommand NoShow TextMerge Pretext 15
								Alter Table "<<tcReparedFileName>>" Add Column <<laFields[ i ]>> M
								ENDTEXT

								&lcCommand

							Catch To oErr

							Finally

							Endtry

						Otherwise
							Throw oErr

					Endcase

				Finally

				Endtry


			Endfor

			TEXT To lcCommand NoShow TextMerge Pretext 15
				Update "<<tcReparedFileName>>" Set <<laFields[ 1 ]>> = ""<<Iif( 1 = lnFields, "", "," )>>
			ENDTEXT

			lcFieldList = laFields[ 1 ]

			For i = 2 To lnFields
				TEXT To lcCommand NoShow TextMerge Pretext 15 ADDITIVE
					<<laFields[ i ]>> = ""<<Iif( i = lnFields, "", "," )>>
				ENDTEXT

				TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
					<<laFields[ i ]>><<Iif( i = lnFields, "", "," )>>
				ENDTEXT

			Endfor

			&lcCommand

			TEXT To lcCommand NoShow TextMerge Pretext 03
			La información de los campos MEMO
			no ha podido recuperarse.

			La lista de campos MEMO es la siguiente:
			<<lcFieldList>>
			ENDTEXT

			If !tlSilence
				Warning( lcCommand, "dbfRepair" )
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			If lnFH # -1
				Fclose( lnFH )
			EndIf
			
			Use in Select( lcAlias ) 
*!*				Close Databases All


		Endtry

	Endproc && MemoFileIsMissing


	*
	* devuelve el nombre de un archivo Memo
	Procedure MemoFileName( tcDBFFile As String ) As Void;
			HELPSTRING "devuelve el nombre de un archivo Memo"

		Local lcMemoFileName As String


		Local lcCommand As String

		Try

			lcCommand = ""

			lcMemoFileName = Addbs( Justpath( tcDBFFile ) ) + Juststem( tcDBFFile ) + ".FPT"
			If !Inlist( Upper( Justext( tcDBFFile )), "DBF", "REP" )
				lcMemoFileName = lcMemoFileName + Justext( tcDBFFile )
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return lcMemoFileName

	Endproc && MemoFileName



Enddefine
*!*
*!* END DEFINE
*!* Class.........: DbfRepair
*!*
*!* ///////////////////////////////////////////////////////
