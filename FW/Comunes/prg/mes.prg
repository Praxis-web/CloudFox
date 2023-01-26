#INCLUDE "FW\Comunes\Include\Praxis.h"

Lparameters dDate
Dimension aMeses[12]
aMeses[01] = MONTH_01
aMeses[02] = MONTH_02
aMeses[03] = MONTH_03
aMeses[04] = MONTH_04
aMeses[05] = MONTH_05
aMeses[06] = MONTH_06
aMeses[07] = MONTH_07
aMeses[08] = MONTH_08
aMeses[09] = MONTH_09
aMeses[10] = MONTH_10
aMeses[11] = MONTH_11
aMeses[12] = MONTH_12
Return aMeses[MONTH(dDate)]