Extension { #name : 'FullBlockClosure' }

{ #category : '*Jackson-Core-Writer' }
FullBlockClosure >> jacksonOn: jacksonWriter [
	"Ignore outerContext."

	jacksonWriter writeObject: self streamMap: [ :map |
		map at: 'compiledBlock' put: compiledBlock.
		map at: 'numArgs' put: numArgs.
		receiver ifNotNil: [
			compiledBlock readsSelf ifTrue: [ map at: 'receiver' put: receiver ] ] ]
]
