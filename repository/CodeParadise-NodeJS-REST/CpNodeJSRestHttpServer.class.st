"
I am a REST HTTP Server and will serve the endpoints provided.
I am snapshot aware, meaning I can be turned into a standalone application
by snapshotting my instances.

"
Class {
	#name : #CpNodeJSRestHttpServer,
	#superclass : #Object,
	#instVars : [
		'server',
		'port'
	],
	#category : #'CodeParadise-NodeJS-REST-Core'
}

{ #category : #'instance creation' }
CpNodeJSRestHttpServer class >> new [

	self error: 'Please use ', #newOnPort:
]

{ #category : #'instance creation' }
CpNodeJSRestHttpServer class >> newOnPort: anInteger [

	"Create a new instance on the specified port"

	^ self basicNew
		initializeOnPort: anInteger ;
		yourself
]

{ #category : #'class initialization' }
CpNodeJSRestHttpServer class >> postInstallOnce [

	"Register class for snapshotting"

	CpNodeJSSnapshot registerSnapshotClass: self
]

{ #category : #'class initialization' }
CpNodeJSRestHttpServer class >> postSnapshotOnce [

	"(Re)start all instances"

	self allInstancesDo: [ :each | each startServer ]
]

{ #category : #'class initialization' }
CpNodeJSRestHttpServer class >> preSnapshotOnce [

	"Stop all instances"

	self allInstancesDo: [ :each | each stopServer ]
]

{ #category : #server }
CpNodeJSRestHttpServer >> createServer [

	server ifNotNil: [ ^ server ].

	^ server := CpNodeJSHttp require
		createServerOn: [ :req :res | self handleRequest: req response: res ]
]

{ #category : #'event handling' }
CpNodeJSRestHttpServer >> handleRequest: anIncomingMessage response: aServerResponse [

	| request |

	self traceCr: 'Received message: ', anIncomingMessage printString.

	request := CpNodeJSRestRequest fromIncomingMessage: anIncomingMessage.
	CpNodeJSRestCollection handleRequest: request response: aServerResponse.

	aServerResponse
		writeChunk: 'Hello world', String lf ;
		statusCode: 200 ;
		end
]

{ #category : #initialization }
CpNodeJSRestHttpServer >> initialize [

	super initialize.

	self startServer
]

{ #category : #initialization }
CpNodeJSRestHttpServer >> initializeOnPort: anInteger [

	port := anInteger.

	self initialize
]

{ #category : #snapshot }
CpNodeJSRestHttpServer >> snapshot [

	CpNodeJSSnapshot saveSnapshot
]

{ #category : #server }
CpNodeJSRestHttpServer >> startServer [

	self traceCr: 'Create REST server on port ', port printString.
	self createServer listenOnPort: 8181 thenDo: [ self traceCr: 'REST server is listening' ]
]

{ #category : #server }
CpNodeJSRestHttpServer >> stopServer [

	self traceCr: 'Stop Shared Moments Accounts REST server'.
	server close.
	server := nil
]