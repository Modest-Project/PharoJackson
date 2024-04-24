Class {
	#name : #BaselineOfJacksonWriter,
	#superclass : #BaselineOf,
	#category : #BaselineOfJacksonWriter
}

{ #category : #baselines }
BaselineOfJacksonWriter >> baseline: spec [
	"subclasses should redefine me"

	"Here is a typical package and its tests
	spec for: #'common' do: [
		spec 
			package: #'XXX-Core';
			package: #'XXX-Core-Tests' with: [
				spec requires: #('XXX-Core' ) ].
		spec 
			group: 'Core' with: #('XXX-Core' );
			group: 'CoreTests' with: #('XXX-Core' 'XXX-Core-Tests');
			group: 'default' with: #('Beacon-XXX' 'Beacon-XXX-Tests') ]
	"

	<baseline>
	spec for: #common do: [ "Packages"
		spec
			package: #'Jackson-Core-Writer';
			package: #'Jackson-Core-Tests'
			with: [ spec requires: #( 'Jackson-Core-Writer' ) ].
		"Groups"
		spec
			group: 'default' with: #( 'Core' 'Tests' );
			group: 'Core' with: #( 'Jackson-Core-Writer' );
			group: 'Tests' with: #( 'Jackson-Core-Tests' ) ]
]
