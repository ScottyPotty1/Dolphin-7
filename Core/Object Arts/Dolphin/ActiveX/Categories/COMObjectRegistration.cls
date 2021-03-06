"Filed out from Dolphin Smalltalk X6"!

Object subclass: #COMObjectRegistration
	instanceVariableNames: 'clsid name toolboxImage'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
COMObjectRegistration guid: (GUID fromString: '{E3AACE46-398D-4CB8-8D6E-D9BF407B92FA}')!
COMObjectRegistration comment: '<COMObjectRegistration> is a simple class to aggregate the registration information for a COM object such as its CLSID and description. It is used in conjunction with the COM Category Manager interface, <ICatInformation>.

Instance Variables:
	clsid		<CLSID>. Coclass guid.
	name		<String>. Short description of the coclass from the registry.
	toolboxBmp	<Image>. Iconic representation for the coclass.

'!
!COMObjectRegistration categoriesForClass!COM Category Manager! !
!COMObjectRegistration methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent (in whatever respect is appropriate for 
	the class of the receiver)."

	^comparand species == self species and: [comparand clsid = self clsid]!

clsid
	"Answer the <CLSID> of the COM component."

	^clsid!

clsid: aCLSID
	"Set the <CLSID> of the COM component."

	clsid := aCLSID!

defaultToolboxBitmap
	^Bitmap new!

description
	"Answer the full type name of the COM component."

	^self getUserType: 1 "USERCLASSTYPE_FULL"
!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	self name displayOn: aStream
!

getUserType: form
	"Private - Answer <readableString> user class type information of the type
	specified by the <integer>, form, which is a value from the USERCLASSTYPE
	enumeration."

	| mem answer hresult |
	mem := COMTaskMemory new.
	hresult := OLELibrary default 
				oleRegGetUserType: clsid
				dwFormOfType: form
				pszUserType: mem.
	answer := hresult < 0 
				ifTrue: ['ERROR: ' , (HRESULT fromInteger: hresult) displayString]
				ifFalse: [(UnicodeString fromAddress: mem) asString].
	mem free.
	^answer!

hash
	"Answer the <integer> hash value for the receiver. By default use the identity hash
	assigned at object creation time, which is temporally invariant."

	^self clsid hash!

name
	"Answer the short type name of the COM component."

	name isNil ifTrue: [name := self getUserType: 2 "USERCLASSTYPE_SHORT"].
	^name

!

printOn: target
	"Append, to the <puttableStream>, target, a string whose characters are a 
	the same as those which would result from sending a #printString
	message to the receiver."

	target
		basicPrint: self;
		nextPut: $(;
		display: self clsid;
		nextPut: $)!

toolboxImage
	"Answer the 16x16 <Bitmap> intended for use in toolboxes as the icon for the control described by the receiver."

	toolboxImage isNil 
		ifTrue: 
			[| toolboxBitmap32 myKey |
			myKey := ((RegKey classesRoot: #read) at: 'CLSID') at: self clsid asString.
			toolboxBitmap32 := myKey at: 'ToolboxBitmap32' ifPresent: [:k | k value].
			toolboxBitmap32 isNil 
				ifTrue: [toolboxImage := self defaultToolboxBitmap]
				ifFalse: 
					["Should be able to use PathParseIconLocation here, but it can't cope with spaces between the path and the icon id."
					| id path pathAndId |
					pathAndId := toolboxBitmap32 subStrings: $,.
					id := Integer readFrom: ((pathAndId last readStream)
										skipSeparators;
										yourself).
					"Some icon ids come back as negative. Why?"
					id < 0 
						ifTrue: [toolboxImage := self defaultToolboxBitmap]
						ifFalse: 
							[| resLib |
							path := File pathBuffer.
							KernelLibrary default 
								expandEnvironmentStrings: pathAndId first
								lpDst: path
								nSize: path byteSize.
							resLib := ExternalResourceLibrary open: path.
							toolboxImage := Bitmap fromId: id in: resLib.
							toolboxImage setMap3DColors: true]]].
	^toolboxImage! !
!COMObjectRegistration categoriesFor: #=!comparing!public! !
!COMObjectRegistration categoriesFor: #clsid!accessing!public! !
!COMObjectRegistration categoriesFor: #clsid:!accessing!public! !
!COMObjectRegistration categoriesFor: #defaultToolboxBitmap!accessing!public! !
!COMObjectRegistration categoriesFor: #description!accessing!public! !
!COMObjectRegistration categoriesFor: #displayOn:!displaying!public! !
!COMObjectRegistration categoriesFor: #getUserType:!accessing!private! !
!COMObjectRegistration categoriesFor: #hash!comparing!public! !
!COMObjectRegistration categoriesFor: #name!accessing!public! !
!COMObjectRegistration categoriesFor: #printOn:!printing!public! !
!COMObjectRegistration categoriesFor: #toolboxImage!accessing!public! !

!COMObjectRegistration class methodsFor!

clsid: aCLSID
	"Answer a new instance of the receiver for the specified class id."

	^self new clsid: aCLSID; yourself! !
!COMObjectRegistration class categoriesFor: #clsid:!instance creation!public! !

