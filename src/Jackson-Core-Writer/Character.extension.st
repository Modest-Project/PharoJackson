Extension { #name : #Character }

{ #category : #'*Jackson-Core-Writer' }
Character >> jacksonOn: jacksonWriter [
	jacksonWriter writeCharacter: self
]
