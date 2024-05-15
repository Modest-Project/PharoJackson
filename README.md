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

"returns '{"@type":"Dictionary","array":[[1,2],[3,4]],"@id":1}' with an array of key/value array"
```
```st
orderedCollection := (OrderedCollection new add: 5; add: nil; yourself).
JacksonWriter serialize: orderedCollection

"returns '{"@type":"OrderedCollection","array":[2,5,null],"@id":1}' with only the added nil and not all nil element of its array"
```
```st
set := (Set new add: 5; add: nil; yourself).
JacksonWriter serialize: set

"returns '{"@type":"Set","array":[2,5,null],"@id":1}'  with only the added nil and not all nil element of its array"
```

```st
character := $a.
JacksonWriter serialize: character

"returns '{"@type":"Character","value":97}'"
```
