# PharoJackson

```
Metacello new
	baseline: 'JacksonWriter';
  	repository: 'github://Modest-Project/PharoJackson:main/src';
  	load
```
## Array
`{nil. nil. nil}` becomes `[1,null,null,null]` with id '1' as first element
## Dictionary
`a Dictionary(1->2 )` becomes `{"@type":"Dictionary","@id":1,"array":[[1,2]]}` with an array of key/value array
## Character
`$a` becomes `{"@type":"Character","asciiValue":97}`
