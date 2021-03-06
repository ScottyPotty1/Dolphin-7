"Filed out from Dolphin Smalltalk 7"!

SequenceableCollection subclass: #ArrayedCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayedCollection guid: (GUID fromString: '{87B4C50C-026E-11D3-9FD7-00A0CC3E4A32}')!
ArrayedCollection comment: 'ArrayedCollection is the class of <SequenceableCollection>s of a fixed size which are indexable by integer keys from 1 to the size of the collection.'!
!ArrayedCollection categoriesForClass!Collections-Abstract! !
!ArrayedCollection methodsFor!

add: newElement
	"ArrayedCollections are not, in general, extensible."

	^self shouldNotImplement!

at: index
	"Answer the receiver's indexed element at the <integer> argument, index.
	Implementation Note: Subclasses are generally implemented as indexable objects,
	so we can use the indexable instance variable accessing primitive (i.e.
	revert to the Object implementation)."

	<primitive: 60>
	^self errorAt: index!

at: index put: newElement
	"Replace the element of the receiver at the specified <integer> index with 
	the <Object> argument, newElement. If the index is out of bounds, raise 
	a BoundsError.

	Implementation Note: Subclasses are generally implemented as indexable objects,
	so we can use the indexable instance variable accessing primitive (i.e.
	revert to the Object implementation)."

	<primitive: 61>
	^self errorAt: index put: newElement!

do: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the elements of the 
	receiver. Answers the receiver. The elements are evaluated in index order.
	Implementation Note: Override the superclass for efficiency."

	1 to: self size do: [:i | operation value: (self at: i)]!

findFirst: discriminator
	"Answer the index of the first element of the receiver for which the monadic
	valuable argument, discriminator, evaluates to true. If there are no such elements,
	answer 0.
	Implementation Note: Override superclass to provide a more efficient implementation.
	ArrayedCollections have a very fast implementation of #at:, so it is better to inline
	the loop."

	1 to: self size do: [:i | (discriminator value: (self at: i)) ifTrue: [^i]].
	^0!

identityIncludes: anObject
	"Answer whether the argument, anObject, is one of the receiver's elements.
	Override superclass to provide a more efficient implementation (hence the
	esoteric logic ops)."

	^((self nextIdentityIndexOf: anObject from: 1 to: self size) == 0) == false!

includes: target
	"Answer whether the argument, target, is one of the elements of the receiver.
	Implementation Note: Override superclass to provide a more efficient implementation."

	1 to: self size do: [:i | target = (self at: i) ifTrue: [^true]].
	^false!

inject: anObject into: aDyadicValuable
	"Evaluate the <dyadicValuable> argument, aDyadicValuable, once for each element in the
	receiver, passing the elements as the second argument, and passing the value of the previous
	evaluation as the first argument, starting with the <Object> argument, initialValue. The
	operation must answer the value it wishes to have passed as its first argument the next time
	it is evaluated. The traversal is in the #do: order. Answer the final value of the
	operation. This enumeration is particularly useful for performing summations and other
	statistical operations."

	"Implementation Note: Override superclass implementation for efficiency. By inlining the do:
	implementation we can avoid requiring a full block."

	| nextValue |
	nextValue := anObject.
	1 to: self size do: [:i | nextValue := aDyadicValuable value: nextValue value: (self at: i)].
	^nextValue!

nextIdentityIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver's indexable
	variables between startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Override the inherited implementation to make use of the primitive"

	<primitive: 59>
	^super nextIdentityIndexOf: anElement from: start to: stop!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Implementation Note: Override the superclass to provide a more efficient
	inlined implementation."

	start to: stop do: [:i | (self at: i) = anElement ifTrue: [^i]].
	^0!

replaceIdentity: anObject with: newElement
	"If the receiver contains an identity match for anObject replace the first with newElement, 
	otherwise increase the size of the receiver, and append newElement. Answer the index.
	This is a very useful method in many system support tasks (e.g. the Dependency mechanism)"

	| size index |
	size := self size.
	index := self nextIdentityIndexOf: anObject from: 1 to: size.
	index == 0 ifTrue: [ 
		index := size + 1.
		self resize: index ].
	self at: index put: newElement.
	^index!

