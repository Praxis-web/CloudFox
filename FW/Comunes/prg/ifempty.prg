* Parametros....: Value to evaluate, Value to return if empty
* Returns the first parameter as is, or the second one if first is empty

Lparameters  txEvaluate As Variant, txReturnIfEmpty As Variant

Return Iif( IsEmpty( txEvaluate ), txReturnIfEmpty, txEvaluate )
