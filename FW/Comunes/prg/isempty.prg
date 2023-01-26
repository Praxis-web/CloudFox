Lparameters tuValue

* Al evaluar una variable de tipo objeto, se considera vacia si esta nula
Return Iif( Vartype( tuValue ) == "O", Isnull( tuValue ), Empty( tuValue ) Or Isnull( tuValue ) )


