*Jackson-Core-Writer
jacksonOn: jacksonWriter
	"I store my instances as maps"

	jacksonWriter
		writeObject: self
		do: [ jacksonWriter encodeMap: self ]