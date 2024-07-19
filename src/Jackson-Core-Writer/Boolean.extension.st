Extension { #name : 'Boolean' }

{ #category : '*Jackson-Core-Writer' }
Boolean >> jacksonOn: jacksonWriter [
	jacksonWriter writeBoolean: self
]
