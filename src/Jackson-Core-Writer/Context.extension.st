Extension { #name : 'Context' }

{ #category : '*Jackson-Core-Writer' }
Context >> jacksonOn: jacksonWriter [

	jacksonWriter writeObject: self
]
