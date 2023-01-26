#DEFINE THROW_EXCEPTION 		Throw m.loErr
#DEFINE DEBUG_CLASS_EXCEPTION 	Debugout Time(0), Program(), m.loErr.Message, m.loErr.Details, m.loErr.ErrorNo, m.loErr.LineContents, m.loErr.StackLevel, This.Class + '.' + m.loErr.Procedure, This.ClassLibrary, m.loErr.Lineno
#DEFINE DEBUG_EXCEPTION 		Debugout Time(0), Program(), m.loErr.Message, m.loErr.Details, m.loErr.ErrorNo, m.loErr.LineContents, m.loErr.StackLevel, m.loErr.Procedure, m.loErr.Lineno
#DEFINE DEBUG_CLASS			 	Debugout Time(0), Program(), Program( –1 ), This.Class, This.ClassLibrary, LineNo(), LineNo( 1 )
#DEFINE DEBUG_PROGRAM 			Debugout Time(0), Program(), Program( -1 ), LineNo(), LineNo( 1 )
#DEFINE SET_DEFAULT 1
