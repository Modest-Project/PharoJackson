Extension { #name : #SmallDictionary }

{ #category : #'*Jackson-Core-Writer' }
SmallDictionary >> jacksonOn: jacksonWriter [
	"I store my instances as maps"

	jacksonWriter
		writeObject: self
		do: [ jacksonWriter encodeMap: self ]
]
