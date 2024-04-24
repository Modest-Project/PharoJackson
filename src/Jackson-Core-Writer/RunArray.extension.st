Extension { #name : #RunArray }

{ #category : #'*Jackson-Core-Writer' }
RunArray >> jacksonOn: jacksonWriter [
	"Overwritten to get back the standard object behavior"

	jacksonWriter writeObject: self
]
