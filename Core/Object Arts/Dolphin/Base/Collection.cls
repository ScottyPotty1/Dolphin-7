"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Collection
	instanceVariableNames: ''
	classVariableNames: 'AbsentCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Collection guid: (GUID fromString: '{87B4C464-026E-11D3-9FD7-00A0CC3E4A32}')!
Collection comment: ''!
!Collection categoriesForClass!Collections-Abstract! !
!Collection methodsFor!

_beginsString: aString
	^aString basicBeginsWith: self!

_indexOfAnyInString: aString startingAt: anInteger 
	aString from: anInteger keysAndValuesDo: [:i :elem | (self includes: elem) ifTrue: [^i]].
	^0!

_separateSubStringsIn: aReadableString 
	"Private - Answer an Array containing the substrings in aReadableString separated
	by the elements of the receiver (which must be Characters)."

	| start answer size end |
	size := aReadableString size.
	size == 0 ifTrue: [^Array new].
	end := aReadableString indexOfAnyOf: self startingAt: 1.
	end == 0 ifTrue: [^Array with: aReadableString].
	answer := Array writeStream: 5.
	start := 1.
	
	[answer nextPut: (aReadableString copyFrom: start to: end - 1).
	start := end + 1.
	end := aReadableString indexOfAnyOf: self startingAt: start.
	end == 0] 
			whileFalse.
	"Copy any remaining chars after the last separator"
	start <= size ifTrue: [answer nextPut: (aReadableString copyFrom: start to: size)].
	^answer contents!

add: newElement
	"Include the <Object> argument, newElement, as one of the receiver's 
	elements. Answer newElement."

	^self subclassResponsibility!

addAll: newElements
	"Include all the elements of the <collection> argument, newElements, as the receiver's elements. 
	Answer newElements. 
	Note that this modifies the and answers the receiver, not a copy.
	newElements can actually be any object which understands #do:."

	newElements do: [:each | self add: each].
	^newElements!

allSatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for
	every element of the receiver.
	Implementation Note: The argument is evaluated for every element
	of the receiver iff it is satisfied for every element."

	self do: [:e | (discriminator value: e) ifFalse: [^false]].
	^true!

anyOne
	"Answer an arbitrary element of the collection. Raise an error if the collection is empty."

	self do: [:each | ^each].
	^self error: 'collection is empty'!

anySatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for
	any element of the receiver.
	Implementation Note: The argument is evaluated for every element of the
	receiver iff it evaluates to false for every element."

	self do: [:e | (discriminator value: e) ifTrue: [^true]].
	^false!

appendToStream: puttableStream
	"Private - Append the receiver's elements to the argument, puttableStream.
	Answer the receiver.
	Implementation note: Double dispatched from puttableStream>>nextPutAll:."

	self do: [ :element | puttableStream nextPut: element ]!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: This does not have to be accurate, but it should be fast
	(i.e. don't calculate it by counting the receiver's elements).
	The default is to guess at 2. Subclasses which can give a more
	accurate size quickly will get better conversion performance."

	^2!

asArray
	"Answer an <Array> whose elements are those of the receiver.
	The ordering is that of the #do: operation as implemented by the receiver,
	and the answer will normally be the same size as the receiver."

	| answer i |
	answer := Array new: self size.
	i := 1.
	self do: 
			[:each | 
			answer at: i put: each.
			i := i + 1].
	^answer!

asBag
	"Answer a <Bag> containing the same elements as the receiver
	Note: As Bags identify multiple occurrences with the equality relationship
	the enumerated elements of the result may not be identical to those of
	the receiver, although there will be the same number.
	Implementation Note: It is an error if the receiver contains nil elements,
	but this is not currently trapped."

	^(Bag new: self approxSize) 
		addAll: self; 
		yourself!

asByteArray
	"Answer a <ByteArray> whose elements are those of the receiver.
	The ordering is that of the #do: operation as implemented by the receiver,
	and the answer will normally be the same size as the receiver.
	This will fail if the receiver contains elements which are not Integers
	in the range 0..255."

	| anArray i |
	anArray := ByteArray new: self size.
	i := 1.
	self do: 
			[:each | 
			anArray basicAt: i put: each.
			i := i + 1].
	^anArray!

asIdentitySet
	"Answer a new <IdentitySet> whose elements are those stored in the receiver.
	Any duplicates are eliminated, so the result may be smaller than
	the receiver. Any nil elements of the receiver are also eliminated."

	^(IdentitySet new: self approxSize) 
		addAll: self; 
		yourself!

