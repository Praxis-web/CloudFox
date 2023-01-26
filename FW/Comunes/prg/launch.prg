
Lparameters  tcTarget As String , tcParameters As String

Local lcExtension, lcParameters, lcCommandLine
lcExtension = Lower( Justext( tcTarget ) )
If Empty( lcExtension )

	lcExtension = "scx"
	tcTarget = Alltrim( tcTarget ) +"."+ lcExtension
Endif

If Empty( tcParameters )
	lcParameters = ""
Else
	lcParameters = "with "+ tcParameters
Endif

Do Case
	Case lcExtension = "prg"

		lcCommandLine = "DO ( tcTarget ) " + lcParameters

	Otherwise

		lcCommandLine = "DO form ( tcTarget ) " + lcParameters
Endcase


&lcCommandLine

