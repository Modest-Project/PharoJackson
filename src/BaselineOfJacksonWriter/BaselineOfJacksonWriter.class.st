Class {
	#name : #BaselineOfJacksonWriter,
	#superclass : #BaselineOf,
	#category : #BaselineOfJacksonWriter
}

{ #category : #baselines }
BaselineOfJacksonWriter >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"Packages"
		spec
			package: #'Jackson-Core-Writer' with: [spec requires: #( 'STON-Core' )];
			package: #'Jackson-Core-Tests' with: [ spec requires: #( 'Jackson-Core-Writer' ) ].
		"Groups"
		spec
			group: 'default' with: #( 'Core' 'Tests' );
			group: 'Core' with: #( 'Jackson-Core-Writer' );
			group: 'Tests' with: #( 'Jackson-Core-Tests' ) ]
]
