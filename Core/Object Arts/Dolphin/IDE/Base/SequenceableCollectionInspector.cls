"Filed out from Dolphin Smalltalk X6"!

BasicInspector subclass: #SequenceableCollectionInspector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequenceableCollectionInspector guid: (GUID fromString: '{87B4C696-026E-11D3-9FD7-00A0CC3E4A32}')!
SequenceableCollectionInspector comment: 'SequenceableCollectionInspector is a <compositePresenter> that implements a specialised inspect facility onto a <SequenceableCollection>. This allows the collection to be inspected via its integer indices.'!
!SequenceableCollectionInspector categoriesForClass!Development!MVP-Presenters! !
!SequenceableCollectionInspector methodsFor!

getField: anInteger
	"Private - Answer the field of the receiver's object which has the key at index
	anInteger in the field list (1 based)."

	| instSize |
	instSize := self selfField class instSize.
	^anInteger > instSize 
		ifTrue: [self selfField at: anInteger - instSize]
		ifFalse: [self selfField instVarAt: anInteger]!

getFieldList
	"Private - Answer the list of fields to be displayed in the instance variable list
	of the inspector. Numeric indices for the elements of the collection are answered."

	| size |
	size := [self selfField size] on: Error do: [:e | 0].
	^self selfField class allInstVarNames , (1 to: size)!

setField: anInteger to: anObject
	"Private - Determine the field of the receiver's object which has the key at index
	anInteger in the field list, and set its value to anObject."

	| instSize |
	instSize := self selfField class instSize.
	anInteger > instSize 
		ifTrue: [self selfField at: anInteger - instSize put: anObject]
		ifFalse: [self selfField instVarAt: anInteger put: anObject]! !
!SequenceableCollectionInspector categoriesFor: #getField:!accessing!private! !
!SequenceableCollectionInspector categoriesFor: #getFieldList!accessing!private! !
!SequenceableCollectionInspector categoriesFor: #setField:to:!accessing!private! !

