Extension { #name : #CleanBlockClosure }

{ #category : #'*Jackson-Core-Writer' }
CleanBlockClosure >> jacksonOn: jacksonWriter [
	"Ignore literal and outerContext."

	jacksonWriter writeObject: self streamMap: [ :map |
		map at: 'compiledBlock' put: compiledBlock.
		map at: 'numArgs' put: numArgs ]
]
