Extension { #name : 'Object' }

{ #category : '*Jackson-Writer' }
Object >> jacksonOn: jacksonWriter [
	"We should be able to handle any subclass of AbstractLayout."

	| instSpec |
	instSpec := self class instSpec. "see comment for details"

	"Encode non-indexable classes with a map of their instance variable and values."
	(instSpec <= 1 or: [ instSpec = 5 ]) ifTrue: [
		^ jacksonWriter writeObject: self ].

	instSpec >= 24 ifTrue: [ ^ jacksonWriter writeCompiledCode: self ].

	(instSpec = 2 or: [ instSpec >= 9 ]) ifTrue: [
		^ jacksonWriter writeIndexable: self ].

	"3 or 4: (weak) indexable object with inst vars"
	^ jacksonWriter writeIndexableObject: self

	"7: immediate, already handled by dispatch, and not possible to make a custom one"
]
