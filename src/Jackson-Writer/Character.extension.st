Extension { #name : 'Character' }

{ #category : '*Jackson-Writer' }
Character >> jacksonOn: jacksonWriter [
	jacksonWriter writeCharacter: self
]
