Lparameters 					  ;
	tcTopic 			As String,;
	tcDescripcion 		As String,;
	tcParameters 		As String,;
	tcReturns 			As String,;
	tcExceptions 		As String,;
	tcSeeAlso 			As String,;
	tcRemarks 			As String,;
	tcSyntax 			As String,;
	tcExample 			As String,;
	tcKeywords 			As String,;
	tcEvents 			As String,;
	tcImplements 		As String,;
	tcInherits 			As String,;
	tcNameSpace 		As String

#Define CR Chr(13)
#Define TAB Chr(9)

Local lcMenor 	As String
Local lcMayor 	As String
Local lcText 	As String
Local lcSpaces  as String 

lcSpaces = TAB + TAB + TAB 

*tcDescripcion 	= IfEmpty( tcDescripcion, '' )

tcDescripcion 	= Iif( Empty( tcDescripcion), '', CR + lcSpaces + tcDescripcion )
tcSyntax 		= Iif( Empty( tcSyntax )	, '', CR + lcSpaces + tcSyntax )
tcExample 		= Iif( Empty( tcExample )	, '', CR + lcSpaces + tcExample )
tcKeywords 		= Iif( Empty( tcKeywords )	, '', CR + lcSpaces + tcKeywords )
tcImplements 	= Iif( Empty( tcImplements ), '', CR + lcSpaces + tcImplements )
tcInherits 		= Iif( Empty( tcInherits )	, '', CR + lcSpaces + tcInherits )
tcNameSpace 	= Iif( Empty( tcNameSpace )	, CR + lcSpaces + 'praxis.com', CR + lcSpaces + tcNameSpace )
tcParameters 	= Iif( Empty( tcParameters ), '', CR + lcSpaces + tcParameters )
tcRemarks 		= Iif( Empty( tcRemarks )	, '', CR + lcSpaces + tcRemarks )
tcReturns 		= Iif( Empty( tcReturns )	, '', CR + lcSpaces + tcReturns )
tcExceptions 	= Iif( Empty( tcExceptions ), '', CR + lcSpaces + tcExceptions )
tcSeeAlso 		= Iif( Empty( tcSeeAlso )	, '', CR + lcSpaces + tcSeeAlso )
tcTopic 		= Iif( Empty( tcTopic )		, '', CR + lcSpaces + tcTopic )
tcEvents 		= Iif( Empty( tcEvents )	, '', CR + lcSpaces + tcEvents )

*!*	        <<lcMenor>>h3 class="outdent"<<lcMayor>>Autor<<lcMenor>>/h3<<lcMayor>><<_USER>>
*!*	        <<lcMenor>>h3 class="outdent"<<lcMayor>>Project<<lcMenor>>/h3<<lcMayor>><<_PROJECTENV>>
*!*	        <<lcMenor>>h3 class="outdent"<<lcMayor>>Date<<lcMenor>>/h3<<lcMayor>><<DateMask(date())>> (<<time()>>)

tcParameters 	= Chrtran( tcParameters, ",", "" )
tcParameters 	= Chrtran( tcParameters, ";", "" )

lcText 	= ''
lcMenor = Chr( 60 ) + Chr( 60 )
lcMayor = Chr( 62 ) + Chr( 62 )
lcText 	= lcText + '#If .F.' + Chr( 13 ) + Space( 4 ) + 'Text' + Chr( 13 )

TEXT To lcText TextMerge NoShow Additive
<<lcSpaces>>*:Help Documentation
<<lcSpaces>>*:Topic:<<tcTopic>>
<<lcSpaces>>*:Description:<<tcDescripcion>>
<<lcSpaces>>*:Project:<<CR + lcSpaces + _PROJECTENV>>
<<lcSpaces>>*:Autor:<<CR + lcSpaces + _USER>>
<<lcSpaces>>*:Date:<<CR + lcSpaces + DateMask(date())>> (<<time()>>)
<<lcSpaces>>*:ModiSummary:
<<lcSpaces>>*:Syntax:<<tcSyntax>>
<<lcSpaces>>*:Example:<<tcExample>>
<<lcSpaces>>*:Events:<<tcEvents>>
<<lcSpaces>>*:NameSpace:<<tcNameSpace>>
<<lcSpaces>>*:Keywords:<<tcKeywords>>
<<lcSpaces>>*:Implements:<<tcImplements>>
<<lcSpaces>>*:Inherits:<<tcInherits>>
<<lcSpaces>>*:Parameters:<<tcParameters>>
<<lcSpaces>>*:Remarks:<<tcRemarks>>
<<lcSpaces>>*:Returns:<<tcReturns>>
<<lcSpaces>>*:Exceptions:<<tcExceptions>>
<<lcSpaces>>*:SeeAlso:<<tcSeeAlso>>
<<lcSpaces>>*:EndHelp
ENDTEXT

lcText = lcText + Chr( 13 ) + Space( 4 ) + 'EndText' + Chr( 13 ) + '#Endif'

Return lcText