resize: anInteger 
	"Override back to the primitive implementation for indexable objects (see Object>>resize:)"

	<primitive: 101>
	^super resize: anInteger!

size
	"Answer the size of the collection. 
	Implementation Note: Subclasses are generally implemented as indexable objects,
	so we can use the indexable instance variable size primitive.
	This primitive should not fail."

	<primitive: 62>
	^self primitiveFailed

!

sortUsing: aSortAlgorithm
	"Perform an in-place sort against the receiver using the specified sort algorithm"
	
	aSortAlgorithm 
		sort: self
		from: 1
		to: self size! !
!ArrayedCollection categoriesFor: #add:!adding!public! !
!ArrayedCollection categoriesFor: #at:!accessing!public! !
!ArrayedCollection categoriesFor: #at:put:!accessing!public! !
!ArrayedCollection categoriesFor: #do:!debugger-step through!enumerating!public! !
!ArrayedCollection categoriesFor: #findFirst:!public!searching! !
!ArrayedCollection categoriesFor: #identityIncludes:!public!searching! !
!ArrayedCollection categoriesFor: #includes:!public!searching! !
!ArrayedCollection categoriesFor: #inject:into:!enumerating!public! !
!ArrayedCollection categoriesFor: #nextIdentityIndexOf:from:to:!public!searching! !
!ArrayedCollection categoriesFor: #nextIndexOf:from:to:!public!searching! !
!ArrayedCollection categoriesFor: #replaceIdentity:with:!public!replacing! !
!ArrayedCollection categoriesFor: #resize:!mutating!public! !
!ArrayedCollection categoriesFor: #size!accessing!public! !
!ArrayedCollection categoriesFor: #sortUsing:!public!sorting! !

!ArrayedCollection class methodsFor!

new
	"Answer a new, empty, instance of the receiver."

	^self new: 0!

new: elementCount withAll: elementValue
	"Answer a new instance of the receiver with <integer>, elementCount, 
	elements, each of which is initialized to the <Object>, elementValue.
	Included mainly for compatibility with VisualWorks."

	^(self new: elementCount)
		atAllPut: elementValue;
		yourself!

with: element1
	"Answer a new instance of the receiver containing the single 
	<Object> element, element1."

	^(self new: 1)
		at: 1 put: element1;
		yourself!

with: element1 with: element2
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements"

	^(self new: 2)
		at: 1 put: element1;
		at: 2 put: element2;
		yourself!

with: element1 with: element2 with: element3
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements."

	^(self new: 3)
		at: 1 put: element1;
		at: 2 put: element2;
		at: 3 put: element3;
		yourself!

with: element1 with: element2 with: element3 with: element4
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements."

	^(self new: 4)
		at: 1 put: element1;
		at: 2 put: element2;
		at: 3 put: element3;
		at: 4 put: element4;
		yourself!

with: element1 with: element2 with: element3 with: element4 with: element5
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements.
	N.B. This is not an ANSI standard method (up to 4 elements are supported
	by <Array factory> #with:&c messages, for more one must use #withAll:)."

	^(self new: 5)
		at: 1 put: element1;
		at: 2 put: element2;
		at: 3 put: element3;
		at: 4 put: element4;
		at: 5 put: element5;
		yourself!

withAll: newElements
	"Answer a new instance of the receiver containing all of the 
	elements of the <collection> newElements."

	| answer |
	answer := self new: newElements size.
	newElements inject: 1 into: [:i :elem | answer at: i put: elem. i + 1].
	^answer! !
!ArrayedCollection class categoriesFor: #new!instance creation!public! !
!ArrayedCollection class categoriesFor: #new:withAll:!instance creation!public! !
!ArrayedCollection class categoriesFor: #with:!instance creation!public! !
!ArrayedCollection class categoriesFor: #with:with:!instance creation!public! !
!ArrayedCollection class categoriesFor: #with:with:with:!instance creation!public! !
!ArrayedCollection class categoriesFor: #with:with:with:with:!instance creation!public! !
!ArrayedCollection class categoriesFor: #with:with:with:with:with:!instance creation!public! !
!ArrayedCollection class categoriesFor: #withAll:!instance creation!public! !

ArrayedCollection class methodProtocol: #'Array factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #with: #with:with: #with:with:with: #with:with:with:with: #withAll:)!