asOrderedCollection
	"Answer an <OrderedCollection> whose elements are those of the receiver
	The ordering is that of the #do: operation as implemented by the receiver,
	and the answer will normally be the same size as the receiver.
	Implementation Note: Although we might be able to perform this operation 
	faster for collections which keep a tally of their size (or can otherwise 
	access it without calculation) we must be careful NOT to provide a default 
	implementation which will cause a double enumeration for collections which must
	count their elements to determine their size, which may be very slow."

	| answer |
	answer := OrderedCollection new: self approxSize.
	self do: [:elem | answer addLast: elem].
	^answer!

asSet
	"Answer a <Set> whose elements are those stored in the receiver.
	Any duplicates are eliminated, so the result may be smaller than
	the receiver. Any nil elements of the receiver are also eliminated,
	but this behaviour may differ between implementations, and so
	should not be relied upon in portable code."

	^(Set new: self approxSize) 
		addAll: self; 
		yourself!

asSortedCollection
	"Answer a <SortedCollection> of the same size as the receiver
	whose elements are those of the receiver, with the order of the result
	being determined by the default sort block (see SortedCollection).
	Exceptions may occur if any of the elements of the receiver are not
	appropriate parameters for the default sort block."

	^(SortedCollection new: self approxSize)
		addAll: self; 
		yourself!

asSortedCollection: aDyadicValuable 
	"Answer a <SortedCollection> whose elements are those of the receiver, sorted according to 
	the <dynadicValuable> argument, sortBlock.
	Exceptions may occur if any of the elements of the receiver are not
	appropriate parameters for sortBlock.
	Note: The argument does not need to be a BlockClosure, it must simply
	understand the #value:value: message from the dyadic valuable protocol."

	^self asSortedCollectionUsing: (self class defaultSortAlgorithmClass sortBlock: aDyadicValuable)!

asSortedCollectionUsing: aSortAlgorithm 
	"Answer a <SortedCollection> whose elements are those of the receiver, sorted using the
	<SortAlgorithm> argument. Exceptions may occur if any of the elements of the receiver are
	not appropriate parameters for the aSortAlgorithm's sortBlock."

	^(SortedCollection new: self approxSize)
		setSortAlgorithm: aSortAlgorithm;
		addAll: self;
		yourself!

