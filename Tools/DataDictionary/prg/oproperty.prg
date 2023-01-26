#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'ErrorHandler\Prg\ErrorHandler.prg'
    Do 'Tools\DataDictionary\prg\oBase.prg'

Endif

* oProperty
* Colección de indices.
Define Class oProperty As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

    #If .F.
        Local This As oProperty Of 'Tools\DataDictionary\prg\oProperty.prg'
    #Endif

    #If .F.
        TEXT
		 *:Help Documentation
		 *:Description:
		 Colección de Indices
		 *:Project:
		 Sistemas Praxis
		 *:Autor:
		 Damian Eiff
		 *:Date:
		 Martes 10 de Febrero de 2009 (11:00:34)
		 *:Parameters:
		 *:Remarks:
		 *:Returns:
		 *:Example:
		 *:SeeAlso:
		 *:Events:
		 *:KeyWords:
		 *:Inherits:
		 *:Exceptions:
		 *:NameSpace:
		 digitalizarte.com
		 *:EndHelp
        ENDTEXT
    #Endif

    cComment = ''

    * Valor de la propiedad
    Value = ''

    *
    nTierLevel = 1

    * Indica si hay que agregar comillas al valor de la propedad
    lAddQuotes = .F.

    * Indica si la propiedad se agrega como un comentario ( plantilla para el desarrollador)
    lAddComment = .F.

    * Agrega un retorno de carro al final de la definición de la propiedad @see ToString
    lCarriageReturn = .T.

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="value" type="property" display="Value" />] ;
        + [<memberdata name="ntierlevel" type="property" display="nTierLevel" />] ;
        + [<memberdata name="laddquotes" type="property" display="lAddQuotes" />] ;
        + [<memberdata name="laddcomment" type="property" display="lAddComment" />] ;
        + [<memberdata name="tostring" type="method" display="ToString" />] ;
        + [<memberdata name="lcarriagereturn" type="property" display="lCarriageReturn" />] ;
        + [</VFPData>]

    * ToString
    * Genera el codigo de la propiedad
    Function ToString() As String HelpString 'Genera el codigo de la propiedad'

        Local lcReturnValue As String, ;
            loErr As Exception, ;
            loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

        #If .F.
            TEXT
				 *:Help Documentation
				 *:Description:
				 Genera el codigo de la propiedad
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damian Eiff
				 *:Date:
				 Viernes 13 de Marzo de 2009 (15:41:31)
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
            ENDTEXT
        #Endif

        Try

            lcReturnValue = ''

            If ! Empty ( This.cComment )
                lcReturnValue = m.lcReturnValue + '* ' + Alltrim ( This.cComment ) + CR

            Endif && ! Empty( .cComment )

            If This.lAddComment
                lcReturnValue = m.lcReturnValue + '* '

            Endif && this.lAddComment

            lcReturnValue = m.lcReturnValue + Alltrim ( This.Name ) + ' = '
            If This.lAddQuotes
                lcReturnValue = m.lcReturnValue + '"'

            Endif && this.lAddQuotes

            lcReturnValue = m.lcReturnValue + Alltrim ( This.Value )

            If This.lAddQuotes
                lcReturnValue = m.lcReturnValue + '"'

            Endif &&  .lAddQuotes

            If This.lCarriageReturn
                lcReturnValue = m.lcReturnValue + CR

            Endif && this.lCarriageReturn

        Catch To loErr
            DEBUG_CLASS_EXCEPTION
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            m.loError.Process ( m.loErr )
            THROW_EXCEPTION

        Finally
            loError = Null

        Endtry

        Return m.lcReturnValue

    Endfunc && ToString

Enddefine && oProperty