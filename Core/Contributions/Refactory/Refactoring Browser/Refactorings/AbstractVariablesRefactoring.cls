"Filed out from Dolphin Smalltalk XP 2002 release 5.05"!

Refactoring subclass: #AbstractVariablesRefactoring
	instanceVariableNames: 'tree fromClass instVarReaders instVarWriters classVarReaders classVarWriters toClasses ignore'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractVariablesRefactoring guid: (GUID fromString: '{4693691A-7A7D-4B15-A3E9-C4C5554AA27E}')!
AbstractVariablesRefactoring comment: ''!
!AbstractVariablesRefactoring categoriesForClass!Refactory-Refactorings! !
!AbstractVariablesRefactoring methodsFor!

abstractClassVariable: aString 
	| refactoring rewriter nonMetaClass |
	nonMetaClass := fromClass nonMetaclass.
	refactoring := CreateAccessorsForVariableRefactoring 
				model: self model
				variable: aString
				class: nonMetaClass
				classVariable: true.
	self performComponentRefactoring: refactoring.
	rewriter := ParseTreeRewriter new.
	fromClass isMeta 
		ifTrue: 
			[rewriter
				replace: aString , ' := ``@object'
					with: ('self <1s> ``@object' expandMacrosWith: refactoring setterMethod);
				replace: aString with: 'self ' , refactoring getterMethod]
		ifFalse: 
			[rewriter
				replace: aString , ' := ``@object'
					with: ('self class <1s> ``@object' 
							expandMacrosWith: refactoring setterMethod);
				replace: aString with: 'self class ' , refactoring getterMethod].
	(rewriter executeTree: tree) ifTrue: [tree := rewriter tree]!

abstractClassVariables
	| variables |
	classVarReaders isEmpty & classVarWriters isEmpty ifTrue: [^self].
	variables := Set new.
	variables
		addAll: classVarReaders;
		addAll: classVarWriters.
	variables do: [:each | self abstractClassVariable: each]!

abstractInstanceVariable: aString 
	| refactoring rewriter |
	refactoring := CreateAccessorsForVariableRefactoring 
				model: self model
				variable: aString
				class: fromClass
				classVariable: false.
	self performComponentRefactoring: refactoring.
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: aString , ' := ``@object'
			with: ('self <1s> ``@object' expandMacrosWith: refactoring setterMethod);
		replace: aString with: 'self ' , refactoring getterMethod.
	(rewriter executeTree: tree) ifTrue: [tree := rewriter tree]!

abstractInstanceVariables
	| variables |
	instVarReaders isEmpty & instVarWriters isEmpty ifTrue: [^self].
	variables := Set new.
	variables
		addAll: instVarReaders;
		addAll: instVarWriters.
	variables do: [:each | self abstractInstanceVariable: each]!

abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection ignoring: aVariableName 
	| poolRefactoring |
	tree := aBRProgramNode.
	fromClass := self classObjectFor: fromBehavior.
	toClasses := behaviorCollection 
				collect: [:each | self classObjectFor: each].
	ignore := aVariableName.
	poolRefactoring := ExpandReferencedPoolsRefactoring 
				model: self model
				forMethod: tree
				fromClass: fromClass
				toClasses: toClasses.
	self performComponentRefactoring: poolRefactoring.
	self computeVariablesToAbstract!

classVariableNames
	| nonMetaClass |
	nonMetaClass := fromClass nonMetaclass.
	^(nonMetaClass allClassVariableNames collect: [:each | each asString]) asSet!

computeVariablesToAbstract
	| searcher |
	instVarReaders := Set new.
	instVarWriters := Set new.
	classVarReaders := Set new.
	classVarWriters := Set new.
	searcher := ParseTreeSearcher new.
	searcher
		matches: '`var := ``@anything'
			do: [:aNode :answer | self processAssignmentNode: aNode];
		matches: '`var' do: [:aNode :answer | self processReferenceNode: aNode].
	searcher executeTree: tree.
	self removeDefinedClassVariables!

