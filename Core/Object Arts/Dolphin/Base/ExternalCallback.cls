"Filed out from Dolphin Smalltalk X6"!

Object subclass: #ExternalCallback
	instanceVariableNames: 'thunk cookie descriptor'
	classVariableNames: 'ArgSizeOffset MaxThunks Registry ThunkBase ThunkSize'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
ExternalCallback guid: (GUID fromString: '{87B4C486-026E-11D3-9FD7-00A0CC3E4A32}')!
ExternalCallback comment: ''!
!ExternalCallback categoriesForClass!System-Support! !
!ExternalCallback methodsFor!

argumentCount
	"Private - Answer the number of arguments expected by the receiver."

	^descriptor argumentCount!

argumentsSize
	"Private - Answer the total size of the receiver's arguments (when
	pushed on the stack)."

	^descriptor argumentsSize!

argumentTypes
	"Private - Answer a collection of the argument types expected by the receiver."

	^descriptor argumentTypes!

asParameter
	"Answer the receiver in a form suitable for passing as a callback function."

	^self thunk!

callingConvention
	"Private - Answer the number of arguments expected by the receiver."

	^descriptor callingConvention!

cookie
	"Answer the callbacks unique (among callbacks) magic cookie (actually an index 
	into the callback registry). This is not private, as it may be useful for some
	user code."

	^cookie!

cookie: anInteger 
	"Private - Set the callbacks magic cookie. Answer the receiver."

	anInteger > MaxThunks 
		ifTrue: [self error: 'Insufficient callback thunks; increase ExternalCallback.MaxThunks and restart'].
	cookie := anInteger!

descriptor
	"Private - Answer the external function descriptor of the callback function which the receiver
	represents. See ExternalMethod for further details of argument types etc."

	^descriptor!

descriptor: anExternalFunctionDescriptor
	"Private - Set the external function descriptor of the callback function which the receiver
	represents. See ExternalMethod for further details of argument types etc."

	descriptor := anExternalFunctionDescriptor!

free
	"Explicitly free any resources consumed by the receiver as it is no longer required.
	Sending this message reduces the load on the MemoryManager, but it is not 
	strictly necessary. Do not free a callback that is still use!!"

	"There is no process sync problem here because the receiver cannot be GC'd while
	in this method, and therefore it cannot be replaced in the registry by another
	callback"

	(Registry at: cookie ifAbsent: []) == self
		ifTrue: [Registry removeAtIndex: cookie].
	thunk := nil!

makeProcInstance
	"Private - Allocate a callback thunk for the receiver from the block in fixed, executable,
	memory."

	thunk := (ThunkBase asInteger + ((cookie - 1) * ThunkSize)) asExternalAddress.
	descriptor calleeCleans ifTrue: [thunk wordAtOffset: ArgSizeOffset put: self argumentsSize]!

thunk
	"Private - Answer the receiver's assembler thunk."

	thunk isNil ifTrue: [self makeProcInstance].
	^thunk!

valueWithArgumentsAt: anAddress
	"Private - Evaluate the receiver with arguments instantiated from the raw data at anAddress.
	For performance and consistency (with outbound external calls) reasons, we use a VM supplied
	primitive to instantiate and push the arguments and perform the message, but there is no reason
	that this cannot be done in Smalltalk if different argument conversions are required. The standard
	conversions are the same as those performed for return types by the external call primitive (see
	the ExternalLibrary class)."

	^self subclassResponsibility! !
!ExternalCallback categoriesFor: #argumentCount!accessing!private! !
!ExternalCallback categoriesFor: #argumentsSize!accessing!private! !
!ExternalCallback categoriesFor: #argumentTypes!accessing!private! !
!ExternalCallback categoriesFor: #asParameter!converting!public! !
!ExternalCallback categoriesFor: #callingConvention!accessing!private! !
!ExternalCallback categoriesFor: #cookie!accessing!public! !
!ExternalCallback categoriesFor: #cookie:!accessing!private! !
!ExternalCallback categoriesFor: #descriptor!accessing!private! !
!ExternalCallback categoriesFor: #descriptor:!accessing!private! !
!ExternalCallback categoriesFor: #free!public!realizing/unrealizing! !
!ExternalCallback categoriesFor: #makeProcInstance!private!realizing/unrealizing! !
!ExternalCallback categoriesFor: #thunk!converting!private! !
!ExternalCallback categoriesFor: #valueWithArgumentsAt:!evaluating!private! !

!ExternalCallback class methodsFor!

allocateThunks
	"Private - Allocate and populate a block of memory with callback thunks. Note that the
	memory is executable to avoid issues with Data Execution Protection. on XP SP2 and 2K3.

	self allocateThunks "

	| procAddress |
	self deallocateThunks.
	ThunkBase := KernelLibrary default 
				virtualAlloc: 0
				dwSize: MaxThunks * ThunkSize
				flAllocationType: MEM_COMMIT
				flProtect: PAGE_EXECUTE_READWRITE.
	procAddress := VMLibrary default getGenericCallback.
	1 to: MaxThunks
		do: 
			[:i | 
			| offset |
			offset := ThunkSize * (i - 1) - 1.
			"push esp - value of esp saved is that before push"
			ThunkBase byteAtOffset: (offset := offset + 1) put: 16r54.
			"push <callback id>"
			ThunkBase
				byteAtOffset: (offset := offset + 1) put: 16r68;
				dwordAtOffset: (offset := offset + 1) put: i.
			"Calls normally have a relative displacement (unless far) so call through a
			register with 'mov eax GenericCallback; call eax' sequence"
			ThunkBase
				byteAtOffset: (offset := offset + 4) put: 16rB8;
				dwordAtOffset: (offset := offset + 1) put: procAddress.
			ThunkBase
				byteAtOffset: (offset := offset + 4) put: 16rFF;
				byteAtOffset: (offset := offset + 1) put: 16rD0.
			"ret <argsSize>; argument size will be substituted when thunk allocated to
			particular callback"
			ThunkBase
				byteAtOffset: (offset := offset + 1) put: 16rC2;
				wordAtOffset: (offset := offset + 1) put: 0]!

