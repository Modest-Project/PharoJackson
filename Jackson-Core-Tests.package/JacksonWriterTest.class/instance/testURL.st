tests
testURL
	self
		assert: (self serialize: 'https://pharo.org/files/pharo.png' asUrl)
		equals: '{"@type":"ZnUrl","@id":1,"scheme":"https","host":"pharo.org","segments":{"@type":"OrderedCollection","@id":2,"array":["files","pharo.png",null,null,null,null,null,null,null,null],"firstIndex":1,"lastIndex":2}}'.
	self
		assert: (self serialize: 'mailto:sven@stfx.eu' asUrl)
		equals: '{"@type":"ZnUrl","@id":4,"scheme":"mailto","host":"stfx.eu","username":"sven"}'.
	self
		assert: (self serialize: 'file:///var/log/system.log' asUrl)
		equals: '{"@type":"ZnUrl","@id":5,"scheme":"file","segments":{"@type":"OrderedCollection","@id":6,"array":["var","log","system.log",null,null,null,null,null,null,null],"firstIndex":1,"lastIndex":3}}'.
	self
		assert: (self serialize: 'scheme://user:password@host:123/var/log/system.log?foo=1&bar#frag' asUrl)
		equals: '{"@type":"ZnUrl","@id":8,"scheme":"scheme","host":"host","port":123,"segments":{"@type":"OrderedCollection","@id":9,"array":["var","log","system.log",null,null,null,null,null,null,null],"firstIndex":1,"lastIndex":3},"query":{"@id":10,"foo":"1","bar":null},"fragment":"frag","username":"user","password":"password"}'