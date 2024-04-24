Extension { #name : #Bitmap }

{ #category : #'*Jackson-Core-Writer' }
Bitmap >> jacksonOn: jacksonWriter [

	jacksonWriter nextPut: self asByteArray
]
