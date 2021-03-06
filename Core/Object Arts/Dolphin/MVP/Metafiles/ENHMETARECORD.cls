"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #ENHMETARECORD
	instanceVariableNames: ''
	classVariableNames: 'RecordTypes'
	poolDictionaries: 'EnhancedMetafileRecordTypes'
	classInstanceVariableNames: ''!
ENHMETARECORD guid: (GUID fromString: '{5A360B92-6A3D-40D5-9D88-972FFD1416E6}')!
ENHMETARECORD comment: '<ENHMETARECORD> is an <ExternalStructure> class to wrap the base struct for all the Enhanced Metafile record structs.'!
!ENHMETARECORD categoriesForClass!Win32-Structs! !
!ENHMETARECORD methodsFor!

getField: fieldNameString 
	"Private - Answer the value of the named field of the receiver,
	or if there is no such field then raise an exception."

	| selector |
	selector := fieldNameString asSymbol.
	selector == #iType 
		ifTrue: [(EnhancedMetafileRecordTypes keyAtValue: self iType ifAbsent: []) ifNotNil: [:name | ^name]].
	^self perform: selector!

iType
	"Answer the receiver's iType field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

iType: anObject 
	"Set the receiver's iType field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

nSize
	"Answer the receiver's nSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nSize)!

nSize: anObject 
	"Set the receiver's nSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nSize) put: anObject! !
!ENHMETARECORD categoriesFor: #getField:!accessing!private! !
!ENHMETARECORD categoriesFor: #iType!**compiled accessors**!public! !
!ENHMETARECORD categoriesFor: #iType:!**compiled accessors**!public! !
!ENHMETARECORD categoriesFor: #nSize!**compiled accessors**!public! !
!ENHMETARECORD categoriesFor: #nSize:!**compiled accessors**!public! !

!ENHMETARECORD class methodsFor!

defineFields
	"Define the fields of the EMR structure.

	self  compileDefinition

		typedef [uuid(5A360B92-6A3D-40D5-9D88-972FFD1416E6)]
		struct tagEMR {
			[helpstring('Enhanced metafile record type')] DWORD iType;
			[helpstring('Length of the record in bytes. This must be a multiple of 4.')] DWORD nSize;
		} EMR;
"

	self
		defineField: #iType type: DWORDField new offset: 0;
		defineField: #nSize type: DWORDField new offset: 4.
	self byteSize: 8!

initialize
	RecordTypes := Array new: EMR_MAX!

initializeAfterLoad
	"Perform any post-load initialisation for the class.
	In this case we set up the function table now to avoid overhead of lazy init. test
	init. on every virtual function callback."

	super initializeAfterLoad.
	"Record any newly loaded subclass in the record types table"
	self == ##(self) ifFalse: [self registerRecordTypes]!

iTypes
	"Answer an collection of the integer enhanced metafile record type ids that this class can represent."

	^(Array 
		with: EMR_ABORTPATH
		with: EMR_BEGINPATH
		with: EMR_ENDPATH
		with: EMR_CLOSEFIGURE
		with: EMR_FLATTENPATH) , (Array 
					with: EMR_WIDENPATH
					with: EMR_SETMETARGN
					with: EMR_SAVEDC
					with: EMR_REALIZEPALETTE)!

registerRecordTypes
	self iTypes do: [:each | RecordTypes at: each put: self]!

uninitializeBeforeRemove
	"Perform any pre-removal uninitialisation for the class."

	self unregisterRecordTypes.
	super uninitializeBeforeRemove!

unregisterRecordTypes
	self iTypes do: [:each | RecordTypes at: each put: nil]! !
!ENHMETARECORD class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!ENHMETARECORD class categoriesFor: #initialize!public! !
!ENHMETARECORD class categoriesFor: #initializeAfterLoad!initializing!public! !
!ENHMETARECORD class categoriesFor: #iTypes!constants!public! !
!ENHMETARECORD class categoriesFor: #registerRecordTypes!initializing!private! !
!ENHMETARECORD class categoriesFor: #uninitializeBeforeRemove!class hierarchy-removing!public! !
!ENHMETARECORD class categoriesFor: #unregisterRecordTypes!accessing!private! !

