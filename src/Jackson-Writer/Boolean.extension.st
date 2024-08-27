Extension { #name : 'Boolean' }

{ #category : '*Jackson-Writer' }
Boolean >> jacksonOn: jacksonWriter [
	jacksonWriter writeBoolean: self
]
