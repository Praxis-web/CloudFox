*	CheckType verifica que el tipo del dato contenido en tuValue se 
* encuentre en la lista tcTypelist. Devuelve un valor L�gico

Lparameters tuValue,tcTypeList
Local lcType
lcType = Vartype(tuValue)
Return lcType$Uppe(tcTypeList)
