"Filed out from Dolphin Smalltalk X6.1"!

BrowserEnvironmentWrapper subclass: #VariableEnvironment
	instanceVariableNames: 'instanceVariables instanceVariableReaders instanceVariableWriters classVariables selectorCache'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VariableEnvironment guid: (GUID fromString: '{E9CADA30-17FA-4434-96E9-1E962BB36333}')!
VariableEnvironment comment: 'VariableEnvironment defines a set of methods (and their classes) that read and/or write to any of a set of named instance and class variables. It is used to implement the browse variable references, readers & writers commands in the browsers.


Instance Variables:
	instanceVariables		<abstractDictionary>, mapping class names to the referenced instance variable names
	instanceVariableReaders	<abstractDictionary>, mapping class names to the read instance variable names
	instanceVariableWriters	<abstractDictionary>, mapping class names to the written instance variable names
	classVariables			<abstractDictionary>, mapping class names to referenced class variable names
	selectorCache			<abstractDictionary>, mapping classes to selectors of methods that read or write one of the variables in the above maps

Note that in Dolphin all <abstractDictionary>s are implemented as instances of <LookupTable> because of its better speed/memory performance relative to <Dictionary>.


'!
!VariableEnvironment categoriesForClass!Refactory-Environments! !
!VariableEnvironment methodsFor!

accessorMethods
	^#(#instanceVariables #instanceVariableReaders #instanceVariableWriters #classVariables)!

addClass: aClass classVariable: aSymbol 
	(classVariables at: aClass name ifAbsentPut: [Set new]) add: aSymbol.
	self flushCachesFor: aClass.
	self addSearchString: aSymbol!

addClass: aClass instanceVariable: aString 
	(instanceVariables at: aClass name ifAbsentPut: [Set new]) add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString!

addClass: aClass instanceVariableReader: aString 
	(instanceVariableReaders at: aClass name ifAbsentPut: [Set new]) 
		add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString!

addClass: aClass instanceVariableWriter: aString 
	(instanceVariableWriters at: aClass name ifAbsentPut: [Set new]) 
		add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString!

