Procedure TestingBench( nType As Integer,;
		cMessage As String,;
		cProgram As String,;
		nLineNo As Integer )

	Local lnTotalTime As Number,;
		lnSeconds As Number

	Local lnElapsedTime As Number,;
		lnTimeStop As Number,;
		lnStart As Number


	Local lcShowMessage As String,;
	lcLogFile as String 

	lnSeconds = Seconds()

	Do Case
		Case nType = 1 && Total (desde el último Start)
			gnElapsedTime 	= lnSeconds - gnTimeStop
			gnTimeStop 		= lnSeconds
			lnTotalTime 	= gnTimeStop - gnStart
			lcLogFile		= gcLogFile

			lnElapsedTime 	= gnElapsedTime
			lnTimeStop 		= gnTimeStop
			lnStart 		= gnStart

		Case nType = 2 && Start
			Release gnTimeStop,;
				gnElapsedTime,;
				gnStart

			Public gnTimeStop As Number, gnElapsedTime As Number, gnStart As Number
			Public gcLogFile as String 
			
			gnStart 		= lnSeconds
			gnTimeStop 		= gnStart
			gnElapsedTime 	= 0

		
			TEXT TO gcLogFile NOSHOW TEXTMERGE
			TestingBench <<Iif( Empty( Version(2) ), "Runtime", "Develop" )>> <<Dtos(Date())+Time()>>.txt
			EndText
			
			gcLogFile = Strtran( gcLogFile, ":", "" )



			lnElapsedTime 	= gnElapsedTime
			lnTimeStop 		= gnTimeStop
			lnStart 		= gnStart
			lnTotalTime 	= 0
			lcLogFile		= gcLogFile


		Otherwise && Release All
			lnElapsedTime 	= lnSeconds - gnTimeStop
			lnTimeStop 		= lnSeconds
			lnTotalTime 	= lnTimeStop - gnStart
			lcLogFile		= gcLogFile

			Release gnTimeStop,;
				gnElapsedTime,;
				gnStart,;
				gcLogFile

			cMessage 	= "Release"
			cProgram 	= ""
			nLineNo 	= 0
			

	Endcase

	TEXT TO lcShowMessage NOSHOW TEXTMERGE pretext 03
	<<cMessage>>

	Program: <<cProgram>>
	Line: <<nLineNo>>

	Tiempo Parcial: <<lnElapsedTime>>
	Tiempo Total: <<lnTotalTime>>
	--------------------------------------------------------------


	ENDTEXT

	Strtofile( lcShowMessage, lcLogFile, 1 )

	Return
Endproc

