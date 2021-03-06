"Filed out from Dolphin Smalltalk X6.1"!

MethodRefactoring subclass: #RenameTemporaryRefactoring
	instanceVariableNames: 'selector interval oldName newName parseTree'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameTemporaryRefactoring guid: (GUID fromString: '{605981C4-3D80-4CE9-B0AC-9691E8A47DED}')!
RenameTemporaryRefactoring comment: ''!
!RenameTemporaryRefactoring categoriesForClass!Refactory-Refactorings! !
!RenameTemporaryRefactoring methodsFor!

class: aClass selector: aSelector interval: anInterval newName: aString 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	selector := aSelector.
	interval := anInterval.
	newName := aString.
	class := self classObjectFor: aClass.
!

oldName: aString 
	#rbFix.	"Add this accessor: Update name of model since we now know the oldName."
	oldName := aString.
	self model name: self displayString!

preconditions
	^(RBCondition definesSelector: selector in: class) 
		& (RBCondition isValidTemporaryVariableName: newName for: class) 
			& (RBCondition definesInstanceVariable: newName in: class) not 
			& (RBCondition definesClassVariable: newName in: class) not 
			& (RBCondition withBlock: 
						[| methodSource |
						interval first > interval last ifTrue: [self refactoringError: 'Invalid variable name'].
						methodSource := class sourceCodeFor: selector.
						methodSource size >= interval last ifFalse: [self refactoringError: 'Invalid range for variable'].
						self oldName: (methodSource copyFrom: interval first to: interval last).
						true])!

renameNode: aParseTree 
	(aParseTree whoDefines: newName) notNil 
		ifTrue: [self refactoringError: newName , ' is already defined'].
	(aParseTree allDefinedVariables includes: newName) 
		ifTrue: [self refactoringError: newName , ' is already defined'].
	(ParseTreeRewriter rename: oldName to: newName) executeTree: aParseTree!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' renameTemporaryFrom: '.
	interval storeOn: aStream.
	aStream
		nextPutAll: ' to: ''';
		nextPutAll: newName;
		nextPutAll: ''' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' selector: #';
		nextPutAll: selector.
	aStream nextPut: $)!

transform
	| definingNode variableNode |
	parseTree := class parseTreeFor: selector.
	variableNode := self 
				whichVariableNode: parseTree
				inInterval: interval
				name: oldName.
	(variableNode isNil or: [variableNode isVariable not]) 
		ifTrue: [self refactoringError: oldName , ' isn''t a valid variable'].
	variableNode name = oldName 
		ifFalse: [self refactoringError: 'Invalid selection'].
	definingNode := variableNode whoDefines: oldName.
	definingNode isNil 
		ifTrue: [self refactoringError: oldName , ' isn''t defined by the method'].
	self renameNode: definingNode.
	class compileTree: parseTree! !
!RenameTemporaryRefactoring categoriesFor: #class:selector:interval:newName:!initialize/release!public! !
!RenameTemporaryRefactoring categoriesFor: #oldName:!accessing!private! !
!RenameTemporaryRefactoring categoriesFor: #preconditions!preconditions!public! !
!RenameTemporaryRefactoring categoriesFor: #renameNode:!public!transforming! !
!RenameTemporaryRefactoring categoriesFor: #storeOn:!printing!public! !
!RenameTemporaryRefactoring categoriesFor: #transform!public!transforming! !

!RenameTemporaryRefactoring class methodsFor!

model: aRBNamespace renameTemporaryFrom: anInterval to: newName in: aClass selector: aSelector 
	^(self new)
		model: aRBNamespace;
		class: aClass
			selector: aSelector
			interval: anInterval
			newName: newName;
		yourself!

renameTemporaryFrom: anInterval to: newName in: aClass selector: aSelector 
	^self new
		class: aClass
		selector: aSelector
		interval: anInterval
		newName: newName! !
!RenameTemporaryRefactoring class categoriesFor: #model:renameTemporaryFrom:to:in:selector:!instance creation!public! !
!RenameTemporaryRefactoring class categoriesFor: #renameTemporaryFrom:to:in:selector:!instance creation!public! !

