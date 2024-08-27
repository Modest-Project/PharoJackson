Extension { #name : 'FileReference' }

{ #category : '*Jackson-Writer' }
FileReference >> jacksonOn: jacksonWriter [

	self fileSystem isDiskFileSystem
		ifTrue: [ "ignore fileSystem"
			jacksonWriter
				writeObject: self
				do: [ "in order to get $/ as delimiter and $. as working directory on all platforms"
					jacksonWriter encodeKey: 'path' value: (path isWorkingDirectory
							 ifTrue: [ '.' ]
							 ifFalse: [ path pathString ]) ] ]
		ifFalse: [ jacksonWriter writeObject: self ]
]
