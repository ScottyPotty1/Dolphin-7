"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #PointTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PointTest guid: (GUID fromString: '{98F92001-3F3A-4296-8A76-5E67F93030A6}')!
PointTest comment: 'This is the unit test for the class Point. Unit tests are a good way to exercise the functionality of your system in a repeatable and automatic manner. They are therefore recommended if you plan to release anything. For more information, see: 
	- http://www.c2.com/cgi/wiki?UnitTest
	- http://minnow.cc.gatech.edu/squeak/1547
	- the sunit class category'!
!PointTest categoriesForClass!Unclassified! !
!PointTest methodsFor!

testAbs

	self assert: (0@0) abs = (0@0).
	self assert: (1@1) abs = (1@1).
	self assert: (-1@1) abs = (1@1).
	self assert: (1@-1) abs = (1@1).
	self assert: (-1@-1) abs = (1@1).!

testEquals
	self assert: 0 @ 0 = 0.
	self assert: 0 = (0 @ 0).
	self assert: 1 @ 1 = (1 @ 1).
	self assert: 1 @ 2 ~= (2 @ 1).
	self assert: 1 @ 2 ~= 1.5!

testIsZero
	self assert: (0 @ 0) isZero.
	self deny: (0 @ 1) isZero.
	self deny: (1 @ 0) isZero.
	self deny: (1 @ 1) isZero! !
!PointTest categoriesFor: #testAbs!public!unit tests! !
!PointTest categoriesFor: #testEquals!public!unit tests! !
!PointTest categoriesFor: #testIsZero!public!testing / testing! !

