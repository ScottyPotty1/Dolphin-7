"Filed out from Dolphin Smalltalk X6"!

Object subclass: #PropertyManager
	instanceVariableNames: 'register'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PropertyManager guid: (GUID fromString: '{87B4C4AB-026E-11D3-9FD7-00A0CC3E4A32}')!
PropertyManager comment: ''!
!PropertyManager categoriesForClass!System-Support! !
!PropertyManager methodsFor!

initialize
	"Private - Initialize the receiver"

	register := (WeakIdentityDictionary new) haveStrongValues; yourself.!

propertyOf: anObject at: aSymbol 
	"Answers a property value matching aSymbol for anObject"

	^self 
		propertyOf: anObject
		at: aSymbol
		ifAbsent: [anObject errorNotFound: aSymbol]!

propertyOf: anObject at: aSymbol ifAbsent: aBlock 
	"Answers a property value matching aSymbol for anObject. If no such property
	exists then aBlock will be evaluated"

	^(register at: anObject ifAbsent: [^aBlock value]) at: aSymbol ifAbsent: aBlock!

propertyOf: anObject at: aSymbol ifAbsentPut: valueOperation 
	"Answers a property value matching aSymbol for anObject. If no such property
	exists then the result of evaluating aBlock will is stored as the value of the
	property, and then answered."

	^(register at: anObject ifAbsentPut: [IdentityDictionary new]) at: aSymbol
		ifAbsentPut: valueOperation!

propertyOf: anObject at: aSymbol put: valueObject 
	"Associates a property valueObject with the property name aSymbol for anObject.
	Answer the valueObject put."

	^(register at: anObject ifAbsentPut: [IdentityDictionary new]) at: aSymbol
		put: valueObject!

removeAllPropertiesOf: anObject
	"Removes all properties for anObject"

	register removeKey: anObject ifAbsent: []
	!

removePropertyOf: anObject at: aSymbol
	"Removes a property value matching aSymbol for anObject"

	self removePropertyOf: anObject at: aSymbol ifAbsent: [anObject errorNotFound: aSymbol]
!

removePropertyOf: anObject at: aSymbol ifAbsent: aBlock
	"Removes a property value matching aSymbol for anObject. If no such property
	exists then aBlock will be evaluated"

	| propertyDict |
	propertyDict := register at: anObject ifAbsent: [^aBlock value].
	propertyDict removeKey: aSymbol ifAbsent: [^aBlock value].
	propertyDict isEmpty ifTrue: [register removeKey: anObject].
	! !
!PropertyManager categoriesFor: #initialize!initializing!private! !
!PropertyManager categoriesFor: #propertyOf:at:!adding!public! !
!PropertyManager categoriesFor: #propertyOf:at:ifAbsent:!adding!public! !
!PropertyManager categoriesFor: #propertyOf:at:ifAbsentPut:!accessing!public! !
!PropertyManager categoriesFor: #propertyOf:at:put:!adding!public! !
!PropertyManager categoriesFor: #removeAllPropertiesOf:!public!removing! !
!PropertyManager categoriesFor: #removePropertyOf:at:!public!removing! !
!PropertyManager categoriesFor: #removePropertyOf:at:ifAbsent:!public!removing! !

!PropertyManager class methodsFor!

new
	"Answers an instance of the receiver; instances require initialization"

	^super new initialize! !
!PropertyManager class categoriesFor: #new!instance creation!public! !

