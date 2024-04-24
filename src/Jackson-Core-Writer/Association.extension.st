Extension { #name : #Association }

{ #category : #'*Jackson-Core-Writer' }
Association >> jacksonOn: jacksonWriter [
	self class == STON associationClass
		ifTrue: [ jacksonWriter writeAssociation: self ]
		ifFalse: [ super jacksonOn: jacksonWriter ]
]
