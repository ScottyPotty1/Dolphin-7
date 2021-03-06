"Filed out from Dolphin Smalltalk 2000 release 5.00"!

AXTypeInfoStructure subclass: #AXMemberDescStructure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''!
AXMemberDescStructure guid: (GUID fromString: '{AC5EB94D-60C1-4C16-AE6D-31ACF5123EB6}')!
AXMemberDescStructure comment: ''!
!AXMemberDescStructure categoriesForClass!External-Data-Structured-COM! !
!AXMemberDescStructure methodsFor!

= comperand
	"Answer whether the receiver is considered equal to the <Object>, comperand."

	^self species == comperand species
		and: [self memid = comperand memid]!

argumentCount
	"Answer the number of parameters to the function described by the receiver.
	Note that this count includes any optional parameters."

	^self cParams!

arguments
	"Answer a <sequencedReadableCollection> containing <ELEMDESC> structures
	describing each of the receiver's parameters."

	^self subclassResponsibility!

argumentTypes
	"Answer a <sequencedReadableCollection> containing the type names of
	each of the receiver's parameters.
	N.B. This may cause a large number of classes to be automatically generated!!"

	^self arguments collect: [:e | e typeName]!

classDesc
	"Private - Answer an <Association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^self tdesc classDesc!

cParams
	"Private - Answer the number of parameters to the function described by the receiver.
	Implementation Note: Where the receiver describes a variable (property)
	so we are cheating a bit here, however by expanding the common protocol with
	FUNCDESC, we can unify the type-library auto generation code for property
	get/put methods and properties."

	^0!

documentation
	"Answer a four element array containing the documentation for the receiver itself.
	See #documentationAt: for more details."

	^piTypeInfo documentationForMember: self memid!

elemDesc
	"Private - Answer an <ELEMDESC> describing the receiver's type."

	^self subclassResponsibility!

flags
	^self subclassResponsibility!

hash
	"Answer <integer> hash value for the receiver."

	^self memid hash!

idlFlags
	"Private - Answer a <sequencedReadableCollection> of the string names
	of the various IDL flags assocated with the receiver."

	| answer |
	answer := SortedCollection new.
	self isBindable ifTrue: [answer add: 'bindable'].
	self isDefaultBind ifTrue: [answer add: 'defaultbind'].
	self isDisplayBind ifTrue: [answer add: 'displaybind'].
	self isHidden ifTrue: [answer add: 'hidden'].
	self isRestricted ifTrue: [answer add: 'restricted'].
	self isRequestEdit ifTrue: [answer add: 'requestedit'].
	self isUIDefault ifTrue: [answer add: 'uidefault'].
	^answer!

isBindable
	"Answer whether the receiver is describing a 'bindable' property.
	Implementation Note: FUNCFLAG_FBINDABLE and VARFLAG_FBINDABLE
	have the same value."

	^self flags allMask: FUNCFLAG_FBINDABLE!

isDefaultBind
	"Answer whether the receiver is describing a 'defaultbind' property (i.e. the single, bindable
	property that best describes the object).
	Implementation Note: FUNCFLAG_FDEFAULTBIND and VARFLAG_FDEFAULTBIND
	have the same value."

	^self flags allMask: FUNCFLAG_FDEFAULTBIND!

isDisplayBind
	"Answer whether the receiver is describing a 'displaybind' property (i.e. a property that
	should be displayed to the user as bindable).
	Implementation Note: FUNCFLAG_FDISPLAYBIND and VARFLAG_FDISPLAYBIND
	have the same value."

	^self flags allMask: FUNCFLAG_FDISPLAYBIND!

isHidden
	"Answer whether the receiver is describing a hidden function or variable (i.e. one not
	intended to be advertised to users of macro/scripting languages).
	Implementation Note: FUNCFLAG_FHIDDEN and VARFLAG_FHIDDEN have the
	same value."

	^self flags allMask: FUNCFLAG_FHIDDEN!

