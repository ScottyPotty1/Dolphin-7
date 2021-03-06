"Filed out from Dolphin Smalltalk X6.2"!

ODBBTreeIterator subclass: #ODBClassInfoFile
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBClassInfoFile guid: (GUID fromString: '{8162EE22-0FB8-11D4-B091-000000000000}')!
ODBClassInfoFile comment: ''!
!ODBClassInfoFile categoriesForClass!No category! !
!ODBClassInfoFile methodsFor!

created
	"Private - File has just been created."

	(self pageClass 
		createOnFile: self
		position: rootPagePosition
		keyLength: keyLength
		valueLength: valueLength) store.
	currentKey := ByteArray new: keyLength.
	stream flush!

descriptionString
	^'Class Info File
OmniBase 1.0, David Gorisek (c) 1998

'!

initialize
	"Private - Initialize receiver."

	super initialize.
	keyLength := 128.
	valueLength := 4.
	rootPagePosition := self headerLength!

opened
	! !
!ODBClassInfoFile categoriesFor: #created!public! !
!ODBClassInfoFile categoriesFor: #descriptionString!public! !
!ODBClassInfoFile categoriesFor: #initialize!public! !
!ODBClassInfoFile categoriesFor: #opened!public! !

