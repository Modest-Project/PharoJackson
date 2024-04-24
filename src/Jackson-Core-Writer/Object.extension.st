Extension { #name : #Object }

{ #category : #'*Jackson-Core-Writer' }
Object >> jacksonOn: jacksonWriter [
	"Encode non-variable classes with a map of their instance variable and values.
	Override to customize and add a matching #fromSton: (see implementors)."

	self class isVariable
		ifTrue: [
			jacksonWriter error: 'custom #jacksonOn: implementation needed for variable/indexable class' ]
		ifFalse: [
			jacksonWriter writeObject: self ]
]
