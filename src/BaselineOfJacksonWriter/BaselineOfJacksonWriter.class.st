Class {
	#name : 'BaselineOfJacksonWriter',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfJacksonWriter',
	#package : 'BaselineOfJacksonWriter'
}

{ #category : 'baselines' }
BaselineOfJacksonWriter >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Packages"
		spec
			package: #'Jackson-Writer';
			package: #'Jackson-Reader';
			package: #'Jackson-Tests' with: [ spec requires: #( 'core' ) ].
		"Groups"
		spec
			group: 'default' with: #( 'core' 'tests' );
			group: 'core' with: #( 'Jackson-Writer' 'Jackson-Reader' );
			group: 'tests' with: #( 'Jackson-Tests' ) ]
]
