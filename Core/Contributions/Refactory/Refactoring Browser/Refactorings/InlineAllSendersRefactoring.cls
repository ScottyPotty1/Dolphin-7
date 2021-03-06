"Filed out from Dolphin Smalltalk XP 2002 release 5.05"!

MethodRefactoring subclass: #InlineAllSendersRefactoring
	instanceVariableNames: 'selector numberReplaced numberNotReplaced'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InlineAllSendersRefactoring guid: (GUID fromString: '{09AC0050-928C-41F2-8A20-8D0490A9C4FB}')!
InlineAllSendersRefactoring comment: ''!
!InlineAllSendersRefactoring categoriesForClass!Refactory-Refactorings! !
!InlineAllSendersRefactoring methodsFor!

checkInlinedMethods
	numberReplaced = 0 
		ifTrue: [self refactoringError: 'Could not inline any senders']!

inlineMessagesInClass: aClass andSelector: aSelector 
	| messagesToInline previousCountOfMessages |
	previousCountOfMessages := 4294967295.	"Some really large
number > # of initial self sends."
	
	[| tree |
	tree := aClass parseTreeFor: aSelector.
	messagesToInline := tree isNil ifTrue: [0] ifFalse: [self numberOfSelfSendsIn: tree].
	messagesToInline > 0 and: [previousCountOfMessages > messagesToInline]] 
			whileTrue: 
				[| node |
				previousCountOfMessages := messagesToInline.
				node := self selfSendIn: (aClass parseTreeFor: aSelector).
				self onError: 
						[self performComponentRefactoring: (InlineMethodRefactoring 
									model: self model
									inline: node sourceInterval
									inMethod: aSelector
									forClass: aClass).
						numberReplaced := numberReplaced + 1]
					do: []].
	numberNotReplaced := numberNotReplaced + messagesToInline!

inlineSelfSends
	class withAllSubclasses do: 
			[:each | 
			| selectors |
			selectors := (each whichMethodsReferToSymbol: selector) 
						collect: [:method | method selector].
			selectors remove: selector ifAbsent: [].
			selectors do: [:sel | self inlineMessagesInClass: each andSelector: sel]]!

messagePattern
	^'self ' , (self buildSelectorString: selector)!

messagesNotReplaced
	^numberNotReplaced!

numberOfSelfSendsIn: aParseTree
	| search |
	search := ParseTreeSearcher new.
	search matches: self messagePattern do: [:aNode :answer | answer + 1].
	^search executeTree: aParseTree initialAnswer: 0!

preconditions
	^RBCondition canUnderstand: selector in: class!

removeMethod
	self onError: 
			[self performComponentRefactoring: (RemoveMethodRefactoring 
						model: self model
						removeMethods: (Array with: selector)
						from: class)]
		do: []!

selfSendIn: aTree 
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: self messagePattern do: [:aNode :answer | ^aNode].
	^searcher executeTree: aTree initialAnswer: nil!

sendersOf: aSelector in: aClass 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	selector := aSelector.
	class := self classObjectFor: aClass.
	numberReplaced := numberNotReplaced := 0!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' sendersOf: #';
		nextPutAll: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	self
		inlineSelfSends;
		removeMethod;
		checkInlinedMethods! !
!InlineAllSendersRefactoring categoriesFor: #checkInlinedMethods!public!transforming! !
!InlineAllSendersRefactoring categoriesFor: #inlineMessagesInClass:andSelector:!public!transforming! !
!InlineAllSendersRefactoring categoriesFor: #inlineSelfSends!public!transforming! !
!InlineAllSendersRefactoring categoriesFor: #messagePattern!public!transforming! !
!InlineAllSendersRefactoring categoriesFor: #messagesNotReplaced!accessing!public! !
!InlineAllSendersRefactoring categoriesFor: #numberOfSelfSendsIn:!public!transforming! !
!InlineAllSendersRefactoring categoriesFor: #preconditions!preconditions!public! !
!InlineAllSendersRefactoring categoriesFor: #removeMethod!public!transforming! !
!InlineAllSendersRefactoring categoriesFor: #selfSendIn:!public!transforming! !
!InlineAllSendersRefactoring categoriesFor: #sendersOf:in:!initialize/release!public! !
!InlineAllSendersRefactoring categoriesFor: #storeOn:!printing!public! !
!InlineAllSendersRefactoring categoriesFor: #transform!public!transforming! !

!InlineAllSendersRefactoring class methodsFor!

model: aRBNamespace sendersOf: aSelector in: aClass 
	^(self new)
		model: aRBNamespace;
		sendersOf: aSelector in: aClass;
		yourself!

sendersOf: aSelector in: aClass 
	^self new sendersOf: aSelector in: aClass! !
!InlineAllSendersRefactoring class categoriesFor: #model:sendersOf:in:!instance creation!public! !
!InlineAllSendersRefactoring class categoriesFor: #sendersOf:in:!instance creation!public! !

