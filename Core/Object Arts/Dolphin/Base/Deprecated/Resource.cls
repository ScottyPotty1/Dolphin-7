"Filed out from Dolphin Smalltalk X6"!

Object subclass: #Resource
	instanceVariableNames: 'accessor icon'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Resource guid: (GUID fromString: '{87B4C4AF-026E-11D3-9FD7-00A0CC3E4A32}')!
Resource comment: ''!
!Resource categoriesForClass!MVP-Resources! !
!Resource methodsFor!

accessor
	"Private - Answer the receiver's accessor instance var. This is the object that contains
	the wherewithall to perform the actual load."

	^accessor!

accessor: aResourceAccessor
	"Private - Set the receiver's accessor instance var to aResourceAccessor. This is the object that contains
	the wherewithall to perform the actual load."

	accessor := aResourceAccessor!

asInternalResource
	"Answer a new instance whose accessor is internal to the image."

	| newResource |
	(newResource := self shallowCopy)
		accessor: accessor asInternalAccessor.
	^newResource!

assignToResourceIdentifier: aResourceIdentifier
	"Private - Assign the receiver, as a binary resource array, to aResourceIdentifier"

	aResourceIdentifier assignBinaryResourceData: self!

canSave
	"Answer whether the receiver represents a resource which can be updated"

	^accessor canSave!

copy
	"Private - Answer a copy of the receiver suitable for putting on the ResourceManager clipboard."

	^super copy
		accessor: accessor copy;
		yourself!

defaultContext
	"Private - Answer the default context to use when one is not provided."

	^nil!

edit: aResourceIdentifier
	"Invoke a suitable editor to edit the receiver with the given identity."

	^self subclassResponsibility!

icon
	"Answer the icon used to represent this resource"

	^icon ifNil: [super icon]!

icon: anIcon
	"Set the the icon used to represent this resource"

	icon := anIcon!

isChanged
	"Answer whether the resource has been changed since it was last saved to disk."

	^accessor isChanged!

isChanged: aBoolean
	"Flag the receiver as changed or not changed, according to the value 
	of the <Boolean> argument."

	^accessor isChanged: aBoolean!

isInternalResource
	"Answer whether the receiver represents a resource which is held internally in the image"

	^accessor isInternalAccessor!

load
	"Load an instance of the resource represented by the receiver."

	^self loadWithContext: self defaultContext!

loadWithContext: context 
	"Load the resource represented by the receiver with context as its target context."

	^self loadWithContext: context forEdit: false!

loadWithContext: context forEdit: aBoolean 
	^accessor loadWithContext: context forEdit: aBoolean!

makeByteArray
	"Store the resource represented by the receiver in a byteArray accessed via a
	ResourceSTBByteArrayAccessor."

	accessor
		makeByteArrayClass: self class
		usingContext: self defaultContext!

makeFile: aResourceIdentifier
	"Store the resource represented by the receiver in an STBFile accessed via a
	ResourceSTBFileAccessor. The name of the file should be based on aResourceIdentifier."

	self makeFilename: (self class generateFileNameFrom: aResourceIdentifier)
!

makeFilename: aStringFilename
	"Store the resource represented by the receiver in an STBFile accessed via a
	ResourceSTBFileAccessor on aStringFilename."

	accessor
		makeFile: aStringFilename
		class: self class
		usingContext: self defaultContext!

resave
	"Loads and saves the receiver"

	self save: self load
!

save: anObject
	"Save anObject as the resource represented by the receiver. At the same time extract
	a default icon to use to represent this resource"

	accessor save: anObject as: self class.
	self icon: anObject icon.!

show: aResourceIdentifier
	"Display the receiver in a suitable manner with the given identity."

	^self subclassResponsibility! !
!Resource categoriesFor: #accessor!accessing!private! !
!Resource categoriesFor: #accessor:!accessing!private! !
!Resource categoriesFor: #asInternalResource!converting!public! !
!Resource categoriesFor: #assignToResourceIdentifier:!private! !
!Resource categoriesFor: #canSave!public!testing! !
!Resource categoriesFor: #copy!operations!private! !
!Resource categoriesFor: #defaultContext!constants!private! !
!Resource categoriesFor: #edit:!operations!public! !
!Resource categoriesFor: #icon!accessing!public! !
!Resource categoriesFor: #icon:!accessing!public! !
!Resource categoriesFor: #isChanged!public!testing! !
!Resource categoriesFor: #isChanged:!accessing!public! !
!Resource categoriesFor: #isInternalResource!public!testing! !
!Resource categoriesFor: #load!operations!public! !
!Resource categoriesFor: #loadWithContext:!operations!public! !
!Resource categoriesFor: #loadWithContext:forEdit:!operations!public! !
!Resource categoriesFor: #makeByteArray!mutating!public! !
!Resource categoriesFor: #makeFile:!development!mutating!public! !
!Resource categoriesFor: #makeFilename:!mutating!public! !
!Resource categoriesFor: #resave!operations!public! !
!Resource categoriesFor: #save:!operations!public! !
!Resource categoriesFor: #show:!operations!public! !

