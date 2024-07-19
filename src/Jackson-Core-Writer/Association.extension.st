Extension { #name : 'Association' }

{ #category : '*Jackson-Core-Writer' }
Association >> jacksonOn: jacksonWriter [
	"Shortcut to write an association quickly."

	self class == Association
		ifTrue: [ jacksonWriter writeAssociation: self ]
		ifFalse: [ super jacksonOn: jacksonWriter ]
]
