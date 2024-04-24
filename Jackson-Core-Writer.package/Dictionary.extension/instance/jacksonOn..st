*Jackson-Core-Writer
jacksonOn: jacksonWriter
	"Instances of STON mapClass will be encoded directly, without a class tag.
	Other (sub)classes will be encoded with a class tag and will use a map representation. "

	self class == STON mapClass
		ifTrue: [
			jacksonWriter writeMap: self ]
		ifFalse: [
			jacksonWriter
				writeObject: self
				do: [ jacksonWriter encodeMap: self ] ]