Extension { #name : 'Array' }

{ #category : '*Jackson-Core-Writer' }
Array >> jacksonOn: jacksonWriter [

	self class == Array
		ifTrue: [ jacksonWriter writeList: self ]
		ifFalse: [ super jacksonOn: jacksonWriter ]
]
