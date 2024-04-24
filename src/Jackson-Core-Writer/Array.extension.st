Extension { #name : #Array }

{ #category : #'*Jackson-Core-Writer' }
Array >> jacksonOn: jacksonWriter [

	jacksonWriter writeList: self
]
