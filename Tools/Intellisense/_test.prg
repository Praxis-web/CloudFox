Local lcCode As String
TEXT To lcCode NoShow
	Lparameter oFoxcode As Object
* 	Wait Nowait Window ( Addbs( Strtran( JustPath(oFoxcode.FileName), Addbs( Set( 'Default' ) ) + Curdir(), '', -1, -1, 1 ) ) + JustFname(oFoxcode.FileName))
	MessageBox( ( Addbs( Strtran( JustPath(oFoxcode.FileName), Addbs( Set( 'Default' ) ) + Curdir(), '', -1, -1, 1 ) ) + JustFname(oFoxcode.FileName)) )
	* Return oFoxcode.UserTyped
ENDTEXT

Delete From (_Foxcode) Where Type = 'U' And ABBREV = '_test'
Insert Into (_Foxcode) (Type, ABBREV, cmd, Data)  Values ('U', '_test', '{}', lcCode )


