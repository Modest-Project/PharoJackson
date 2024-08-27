Extension { #name : 'UndefinedObject' }

{ #category : '*Jackson-Writer' }
UndefinedObject >> jacksonOn: jacksonWriter [
	jacksonWriter writeNull
]
