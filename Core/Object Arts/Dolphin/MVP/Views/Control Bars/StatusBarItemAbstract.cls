"Filed out from Dolphin Smalltalk X6"!

Object subclass: #StatusBarItemAbstract
	instanceVariableNames: 'border width parentView model'
	classVariableNames: 'BorderStyles'
	poolDictionaries: 'StatusBarConstants'
	classInstanceVariableNames: ''!
StatusBarItemAbstract guid: (GUID fromString: '{87B4C4BF-026E-11D3-9FD7-00A0CC3E4A32}')!
StatusBarItemAbstract comment: 'StatusBarItemAbstract is an abstract class whose subclasses represent the items held by a <StatusBar> view.

Subclasses should redefine the #drawItem:bounding: to paint in the desired manner.

Instance Variables:
	border		<integer> representing the Windows border style for the item.
	width		<integer> representing the pixel width of the item. This should be -1 if the item is to occupy the full width of the status bar.
	parentView	<Status> bar holding the item.
	model		<ValueHolder> model holding the item''s data.

Class Variables:
	BorderStyles	<IdentityDictionary> mapping border style symbols to style integers.



'!
!StatusBarItemAbstract categoriesForClass!MVP-Views-Support! !
!StatusBarItemAbstract methodsFor!

beFullWidth
	"Set the width of the receiver so it will stretch to the far
	right of its parent view."

	self width: -1!

border
	"Private - Answer the receivers border."

	^border!

border: anInteger
	"Private - Set the receivers border."

	border := anInteger.
	self update!

borderStyle
	"Answer a symbol describing the border style of the receiver"

	^BorderStyles keyAtValue: self border!

borderStyle: aSymbol
	"Set the border of the receiver to the style dictated by aSymbol. This can be one of:

	#noBorder
	#sunkenBorder
	#raisedBorder "

	self border: (BorderStyles at: aSymbol)
!

drawItem: aCanvas bounding: aRectangle 
	^self subclassResponsibility!

extent: aPoint
	"Set the receiver's extent (the height is ignored)."

	self width: aPoint x!

getText
	"Private - Answer the text for this item."

	^model isNil
		ifTrue: ['']
		ifFalse: [model value]!

getTipText
	"Private - Answer the tool-tip text for this item.
	Implementation Note: Use the same text as the content."

	^self getText!

hasParentView
	"Private - Answer whether a valid parentView has been set for the receiver."

	^self parentView notNil!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	border := 0.
	width := -1!

invalidate
	"Invalidate the entire client area so that it will be re-painted"

	self parentView invalidateRect: self rectangle!

model
	"Answer the model (if any) for the receiver"
	
	^model!

model: aValueModel
	"Set model for the receiver. Overridden by subclasses that wish to connect
	to specific update events generated by the model"
	
	model := aValueModel.
	aValueModel when: #valueChanged send: #onValueChanged to: self.
	self refreshContents
!

name
	"Answer the name of the receiver in its parent or nil if no
	name has been set"

	^self parentView nameOf: self.
!

name: aStringOrNil
	"Set the name of the receiver in its parent to aStringOrNil"

	^self parentView name: self as: aStringOrNil.
!

onClick: aPoint 
	"This item was left-clicked at the specified <Point>."

	self trigger: #clicked: with: aPoint!

onDoubleClick: aPoint 
	"This item was left double-clicked at the specified <Point>."

	self trigger: #doubleClicked: with: aPoint!

onRightClick: aPoint 
	"This item was right-clicked at the specified <Point>."

	self trigger: #rightClicked: with: aPoint!

onValueChanged
	"The model held by the receiver has changed so refresh the parentView. The
	default is to invalidate the receiver and cause it to repaint."

	self refreshContents
!

onViewOpened
	"Handler for view opened"
!

parentView
	"Private - Answer the Status view which the receiver is attached to
	or nil if it is not attached."

	^parentView!

parentView: aStatus
	"Private - Set the receivers parentView."

	parentView := aStatus!

presenter: aPresenter
	"Sets the presenter associated with the receiver (ignore this request)."
!

presenterConnectionPoint
	"Answer the view within the receiver to which a same named presenter should connect.
	Normally this is the receiver itself. Some views that wish to direct the presenter
	to connect to another view may override this method however"

	^self!

rectangle
	"Answer the rectangle of the receiver in its parentView coordinates."

	^parentView rectangleOfItem: self!

