"Filed out from Dolphin Smalltalk X6"!

StaticView subclass: #SysLinkView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SysLinkConstants'
	classInstanceVariableNames: ''!
SysLinkView guid: (GUID fromString: '{E19A1369-3C1D-4216-B5B6-C6649E51DC4B}')!
SysLinkView comment: 'SysLinkView is a <valueView> wrapper class for the Windows SysLink control. The SysLink control is similar to a normal <StaticText> control, but may contain embedded links, and triggers #linkClicked: notification events when the links are clicked. The <valueModel> associated with a SysLinkView must always yield a <readableString> value when mapped through the installed type converter. A SysLinkView will normally be used in conjunction with a <TextPresenter>.

Please Note: The underlying Windows control is not supported on Windows 2000 and earlier.'!
!SysLinkView categoriesForClass!MVP-Views! !
!SysLinkView methodsFor!

calculateExtent: aLayoutContext 
	"Private - Calculate an extent for the receiver that would allow it to display all the text
	that it currently contains."

	"Implementation Note: We consider the width to be fixed, and calculate the required height
	(actually the control can do this ourselves), which is the same preferred extent behaviour
	implemented by StaticText when in multiline mode."

	| extent clientExt |
	clientExt := aLayoutContext clientExtentOf: self.
	extent := clientExt x @ self preferredHeight.

	"Now adjust required client extent to window extent"
	^self calcExtentFromClientExtent: extent!

displayValue
	"Private - Answer the displayed contents, the text, of the receiver"

	^self text!

displayValue: anObject 
	"Private - Set the displayable contents, the text, of the receiver to the
	displayString of anObject"

	| newText |
	newText := anObject displayString.
	self displayValue = newText 
		ifFalse: 
			["If the text has changed then set the new text for anObject"
			self text: newText]!

itemFromPoint: aPoint 
	"Private - Answer the <integer> index of the link in the receiver under the <Point> argument
	(expressed in client coordinates), or nil if none."

	| struct |
	struct := LHITTESTINFO new.
	struct pt: aPoint asParameter.
	"Note that the MSDN docs for LM_HITTEST are in error: It doesn't return details of the
	 last link clicked, but really is a hit testing function for finding the item under a point."
	^(self 
		sendMessage: LM_HITTEST
		wParam: 0
		lpParam: struct) asBoolean 
		ifTrue: [struct item copy]!

linkAt: anInteger 
	"Answer an <LITEM>s, describing the links with the specified <integer> index in
	the receiver, or, if there is no such link, raise a <BoundsError>."

	^self linkAt: anInteger ifAbsent: [self errorSubscriptBounds: anInteger]!

linkAt: anInteger ifAbsent: aNiladicValuable 
	"Answer an <LITEM>s, describing the links with the specified <integer> index in
	the receiver, or, if there is no such link, the result of evaluating aNiladicValuable."

	^(self lmGetItem: anInteger) ifNil: [aNiladicValuable value]!

linkAt: anInteger put: aLITEM 
	"Set the state and attributes of the link in the receiver with the specified <integer> index 
	from the details in the an <LITEM> argument."

	aLITEM
		maskIn: LIF_ITEMINDEX;
		iLink: anInteger - 1.
	(self lmSetItem: aLITEM) ifFalse: [self errorSubscriptBounds: anInteger]!

links
	"Answer a <sequencedReadableCollection> of <LITEM>s, describing each of the links in the
	receiver."

	| answer link i |
	answer := OrderedCollection new.
	i := 1.
	
	[link := self linkAt: i ifAbsent: [].
	link notNil] whileTrue: 
				[answer addLast: link.
				i := i + 1].
	^answer!

lmGetItem: anInteger 
	| answer |
	answer := LITEM new.
	answer
		mask: ##(LIF_ITEMINDEX | LIF_STATE | LIF_ITEMID | LIF_URL);
		iLink: anInteger - 1.
	^(self 
		sendMessage: LM_GETITEM
		wParam: 0
		lpParam: answer) ~~ 0 ifTrue: [answer]!

lmSetItem: aLITEM 
	^(self 
		sendMessage: LM_SETITEM
		wParam: 0
		lpParam: aLITEM) asBoolean!

nmClick: pNMHDR 
	"Default handler for a NM_CLICK notification message."

	| nmlink |
	nmlink := NMLINK fromAddress: pNMHDR.
	self onLinkClicked: nmlink.
	^0!

nmReturn: pNMHDR
	"Default handler for a NM_RETURN notification message."

	| nmlink |
	nmlink := NMLINK fromAddress: pNMHDR.
	self onLinkClicked: nmlink item.
	^0!

onLinkClicked: aNMLINK 
	self presenter trigger: #linkClicked: with: aNMLINK item!

preferredHeight
	"Private - Answer the <integer> number of pels that the control thinks would be its 
	ideal height, given its current width."

	^self sendMessage: LM_GETIDEALHEIGHT! !
!SysLinkView categoriesFor: #calculateExtent:!geometry!private! !
!SysLinkView categoriesFor: #displayValue!private!updating! !
!SysLinkView categoriesFor: #displayValue:!private!updating! !
!SysLinkView categoriesFor: #itemFromPoint:!enquiries!private! !
!SysLinkView categoriesFor: #linkAt:!accessing!public! !
!SysLinkView categoriesFor: #linkAt:ifAbsent:!accessing!public! !
!SysLinkView categoriesFor: #linkAt:put:!accessing!public! !
!SysLinkView categoriesFor: #links!accessing!public! !
!SysLinkView categoriesFor: #lmGetItem:!accessing!private! !
!SysLinkView categoriesFor: #lmSetItem:!accessing!private! !
!SysLinkView categoriesFor: #nmClick:!event handling-win32!private! !
!SysLinkView categoriesFor: #nmReturn:!event handling-win32!private! !
!SysLinkView categoriesFor: #onLinkClicked:!event handling!private! !
!SysLinkView categoriesFor: #preferredHeight!enquiries!private! !

!SysLinkView class methodsFor!

initialize
	CommCtrlLibrary initFlags: (CommCtrlLibrary initFlags maskSet: ICC_LINK_CLASS)!

uninitialize
	CommCtrlLibrary initFlags: (CommCtrlLibrary initFlags maskClear: ICC_LINK_CLASS)!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SysLink'! !
!SysLinkView class categoriesFor: #initialize!initializing!public! !
!SysLinkView class categoriesFor: #uninitialize!class hierarchy-removing!public! !
!SysLinkView class categoriesFor: #winClassName!constants!private! !

