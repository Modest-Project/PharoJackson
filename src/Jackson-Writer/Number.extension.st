Extension { #name : 'Number' }

{ #category : '*Jackson-Writer' }
Number >> jacksonOn: jacksonWriter [
	jacksonWriter writeFloat: self asFloat
]
