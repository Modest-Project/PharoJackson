Extension { #name : 'String' }

{ #category : '*Jackson-Writer' }
String >> jacksonOn: jacksonWriter [
	jacksonWriter writeString: self
]
