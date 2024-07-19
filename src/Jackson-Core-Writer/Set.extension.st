Extension { #name : 'Set' }

{ #category : '*Jackson-Core-Writer' }
Set >> jacksonOn: jacksonWriter [
	"Because Set is used so often, write it as collection instead of writing all inst vars.
	However, this disables making a @ref to the inner array."

	self class == Set
		ifTrue: [ jacksonWriter writeCollection: self ]
		ifFalse: [ super jacksonOn: jacksonWriter ]
]
