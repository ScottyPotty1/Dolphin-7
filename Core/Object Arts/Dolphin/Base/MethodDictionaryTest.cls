"Filed out from Dolphin Smalltalk 7"!

DictionaryTest subclass: #MethodDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodDictionaryTest guid: (GUID fromString: '{D47DF8C5-DBA6-468F-8BF4-4211E21A132B}')!
MethodDictionaryTest comment: ''!
!MethodDictionaryTest categoriesForClass!Unclassified! !
!MethodDictionaryTest methodsFor!

collectionClass
	^MethodDictionary!

loadFactor
	^0.75!

testClassSizeFor
	"The capacity algorithm should be the minimum power of 2 that allows for 25% slop."

	1 to: 1024
		do: 
			[:size |
			| actualCapacity minimum |
			actualCapacity := self collectionClass sizeFor: size.
			"There must always be a minimum of 25% free"
			minimum := size / self loadFactor.
			self assert: actualCapacity >= minimum.
			"But it mustn't be a larger power of two than necessary"
			self assert: actualCapacity / 2 < minimum]!

testMaintainsLoadFactor
	"At least 25% slop should be maintained."

	| subject method |
	subject := self collectionClass new.
	self assert: 0 equals: subject size.
	self assert: 2 equals: subject basicSize.
	method := Object >> #size.
	"The capacity is increased to the next power of 2 that holds double the current size when the collection grows"
	#(#(#a 2) #(#b 4) #(#c 4) #(#d 8) #(#e 8) #(#f 8) #(#g 16) #(#h 16) #(#i 16) #(#j 16) #(#k 16) #(#l 16) #(#m 32))
		keysAndValuesDo: 
			[:expectedSize :each |
			| minimumSlots actualSlots expectedSlots actualSize |
			expectedSlots := each last.
			minimumSlots := expectedSize / self loadFactor.
			subject at: each first put: method.
			actualSlots := subject basicSize.
			actualSize := subject size.
			self assert: actualSlots >= minimumSlots.
			self assert: expectedSize equals: actualSize.
			self assert: actualSlots / 2 <= minimumSlots.
			self assert: expectedSlots equals: actualSlots]! !
!MethodDictionaryTest categoriesFor: #collectionClass!helpers!private! !
!MethodDictionaryTest categoriesFor: #loadFactor!constants!private! !
!MethodDictionaryTest categoriesFor: #testClassSizeFor!public!unit tests! !
!MethodDictionaryTest categoriesFor: #testMaintainsLoadFactor!public!unit tests! !

