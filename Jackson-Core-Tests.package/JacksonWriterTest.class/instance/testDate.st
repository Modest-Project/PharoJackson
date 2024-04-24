tests
testDate
	| date |
	date := (Date year: 2012 month: 1 day: 1) translateToUTC.
	self assert: (self serialize: date) equals: '{"@type":"Date","@id":1,"start":{"@type":"DateAndTime","@id":2,"seconds":0,"offset":{"@type":"Duration","@id":3,"nanos":0,"seconds":0},"julianDayNumber":2455928,"nanos":0},"duration":{"@type":"Duration","@id":4,"nanos":0,"seconds":86400}}'.
	date := (Date year: 2012 month: 1 day: 1) translateTo: 1 hour.
	self assert: (self serialize: date) equals: '{"@type":"Date","@id":5,"start":{"@type":"DateAndTime","@id":6,"seconds":82800,"offset":{"@type":"Duration","@id":7,"nanos":0,"seconds":3600},"julianDayNumber":2455927,"nanos":0},"duration":{"@type":"Duration","@id":8,"nanos":0,"seconds":86400}}'