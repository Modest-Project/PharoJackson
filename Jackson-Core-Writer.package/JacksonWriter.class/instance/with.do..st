private
with: object do: block

	| index |
	referencePolicy = #ignore ifTrue: [ ^ block value ].
	(index := objects at: object ifAbsent: [ nil ])
		ifNotNil: [
			referencePolicy = #error ifTrue: [
				^ self error: 'shared reference detected' ].
			self writeReference: index ]
		ifNil: [
			index := objects size + 1.
			objects at: object put: index.
			block value ]