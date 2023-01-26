Local lcPopUp as String

lcPopUp = Sys(2015)

DEFINE Pad (lcPopUp) OF _MSYSMENU PROMPT "\<Editar" COLOR SCHEME 3 ;
	KEY ALT+E, "ALT+E" ;
	MESSAGE "Edita el texto o la selección actual"

ON PAD (lcPopUp) OF _MSYSMENU ACTIVATE POPUP _medit


DEFINE POPUP _medit MARGIN RELATIVE SHADOW COLOR SCHEME 4

DEFINE BAR _med_undo OF _medit PROMPT "\<Deshacer" ;
	KEY CTRL+Z, "Ctrl+Z" ;
	PICTRES _med_undo ;
	MESSAGE "Deshace el último comando o acción"
DEFINE BAR _med_redo OF _medit PROMPT "\<Repetir" ;
	KEY CTRL+R, "Ctrl+R" ;
	PICTRES _med_redo ;
	MESSAGE "Repite el último comando o acción"
DEFINE BAR _med_sp100 OF _medit PROMPT "\-" ;
	PICTRES _med_sp100
DEFINE BAR _med_cut OF _medit PROMPT "\<Cortar" ;
	KEY CTRL+X, "Ctrl+X" ;
	PICTRES _med_cut ;
	MESSAGE "Remueve la selección y la guarda en el Portapapeles"
DEFINE BAR _med_copy OF _medit PROMPT "\<Copiar" ;
	KEY CTRL+C, "Ctrl+C" ;
	PICTRES _med_copy ;
	MESSAGE "Copia la selección y la guarda en el Portapapeles"
DEFINE BAR _med_paste OF _medit PROMPT "\<Pegar" ;
	KEY CTRL+V, "Ctrl+V" ;
	PICTRES _med_paste ;
	MESSAGE "Pega el contenido del Portapapeles"
DEFINE BAR _med_sp200 OF _medit PROMPT "\-" ;
	PICTRES _med_sp200
DEFINE BAR _med_slcta OF _medit PROMPT "Se\<leccionar Todo" ;
	KEY CTRL+A, "Ctrl+A" ;
	PICTRES _med_slcta ;
	MESSAGE "Selecciona todo el texto o items en la ventana actual"
DEFINE BAR _med_sp300 OF _medit PROMPT "\-" ;
	PICTRES _med_sp300
DEFINE BAR _med_find OF _medit PROMPT "\<Buscar..." ;
	KEY CTRL+F, "Ctrl+F" ;
	PICTRES _med_find ;
	MESSAGE "Busca un texto específico"
DEFINE BAR _med_repl OF _medit PROMPT "R\<eemplazar..." ;
	KEY CTRL+L, "Ctrl+L" ;
	PICTRES _med_repl ;
	MESSAGE "Reemplaza un texto específico con un texto diferente"



