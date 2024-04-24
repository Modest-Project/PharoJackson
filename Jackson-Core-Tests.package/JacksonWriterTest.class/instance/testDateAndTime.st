tests
testDateAndTime
	| dateAndTime |
	dateAndTime := DateAndTime
		year: 2012
		month: 1
		day: 1
		hour: 6
		minute: 30
		second: 15
		offset: 1 hour.
	self assert: (self serialize: dateAndTime) equals: '{"@type":"DateAndTime","@id":1,"seconds":19815,"offset":{"@type":"Duration","@id":2,"nanos":0,"seconds":3600},"julianDayNumber":2455928,"nanos":0}'