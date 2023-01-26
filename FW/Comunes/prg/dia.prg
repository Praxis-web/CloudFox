#INCLUDE "FW\Comunes\Include\Praxis.h"

Lparameters dDate
Dimension aDias[7]
lcDow = Cdow(dDate)
aDias[1] = DOW_01
aDias[2] = DOW_02
aDias[3] = DOW_03
aDias[4] = DOW_04
aDias[5] = DOW_05
aDias[6] = DOW_06
aDias[7] = DOW_07
Return aDias[DOW(dDate)]