"Filed out from Dolphin Smalltalk X6"!

ResourceSTBAccessor subclass: #ResourceSTBByteArrayAccessor
	instanceVariableNames: 'byteArray'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ResourceSTBByteArrayAccessor guid: (GUID fromString: '{87B4C6D9-026E-11D3-9FD7-00A0CC3E4A32}')!
ResourceSTBByteArrayAccessor comment: ''!
!ResourceSTBByteArrayAccessor categoriesForClass!MVP-Resources! !
!ResourceSTBByteArrayAccessor methodsFor!

byteArray
	"Private - Answer the receiver's byteArray inst var."

	^byteArray!

byteArray: aByteArray
	"Private - Set the receiver's byteArray inst var to aByteArray. This is the STB format
	data file from which the receiver will load instances of the resource."

	byteArray := aByteArray!

makeByteArrayClass: aResourceClass usingContext: context
	"Private - Mutate the receiver to a ResourceSTBByteArrayAccessor using the context to load
	the resource (if required), and the resources class aResourceClass to resave it."

	^self!

makeFile: aString class: aResourceClass usingContext: context
	"Private - Mutate the receiver to a ResourceSTBFileAccessor using the context to load
	the resource (if required), and the resources class aResourceClass to resave it into
	an STB file named aString."

	| stream |
	stream := FileStream write: aString text: false.
	[
		stream nextPutAll: byteArray
	] ensure: [stream close].

	self become: (ResourceSTBFileAccessor onFileName: aString)
!

postCopy
	super postCopy.
	byteArray := byteArray copy.
	^self!

readStream
	^byteArray readStream!

save: anObject as: aResourceClass 
	"Save out anObject in the format dictated by aResourceClass."

	| stream |
	stream := ByteArray writeStream: 256.
	self 
		save: anObject
		as: aResourceClass
		on: stream.
	byteArray := stream contents.
	self isChanged: true!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler.
	The proxy is required so that we can propagate the codebase of the loading
	STBInFiler into the reconstituted accessor thus allowing us to resolve remote
	class references within a resource."

	anSTBOutFiler saveObject: self as: (STBResourceSTBByteArrayAccessorProxy forAccessor: self)! !
!ResourceSTBByteArrayAccessor categoriesFor: #byteArray!accessing!private! !
!ResourceSTBByteArrayAccessor categoriesFor: #byteArray:!accessing!private! !
!ResourceSTBByteArrayAccessor categoriesFor: #makeByteArrayClass:usingContext:!mutating!private! !
!ResourceSTBByteArrayAccessor categoriesFor: #makeFile:class:usingContext:!mutating!private! !
!ResourceSTBByteArrayAccessor categoriesFor: #postCopy!copying!private! !
!ResourceSTBByteArrayAccessor categoriesFor: #readStream!accessing!private! !
!ResourceSTBByteArrayAccessor categoriesFor: #save:as:!operations!public! !
!ResourceSTBByteArrayAccessor categoriesFor: #stbSaveOn:!binary filing!public! !

!ResourceSTBByteArrayAccessor class methodsFor!

onByteArray: aByteArray
	"Answer a new instance of the receiver capable of loading instances from the
	data in STB format in aByteArray."

	^self new
		byteArray: aByteArray
		yourself!

stbConvertFromVersion1: version1Array
	"Private - Convert version1Array to version 2 format and answer the new Array.

	instVarAt:	Version 2		Version 1
	----------	---------		---------
		1		flags		flags
		2		classLocator	byteArray
		3		byteArray"

	^Array
		with: (version1Array at: 1)
		with: ClassLocator new
		with: (version1Array at: 2)!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^2! !
!ResourceSTBByteArrayAccessor class categoriesFor: #onByteArray:!instance creation!public! !
!ResourceSTBByteArrayAccessor class categoriesFor: #stbConvertFromVersion1:!binary filing!private! !
!ResourceSTBByteArrayAccessor class categoriesFor: #stbVersion!binary filing!public! !

