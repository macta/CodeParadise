Extension { #name : #CompiledMethod }

{ #category : #'*CodeParadise-RemoteEnvironment' }
CompiledMethod >> bindClassVariables [

	"Bind class variables to the receiver (replace literal association with class variable association).
	Assume the receiver is already bound to a class."

	self bindClassVariablesTo: self methodClass instanceSide

]

{ #category : #'*CodeParadise-RemoteEnvironment' }
CompiledMethod >> bindClassVariablesTo: aClass [

	"Bind class variables to the receiver (replace literal association with the
	class variable association)"

	<clientEnvironment>

	| classVariableClass |

	classVariableClass := Smalltalk at: #ClassVariable.
	1 to: self numLiterals do: [ :index |
		| literal |
		literal := self literalAt: index.
		(literal class == classVariableClass and: [ literal value isNil ])
			ifTrue: [ self literalAt: index put: (aClass classVariableNamed: literal key) ] ]

]

{ #category : #'*CodeParadise-RemoteEnvironment' }
CompiledMethod >> cpEncodeWith: anEncoder [

	<clientEnvironment>

	anEncoder encodeCompiledMethod: self
]

{ #category : #'*CodeParadise-RemoteEnvironment' }
CompiledMethod >> install [
	"Install the receiver in its Class"

	<clientEnvironment>

	self methodClass
		ifNotNil: [ :methodClass | methodClass installMethod: self ]
]

{ #category : #'*CodeParadise-RemoteEnvironment' }
CompiledMethod >> isServerSideOnly [

	"Answer whether the receiver is a server side only method"

	^ self hasPragmaNamed: #serverEnvironment
]

{ #category : #'*CodeParadise-RemoteEnvironment' }
CompiledMethod >> remove [
	"Remove the receiver from its Class"

	<clientEnvironment>

	self methodClass
		ifNotNil: [ :methodClass | methodClass removeMethod: self ]
]
