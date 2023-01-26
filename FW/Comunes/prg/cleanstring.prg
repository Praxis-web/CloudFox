* Le saca a un string los caracteres no imprimibles

Lparameters  tcStr As String

Local lcStr As String

lcStr = Strtran(tcStr, Chr(13), Space(1))
lcStr = Strtran(lcStr, Chr(10), Space(0))
lcStr = Strtran(lcStr, Chr(09), Space(1))
*!*	lcStr = Strtran(lcStr, Space(2), Space(1))

Return lcStr
