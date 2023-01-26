proc Clone()
	local laProps[ 1 ] As string
    local loDest As Object
    local i As Number
    loDest = NEWOBJECT( This.Class, This.ClassLibrary )
	FOR i = 1 TO AMEMBERS( laProps, loDest, 0 )
        loDest.&laProps[ i ]. = this.&laProps[ i ]
	ENDFOR
	RETURN loDest
ENDPROC && Clone