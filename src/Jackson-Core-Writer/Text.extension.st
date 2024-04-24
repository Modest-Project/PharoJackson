Extension { #name : #Text }

{ #category : #'*Jackson-Core-Writer' }
Text >> jacksonOn: jacksonWriter [
	"Overwritten to get back the standard object behavior"

	jacksonWriter writeObject: self
]
