Extension { #name : 'CompiledBlock' }

{ #category : '*Jackson-Writer' }
CompiledBlock >> jacksonOn: jacksonWriter [

	jacksonWriter writeCompiledBlock: self
]
