"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RefactoryVariableChange subclass: #AddInstanceVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AddInstanceVariableChange comment: ''!

AddInstanceVariableChange guid: (GUID fromString: '{B6AD3820-2921-48E3-ABF0-439DA4482D55}')!

!AddInstanceVariableChange categoriesForClass!Refactory-Change Objects! !
!AddInstanceVariableChange methodsFor!

asUndoOperation
	^RemoveInstanceVariableChange remove: variable from: self changeClass!

changeString
	^'Add instance variable named, <1s>, from <2s>' 
		expandMacrosWith: variable
		with: self displayClassName!

changeSymbol
	^#addInstVarName:!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' addInstVarNamed: ';
		nextPutAll: variable;
		nextPut: $!!! !
!AddInstanceVariableChange categoriesFor: #asUndoOperation!converting!public! !
!AddInstanceVariableChange categoriesFor: #changeString!printing!public! !
!AddInstanceVariableChange categoriesFor: #changeSymbol!*-unclassified!private! !
!AddInstanceVariableChange categoriesFor: #printOn:!printing!public! !

