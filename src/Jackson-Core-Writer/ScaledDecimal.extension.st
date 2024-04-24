Extension { #name : #ScaledDecimal }

{ #category : #'*Jackson-Core-Writer' }
ScaledDecimal >> jacksonOn: jacksonWriter [
	jacksonWriter writeScaledDecimal: self
]
