Extension { #name : #Interval }

{ #category : #'*Jackson-Core-Writer' }
Interval >> jacksonOn: jacksonWriter [
	"Overwritten to get back the standard object behavior"

	jacksonWriter writeObject: self
]
