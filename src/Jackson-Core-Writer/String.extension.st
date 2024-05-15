Extension { #name : 'String' }

{ #category : '*Jackson-Core-Writer' }
String >> jacksonOn: jacksonWriter [
	jacksonWriter writeString: self
]
