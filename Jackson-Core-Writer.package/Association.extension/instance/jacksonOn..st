*Jackson-Core-Writer
jacksonOn: jacksonWriter
	self class == STON associationClass
		ifTrue: [ jacksonWriter writeAssociation: self ]
		ifFalse: [ super jacksonOn: jacksonWriter ]