refreshContents
	"The model held by the receiver has changed so refresh the display
	of the receiver in the parentView. The default is to invalidate the 
	receiver and cause it to repaint."

	self hasParentView ifTrue: [
		self updateTipText; invalidate]!

style
	"Answer the <integer> style flags to be used when displaying the receiver."

	^self border bitOr: SBT_OWNERDRAW !

update
	"Private - Update the parentView common controls knowledge of the receiver."

	parentView notNil ifTrue: [
		parentView updateItem: self ]!

updateTipText
	"Private - Update the receiver's tool tip text.
	We set this to be the same as the receiver's text so that full text can be viewed when
	truncated."

	self parentView setItem: self tipText: self getTipText!

width
	"Answer the width in pixels of the receiver, or -1 if the receiver
	is stretched to the end of its parentView."

	^width!

width: widthInteger
	"Set the width in pixels."

	width := widthInteger.
	self update! !
!StatusBarItemAbstract categoriesFor: #beFullWidth!accessing!public! !
!StatusBarItemAbstract categoriesFor: #border!accessing!private! !
!StatusBarItemAbstract categoriesFor: #border:!accessing!private! !
!StatusBarItemAbstract categoriesFor: #borderStyle!accessing!public! !
!StatusBarItemAbstract categoriesFor: #borderStyle:!accessing!public! !
!StatusBarItemAbstract categoriesFor: #drawItem:bounding:!drawing!private! !
!StatusBarItemAbstract categoriesFor: #extent:!accessing!public! !
!StatusBarItemAbstract categoriesFor: #getText!private!updating! !
!StatusBarItemAbstract categoriesFor: #getTipText!private!updating! !
!StatusBarItemAbstract categoriesFor: #hasParentView!private!views! !
!StatusBarItemAbstract categoriesFor: #initialize!initializing!private! !
!StatusBarItemAbstract categoriesFor: #invalidate!drawing!public! !
!StatusBarItemAbstract categoriesFor: #model!accessing!public! !
!StatusBarItemAbstract categoriesFor: #model:!accessing!public! !
!StatusBarItemAbstract categoriesFor: #name!accessing!public! !
!StatusBarItemAbstract categoriesFor: #name:!accessing!public! !
!StatusBarItemAbstract categoriesFor: #onClick:!event handling!public! !
!StatusBarItemAbstract categoriesFor: #onDoubleClick:!event handling!public! !
!StatusBarItemAbstract categoriesFor: #onRightClick:!event handling!public! !
!StatusBarItemAbstract categoriesFor: #onValueChanged!event handling!public! !
!StatusBarItemAbstract categoriesFor: #onViewOpened!event handling!public! !
!StatusBarItemAbstract categoriesFor: #parentView!accessing!private! !
!StatusBarItemAbstract categoriesFor: #parentView:!accessing!private! !
!StatusBarItemAbstract categoriesFor: #presenter:!accessing!public! !
!StatusBarItemAbstract categoriesFor: #presenterConnectionPoint!accessing!public! !
!StatusBarItemAbstract categoriesFor: #rectangle!accessing!public! !
!StatusBarItemAbstract categoriesFor: #refreshContents!public!updating! !
!StatusBarItemAbstract categoriesFor: #style!accessing!public! !
!StatusBarItemAbstract categoriesFor: #update!private!updating! !
!StatusBarItemAbstract categoriesFor: #updateTipText!private!updating! !
!StatusBarItemAbstract categoriesFor: #width!accessing!public! !
!StatusBarItemAbstract categoriesFor: #width:!accessing!public! !

!StatusBarItemAbstract class methodsFor!

initialize
	"Private - Initialize the receiver.

	self initialize.
"
	BorderStyles := ##(IdentityDictionary new
		at: #noBorder put: SBT_NOBORDERS;
		at: #sunkenBorder put: 0;
		at: #raisedBorder put: SBT_POPOUT;
		yourself).
!

new
	"Answer a new initialize instance of the receiver."

	^super new initialize!

separator: width
	"Answer a new instance of the receiver which appears blank."

	^self new
		width: width;
		borderStyle: #noBorder;
		yourself! !
!StatusBarItemAbstract class categoriesFor: #initialize!development!initializing!private! !
!StatusBarItemAbstract class categoriesFor: #new!instance creation!public! !
!StatusBarItemAbstract class categoriesFor: #separator:!instance creation!public! !

