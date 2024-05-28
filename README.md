![Pharo version](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)
![Pharo version](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)
![Build Info](https://github.com/Modest-Project/PharoJackson/workflows/CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/Modest-Project/PharoJackson/badge.svg?branch=main)](https://coveralls.io/github/Modest-Project/PharoJackson?branch=main)

# PharoJackson

Serialize anything\* to JSON with this [Jackson](https://github.com/FasterXML/jackson)-inspired library for Pharo.  
Values representable by JSON literals are written using the default notation, e.g. arrays, strings, numbers, booleans, null.  
All other objects are represented by dictionaries containing additional metadata:
- `@type`: the class name of the object
- `@id`: the unique identifier assigned to the object, used to handle circular references.

If an object occurs more than once, it is referenced by a dictionary containing a single `@ref` attribute with the id of the object in question.  
Arrays are also assigned an id, which appears as the first element.

> [!NOTE]
> \*This library accepts serialization of almost anything, including blocks, but is still limited when it comes to global variables, methods, and meta-values such as `Context`.

## Installing

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
```
```json
[1,1,2]
```
---
```st
dictionary := Dictionary newFrom: { 1 -> 2. 3 -> 4 }.
JacksonWriter serialize: dictionary
```
```json
{"@type":"Dictionary","@":[{"@type":"Association","key":1,"value":2,"@id":2},{"@type":"Association","key":3,"value":4,"@id":3}],"@id":1}
```
---
```st
orderedCollection := (OrderedCollection new add: 5; add: nil; yourself).
JacksonWriter serialize: orderedCollection
```
With only the added nil, not all nil elements of its array:
```json
{"@type":"OrderedCollection","array":[2,5,null],"@id":1}
```
---
```st
set := (Set new add: 5; add: nil; yourself).
JacksonWriter serialize: set
```
```json
{"@type":"Set","array":[2,5,null],"@id":1}
```
---
```st
character := $a.
JacksonWriter serialize: character
```
```json
{"@type":"Character","value":97}
```
