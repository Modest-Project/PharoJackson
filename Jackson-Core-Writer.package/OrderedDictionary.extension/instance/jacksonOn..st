*Jackson-Core-Writer
jacksonOn: jacksonWriter
	"I store my instances as maps. When in JSON mode,
	encode me directly, without a class tag, keeping the order."

	jacksonWriter encodeMap: self