block: aBlockClosure argumentTypes: aString
	"Answer a new subinstance of the receiver appropriate for dispatching callbacks
	to the block, aBlockClosure, with the specified argument types."

	^(BlockCallback new)
		block: aBlockClosure;
		descriptor: (self descriptorClass argumentTypes: aString);
		yourself!

block: aBlockClosure descriptor: anExternalDescriptor
	"Answer a new subinstance of the receiver appropriate for dispatching callbacks
	to the block, aBlockClosure, with the specified descriptor."

	^(BlockCallback new)
		block: aBlockClosure;
		descriptor: anExternalDescriptor;
		yourself!

callback: anInteger withArgumentsAt: anAddress
	"Private - Ask the receiver's instance with the cookie, anInteger, to evaluate itself
	with arguments constructed from the raw data at anAddress (in the stack)"

	^(self fromCookie: anInteger) valueWithArgumentsAt: anAddress!

callbackPrimitive
	"Private - Answer the index of the callback method primitive (which is only a marker)."

	^0!

clear
	"Private - Clear down the registry of outstanding instances of the receiver.

	WARNING: THIS IS LIKELY TO REDUCE THE EFFECTIVENESS OF A RUNNING IMAGE!!"

	Registry := WeakRegistry new!

deallocateThunks
	ThunkBase isNil ifTrue: [^self].
	KernelLibrary default 
		virtualFree: ThunkBase
		dwSize: 0
		dwFreeType: MEM_RELEASE.
	ThunkBase := nil!

descriptorClass
	"Private - Answer the class used to build and represent function descriptors."

	^ExternalDescriptor!

fromCookie: anInteger
	"Answer the receiver's registered instance with the cookie, anInteger. If there is no such
	instance, raise a NotFoundError/BoundsError."

	| inst |
	inst := Registry at: anInteger.
	^inst isNil 
		ifTrue: [self errorNotFound: anInteger]
		ifFalse: [inst]
!

initialize
	"Private - Initialize the receiver's class variables.
		ExternalCallback initialize
	"

	ThunkSize := 16.
	self assert: [(4096 rem: ThunkSize) = 0].
	"The maximum number of callback that can be allocated at any one time is limited by
	MaxThunks. If insufficient, increase by a multiple of 256 and restart."
	MaxThunks := 256.
	self assert: [(ThunkSize * MaxThunks rem: 4096) = 0].
	Registry isNil ifTrue: [self clear].
	ArgSizeOffset := ThunkSize - 2!

new
	"Answer a new registered instance of the receiver with a unique magic cookie."

	| answer |
	answer := self basicNew.
	answer cookie: (self register: answer).
	^answer!

onStartup
	"Private - The system is starting. Perform necessary initialization.
	We clear down old callbacks as these can no longer be valid. We must
	also re-establish the VM entry point proc. address, as this may change."

	ThunkBase := nil.
	self allocateThunks.
	self clear!

receiver: anObject selector: aSymbol descriptor: anExternalDescriptor
	"Answer a new instance of the receiver configured to send the <selector>, aSymbol,
	to the <Object>, anObject, when invoked as a callback with descriptor, anExternalDescriptor."

	^(MessageCallback new)
		receiver: anObject;
		selector: aSymbol;
		descriptor: anExternalDescriptor;
		yourself!

register: instance
	"Private - Register the subinstance of the receiver, instance, answering its
	unique integer cookie."

	^Registry addAnsweringIndex: instance! !
!ExternalCallback class categoriesFor: #allocateThunks!helpers!private! !
!ExternalCallback class categoriesFor: #block:argumentTypes:!instance creation!public! !
!ExternalCallback class categoriesFor: #block:descriptor:!instance creation!public! !
!ExternalCallback class categoriesFor: #callback:withArgumentsAt:!operations!private! !
!ExternalCallback class categoriesFor: #callbackPrimitive!constants!private! !
!ExternalCallback class categoriesFor: #clear!initializing!private! !
!ExternalCallback class categoriesFor: #deallocateThunks!initializing!private! !
!ExternalCallback class categoriesFor: #descriptorClass!constants!private! !
!ExternalCallback class categoriesFor: #fromCookie:!accessing!public! !
!ExternalCallback class categoriesFor: #initialize!development!initializing!public! !
!ExternalCallback class categoriesFor: #new!instance creation!public! !
!ExternalCallback class categoriesFor: #onStartup!event handling!public! !
!ExternalCallback class categoriesFor: #receiver:selector:descriptor:!instance creation!public! !
!ExternalCallback class categoriesFor: #register:!instance creation!private! !

