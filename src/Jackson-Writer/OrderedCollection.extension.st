Extension { #name : 'OrderedCollection' }

{ #category : '*Jackson-Writer' }
OrderedCollection >> jacksonOn: jacksonWriter [
	"Because OrderedCollection is used so often, write it as indexable instead of writing all inst vars.
	However, this disables making a @ref to the inner array."

	self class == OrderedCollection
		ifTrue: [ jacksonWriter writeCollection: self ]
		ifFalse: [ super jacksonOn: jacksonWriter ]
]
