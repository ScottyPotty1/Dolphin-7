"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaDef
	instanceVariableNames: 'id name isDeprecated comment selector constName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaDef guid: (GUID fromString: '{5D1763E5-2A8B-42E5-9A1C-C1973B7E2D8B}')!
ScintillaDef comment: ''!
!ScintillaDef categoriesForClass!Development! !
!ScintillaDef methodsFor!

comment
	^comment!

comment: aString 
	comment := aString!

constName
	^constName!

constPrefix
	^self subclassResponsibility!

id
	^id!

id: idString name: nameString retType: retString 
	id := idString.
	name := nameString.
	self retType: retString.
	isDeprecated := false.
	constName := self constPrefix , name asUppercase!

isDeprecated
	^isDeprecated!

isDeprecated: aBoolean 
	isDeprecated := aBoolean!

retType: aString 
	^self subclassResponsibility!

selector
	^selector! !
!ScintillaDef categoriesFor: #comment!accessing!public! !
!ScintillaDef categoriesFor: #comment:!accessing!private! !
!ScintillaDef categoriesFor: #constName!helpers!public! !
!ScintillaDef categoriesFor: #constPrefix!constants!private! !
!ScintillaDef categoriesFor: #id!accessing!public! !
!ScintillaDef categoriesFor: #id:name:retType:!initializing!private! !
!ScintillaDef categoriesFor: #isDeprecated!accessing!public!testing! !
!ScintillaDef categoriesFor: #isDeprecated:!accessing!private! !
!ScintillaDef categoriesFor: #retType:!accessing!private! !
!ScintillaDef categoriesFor: #selector!accessing!private! !

!ScintillaDef class methodsFor!

icon
	^ScintillaView icon!

id: anInteger name: nameString retType: retString 
	^self new 
		id: anInteger
		name: nameString
		retType: retString!

tokens: anArray 
	^self 
		id: (anArray at: 3)
		name: (anArray at: 2)
		retType: (anArray at: 1)! !
!ScintillaDef class categoriesFor: #icon!constants!development!public! !
!ScintillaDef class categoriesFor: #id:name:retType:!initializing!public! !
!ScintillaDef class categoriesFor: #tokens:!instance creation!public! !

