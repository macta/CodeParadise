Class {
	#name : #CpDomElementAnnouncer,
	#superclass : #Announcer,
	#instVars : [
		'element'
	],
	#category : #'CodeParadise-WebApplication-DOM'
}

{ #category : #'instance creation' }
CpDomElementAnnouncer class >> new [

	self shouldNotImplement
]

{ #category : #'instance creation' }
CpDomElementAnnouncer class >> newForElement: anElement [

	^ self basicNew
		initializeWithElement: anElement ;
		yourself
]

{ #category : #accessing }
CpDomElementAnnouncer >> element [

	^ element
]

{ #category : #initialization }
CpDomElementAnnouncer >> initializeWithElement: anElement [

	self initialize.

	element := anElement
]

{ #category : #subscription }
CpDomElementAnnouncer >> removeSubscription: aSubscription [

	"Remove the specified subscription from the receiver"

	aSubscription announcementClass removeListenerFrom: self element.

	^ super removeSubscription: aSubscription
]

{ #category : #subscription }
CpDomElementAnnouncer >> unsubscribe: anObject [

	"Unsubscribe all subscriptions of anObject from the receiver"
	
	registry subscriptionsOf: anObject do: [ :each |
		each announcementClass removeListenerFrom: each subscriber ].

	super unsubscribe: anObject
]

{ #category : #deprecated }
CpDomElementAnnouncer >> when: anAnnouncementClass do: aBlock [

	self warnCr: 'Use of any Announcer''s #when:do: is deprecated, please use #when:do:for:'.

	^ self when: anAnnouncementClass do: aBlock for: aBlock receiver
]

{ #category : #subscription }
CpDomElementAnnouncer >> when: anAnnouncementClass do: aBlock for: anObject [

	"Subscribe anObject to announcements of anAnnouncementClass class. 
	 When announced, aBlock is evaluated."

	anAnnouncementClass addListenerTo: self element.

	^ super when: anAnnouncementClass do: aBlock for: anObject
]

{ #category : #subscription }
CpDomElementAnnouncer >> when: anAnnouncementClass send: aSymbol to: anObject [

	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.

	Implementation:
	Simply perform the same behavior as the superclass. Do NOT add a listener here as in the
	method #when:do: because then it will be added twice."

	^ self
		when: anAnnouncementClass
		do: (MessageSend receiver: anObject selector: aSymbol)
		for: anObject
]
