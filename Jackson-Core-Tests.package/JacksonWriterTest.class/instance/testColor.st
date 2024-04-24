tests
testColor
	self
		assert: (self serialize: Color red)
		equals: '{"@type":"Color","@id":1,"rgb":1072693248,"cachedDepth":32,"cachedBitPattern":"ffff0000","alpha":255}'.
	self
		assert: (self serialize: (Color red copy setAlpha: 0.4))
		equals: '{"@type":"Color","@id":2,"rgb":1072693248,"cachedDepth":32,"cachedBitPattern":"ffff0000","alpha":102}'.
	self
		assert: (self serialize: Color red lighter lighter)
		equals: '{"@type":"Color","@id":3,"rgb":1072756798,"alpha":255}'