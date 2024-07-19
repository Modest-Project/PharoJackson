Extension { #name : 'FullBlockClosure' }

{ #category : '*Jackson-Core-Writer' }
FullBlockClosure >> jacksonOn: jacksonWriter [

	jacksonWriter writeFullBlockClosure: self
]
