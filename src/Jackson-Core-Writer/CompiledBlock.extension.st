Extension { #name : #CompiledBlock }

{ #category : #'*Jackson-Core-Writer' }
CompiledBlock >> jacksonOn: jacksonWriter [

	jacksonWriter writeCompiledBlock: self
]
