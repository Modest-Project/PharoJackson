Extension { #name : 'Set' }

{ #category : '*Jackson-Core-Writer' }
Set >> jacksonOn: jacksonWriter [

	jacksonWriter writeCollection: self
]
