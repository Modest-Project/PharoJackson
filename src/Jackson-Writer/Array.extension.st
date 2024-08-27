Extension { #name : 'Array' }

{ #category : '*Jackson-Writer' }
Array >> jacksonOn: jacksonWriter [

	self class == Array
		ifTrue: [ jacksonWriter writeList: self ]
		ifFalse: [ super jacksonOn: jacksonWriter ]
]
