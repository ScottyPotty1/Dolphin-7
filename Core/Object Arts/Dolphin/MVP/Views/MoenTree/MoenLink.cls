"Filed out from Dolphin Smalltalk X6"!

Link subclass: #MoenLink
	instanceVariableNames: 'x y'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MoenLink guid: (GUID fromString: '{68F4AC02-2F95-11D3-93BA-00A024CA708A}')!
MoenLink comment: 'MoenLink is a private helper class that is part of the implementation of the <MoenTreeView>'!
!MoenLink categoriesForClass!Collections-Support!MVP-Views-Support! !
!MoenLink methodsFor!

printOn: aStream
	"Append a textual representation of the receiver to the <puttableStream> argument
	as a developer might want to see it."

	aStream 
		nextPut: $[;
		print: x @ y;
		nextPutAll: '] ';
		print: nextLink!

setX: xInteger y: yInteger
	"Private - Initialize the receiver's instance variables.
	Answer the receiver."

	x := xInteger.
	y := yInteger!

x
	"Private - Answer the x-coordinate"

	^x!

y
	"Private - Answer the y-coordinate."

	^y! !
!MoenLink categoriesFor: #printOn:!development!printing!public! !
!MoenLink categoriesFor: #setX:y:!initializing!private! !
!MoenLink categoriesFor: #x!accessing!private! !
!MoenLink categoriesFor: #y!accessing!private! !

!MoenLink class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^MoenTreeView icon!

x: x y: y nextLink: aLink
	"Answer a new, initialized, instance of the receiver."

	^(self nextLink: aLink) setX: x y: y! !
!MoenLink class categoriesFor: #icon!constants!public! !
!MoenLink class categoriesFor: #x:y:nextLink:!instance creation!public! !

