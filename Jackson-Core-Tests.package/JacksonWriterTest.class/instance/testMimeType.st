tests
testMimeType
	self
		assert: (self serialize: ZnMimeType applicationJson)
		equals: '{"@type":"ZnMimeType","@id":1,"main":"application","sub":"json"}'.
	self
		assert: (self serialize: ZnMimeType textPlain)
		equals: '{"@type":"ZnMimeType","@id":2,"main":"text","sub":"plain","parameters":{"@id":3,"charset":"utf-8"}}'