"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRELLIPSE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRELLIPSE guid: (GUID fromString: '{23D57DDC-4A1E-4927-AE53-094C3485EBB1}')!
EMRELLIPSE comment: '<EMRELLIPSE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRELLIPSE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney�s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(23D57DDC-4A1E-4927-AE53-094C3485EBB1)]
struct tagEMRELLIPSE {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounding rectangle")] RECTL rclBox;
} EMRELLIPSE;
'!
!EMRELLIPSE categoriesForClass!Win32-Structs! !
!EMRELLIPSE methodsFor!

rclBox
	"Answer the receiver's rclBox field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBox)!

rclBox: anObject 
	"Set the receiver's rclBox field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBox) + 1)
		to: ##((self offsetOf: #rclBox) + RECT basicByteSize)
		startingAt: 1! !
!EMRELLIPSE categoriesFor: #rclBox!**compiled accessors**!public! !
!EMRELLIPSE categoriesFor: #rclBox:!**compiled accessors**!public! !

!EMRELLIPSE class methodsFor!

defineFields
	"Define the fields of the EMRELLIPSE structure.

	EMRELLIPSE  compileDefinition

		typedef [uuid(23D57DDC-4A1E-4927-AE53-094C3485EBB1)]
		struct tagEMRELLIPSE {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounding rectangle')] RECTL rclBox;
		} EMRELLIPSE;
"

	super defineFields.
	self
		defineField: #rclBox type: (StructureField type: RECT) offset: 8.
	self byteSize: 24!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_ELLIPSE with: EMR_RECTANGLE! !
!EMRELLIPSE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRELLIPSE class categoriesFor: #iTypes!constants!public! !

