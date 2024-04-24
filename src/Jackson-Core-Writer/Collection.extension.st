Extension { #name : #Collection }

{ #category : #'*Jackson-Core-Writer' }
Collection >> jacksonOn: jacksonWriter [

	jacksonWriter writeObject: self
]
