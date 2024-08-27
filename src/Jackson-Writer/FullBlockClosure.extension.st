Extension { #name : 'FullBlockClosure' }

{ #category : '*Jackson-Writer' }
FullBlockClosure >> jacksonOn: jacksonWriter [

	jacksonWriter writeFullBlockClosure: self
]
