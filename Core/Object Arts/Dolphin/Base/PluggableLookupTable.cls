"Filed out from Dolphin Smalltalk X6"!

LookupTable variableSubclass: #PluggableLookupTable
	instanceVariableNames: 'searchPolicy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluggableLookupTable guid: (GUID fromString: '{123A1504-7CB8-11D3-93CA-00A024CA708A}')!
PluggableLookupTable comment: 'PluggableLookupTable is the class of <LookupTable>s which support a pluggable <searchPolicy>, and which can thus be configured to behave in the same way as either standard <LookupTable>s (equality search) or <IdentityDictionary>s (identity search), or indeed any user-defined search policy.

Instance Variables:
	searchPolicy		<searchPolicy>. The policy used to hash and compare elements of the receiver.

'!
!PluggableLookupTable categoriesForClass!Collections-Unordered! !
!PluggableLookupTable methodsFor!

copyEmpty: anInteger
	"Private - Answer an empty copy of the receiver, with enough space for anInteger
	number of elements. 
	Implementation Note: We must override in order to preserve the searchPolicy."

	^(super copyEmpty: anInteger) setSearchPolicy: self searchPolicy!

findKeyOrNil: anObject 
	"Private - Answer the <integer> index of the given key in the receiver, or, if not found,
	the index of the first empty slot including and after that to which 
	the key hashes. A pluggable <searchPolicy> is used for key comparisons and hashing."

	| capacity index |
	capacity := self basicSize.
	index := self searchPolicy hash: anObject max: capacity.
	
	[| key |
	(key := self basicAt: index) isNil or: [self searchPolicy compare: key with: anObject]] 
			whileFalse: [index := index \\ capacity + 1].
	^index!

hash: anObject max: anInteger
	^self searchPolicy hash: anObject max: anInteger!

initialize
	"Private - Instance variable initialization. The tally records the number of elements."

	super initialize.
	self setSearchPolicy: self class defaultSearchPolicy
!

newSelection
	"Private - Answer a new empty collection like the receiver to 
	contain a selection of the receiver's elements."

	^self class searchPolicy: self searchPolicy!

preResize: newMe
	"This message is sent by the receiver when resizing, before the
	receiver's elements are added to newMe. We must assign across the
	search policy."

	newMe setSearchPolicy: self searchPolicy!

searchPolicy
	"Answer the receiver's <searchPolicy>."

	^searchPolicy!

searchPolicy: aSearchPolicy 
	"Set the receiver's <searchPolicy>."

	self setSearchPolicy: aSearchPolicy.
	self notEmpty ifTrue: [self rehash]!

setSearchPolicy: policy
	"Private - Set the receiver's <searchPolicy>. Answer the receiver."

	searchPolicy := policy.
	^self!

species
	"Answer the class of object to be used when copying the receiver with #collect:, etc."

	^LookupTable
! !
!PluggableLookupTable categoriesFor: #copyEmpty:!copying!private! !
!PluggableLookupTable categoriesFor: #findKeyOrNil:!private!searching! !
!PluggableLookupTable categoriesFor: #hash:max:!private!searching! !
!PluggableLookupTable categoriesFor: #initialize!initializing!private! !
!PluggableLookupTable categoriesFor: #newSelection!enumerating!private! !
!PluggableLookupTable categoriesFor: #preResize:!adding!public! !
!PluggableLookupTable categoriesFor: #searchPolicy!accessing!public! !
!PluggableLookupTable categoriesFor: #searchPolicy:!accessing!public! !
!PluggableLookupTable categoriesFor: #setSearchPolicy:!accessing!private! !
!PluggableLookupTable categoriesFor: #species!constants!public! !

!PluggableLookupTable class methodsFor!

defaultSearchPolicy
	"Answer the default <searchPolicy> used by instances of the receiver."

	^SearchPolicy equality!

new: anInteger searchPolicy: aSearchPolicy
	"Answer a new instance of the receiver with an initial capacity of at least 
	<integer> count elements (i.e. the size is a hint), and with the specified <searchPolicy>."

	^(self new: anInteger) setSearchPolicy: aSearchPolicy!

searchPolicy: policy
	"Answer a new, empty, instance of the receiver with the specified <searchPolicy>."

	^self new setSearchPolicy: policy! !
!PluggableLookupTable class categoriesFor: #defaultSearchPolicy!constants!public! !
!PluggableLookupTable class categoriesFor: #new:searchPolicy:!instance creation!public! !
!PluggableLookupTable class categoriesFor: #searchPolicy:!instance creation!public! !