hasVariablesToAbstract
	^(instVarReaders isEmpty 
		& instVarWriters isEmpty 
		& classVarReaders isEmpty 
		& classVarWriters isEmpty) 
		not!

instanceVariableNames
	^fromClass allInstanceVariableNames asSet!

parseTree
	^tree!

preconditions
	^RBCondition empty!

processAssignmentNode: aNode 
	| varName |
	varName := aNode variable name.
	ignore = varName ifTrue: [^self].
	(aNode whoDefines: varName) notNil ifTrue: [^self].
	(self instanceVariableNames includes: varName) 
		ifTrue: [instVarWriters add: varName].
	(self classVariableNames includes: varName) 
		ifTrue: [classVarWriters add: varName]!

processReferenceNode: aNode 
	| varName |
	varName := aNode name.
	ignore = varName ifTrue: [^self].
	(aNode whoDefines: varName) notNil ifTrue: [^self].
	(self instanceVariableNames includes: varName) 
		ifTrue: [instVarReaders add: varName].
	(self classVariableNames includes: varName) 
		ifTrue: [classVarReaders add: varName]!

removeDefinedClassVariables
	| selectionBlock nonMetaClass |
	nonMetaClass := fromClass nonMetaclass.
	selectionBlock := 
			[:varName | 
			toClasses anySatisfy: 
					[:each | 
					(each nonMetaclass includesClass: (nonMetaClass whoDefinesClassVariable: varName)) not]].
	classVarReaders := classVarReaders select: selectionBlock.
	classVarWriters := classVarWriters select: selectionBlock!

transform
	self hasVariablesToAbstract 
		ifTrue: 
			[self 
				refactoringWarning: 'This method has direct variable references which<n>will need to be converted to getter/setters.' 
						expandMacros].
	self abstractInstanceVariables.
	self abstractClassVariables! !
!AbstractVariablesRefactoring categoriesFor: #abstractClassVariable:!public!transforming! !
!AbstractVariablesRefactoring categoriesFor: #abstractClassVariables!public!transforming! !
!AbstractVariablesRefactoring categoriesFor: #abstractInstanceVariable:!public!transforming! !
!AbstractVariablesRefactoring categoriesFor: #abstractInstanceVariables!public!transforming! !
!AbstractVariablesRefactoring categoriesFor: #abstractVariablesIn:from:toAll:ignoring:!initialize/release!public! !
!AbstractVariablesRefactoring categoriesFor: #classVariableNames!public!transforming! !
!AbstractVariablesRefactoring categoriesFor: #computeVariablesToAbstract!public!transforming! !
!AbstractVariablesRefactoring categoriesFor: #hasVariablesToAbstract!public!testing! !
!AbstractVariablesRefactoring categoriesFor: #instanceVariableNames!public!transforming! !
!AbstractVariablesRefactoring categoriesFor: #parseTree!accessing!public! !
!AbstractVariablesRefactoring categoriesFor: #preconditions!preconditions!public! !
!AbstractVariablesRefactoring categoriesFor: #processAssignmentNode:!public!transforming! !
!AbstractVariablesRefactoring categoriesFor: #processReferenceNode:!public!transforming! !
!AbstractVariablesRefactoring categoriesFor: #removeDefinedClassVariables!public!transforming! !
!AbstractVariablesRefactoring categoriesFor: #transform!public!transforming! !

!AbstractVariablesRefactoring class methodsFor!

model: aRBNamespace abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection 
	^self 
		model: aRBNamespace
		abstractVariablesIn: aBRProgramNode
		from: fromBehavior
		toAll: behaviorCollection
		ignoring: nil!

model: aRBNamespace abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection ignoring: aVariableName 
	^(self new)
		model: aRBNamespace;
		abstractVariablesIn: aBRProgramNode
			from: fromBehavior
			toAll: behaviorCollection
			ignoring: aVariableName;
		yourself! !
!AbstractVariablesRefactoring class categoriesFor: #model:abstractVariablesIn:from:toAll:!instance creation!public! !
!AbstractVariablesRefactoring class categoriesFor: #model:abstractVariablesIn:from:toAll:ignoring:!instance creation!public! !

