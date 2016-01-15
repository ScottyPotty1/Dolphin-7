"Filed out from Dolphin Smalltalk 7"!

SelectableTreeItemsTest subclass: #TreeViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TreeViewTest guid: (GUID fromString: '{9F22E0FE-4151-461C-A92A-F1D9F25E6605}')!
TreeViewTest comment: ''!
!TreeViewTest categoriesForClass!Unclassified! !
!TreeViewTest methodsFor!

classToTest
	^TreeView!

getItemText: anObject
	| treeView |
	treeView := presenter view.
	^treeView getItemText: (treeView handleFromObject: anObject)!

paintTree
	(presenter view)
		invalidate;
		update!

refreshTree: aSymbol
	| tvItem child root text |
	presenter hasLinesAtRoot: true.
	presenter view updateMode: aSymbol.
	root := '1' -> 1.
	presenter model addRoot: root.
	child := '1.1' -> 2.
	presenter model add: child asChildOf: root.
	presenter view expandAll: root.
	self paintTree.
	tvItem := self getItemText: root.
	text := root displayString.
	self assert: (self getItemText: root) = text.
	root value: 3.
	presenter view updateMode == #dynamic 
		ifFalse: 
			[self assert: (self getItemText: root) = text.
			self paintTree.
			self assert: (self getItemText: root) = text]
		ifTrue: 
			["Just re-requesting the text is sufficient to get it to redisplay"

			self assert: (self getItemText: root) = root displayString].
	presenter model refreshTree: root.
	self assert: (self getItemText: root) = root displayString.
	self paintTree!

testCollapseOneLevel
	presenter hasLinesAtRoot: true.
	presenter model: (TreeModel withRoots: #('1') searchPolicy: SearchPolicy equality).
	presenter model add: '1.1' asChildOf: '1'.
	presenter view expandAll: '1'.
	presenter model collapse: '1'.
	self paintTree!

testCollapseTwoLevels
	presenter hasLinesAtRoot: true.
	presenter model: (TreeModel withRoots: #('1') searchPolicy: SearchPolicy equality).
	presenter model add: '1.1' asChildOf: '1'.
	#('1.1.1' '1.1.2') do: [:each | presenter model add: each asChildOf: '1.1'].
	presenter view expandAll: '1'.
	presenter model collapse: '1.1'.
	self paintTree.
	presenter model collapse: '1'.
	self paintTree!

testRefreshTreeDynamic
	self refreshTree: #dynamic!

testRefreshTreeLazy
	"Just re-requesting the text is sufficient to get it to redisplay"

	self refreshTree: #lazy!

testRefreshTreeStatic
	"Just re-requesting the text is sufficient to get it to redisplay"

	self refreshTree: #static!

testSetImageBlockDoesNotAffectSelection
	presenter view class updateModes do: 
			[:each | 
			presenter view updateMode: each.
			super testSetImageBlockDoesNotAffectSelection.
			presenter view model clear]!

testSetTextBlockDoesNotAffectSelection
	presenter view class updateModes do: 
			[:each | 
			presenter view updateMode: each.
			super testSetTextBlockDoesNotAffectSelection.
			presenter view model clear]! !
!TreeViewTest categoriesFor: #classToTest!helpers!private! !
!TreeViewTest categoriesFor: #getItemText:!helpers!private! !
!TreeViewTest categoriesFor: #paintTree!helpers!private! !
!TreeViewTest categoriesFor: #refreshTree:!helpers!private! !
!TreeViewTest categoriesFor: #testCollapseOneLevel!public!unit tests! !
!TreeViewTest categoriesFor: #testCollapseTwoLevels!public!unit tests! !
!TreeViewTest categoriesFor: #testRefreshTreeDynamic!public!unit tests! !
!TreeViewTest categoriesFor: #testRefreshTreeLazy!public!unit tests! !
!TreeViewTest categoriesFor: #testRefreshTreeStatic!public!unit tests! !
!TreeViewTest categoriesFor: #testSetImageBlockDoesNotAffectSelection!public!unit tests! !
!TreeViewTest categoriesFor: #testSetTextBlockDoesNotAffectSelection!public!unit tests! !
