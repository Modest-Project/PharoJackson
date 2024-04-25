Extension { #name : #Path }

{ #category : #'*Jackson-Core-Writer' }
Path >> jacksonOn: jacksonWriter [

	jacksonWriter writeString: self fullName
]