allClassesDo: aBlock 
	| classes instVarBlock numClasses i |
	classes := Set new.
	instVarBlock := 
			[:each | 
			| class |
			class := self classForName: each.
			classes addAll: class withAllSubclasses].
	instanceVariables keysDo: instVarBlock.
	instanceVariableReaders keysDo: instVarBlock.
	instanceVariableWriters keysDo: instVarBlock.
	classVariables keysDo: 
			[:each | 
			| class |
			class := self classForName: each.
			class notNil 
				ifTrue: 
					[classes
						addAll: class withAllSubclasses;
						addAll: class class withAllSubclasses]].
	numClasses := classes size.
	i := 0.0.
	progressBlock value: i.
	classes do: 
			[:class | 
			aBlock value: class.
			i := i + 1.
			progressBlock value: i * 100 // numClasses]!

classForName: aString 
	| name isMeta class |
	isMeta := aString includes: $ .
	name := (isMeta 
				ifTrue: [aString copyFrom: 1 to: (aString size - 6 max: 1)]
				ifFalse: [aString]) asSymbol.
	class := Smalltalk at: name ifAbsent: [nil].
	^class notNil & isMeta ifTrue: [class class] ifFalse: [class]!

classNamesWithVariables
	| classNames |
	classNames := Set new.
	classNames
		addAll: instanceVariables keys;
		addAll: instanceVariableReaders keys;
		addAll: instanceVariableWriters keys;
		addAll: classVariables keys.
	^classNames!

classVariables
	^classVariables!

classVariables: anObject
	classVariables := anObject!

classVariableSelectorsFor: aClass 
	| selectors classVars nonMetaClass |
	nonMetaClass := aClass isMeta 
				ifTrue: [aClass soleInstance]
				ifFalse: [aClass].
	selectors := Set new.
	classVars := Set new.
	classVariables keysDo: 
			[:each | 
			| cls |
			cls := self classForName: each.
			(cls notNil and: [nonMetaClass includesBehavior: cls]) 
				ifTrue: [classVars addAll: (classVariables at: each)]].
	classVars do: 
			[:each | 
			| binding |
			binding := aClass bindingFor: each.
			binding notNil 
				ifTrue: [selectors addAll: (aClass whichSelectorsReferTo: binding)]].
	^selectors!

classVariablesFor: aClass 
	^classVariables at: aClass name ifAbsent: [#()]!

computeSelectorCacheFor: aClass 
	^(self instanceVariableSelectorsFor: aClass)
		addAll: (self classVariableSelectorsFor: aClass);
		yourself!

copyDictionary: aDictionary 
	#rbFix.	"Because we are using LookupTables (instead of Dictionaries) we don't need any
			special copying for the dictionaries."
	^aDictionary copy!

environmentForClassVariable: aSymbol in: aClass 
	| selectorEnvironment assoc block |
	selectorEnvironment := SelectorEnvironment onEnvironment: self.
	selectorEnvironment addSearchString: aSymbol.
	((classVariables at: aClass name ifAbsent: [#()]) includes: aSymbol) 
		ifFalse: [^selectorEnvironment].
	assoc := aClass bindingFor: aSymbol.
	block := 
			[:each | 
			(each whichSelectorsReferTo: assoc) 
				do: [:sel | selectorEnvironment addClass: each selector: sel]].
	aClass withAllSubclasses do: 
			[:each | 
			block
				value: each;
				value: each class].
	^selectorEnvironment!

environmentForInstanceVariable: aString in: aClass 
	| selectorEnvironment isReader isWriter |
	selectorEnvironment := SelectorEnvironment onEnvironment: self.
	selectorEnvironment addSearchString: aString.
	isReader := isWriter := false.
	((instanceVariables at: aClass name ifAbsent: [#()]) includes: aString) 
		ifTrue: 
			[isReader := true.
			isWriter := true].
	((instanceVariableWriters at: aClass name ifAbsent: [#()]) 
		includes: aString) ifTrue: [isWriter := true].
	((instanceVariableReaders at: aClass name ifAbsent: [#()]) 
		includes: aString) ifTrue: [isReader := true].
	aClass withAllSubclasses do: 
			[:each | 
			isWriter 
				ifTrue: 
					[(each whichSelectorsAssign: aString) 
						do: [:sel | selectorEnvironment addClass: each selector: sel]].
			isReader 
				ifTrue: 
					[(each whichSelectorsRead: aString) 
						do: [:sel | selectorEnvironment addClass: each selector: sel]]].
	^selectorEnvironment!

flushCachesFor: aClass 
	| nonMetaClass |
	selectorCache isNil ifTrue: [^self].
	nonMetaClass := aClass isMeta 
				ifTrue: [aClass soleInstance]
				ifFalse: [aClass].
	nonMetaClass withAllSubclasses do: 
			[:each | 
			selectorCache
				removeKey: each ifAbsent: [];
				removeKey: each class ifAbsent: []]!

includesCategory: aCategory 
	^(self classNamesFor: aCategory) notEmpty!

includesClass: aClass 
	| name |
	#rbFix.	"SW: The *Variable dictionaries are keyed by class name not class"
	(super includesClass: aClass) ifFalse: [^false].
	name := aClass name.
	(instanceVariables includesKey: name) ifTrue: [^true].
	(classVariables includesKey: name) ifTrue: [^true].
	^(self selectorCacheFor: aClass) anySatisfy: [:each | self includesSelector: each in: aClass]!

includesProtocol: aProtocol in: aClass 
	^(self selectorsFor: aProtocol in: aClass) notEmpty!

includesSelector: aSymbol in: aClass 
	^(environment includesSelector: aSymbol in: aClass) 
		and: [(self selectorCacheFor: aClass) includes: aSymbol]!

initialize
	super initialize.
	instanceVariables := self lookupTableClass new.
	classVariables := self lookupTableClass new.
	instanceVariableReaders := self lookupTableClass new.
	instanceVariableWriters := self lookupTableClass new!

instanceVariableReaders
	^instanceVariableReaders!

instanceVariableReaders: anObject
	instanceVariableReaders := anObject!

instanceVariables
	^instanceVariables!

instanceVariables: anObject
	instanceVariables := anObject!

instanceVariableSelectorsFor: aClass 
	| selectors |
	selectors := Set new.
	#(#instanceVariables #instanceVariableReaders #instanceVariableWriters) 
		with: #(#whichSelectorsAccess: #whichSelectorsRead: #whichSelectorsAssign:)
		do: 
			[:var :sel | 
			| instVars |
			instVars := self instVarsFor: aClass in: (self perform: var).
			instVars do: [:each | selectors addAll: (aClass perform: sel with: each)]].
	^selectors!

instanceVariablesFor: aClass 
	| vars name |
	vars := Set new.
	name := aClass name.
	vars
		addAll: (instanceVariables at: name ifAbsent: [#()]);
		addAll: (instanceVariableReaders at: name ifAbsent: [#()]);
		addAll: (instanceVariableWriters at: name ifAbsent: [#()]).
	^vars!

instanceVariableWriters
	^instanceVariableWriters!

instanceVariableWriters: anObject
	instanceVariableWriters := anObject!

instVarsFor: aClass in: aDictionary 
	| instVars |
	instVars := Set new.
	aDictionary keysAndValuesDo: 
			[:eachKey :eachValue | 
			| cls |
			cls := self classForName: eachKey.
			(cls notNil and: [aClass includesBehavior: cls]) ifTrue: [instVars addAll: eachValue]].
	^instVars!

isEmpty
	self accessorMethods do: [:each | (self perform: each) notEmpty ifTrue: [^false]].
	^true!

lookupTableClass
	#rbFix.	"Class ref. extracted to method, and use LookupTable rather than Dictionary for improved performance."
	^LookupTable!

numberVariables
	^self accessorMethods inject: 0
		into: [:sum :each | sum + ((self perform: each) inject: 0 into: [:s :e | s + e size])]!

postCopy
	super postCopy.
	instanceVariables := self copyDictionary: instanceVariables.
	instanceVariableReaders := self copyDictionary: instanceVariableReaders.
	instanceVariableWriters := self copyDictionary: instanceVariableWriters.
	classVariables := self copyDictionary: classVariables.
	selectorCache := nil.
	^self!

problemCount
	^self numberVariables!

removeClass: aClass classVariable: aSymbol 
	| vars |
	vars := classVariables at: aClass name ifAbsent: [Set new].
	vars remove: aSymbol ifAbsent: [].
	vars isEmpty ifTrue: [classVariables removeKey: aClass name ifAbsent: []].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariable: aString 
	| vars |
	vars := instanceVariables at: aClass name ifAbsent: [Set new].
	vars remove: aString ifAbsent: [].
	vars isEmpty 
		ifTrue: [instanceVariables removeKey: aClass name ifAbsent: []].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariableReader: aString 
	| vars |
	vars := instanceVariableReaders at: aClass name ifAbsent: [Set new].
	vars remove: aString ifAbsent: [].
	vars isEmpty 
		ifTrue: [instanceVariableReaders removeKey: aClass name ifAbsent: []].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariableWriter: aString 
	| vars |
	vars := instanceVariableWriters at: aClass name ifAbsent: [Set new].
	vars remove: aString ifAbsent: [].
	vars isEmpty 
		ifTrue: [instanceVariableWriters removeKey: aClass name ifAbsent: []].
	self flushCachesFor: aClass!

selectorCache
	^selectorCache isNil ifTrue: [selectorCache := self lookupTableClass new] ifFalse: [selectorCache]!

selectorCacheFor: aClass 
	^self selectorCache at: aClass
		ifAbsentPut: [self computeSelectorCacheFor: aClass]!

storeOn: aStream 
	aStream
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' new '.
	#(#instanceVariables #instanceVariableReaders #instanceVariableWriters #classVariables) 
		do: 
			[:each | 
			aStream
				nextPutAll: each;
				nextPutAll: ': '.
			(self perform: each) storeOn: aStream.
			aStream nextPutAll: '; '].
	aStream nextPutAll: ' yourself)'! !
!VariableEnvironment categoriesFor: #accessorMethods!constants!private! !
!VariableEnvironment categoriesFor: #addClass:classVariable:!accessing!public! !
!VariableEnvironment categoriesFor: #addClass:instanceVariable:!accessing!public! !
!VariableEnvironment categoriesFor: #addClass:instanceVariableReader:!accessing!public! !
!VariableEnvironment categoriesFor: #addClass:instanceVariableWriter:!accessing!public! !
!VariableEnvironment categoriesFor: #allClassesDo:!enumerating!private! !
!VariableEnvironment categoriesFor: #classForName:!helpers!private! !
!VariableEnvironment categoriesFor: #classNamesWithVariables!accessing!public! !
!VariableEnvironment categoriesFor: #classVariables!accessing!private! !
!VariableEnvironment categoriesFor: #classVariables:!accessing!private! !
!VariableEnvironment categoriesFor: #classVariableSelectorsFor:!helpers!private! !
!VariableEnvironment categoriesFor: #classVariablesFor:!accessing!public! !
!VariableEnvironment categoriesFor: #computeSelectorCacheFor:!helpers!private! !
!VariableEnvironment categoriesFor: #copyDictionary:!copying!public! !
!VariableEnvironment categoriesFor: #environmentForClassVariable:in:!accessing!public! !
!VariableEnvironment categoriesFor: #environmentForInstanceVariable:in:!accessing!public! !
!VariableEnvironment categoriesFor: #flushCachesFor:!helpers!private! !
!VariableEnvironment categoriesFor: #includesCategory:!public!testing! !
!VariableEnvironment categoriesFor: #includesClass:!public!testing! !
!VariableEnvironment categoriesFor: #includesProtocol:in:!public!testing! !
!VariableEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!VariableEnvironment categoriesFor: #initialize!initialize/release!public! !
!VariableEnvironment categoriesFor: #instanceVariableReaders!accessing!private! !
!VariableEnvironment categoriesFor: #instanceVariableReaders:!public! !
!VariableEnvironment categoriesFor: #instanceVariables!accessing!private! !
!VariableEnvironment categoriesFor: #instanceVariables:!accessing!private! !
!VariableEnvironment categoriesFor: #instanceVariableSelectorsFor:!helpers!private! !
!VariableEnvironment categoriesFor: #instanceVariablesFor:!accessing!public! !
!VariableEnvironment categoriesFor: #instanceVariableWriters!accessing!private! !
!VariableEnvironment categoriesFor: #instanceVariableWriters:!accessing!private! !
!VariableEnvironment categoriesFor: #instVarsFor:in:!helpers!private! !
!VariableEnvironment categoriesFor: #isEmpty!public!testing! !
!VariableEnvironment categoriesFor: #lookupTableClass!constants!private! !
!VariableEnvironment categoriesFor: #numberVariables!accessing!public! !
!VariableEnvironment categoriesFor: #postCopy!copying!public! !
!VariableEnvironment categoriesFor: #problemCount!accessing!public! !
!VariableEnvironment categoriesFor: #removeClass:classVariable:!accessing!public! !
!VariableEnvironment categoriesFor: #removeClass:instanceVariable:!accessing!public! !
!VariableEnvironment categoriesFor: #removeClass:instanceVariableReader:!accessing!public! !
!VariableEnvironment categoriesFor: #removeClass:instanceVariableWriter:!accessing!public! !
!VariableEnvironment categoriesFor: #selectorCache!accessing!private! !
!VariableEnvironment categoriesFor: #selectorCacheFor:!accessing!private! !
!VariableEnvironment categoriesFor: #storeOn:!printing!public! !

!VariableEnvironment class methodsFor!

on: anEnvironment readersOfInstanceVariable: aString in: aClass 
	^(self onEnvironment: anEnvironment)
		label: 'Readers of ''' , aString , ''' in ' , aClass name;
		addClass: aClass instanceVariableReader: aString;
		yourself!

on: anEnvironment referencesToClassVariable: aSymbol in: aClass 
	^(self onEnvironment: anEnvironment)
		label: 'References to ''' , aSymbol , ''' in ' , aClass name;
		addClass: aClass classVariable: aSymbol;
		yourself!

on: anEnvironment referencesToInstanceVariable: aString in: aClass 
	^(self onEnvironment: anEnvironment)
		label: 'References to ''' , aString , ''' in ' , aClass name;
		addClass: aClass instanceVariable: aString;
		yourself!

on: anEnvironment writersOfInstanceVariable: aString in: aClass 
	^(self onEnvironment: anEnvironment)
		label: 'Writers of ''' , aString , ''' in ' , aClass name;
		addClass: aClass instanceVariableWriter: aString;
		yourself!

readersOfInstanceVariable: aString in: aClass 
	^self 
		on: BrowserEnvironment new
		readersOfInstanceVariable: aString
		in: aClass!

referencesToClassVariable: aSymbol in: aClass 
	^self 
		on: BrowserEnvironment new
		referencesToClassVariable: aSymbol
		in: aClass!

referencesToInstanceVariable: aString in: aClass 
	^self 
		on: BrowserEnvironment new
		referencesToInstanceVariable: aString
		in: aClass!

writersOfInstanceVariable: aString in: aClass 
	^self 
		on: BrowserEnvironment new
		writersOfInstanceVariable: aString
		in: aClass! !
!VariableEnvironment class categoriesFor: #on:readersOfInstanceVariable:in:!instance creation!public! !
!VariableEnvironment class categoriesFor: #on:referencesToClassVariable:in:!instance creation!public! !
!VariableEnvironment class categoriesFor: #on:referencesToInstanceVariable:in:!instance creation!public! !
!VariableEnvironment class categoriesFor: #on:writersOfInstanceVariable:in:!instance creation!public! !
!VariableEnvironment class categoriesFor: #readersOfInstanceVariable:in:!instance creation!public! !
!VariableEnvironment class categoriesFor: #referencesToClassVariable:in:!instance creation!public! !
!VariableEnvironment class categoriesFor: #referencesToInstanceVariable:in:!instance creation!public! !
!VariableEnvironment class categoriesFor: #writersOfInstanceVariable:in:!instance creation!public! !

