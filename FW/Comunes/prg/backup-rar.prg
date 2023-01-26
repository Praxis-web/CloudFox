Lparameters tcDir As String, tcDirToBck As String, tcBckName As String, tlBckAutoInc As Logical, tcPass As String

Declare Integer ShellExecute In shell32.Dll ;
    INTEGER hndWin, ;
    STRING cAction, ;
    STRING cFileName, ;
    STRING cParams, ;
    STRING cDir, ;
    INTEGER nShowWin

Local lnRet As Number,;
    lcDir As String, ;
    lcBckDir As String, ;
    lcCommands As String, ;
    lcNewDir As String

lnRet = 0
*
If Vartype(tcDir) = 'C' And !Empty(tcDir) And ! Isblank(tcDir) And Directory(tcDir)
    lcDir = tcDir
Else
    lcDir = Addbs(Justpath(Sys(16)))
Endif

If Vartype(tcDirToBck) = 'C' And !Empty(tcDirToBck) And ! Isblank(tcDirToBck) And Directory(tcDirToBck)
    lcDirToBck = tcDirToBck
Else
    If Vartype(tcDirToBck) = 'C' And !Empty(tcDirToBck) And ! Isblank(tcDirToBck) And Directory(Addbs(lcDir) + tcDirToBck)
        lcDirToBck = tcDirToBck
    Else
        lcDirToBck = Addbs(Justpath(Sys(16)))
    Endif
Endif

lcBckName = 'backup'

If Vartype(tcBckName) = 'C' And !Empty(tcBckName) And ! Isblank(tcBckName)
    lcBckName = tcBckName
Endif

llBckAutoInc = .F.
If Vartype(tlBckAutoInc) = 'L'
    llBckAutoInc = tlBckAutoInc
Endif

lcCommands = ' a -w' + lcDir + 'tmp -k -t -tk -r -s -md4096 -rr3%% -rv3%%  -v8192k -y -m5 '

If Vartype(tcPass) = 'C' And ! Empty(tcPass) And ! Isblank(tcPass)
    lcCommands = lcCommands + ' -p' + tcPass
Endif

If llBckAutoInc
    lcCommands = lcCommands + ' -ag+YYYYMMDD-NN '
Endif
lcCommands = lcCommands + ' Backup\' + lcBckName + ' ' + lcDirToBck

lcCommands = Strtran(lcCommands, Space(2), Space(1))

If ! Directory(lcDir + 'Backup')
    lcNewDir = '"' + lcDir + 'Backup' + '"'
    Mkdir &lcNewDir
Endif

If ! Directory(lcDir + 'tmp')
    lcNewDir = '"' + lcDir + 'tmp' + '"'
    Mkdir &lcNewDir
Endif

Wait 'Se va a realizar el backup de la base de datos' Window Nowait
lcDir = '"' + lcDir + '"'
Cd &lcDir

lnRet = ShellExecute(0, 'Open', 'rar.exe', lcCommands, &lcDir, 0)
lcmsg = ''
Do Case
    Case lnRet = 255 && USER BREAK       User stopped the process
    Case lnRet = 9   && CREATE ERROR     Create file error
    Case lnRet = 8   && MEMORY ERROR     Not enough memory for operation
    Case lnRet = 7   && USER ERROR       Command line option error
    Case lnRet = 6   && OPEN ERROR       Open file error
    Case lnRet = 5   && WRITE ERROR      Write to disk error
        lcmsg = 'Ocurrio un error durante el proceso de backup' + Chr(13) ;
            + 'Error de escritura en el disco' + Chr(13) ;
            + 'Comuniquese con el administrador del sistema'
    Case lnRet = 4   && LOCKED ARCHIVE   Attempt to modify an archive previously locked by the 'k' command
        lcmsg = 'Ocurrio un error durante el proceso de backup' + Chr(13) ;
            + 'Error: Intento modificar un archivo bloqueado' + Chr(13) ;
            + 'Comuniquese con el administrador del sistema'
    Case lnRet = 3   && CRC ERROR        A CRC error occurred when unpacking
        lcmsg = 'Ocurrio un error durante el proceso de backup' + Chr(13) ;
            + 'Error en la comprobación CRC' + Chr(13) ;
            + 'Comuniquese con el administrador del sistema'
    Case lnRet = 2   && FATAL ERROR      A fatal error occurred
        lcmsg = 'Ocurrio un error durante el proceso de backup' + Chr(13) ;
            + 'Error fatal, no se pudo terminar el proceso de backup' + Chr(13) ;
            + 'Comuniquese con el administrador del sistema'
    Case lnRet = 1   && WARNING          Non fatal error(s) occurred
        lcmsg = 'Ocurrio un error durante el proceso de backup' + Chr(13) ;
            + 'Error no fatal' + Chr(13) ;
            + 'Comuniquese con el administrador del sistema'
    Case lnRet = 0   && SUCCESS          Successful operation
        lcmsg = 'Finalizo el proceso de backup correctamente'
Endcase

lcCmdExp = ''
lcFilecmdBck = Addbs(Justpath(Sys(16))) + 'backup.cmd'

ldFecha = Date() -1
IF DIRECTORY('s:\')
lcCmdExp = lcCmdExp + '@NET USE \\purgatorio\download\Backup S:\' + Chr(13) + Chr(10)
ENDIF 
* lcCmdExp = lcCmdExp + 'xcopy ' + Lower(Addbs(lcDirToBck)) + 'backup\*.* S:\ /v /i /y /c /D:' + Transform(Month(ldFecha), '@L 99') + '-' + Transform(Day(ldFecha), '@L 99') + '-' + Transform(Year(ldFecha), '@L 9999') + Chr(13) + Chr(10)
lcCmdExp = lcCmdExp + '@xcopy ' + '.\backup\ S:\ /v /i /y /c /D:' + Transform(Month(ldFecha), '@L 99') + '-' + Transform(Day(ldFecha), '@L 99') + '-' + Transform(Year(ldFecha), '@L 9999') + Chr(13) + Chr(10)
* lcCmdExp = lcCmdExp + '@NET Use \\purgatorio\download\Backup /Delete ' + Chr(13) + Chr(10)

= Strtofile(lcCmdExp ,lcFilecmdBck, 0)
lnRet = ShellExecute(0, 'Open', lcFilecmdBck, '', &lcDir, 0)

If ! Empty(lcmsg)
    Messagebox( lcmsg, 64, _vfp.Caption )
Endif

Clear Dlls ShellExecute
