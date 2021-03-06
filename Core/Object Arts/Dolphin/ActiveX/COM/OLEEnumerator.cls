"Filed out from Dolphin Smalltalk X6"!

SequenceableCollection subclass: #OLEEnumerator
	instanceVariableNames: 'interface'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OLEEnumerator guid: (GUID fromString: '{87B4C50E-026E-11D3-9FD7-00A0CC3E4A32}')!
OLEEnumerator comment: 'OLEEnumerator is a <sequencedReadableCollection> that wraps an OLE enumeration interface (IEnumXXXX). It provides an efficient way to treat an enumeration supplied by a COM object as a full-blown Smalltalk collection.'!
!OLEEnumerator categoriesForClass!Collections-Sequenceable! !
!OLEEnumerator methodsFor!

add: newElement
	"OLE IEnums are immutable, and therefore not extensible."

	^self shouldNotImplement!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: The size of enumerators must be calculated (no tally
	is kept), which is expensive, so we revert to the basic collection
	implementation."

	^2!

at: index 
	"Answer the element of the receiver at the specified index. If the index
	is out of bounds, raise an exception."

	| elem |
	elem := interface
				position: index - 1;
				nextAvailable.
	^elem ifNil: [self errorSubscriptBounds: index]!

at: index put: newElement
	"OLE IEnums are immutable."

	^self shouldNotImplement!

basicFree
	"Private - Release any external resources held by the receiver."

	interface free!

collect: transformer
	"Evaluate the <monadicValuable> argument, transformer, for each of the 
	receiver's elements in the order defined by the receiver's implementation of #do:.
	Answer a new collection like the receiver containing the values returned by 
	transformer on each evaluation.
	Implementation Note: #size is very slow on an OLE enumerator (it has to be calculated
	by enumerating the collection), so override to avoid it."

	^interface collect: [:elem | transformer value: elem]!

copyEmpty: anInteger
	"Private - Answer an empty copy of the receiver (which must be of the exact same class
	not just the same #species), with sufficient capacity for anInteger number of elements.
	Implementation Note: This is not possible for an OLEEnumerator, so answer an empty 
	<OrderedCollection>"

	^self species new: anInteger!

copySize
	"Private - Answer the size of empty copy to create when performing various
	copying/collecting transformations against the receiver.
	Implementation Note: Override because #size is slow, and we copy into
	a dynamically extensible collection."

	^self approxSize!

free
	"Release an external resources held by the receiver."

	interface notNil ifTrue: [
		self basicFree.
		interface := nil]!

from: start to: stop keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the <integer> indices, start and stop, inclusive with the element and its
	index as respectively the second and first arguments. A BoundsError will be
	raised if either start or stop is out of bounds.
	Implementation Note: The superclass implementation would be very slow, because #at:
	is quite slow on IEnums due to the lack of easy random access."

	| elem index |
	index := start - 1.
	interface position: index.
	[(elem := interface nextAvailable) notNil and: [index < stop]] whileTrue: [
		operation value: (index:=index+1) value: elem].
	"Report any stop bounds error."
	stop > index
		ifTrue: [^self errorSubscriptBounds: stop].!

growSize
	"Private - Not growable."

	^self shouldNotImplement!

interface: anIEnum
	"Private - Set the receiver's IEnum interface to be the argument."

	interface := anIEnum!

keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	with the <integer> index of that element and the element itself as the arguments.
	Implementation Note: We must override this in order that #countElements can calculate
	the size without causing the infinite recursion
		 #keysAndValuesDo:->#size->#countElements->#do:->#keysAndValuesDo: ... and so on."

	| index |
	index := 0.
	interface do: [:elem | operation value: (index := index + 1) value: elem]!

size
	"Answer the number of elements in the receiver.
	Implementation Note: We cannot cache the size because IEnums do not guarantee that 
	they remain constant, which is unfortunate since it is rather expensive to calculate."

	#todo "Use skip to advance over the collection in blocks until fails. Then reset to last known good 
		position and move forward in half the increment. Repeat until block size is 1 and reach the end.".
	^self countElements!

species
	"Answer the class of object to be used when copying the receiver.
	For an OLEEnumerator, we copy to an appropriate Smalltalk class
	(Array because OLEEnumerators are fixed in size and typically static)."

	^Array! !
!OLEEnumerator categoriesFor: #add:!adding!public! !
!OLEEnumerator categoriesFor: #approxSize!accessing!private! !
!OLEEnumerator categoriesFor: #at:!accessing!public! !
!OLEEnumerator categoriesFor: #at:put:!accessing!public! !
!OLEEnumerator categoriesFor: #basicFree!private!realizing/unrealizing! !
!OLEEnumerator categoriesFor: #collect:!enumerating!public! !
!OLEEnumerator categoriesFor: #copyEmpty:!copying!private! !
!OLEEnumerator categoriesFor: #copySize!copying!private! !
!OLEEnumerator categoriesFor: #free!public!realizing/unrealizing! !
!OLEEnumerator categoriesFor: #from:to:keysAndValuesDo:!enumerating!public! !
!OLEEnumerator categoriesFor: #growSize!accessing!private! !
!OLEEnumerator categoriesFor: #interface:!accessing!private! !
!OLEEnumerator categoriesFor: #keysAndValuesDo:!enumerating!public! !
!OLEEnumerator categoriesFor: #size!accessing!public! !
!OLEEnumerator categoriesFor: #species!constants!public! !

!OLEEnumerator class methodsFor!

onIEnum: anIEnum
	"Answer a new instance of the receiver which provides access via the Collection protocol 
	to the specified IEnum."

	^self new
		interface: anIEnum

	! !
!OLEEnumerator class categoriesFor: #onIEnum:!instance creation!public! !

