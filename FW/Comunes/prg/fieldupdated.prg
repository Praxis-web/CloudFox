Lparameters cExpression, cTableAlias

Local llUpdated As Boolean

Do Case
	Case Isnull( Oldval( cExpression, cTableAlias ) )
		llUpdated = !Isnull( Evaluate( cTableAlias  + [.] + cExpression ) )
		
	Case Isnull( Curval( cExpression, cTableAlias ) )
		llUpdated = !Isnull( Evaluate( cTableAlias  + [.] + cExpression ) )

	Otherwise
		llUpdated = Oldval( cExpression, cTableAlias ) <> Evaluate( cTableAlias  + [.] + cExpression )
	
Endcase

Return llUpdated 