!Resource class methodsFor!

copyAllToClipboard: aCollection 
	"Create new instances of the receiver for each of the elements of aCollection.
    	with a ResourceSTBByteArrayAccessor and save it to the ResourceManager's clipboard."

	| resourceManager |
	(resourceManager := SessionManager current resourceManager) clearClipboard.
	aCollection do: 
			[:each | 
			| res |
			(res := self inSTBByteArray) save: each.
			resourceManager addToClipboard: (InternalDragDropObject object: res)]!

copyToClipboard: anObject
    	"Create a new instance of the receiver with a ResourceSTBByteArrayAccessor and save it to the
    	ResourceManager's clipboard."
    
    	| res |
    	res := self inSTBByteArray
    		save: anObject;
    		yourself.
    	SessionManager current resourceManager
    		clearClipboard;
    		addToClipboard: (InternalDragDropObject object: res).
    !

createdFromClass: aClass selector: selector
	"Answer an instance of the receiver which will create new object on each call to #load
	or #loadWithContext:. The new object is created by sending selector to aClass with a
	parameter of the context passed to #loadWithContext:."

	^super new
		accessor: (ResourceGeneratorAccessor class: aClass selector: selector);
		yourself!

defaultWritable
	"Answer a writable resource suitable for containing a resource.
	By default, Resources are stored in a ByteArray in the image."

	^self inSTBByteArray!

dummy
	"Answer an instance of the receiver which will directly hold its resource data."

	^super new
		accessor: ResourceDummyAccessor new;
		yourself!

fileExtension
	"Private - Answer the file extension associated with resources of this type when
	stored in files. Must be overridden by subclasses as necessary."

	^'stb'!

generateFileNameFrom: aResourceIdentifier 
	"Private - Answer a file name suitable for holding the resource identified by aResourceIdentifier."

	| package |
	package := Package manager packageOfResourceIdentifierOrItsClass: aResourceIdentifier.
	^self generateFilenameFrom: aResourceIdentifier inPackage: package!

generateFilenameFrom: aResourceIdentifier inPackage: package 
	| path |
	path := package isNil ifTrue: [''] ifFalse: [package path].
	^File 
		composePath: path
		stem: aResourceIdentifier displayString
		extension: self fileExtension!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

inSTBByteArray
	"Answer an instance of the receiver which will save/load its resource data to a
	ByteArray in STB format."

	^super new
		accessor: ResourceSTBByteArrayAccessor new;
		yourself!

inSTBFileWithName: aFileName
	"Answer an instance of the receiver which will save/load its resource data to/from an STB file
	with name aFileName."

	^super new
		accessor: (ResourceSTBFileAccessor onFileName: aFileName);
		yourself!

inSTBFileWithNameBasedOn: aResourceIdentifier
	"Answer an instance of the receiver which will save/load its resource data to/from an STB file
	whose name is based on aResourceIdentifier."

	^self inSTBFileWithName: (self  generateFileNameFrom: aResourceIdentifier)!

save: anObject toFiler: anSTBOutFiler
	"Private - Save anObject to the STBOutFiler provided."

	anSTBOutFiler nextPut: anObject!

stbConvertFrom: anSTBClassFormat 
	"Convert from version 0 Resource. Version 1 adds an icon instance var"

	^
	[:data | 
	| newInstance |
	newInstance := self basicNew.
	1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
	newInstance]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !
!Resource class categoriesFor: #copyAllToClipboard:!copying!public! !
!Resource class categoriesFor: #copyToClipboard:!binary filing!public! !
!Resource class categoriesFor: #createdFromClass:selector:!instance creation!public! !
!Resource class categoriesFor: #defaultWritable!instance creation!public! !
!Resource class categoriesFor: #dummy!instance creation!public! !
!Resource class categoriesFor: #fileExtension!constants!private! !
!Resource class categoriesFor: #generateFileNameFrom:!development!filename manipulation!private! !
!Resource class categoriesFor: #generateFilenameFrom:inPackage:!development!filename manipulation!private! !
!Resource class categoriesFor: #icon!constants!public! !
!Resource class categoriesFor: #inSTBByteArray!instance creation!public! !
!Resource class categoriesFor: #inSTBFileWithName:!instance creation!public! !
!Resource class categoriesFor: #inSTBFileWithNameBasedOn:!development!instance creation!public! !
!Resource class categoriesFor: #save:toFiler:!binary filing!private! !
!Resource class categoriesFor: #stbConvertFrom:!binary filing!public! !
!Resource class categoriesFor: #stbVersion!binary filing!public! !

