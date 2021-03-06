"Filed out from Dolphin Smalltalk 7"!

OLECountedArray subclass: #CALPOLESTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CALPOLESTR guid: (GUID fromString: '{B4CB3D32-BC0E-4C28-8F52-10F224F37E2F}')!
CALPOLESTR comment: '<CALPOLESTR> is an <ExternalStructure> class to wrap the struct ''OCIDL.CALPOLESTR'' from type information in the ''OCIDL Library'' library.

CALPOLESTR is a counted array of Unicode strings. For an example usage see IPerPropertyBrowsing.'!
!CALPOLESTR categoriesForClass!OCIDL-Structs! !
!CALPOLESTR methodsFor!

basicFree
	"Private - Free external resources owned by the receiver.
	Not only is the array allocated from the task heap, but also each of the individual strings in it."

	| allocator pElems |
	allocator := COMTaskMemory allocator.
	pElems := self pElems.
	0 to: self length - 1
		do: [:i | allocator Free: (pElems uintPtrAtOffset: i * VMConstants.IntPtrSize)].
	super basicFree!

getElements
	"Private - Answer the receiver's <ExternalArray> of elements."

	^StructureArray 
		fromAddress: self pElems
		length: self cElems
		elementClass: self elementClass! !
!CALPOLESTR categoriesFor: #basicFree!private!realizing/unrealizing! !
!CALPOLESTR categoriesFor: #getElements!accessing!private! !

!CALPOLESTR class methodsFor!

defineFields
	"Define the fields of the CALPOLESTR structure.
		CALPOLESTR compileDefinition
	
		typedef 		struct tagCALPOLESTR {
			unsigned long cElems;
			LPWSTR* pElems;
		} CALPOLESTR;

	"

	"Element type is different, but override with hand-coded accessor"
	super defineFields.!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^LPWSTR
! !
!CALPOLESTR class categoriesFor: #defineFields!initializing!public! !
!CALPOLESTR class categoriesFor: #elementClass!constants!public! !

