Extension { #name : 'Number' }

{ #category : '*Jackson-Core-Writer' }
Number >> jacksonOn: jacksonWriter [
	jacksonWriter writeFloat: self asFloat
]
