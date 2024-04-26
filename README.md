# PharoJackson

```
Metacello new
	baseline: 'JacksonWriter';
  	repository: 'github://Modest-Project/PharoJackson:main/src';
  	load
```
## Examples
```
JacksonWriter serialize: #(1 2)	"returns [1,null,null,null] with id '1' as first element"
```

```
JacksonWriter serialize: JacksonWriter serialize: (Dictionary newFrom: {1->2. 3->4 } )	"returns {"@type":"Dictionary","@id":1,"array":[[1,2],[3,4]]} with an array of key/value array"
```

```
JacksonWriter serialize: $a	"returns {"@type":"Character","value":97}"
```