isNonInspectable
	"Answer whether the receiver is describing a 'non-browsable' property.
	Oddly this doesn't mean that the method should not be displayed in type library
	browsers, but that it shouldn't be shown in inspectors, hence our choice
	of selector.
	Implementation Note: FUNCFLAG_FNONBROWSABLE and VARFLAG_FNONBROWSABLE
	have the same value."

	^self flags allMask: FUNCFLAG_FNONBROWSABLE!

isRequestEdit
	"Answer whether the receiver is describing a 'requestedit' property (i.e. one that causes
	a call to IPropertyNotifySink::OnRequestEdit when one attemps to change its value).
	Implementation Note: FUNCFLAG_FDEFAULTBIND and VARFLAG_FREQUESTEDIT
	have the same value."

	^self flags allMask: FUNCFLAG_FREQUESTEDIT!

isRestricted
	"Answer whether the receiver is describing a restricted function (i.e. one not
	intended to be used from macro/scripting languages)."

	^self flags allMask: FUNCFLAG_FRESTRICTED!

isScalarProperty
	^true!

isSource
	"Answer whether the receiver is describing a function that returns an object, or 
	a variable that holds an object, that is a source of events.
	Implementation Note: FUNCFLAG_FSOURCE and VARFLAG_FSOURCE 
	have the same value."

	^self flags allMask: FUNCFLAG_FSOURCE!

isUIDefault
	"Answer whether the receiver is describing a 'uidefault' property (i.e. that property that
	should be displayed in a UI to represent the object).
	Implementation Note: FUNCFLAG_FUIDEFAULT and VARFLAG_FUIDEFAULT
	have the same value."

	^self flags allMask: FUNCFLAG_FUIDEFAULT!

isValueProperty
	"Answer whether the receiver describes a method for getting or setting the default 
	(DISPID_VALUE) property."

	^self memid == DISPID_VALUE!

memid
	"Answer the receiver's memid field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

tdesc
	"Private - Answer a TYPEDESC describing the receiver's return type.
	N.B. The return type is the type of the argument marked with the 'retval'
	attribute in the IDL, or, if there is no retval argument, the return type of
	the function (usually HRESULT)."

	^self elemDesc tdesc! !
!AXMemberDescStructure categoriesFor: #=!comparing!public! !
!AXMemberDescStructure categoriesFor: #argumentCount!accessing!public! !
!AXMemberDescStructure categoriesFor: #arguments!*-subclass responsibility!enumerating!public! !
!AXMemberDescStructure categoriesFor: #argumentTypes!enumerating!public! !
!AXMemberDescStructure categoriesFor: #classDesc!accessing!private! !
!AXMemberDescStructure categoriesFor: #cParams!accessing!private! !
!AXMemberDescStructure categoriesFor: #documentation!accessing!public! !
!AXMemberDescStructure categoriesFor: #elemDesc!*-subclass responsibility!accessing!private! !
!AXMemberDescStructure categoriesFor: #flags!*-subclass responsibility!accessing!private! !
!AXMemberDescStructure categoriesFor: #hash!comparing!public! !
!AXMemberDescStructure categoriesFor: #idlFlags!printing-IDL!private! !
!AXMemberDescStructure categoriesFor: #isBindable!public!testing! !
!AXMemberDescStructure categoriesFor: #isDefaultBind!public!testing! !
!AXMemberDescStructure categoriesFor: #isDisplayBind!public!testing! !
!AXMemberDescStructure categoriesFor: #isHidden!public!testing! !
!AXMemberDescStructure categoriesFor: #isNonInspectable!public!testing! !
!AXMemberDescStructure categoriesFor: #isRequestEdit!public!testing! !
!AXMemberDescStructure categoriesFor: #isRestricted!public!testing! !
!AXMemberDescStructure categoriesFor: #isScalarProperty!public!testing! !
!AXMemberDescStructure categoriesFor: #isSource!public!testing! !
!AXMemberDescStructure categoriesFor: #isUIDefault!public!testing! !
!AXMemberDescStructure categoriesFor: #isValueProperty!public!testing! !
!AXMemberDescStructure categoriesFor: #memid!*-unclassified!public! !
!AXMemberDescStructure categoriesFor: #tdesc!accessing!private! !

