Extension { #name : 'ByteArray' }

{ #category : '*Jackson-Core-Writer' }
ByteArray >> jacksonOn: jacksonWriter [
	"Use a hex representation"

	jacksonWriter writeString: self hex
]
