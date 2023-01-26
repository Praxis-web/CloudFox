function IsCompanyNameValid(companyName as string) as Boolean
	local IsValid as Boolean
	IsValid = .t.
	if empty(companyName)
		this.AddBrokenRule("Company name must be entered.")
		IsValid = .f.
	endif
	return IsValid
endfunc



function IsPostalCodeValid(postalCode as string) as Boolean
	local IsValid as Boolean
	IsValid = .t.
	if empty(postalCode)
		this.AddBrokenRule("Postal Code must be entered")
		IsValid = .f.
	endif
	return IsValid
endfunc



function IsPhoneValid(phone as string) as Boolean
	local IsValid as Boolean
	IsValid = .t.
	if empty(phone)
		this.AddBrokenRule("Phone must be entered")
		IsValid = .f.
	endif
	return IsValid
endfunc
