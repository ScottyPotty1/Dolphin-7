"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #RemoveParameterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveParameterTest guid: (GUID fromString: '{E5FF0A30-1644-4902-8240-701881D750FE}')!
RemoveParameterTest comment: ''!
!RemoveParameterTest categoriesForClass!Refactory-Testing! !
!RemoveParameterTest methodsFor!

testNonExistantName
	self
		shouldFail: (RemoveParameterRefactoring 
					removeParameter: 'asdf'
					in: BasicLintRuleTest
					selector: #checkClass:);
		shouldFail: (RemoveParameterRefactoring 
					removeParameter: 'aSmalllintContext'
					in: BasicLintRuleTest
					selector: #checkClass1:)!

testPrimitiveMethods
	| refactoring |
	(model classNamed: #Object) 
		compile: 'foo123: a <primitive: 100> ^#() primitiveFailed'
		classified: #(#accessing).
	refactoring := RemoveParameterRefactoring 
				model: model
				removeParameter: 'a'
				in: Object
				selector: #foo123:.
	self shouldFail: refactoring!

testRemoveParameter
	| refactoring class |
	refactoring := RemoveParameterRefactoring 
				removeParameter: 'anArg'
				in: RefactoryTestDataApp
				selector: ('rename' , 'ThisMethod:') asSymbol.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #RefactoryTestDataApp.
	self assert: (class parseTreeFor: #renameThisMethod) 
				= (RBParser parseMethod: 'renameThisMethod
								^self').
	self assert: (class parseTreeFor: #callMethod) 
				= (RBParser parseMethod: 'callMethod
								^(self renameThisMethod)').
	self 
		deny: (class directlyDefinesMethod: ('rename' , 'ThisMethod:') asSymbol)! !
!RemoveParameterTest categoriesFor: #testNonExistantName!failure tests!public! !
!RemoveParameterTest categoriesFor: #testPrimitiveMethods!failure tests!public! !
!RemoveParameterTest categoriesFor: #testRemoveParameter!public!tests! !

