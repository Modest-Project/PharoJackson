Extension { #name : 'UndefinedObject' }

{ #category : '*Jackson-Core-Writer' }
UndefinedObject >> jacksonOn: jacksonWriter [
	jacksonWriter writeNull
]
