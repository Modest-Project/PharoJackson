# PharoJackson

```st
Metacello new
	baseline: 'JacksonWriter';
  	repository: 'github://Modest-Project/PharoJackson:main/src';
  	load
```
## Examples
```st
array := #(1 2).
JacksonWriter serialize: array

"returns '[1,null,null,null]' with id '1' as first element"
```

```st
dictionary := Dictionary newFrom: {1->2. 3->4 }.
JacksonWriter serialize: JacksonWriter serialize: dictionary

"returns '{"@type":"Dictionary","@id":1,"array":[[1,2],[3,4]]}' with an array of key/value array"
```

```st
character := $a.
JacksonWriter serialize: character

"returns '{"@type":"Character","value":97}'"
```
