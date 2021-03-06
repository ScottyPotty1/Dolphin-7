"Filed out from Dolphin Smalltalk X6"!

COMFunctionAbstract subclass: #UnkAddRefFunction
	instanceVariableNames: ''
	classVariableNames: 'Descriptor'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UnkAddRefFunction guid: (GUID fromString: '{19C5E908-2DB4-4E67-8984-B11C9CF2E982}')!
UnkAddRefFunction comment: 'COMAddRefFunction is a specialized class of <COMFunction> intended to represent the IUnknown::AddRef() method.

As IUnknown is implemented entirely by the <COMObjectStub>, a COMAddRefFunction sends a #AddRef message to the relevant stub.'!
!UnkAddRefFunction categoriesForClass!COM-Implementations! !
!UnkAddRefFunction methodsFor!

callback: stub interface: aCOMInterface withArgumentsAt: pArgs
	"Private - Send an IUnknown::AddRef() call as an #AddRef message back to 
	the <COMObjectStub>, stub. Answer the resulting reference count.

	Implementation Note: This method is called very frequently, so we have a special function
	class just to improve performance."

	^stub AddRef!

descriptor
	"Private - Answer the descriptor object which described the external function represented
	by the receiver."

	^Descriptor!

selector
	"Private - Answer the selector sent when the receiver is evaluated."

	^#AddRef! !
!UnkAddRefFunction categoriesFor: #callback:interface:withArgumentsAt:!evaluating!private! !
!UnkAddRefFunction categoriesFor: #descriptor!accessing!private! !
!UnkAddRefFunction categoriesFor: #selector!accessing!private! !

!UnkAddRefFunction class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	Descriptor := IUnknown descriptorClass
				callingConvention: IUnknown stdMethodCallType
				returnType: 'dword'
				argumentTypes: ''!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Descriptor := nil! !
!UnkAddRefFunction class categoriesFor: #initialize!development!initializing!private! !
!UnkAddRefFunction class categoriesFor: #uninitialize!accessing!class hierarchy-removing!private! !

