Extension { #name : #Character }

{ #category : #'*Jackson-Core-Writer' }
Character >> jacksonOn: jacksonWriter [
	jacksonWriter writeObject: self listSingleton: self asString
]