collect: transformer
	"Evaluate the <monadicValuable> argument, transformer, for each of the 
	receiver's elements in the order defined by the receiver's implementation of #do:.
	Answer a new collection like the receiver (i.e. of the same #species but not 
	necessarily the exact same class - since the collection may hold a different objects,
	it may need to be of a different type, hence the #species /#copyLike mechanism) 
	containing the values returned by transformer on each evaluation."

	| answer |
	answer := self copyLike.
	self do: [:each | answer add: (transformer value: each)].
	^answer!

copyEmpty
	"Answer an empty copy of the receiver (which must be of the exact same class
	not just the same #species), with enough capacity for the same number of elements.
	#copyEmpty can be useful when you wish to take a copy of a collection that
	preserves all of the collections attributes (including the capacity) apart from its 
	elements."

	^self copyEmpty: self copySize!

copyEmpty: anInteger
	"Private - Answer an empty copy of the receiver (which should be of the exact same class
	not just the same #species), with sufficient capacity for anInteger number of elements."

	"N.B. Must be reimplemented by subclasses that need to copy additional instance 
	variables (e.g. the sortBlock of SortedCollection)."

	^self class new: anInteger!

copyLike
	"Private - Answer an empty collection of the same species as the receiver with 
	sufficient capacity for anInteger number of elements."

	^self copyLike: self copySize!

copyLike: anInteger
	"Private - Answer an empty collection of the same species of the receiver with 
	sufficient capacity for anInteger number of elements."

	^self species new: anInteger!

copySize
	"Private - Answer the size of empty copy to create when performing various
	copying/collecting transformations against the receiver. Can be overridden
	by subclasses for which #size is a slow operation."

	^self size!

copyWithoutDuplicates
	"Answers a copy of the receiver that contains no duplicate objects. 
	Uses equality for comparison."

	^self distinct!

countElements
	"Private - Count, and answer, the number of elements in the receiver.
	Implementation Note: Could be implemented more elegantly with #inject:into:, but
	this implementation is about twice as fast."

	| tally |
	tally := 0.
	self do: [ :each | tally := tally + 1].
	^tally!

detect: discriminator
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's elements
	in the order defined by the receiver's implementation of #do:.
	Answer the first element for which discriminator evaluates to true. If none evaluates to true,
	report an error."

	^self detect: discriminator ifNone: [self errorNotFound: discriminator]!

detect: discriminator ifNone: exceptionHandler
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's 
	elements.  Answer the first element (in the #do: order) for which discriminator evaluates 
	to true. If none evaluates to true answer the result of evaluating the <niladicValuable> 
	argument, exceptionHandler.
	Implementation Note: It is important for Shared subclasses that the exceptionHandler is 
	not evaluated inside the enumeration in case it is a niladic block containing an explicit 
	return (we try to avoid explicit returns from critical sections, as these require an unwind)."

	self do: [:each | (discriminator value: each) ifTrue: [^each]].
	^exceptionHandler value!

difference: comperand
	"Answer a <collection> like the receiver containing the Set theroetic 
	difference between the receiver and the <collection>, comperand. 
	i.e. Answer the set of all objects that are elements of the receiver 
	but not the argument."

	^self reject: [:e | comperand includes: e]!

distinct
	"Answer a <collection> like the receiver containing only one occurrence of each element."

	| seen |
	seen := Set new.
	^self select: [:each | seen addNewElement: each]!

do: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the 
	receiver's elements.
	The exact visit ordering is unspecified at this level, but this message must be
	implemented by subclasses (as it provides much of the enumeration behaviour 
	of Collections), and those implementations are free to define any appropriate
	ordering."

	^self subclassResponsibility!

do: operation separatedBy: separator 
	"Evaluate the <monadicValuable> argument, operation, for each of the 
	receiver's elements, interspersed with evaluations of the <niladicValuable>
	argument, separator. The separator is first evaluated after the first
	element, and is not evaluated after the last element (i.e. it is not evaluated
	at all if there are less than two elements)."

	| sep |
	sep := [sep := separator].	"Switch to the real separator after first eval."
	self do: 
			[:each | 
			sep value.
			operation value: each]!

errorEmptyCollection
	^self error: 'empty collection'!

errorNotKeyed
	"Private - Generate an error to the effect that the receiver is not a keyed Collection"

	^self error: self class name, 's do not respond to keyed accessing messages'
!

fold: aDyadicValuable 
	"Evaluate the <dyadicValuable> argument, operation, across the elements of the receiver
	starting with the first two elements. For subsequent evaluations the first argument to the
	block is the result of the previous evaluation, and the second argument is the next element.
	The order of the elements is as defined by the #do: operation. Answer the result of the
	final evaluation. It is an error for the collection to be empty. Should the collection
	contain only one element, then answer that element."

	| answer operation |
	answer := nil.
	operation := 
			[:a :first | 
			operation := aDyadicValuable.
			first].
	self do: [:each | answer := operation value: answer value: each].
	^operation == aDyadicValuable ifTrue: [answer] ifFalse: [self errorEmptyCollection]!

growSize
	"Private - Answer the number of elements by which the receiver should grow, when growing!!
	(at least 2, in case the receiver is currently empty)"

	^self size max: 2!

identityIncludes: anObject 
	"Answer whether the argument, anObject, is one of the receiver's elements."

	self do: [:each | anObject == each ifTrue: [^true]].
	^false!

includes: target
	"Answer whether the <Object> argument, target, is one of the elements of the receiver.
	Implementation Note: The default is to use equality for comparison."

	self do: [:each | target = each ifTrue: [^true]].
	^false!

inject: initialValue into: operation
	"Evaluate the <dyadicValuable> argument, operation, once for each element in the receiver, with
	that element as the second argument; and with the first argument as the value of the previous 
	evaluation, starting with the <Object> argument, initialValue. The operation must answer the value
	it wishes to have passed as its first argument the next time it is evaluated. The traversal is in the #do: 
	order. Answer the final value of the operation.
	This enumeration is particularly useful for performing summations and other statistical operations."

	| nextValue |
	nextValue := initialValue.
	self do: [:each | nextValue := operation value: nextValue value: each].
	^nextValue!

intersection: comperand
	"Answer a new <collection>, like the receiver, that is the intersection of the 
	receiver and the <collection>, comperand, i.e. answer the set of all objects
	which are elements of both the receiver and the argument."

	^self select: [ :element | comperand includes: element ]!

isEmpty
	"Answer whether the receiver contains no elements."

	^self size == 0
!

maxPrint
	"Private - Answer the maximum number of characters to be printed onto a stream as 
	the string representation of the receiver."

	^3000
!

newSelection
	"Private - Answer a new empty collection like the receiver to 
	contain a selection of the receiver's elements."

	^self species new!

noDifference: aCollection 
	"Answer whether the receiver contains the same elements as the <collection> argument
	(i.e. the symmetric difference is empty)."

	aCollection == self ifTrue: [^true].
	aCollection size = self size ifFalse: [^false].
	^(self symmetricDifference: aCollection) isEmpty!

notEmpty
	"Answer whether the receiver contains any elements."

	^self isEmpty not!

occurrencesOf: target
	"Answer the <integer> number of the receiver's elements which are 
	equal to the <Object> argument, target."

	| count |
	count := 0.
	self do: [:each | target = each ifTrue: [count := count + 1]].
	^count!

printCyclicRefOn: aStream
	"Private - Append to the argument, aStream, a String whose characters describe
	a cyclic (or recursive) reference to the receiver. Used by some
	printOn: methods (e.g. see Collection) to prevent an infinite recursion."

	aStream nextPutAll: '... a cyclic ref to '.
	self basicPrintOn: aStream.
	aStream nextPutAll: '...'!

printOn: aStream
	"Print a string representation of self on aStream. This method suffices for 
	most collections, and is able to handle cyclic references."

	| printed |
	printed := Processor activeProcess _alreadyPrinted.
	(printed includes: self) ifTrue: [^self printCyclicRefOn: aStream].
	printed add: self.
	
	[| tooMany |
	tooMany := aStream position + self maxPrint.
	self printPrefixOn: aStream.
	self do: 
			[:each | 
			aStream position > tooMany 
				ifTrue: 
					[aStream nextPutAll: '... etc ...'.
					^self].
			each printOn: aStream]
		separatedBy: [aStream space].
	self printSuffixOn: aStream] 
			ensure: [printed remove: self ifAbsent: []]!

printPrefixOn: aStream
	"Private - Print a prefix string for the debug representation of the receiver on aStream."

	aStream
		basicPrint: self;
		nextPut: $(!

printSuffixOn: aStream
	"Private - Print a suffix string for the debug representation of the receiver on aStream."

	aStream nextPut: $)!

rehash
	"Rehash the receiver to re-establish hash invariants, if any.
	The default is to do nothing, but this selector is present at this level, as any
	subclass could potentially be implemented as a hashed collection." !

reject: discriminator
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's elements.
	Answer a new <collection> like the receiver containing only those elements for which 
	the discriminator evaluates to false."

	^self select: [:elem | (discriminator value: elem) == false]!

remove: oldElement 
	"Remove the <Object> argument, oldElement, from the receiver's elements.
	Answer oldElement unless it is not an element of the receiver, in which 
	case, raise a suitable exception."

	| removed |
	removed := self remove: oldElement ifAbsent: [AbsentCookie].
	^removed == AbsentCookie ifTrue: [self errorNotFound: oldElement] ifFalse: [removed]!

remove: oldElement ifAbsent: exceptionHandler
	"Remove the <Object> argument, oldElement, from the receiver's elements.  
	If several of the elements are equal to anObject, only one is removed (precisely 
	which is determined by the the subclass).
	If no element is equal to oldElement, answer the result of evaluating the <niladicValuable>
	exceptionHandler. Otherwise, answer oldElement. 
	Must be implemented by subclasses which comply with <extensibleCollection>."

	^self subclassResponsibility!

removeAll: oldElements
	"Remove each element of the <collection>, oldElements, from the receiver, raising
	an Exception if any are not elements of the receiver. Answer oldElements."

	oldElements do: [:each | self remove: each].
	^oldElements!

removeAllSuchThat: aBlock 
	"Evaluate aBlock for each element and remove all that elements from the receiver for that
	aBlock evaluates to true. Use a copy to enumerate collections whose order changes when an
	element is removed (i.e. Sets)."

	self copy do: [:each | (aBlock value: each) ifTrue: [self remove: each]]!

select: discriminator
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's elements.
	Answer a new <collection> like the receiver containing only those elements for which 
	the discriminator evaluates to true."

	| newCollection |
	newCollection := self newSelection.
	self 
		do: [:each | (discriminator value: each) ifTrue: [newCollection add: each]].
	^newCollection!

select: discriminator thenCollect: transformer
	"Answer a new <collection> like the receiver containing the values returned by 
	the <monadicValuable>, transformer, when evaluated for each of the receiver's 
	elements for which the <monadicValuable>, discriminator, evaluates to true."

	^(self select: discriminator) collect: transformer!

size
	"Answer the <integer> number of elements in the receiver.
	Implementation Note: This implementation is rather inefficient, 
	and subclasses will probably want to override it."

	^self countElements!

storeOn: aStream 
	"Append to the <puttableStream> argument, target, an expression which when 
	evaluated will answer a collection similar to the receiver."

	| first |
	aStream nextPutAll: '(('.
	self class storeOn: aStream.
	aStream nextPutAll: ' new)'.
	first := true.
	self do: [:value |
		first
			ifTrue: [first := false]
			ifFalse: [aStream nextPut: $;].
		aStream nextPutAll: ' add: '.
		value storeOn: aStream].
	first ifFalse: [aStream nextPutAll: '; yourself'].
	aStream nextPut: $)!

symmetricDifference: comperand
	"Answer a <collection> like the receiver containing the symmetric
	difference of the receiver and the <collection>, comperand. 
	i.e. Answer the set of all objects that are elements of the receiver 
	or the argument, but not both."

	^(self union: comperand) difference: (self intersection: comperand)!

union: comperand
	"Answer a <Set> that is the union of the elements of receiver and 
	the <collection>, comperand. i.e. Answer the set of all objects that
	are elements of the receiver or the argument, or both."

	^(Set withAll: self)
		addAll: comperand;
		yourself
! !
!Collection categoriesFor: #_beginsString:!comparing!double dispatch!private! !
!Collection categoriesFor: #_indexOfAnyInString:startingAt:!double dispatch!private!searching! !
!Collection categoriesFor: #_separateSubStringsIn:!double dispatch!private! !
!Collection categoriesFor: #add:!adding!public! !
!Collection categoriesFor: #addAll:!adding!public! !
!Collection categoriesFor: #allSatisfy:!enumerating!public! !
!Collection categoriesFor: #anyOne!accessing!public! !
!Collection categoriesFor: #anySatisfy:!enumerating!public! !
!Collection categoriesFor: #appendToStream:!double dispatch!private! !
!Collection categoriesFor: #approxSize!accessing!private! !
!Collection categoriesFor: #asArray!converting!public! !
!Collection categoriesFor: #asBag!converting!public! !
!Collection categoriesFor: #asByteArray!converting!public! !
!Collection categoriesFor: #asIdentitySet!converting!public! !
!Collection categoriesFor: #asOrderedCollection!converting!public! !
!Collection categoriesFor: #asSet!converting!public! !
!Collection categoriesFor: #asSortedCollection!converting!public! !
!Collection categoriesFor: #asSortedCollection:!converting!public! !
!Collection categoriesFor: #asSortedCollectionUsing:!converting!public! !
!Collection categoriesFor: #collect:!enumerating!public! !
!Collection categoriesFor: #copyEmpty!copying!public! !
!Collection categoriesFor: #copyEmpty:!copying!private! !
!Collection categoriesFor: #copyLike!enumerating!private! !
!Collection categoriesFor: #copyLike:!enumerating!private! !
!Collection categoriesFor: #copySize!copying!private! !
!Collection categoriesFor: #copyWithoutDuplicates!copying!public! !
!Collection categoriesFor: #countElements!accessing!private! !
!Collection categoriesFor: #detect:!public!searching! !
!Collection categoriesFor: #detect:ifNone:!public!searching! !
!Collection categoriesFor: #difference:!public!set operations! !
!Collection categoriesFor: #distinct!public!set operations! !
!Collection categoriesFor: #do:!enumerating!public! !
!Collection categoriesFor: #do:separatedBy:!enumerating!public! !
!Collection categoriesFor: #errorEmptyCollection!exceptions!private! !
!Collection categoriesFor: #errorNotKeyed!exceptions!private! !
!Collection categoriesFor: #fold:!enumerating!public! !
!Collection categoriesFor: #growSize!accessing!private! !
!Collection categoriesFor: #identityIncludes:!public!searching! !
!Collection categoriesFor: #includes:!public!searching! !
!Collection categoriesFor: #inject:into:!enumerating!public! !
!Collection categoriesFor: #intersection:!public!set operations! !
!Collection categoriesFor: #isEmpty!public!testing! !
!Collection categoriesFor: #maxPrint!constants!private! !
!Collection categoriesFor: #newSelection!enumerating!private! !
!Collection categoriesFor: #noDifference:!public!set operations! !
!Collection categoriesFor: #notEmpty!public!testing! !
!Collection categoriesFor: #occurrencesOf:!public!searching! !
!Collection categoriesFor: #printCyclicRefOn:!printing!private! !
!Collection categoriesFor: #printOn:!printing!public! !
!Collection categoriesFor: #printPrefixOn:!printing!private! !
!Collection categoriesFor: #printSuffixOn:!printing!private! !
!Collection categoriesFor: #rehash!operations!public! !
!Collection categoriesFor: #reject:!enumerating!public! !
!Collection categoriesFor: #remove:!public!removing! !
!Collection categoriesFor: #remove:ifAbsent:!public!removing! !
!Collection categoriesFor: #removeAll:!public!removing! !
!Collection categoriesFor: #removeAllSuchThat:!public!removing! !
!Collection categoriesFor: #select:!enumerating!public! !
!Collection categoriesFor: #select:thenCollect:!enumerating!public! !
!Collection categoriesFor: #size!accessing!public! !
!Collection categoriesFor: #storeOn:!printing!public! !
!Collection categoriesFor: #symmetricDifference:!public!set operations! !
!Collection categoriesFor: #union:!public!set operations! !

Collection methodProtocol: #collection attributes: #(#ansi #readOnly) selectors: #(#allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #inject:into: #isEmpty #notEmpty #occurrencesOf: #rehash #reject: #select: #size)!
Collection methodProtocol: #extensibleCollection attributes: #(#ansi #readOnly) selectors: #(#add: #addAll: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #inject:into: #isEmpty #notEmpty #occurrencesOf: #rehash #reject: #remove: #remove:ifAbsent: #removeAll: #select: #size)!

!Collection class methodsFor!

defaultSortAlgorithmClass
	"Answer the class of <PluggableSortAlgorithm> to be used by default in conjunction with a
	user-defined sort block."

	^DefaultSortAlgorithm!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables."

	AbsentCookie := Object new
!

with: element1
	"Answer an instance of the receiver containing the <Object>, element1.
	Implementation Note: The #yourself is definitely required here."

	^self new
		add: element1; 
		yourself!

with: element1 with: element2
	"Answer an instance of the receiver containing each of the <Object>
	arguments as its elements"

	^(self new: 2)
		add: element1; 
		add: element2; 
		yourself!

with: element1 with: element2 with: element3
	"Answer an instance of the receiver containing each of the <Object>
	arguments as its elements."

	^(self new: 3)
		add: element1; 
		add: element2; 
		add: element3; 
		yourself!

with: element1 with: element2 with: element3 with: element4
	"Answer an instance of the receiver containing each of the <Object>
	arguments as its elements."

	^(self new: 4)
		add: element1; 
		add: element2; 
		add: element3; 
		add: element4; 
		yourself!

with: firstObject with: secondObject with: thirdObject with: fourthObject with: fifthObject
	"Answer an instance of the receiver containing the arguments as its elements"

	^self new
		add: firstObject; 
		add: secondObject; 
		add: thirdObject;
		add: fourthObject; 
		add: fifthObject; 
		yourself
!

withAll: newElements
	"Answer a new instance of the receiver containing all of the 
	elements of the <collection>, newElements."

	^(self new: newElements size)
		addAll: newElements;
		yourself! !
!Collection class categoriesFor: #defaultSortAlgorithmClass!instance creation!public! !
!Collection class categoriesFor: #icon!constants!public! !
!Collection class categoriesFor: #initialize!development!initializing!private! !
!Collection class categoriesFor: #with:!instance creation!public! !
!Collection class categoriesFor: #with:with:!instance creation!public! !
!Collection class categoriesFor: #with:with:with:!instance creation!public! !
!Collection class categoriesFor: #with:with:with:with:!instance creation!public! !
!Collection class categoriesFor: #with:with:with:with:with:!instance creation!public! !
!Collection class categoriesFor: #withAll:!instance creation!public! !

Collection class methodProtocol: #'collection factory' attributes: #(#ansi #readOnly) selectors: #(#new #new:)!
Collection class methodProtocol: #'initializeableCollection factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #with: #with:with: #with:with:with: #with:with:with:with: #withAll:)!

