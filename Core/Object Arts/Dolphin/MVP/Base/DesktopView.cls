"Filed out from Dolphin Smalltalk X6.1"!

View subclass: #DesktopView
	instanceVariableNames: 'resolution defaultExtentBlock dvReserved1 dvReserved2'
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DesktopView guid: (GUID fromString: '{87B4C70E-026E-11D3-9FD7-00A0CC3E4A32}')!
DesktopView comment: 'DesktopView is a <compositeView> representing the Windows desktop. 

Instance Variables:
	resolution	<Point>holding the logical pixels per inch of the Window''s system font.

Class Variables:
	Current	<DesktopView> singleton instance of the desktop.

'!
!DesktopView categoriesForClass!MVP-Views! !
!DesktopView methodsFor!

actualFont
	"Private - Answer the actual font to be used to paint text in the receiver"

	^self font ifNil: [self iconTitleFont]!

addCommandHistory: aCommand
	"Private - Provided for protocol compatiblity with Shell presenters.
	DesktopViews do not support command history do do nothing"
!

addSubView: aView
	"Adds aView as a subview of the receiver. Can only be called before aView is realized
	due to a Windows bug where setParent: does not work reliably. The act of adding the 
	view realizes it"

	aView parentView: self.
	aView create.
	self onSubViewAdded: aView.

	^aView.!

allParents
	"Answers a <sequencedReadableCollection> of all parents of the receiver including, ultimately,
	the desktop."

	^#()!

ambientBackcolor
	"Private - Answer the background colour that should be inherited by top-level views that
	don't have their own background colour specified. In this case it should be those views own
	default background colour."

	^Color default!

assumeDesktopHandle
	"Ensure the receiver represents the Windows desktop.
	Note that we associate with both the true desktop handle and null."

	self attachHandle: self class desktopHandle.
	SessionManager inputState windowAt: 0 put: self!

basicActualBackcolor
	"Private - Answer the <Color> to be applied as the receiver's background colour."

	^Color default!

buttonRemoved: aPushButton 
	"Private - Informs the receiver that aPushButton has been removed from the child hierachy."

	!

canvas
	"Answer a Canvas for the desktop."

	^Canvas forDesktop!

caption
	"Answers the caption for the receiver.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop."

	^self text!

caption: aString
	"Set the caption for the receiver. Usually sent by a Presenter
	that wishes to display a caption in it's associated view.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We use the same implementation
	as <ShellView>."

	self text: aString.
	self trigger: #captionChanged!

commandPolicyWithSource: sourceView
	"Answers a <CommandPolicy> object for routing commands originating
	from the <View>, source.
	N.B. This is implemented to complete the <topPresenter> protocol, it is required
	so that commands can be routed for views parented directly by the desktop which
	do not have a shell."

	^CommandPolicy defaultClass 
		commandSource: sourceView!

defaultExtentOf: aShellView 
	"Private - Answer the default extent of a ShellView created within the receiver."

	^aShellView class defaultExtentBlock value: aShellView!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Desktop'!

ensureSubView: aView rectangleVisible: aRectangle
	"Private - Ensures that the aRectangle area of the receiver's sub-<View>, aView,
	is visible in the receiver if the parent has this level of control."
!

ensureVisible
	"Ensures that the receiver is visible. 
	The desktop is always visible so do nothing"


	!

filerProxy
	"Private - Answer a filer proxy that represents the receiver."

	^STBSingletonProxy forClass: self class!

helpId
	"Answer an integer ID used to associate the receicer with pop-up help"

	^-1!

iconTitleFont
	"Answer a <Font> which is that used for icon titles on the desktop."

	^SystemMetrics current iconTitleFont!

invalidateLayout
	"Nothing to do."
!

invalidateRect: aRectangle erase: aBoolean 
	"Invalidates the specified desktop rectangle (a RECT, Rectangle, or nil for the whole client window).
	Set whether to erase the receivers background before repainting. Answer whether the function succeeds."

	^UserLibrary default 
		invalidate: handle
		lpRect: aRectangle asParameter
		bErase: aBoolean asParameter
!

invalidateUserInterface
	"Invalidates the user interface of the receiver indicating that it needs
	to be requeried using #validateUserInterface (usually at idle time)"

	flags := flags maskClear: UIValidMask.!

isLayoutValid
	"Answer true if the layout of the receiver is currently valid"

	"Implementation Note: We have no control over the desktop's layout."

	^true!

layoutManager: layoutManager
	"Sets the layout manager of the receiver to <layoutManager>. The Windows desktop
	does not support layout managers so we deny the ability to set one."

	^self shouldNotImplement!

name
	"Answer the name of the receiver in its parent or nil if no name has been set.
	Implementation Note: The receiver has no parent, and therefore no name."

	^nil!

name: aStringOrNil
	"Set the name of the receiver in its parent to aStringOrNil.
	Implementation Note: The receiver has no parent, so this does not make sense."

	^self shouldNotImplement!

name: aView as: aNameStringOrNil 
	self shouldNotImplement!

onAboutToDisplaySystemMenu: hMenu
	"The system menu with <integer> handle, hMenu, is about to be displayed.
	This is our opportunity to update it, e.g. to add our own items.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We use the same implementation
	as <ShellView>."

	self presenter trigger: #aboutToDisplaySystemMenu: with: hMenu.
	^0!

onStartup
	"Make sure the receiver represents the desktop window handle."

	self assumeDesktopHandle.
	resolution := nil
!

onViewActivated: anEvent
	"Default handler for window activation.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We accept the default window
	procedures implementation."

	self trigger: #viewActivated.
	^self defaultWindowProcessing: anEvent!

onViewDeactivated: anEvent
	"Default handler for window de-activation.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We accept the default window
	procedures implementation."

	self trigger: #viewDeactivated.
	^self defaultWindowProcessing: anEvent!

onViewMinimized: anEvent
	"Default handler for window iconification.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We accept the default window
	procedures implementation."

	self presenter trigger: #viewMinimized.
	^self defaultWindowProcessing: anEvent!

onViewRestored: anEvent
	"Default handler for window restoration from iconic state.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop. We use the same implementation
	as <ShellView>."

	self presenter trigger: #viewRestored.
	^self defaultWindowProcessing: anEvent!

performCommand: aCommand
	"Performs aCommand on the receiver and answer the result.
	Can be overridden by subclasses that wish, perhaps, to add some
	generic undo/redo ability for all commands."

	^aCommand value!

queryContextMenu
	"Answer the context <Menu> that is associated with the receiver, if any.
	We're not in control of the desktop's context menu."

	^nil!

refresh
	"Redraw the entire desktop and all windows (i.e. a complete screen refresh). This will cause
	a lot of flashing!!"

	^UserLibrary default 
		invalidate: nil
		lpRect: nil
		bErase: true!

resolution
	"Answer the logical pixels per inch of the desktop"

	resolution isNil ifTrue: [
		resolution := self canvas resolution ].
	^resolution
!

screenRectangle
	"Answer the boundary of the receiver window in screen coordinates"

	^self clientRectangle!

setDefaultButton: button state: setDefault
	"Private - Set aPushButton as being the default button within the receiver according 
	to aBoolean.
	Implementation Note: Required in order to be able to create default buttons in the context
	of the desktop."

	!

setFocus
	^UserLibrary default setFocus: self asParameter!

topShell
	"Answer the first <topPresenter> located in the parent chain of the receiver."

	^self!

topView
	^self!

updateCaption
	"The receiver has changed in such a way that the caption may need to be refreshed.
	N.B. This is only really implemented to complete the <topPresenter> protocol, it
	doesn't haven much meaning for the desktop so do nothing."

	!

withAllParentsDo: aMonadicValuable 
	^aMonadicValuable value: self!

workArea
	"Answer a <Rectangle> which is the desktop area excluding that 
	occuppied by the tool bar."

	^(SystemMetrics current getSysParamStruct: SPI_GETWORKAREA type: RECT) asRectangle! !
!DesktopView categoriesFor: #actualFont!accessing!private! !
!DesktopView categoriesFor: #addCommandHistory:!accessing!private! !
!DesktopView categoriesFor: #addSubView:!hierarchy!public!sub views! !
!DesktopView categoriesFor: #allParents!hierarchy!public! !
!DesktopView categoriesFor: #ambientBackcolor!accessing!private! !
!DesktopView categoriesFor: #assumeDesktopHandle!accessing!public! !
!DesktopView categoriesFor: #basicActualBackcolor!accessing!private! !
!DesktopView categoriesFor: #buttonRemoved:!default button!private! !
!DesktopView categoriesFor: #canvas!accessing!public! !
!DesktopView categoriesFor: #caption!accessing!public! !
!DesktopView categoriesFor: #caption:!accessing!public! !
!DesktopView categoriesFor: #commandPolicyWithSource:!commands!public! !
!DesktopView categoriesFor: #defaultExtentOf:!geometry!helpers!private! !
!DesktopView categoriesFor: #displayOn:!displaying!public! !
!DesktopView categoriesFor: #ensureSubView:rectangleVisible:!private!updating! !
!DesktopView categoriesFor: #ensureVisible!accessing!public! !
!DesktopView categoriesFor: #filerProxy!binary filing!private! !
!DesktopView categoriesFor: #helpId!accessing!public! !
!DesktopView categoriesFor: #iconTitleFont!geometry!public! !
!DesktopView categoriesFor: #invalidateLayout!geometry!public! !
!DesktopView categoriesFor: #invalidateRect:erase:!drawing!public! !
!DesktopView categoriesFor: #invalidateUserInterface!accessing!public! !
!DesktopView categoriesFor: #isLayoutValid!geometry!public!testing! !
!DesktopView categoriesFor: #layoutManager:!geometry!public! !
!DesktopView categoriesFor: #name!accessing!public! !
!DesktopView categoriesFor: #name:!accessing!public! !
!DesktopView categoriesFor: #name:as:!hierarchy!public!sub views! !
!DesktopView categoriesFor: #onAboutToDisplaySystemMenu:!event handling!public! !
!DesktopView categoriesFor: #onStartup!event handling!public! !
!DesktopView categoriesFor: #onViewActivated:!event handling!public! !
!DesktopView categoriesFor: #onViewDeactivated:!event handling!public! !
!DesktopView categoriesFor: #onViewMinimized:!event handling!public! !
!DesktopView categoriesFor: #onViewRestored:!event handling!public! !
!DesktopView categoriesFor: #performCommand:!commands!public! !
!DesktopView categoriesFor: #queryContextMenu!menus!public! !
!DesktopView categoriesFor: #refresh!drawing!public! !
!DesktopView categoriesFor: #resolution!accessing!public! !
!DesktopView categoriesFor: #screenRectangle!geometry!public! !
!DesktopView categoriesFor: #setDefaultButton:state:!accessing!default button!private! !
!DesktopView categoriesFor: #setFocus!operations!public! !
!DesktopView categoriesFor: #topShell!hierarchy!public! !
!DesktopView categoriesFor: #topView!hierarchy!public! !
!DesktopView categoriesFor: #updateCaption!public!updating! !
!DesktopView categoriesFor: #withAllParentsDo:!hierarchy!public! !
!DesktopView categoriesFor: #workArea!geometry!public! !

DesktopView methodProtocol: #compositeView attributes: #(#readOnly) selectors: #(#addSubView: #allParents #allSubViews #arrangement #arrangement: #backcolor #backcolor: #canAcceptSubViews #canvas #clientExtent #clientHeight #clientRectangle #clientWidth #close #contextMenu #contextMenu: #cursor #cursorPosition #destroy #disable #disableRedraw #enable #enableRedraw #ensureLayoutValid #ensureRectangleVisible: #ensureSubView:rectangleVisible: #ensureSubViewVisible: #ensureVisible #extent #extent: #firstSubView #font #font: #forecolor #forecolor: #hasBorder #hasBorder: #hasClientEdge #hasClientEdge: #hasFocus #hasLayoutManager #hasStaticEdge #hasStaticEdge: #hasVisibleStyle #hasVisibleStyle: #height #height: #hide #invalidate #invalidateCalculatedExtent #invalidateLayout #invalidateRect: #invalidateRect:erase: #invalidateRgn: #invalidateUserInterface #isEnabled: #isGroupStop #isGroupStop: #isLayoutValid #isManaged #isManaged: #isTabStop #isTabStop: #isTopView #isTransparent #isTransparent: #isWindowVisible #layout #layoutExtent: #layoutManager #layoutManager: #managedSubViews #mapPoint:to: #mapRectangle:to: #model #model: #name #name: #nameOf: #needsValidateLayout #nextSiblingView #nonClientCanvas #onAboutToCreate #onBegin:drag: #onCommand: #onCreated: #onDestroyed #onEraseRequired: #onFullyCreated #onHScroll: #onModelChanged #onPaintRequired: #onSubViewAdded: #onSubViewRemoved: #onVScroll: #onZOrderChanged #parentView #placement #placement: #plainText #position #position: #preferredExtent #preferredExtent: #presenter #presenter: #presenterConnectionPoint #preTranslateKeyboardInput: #preTranslateMessage: #preTranslateMouseInput: #previousSiblingView #queryContextMenu #recreate #rectangle #rectangle: #refreshContents #removeSubView: #resolution #screenRectangle #screenRectangle: #scrollBy:clip: #scrollBy:scroll:clip: #setCapture #styles #subViewFromPoint: #subViewFromPoint:flags: #subViews #tabFirst #tabNext #text #text: #topView #update #updateModel #usePreferredExtent #usePreferredExtent: #validate #validateLayout #validateRect: #validateUserInterface #viewNamed: #viewNamed:ifNone: #width #width: #withAllParents #withAllSubViews #x #x: #y #y: #zOrderAfter: #zOrderAfter:withFlags: #zOrderBottom #zOrderTop)!
DesktopView methodProtocol: #topPresenter attributes: #(#readOnly) selectors: #(#caption #caption: #commandPolicyWithSource: #ensureVisible #invalidateUserInterface #onAboutToDisplayMenu: #onAboutToDisplaySystemMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewActivated: #onViewClosed #onViewDeactivated: #onViewMinimized: #onViewOpened #onViewRestored: #parentPresenter #performAction #performCommand: #setFocus #show #topShell #updateCaption #view)!

!DesktopView class methodsFor!

current
	"Answers the singleton instance of the receiver."

	^Current!

current: aDesktopView
	"Sets the singleton instance of the receiver."

	Current := aDesktopView!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Initialize the DesktopView singleton."

	Current := self new
			assumeDesktopHandle;
			yourself!

stbConvertFromVersion9: anArray 
	"Private - Perform an STB conversion from a version 9 (or earlier) instance
	of the receiver to version 10,
		10: append iconTitleFont inst. var., and a couple more reserved for future use
	"

	| newArray array |
	array := super stbConvertFromVersion9: anArray.
	newArray := Array new: array size + 3.
	newArray
		replaceFrom: 1
			to: 13
			with: array
			startingAt: 1;
		replaceFrom: 17
			to: newArray size
			with: array
			startingAt: 13.
	^newArray!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Current isNil ifTrue: [^self].
	SessionManager inputState removeWindowAt: 0.
	Current
		winFinalize;
		handle: nil.
	Current := nil! !
!DesktopView class categoriesFor: #current!accessing!public! !
!DesktopView class categoriesFor: #current:!accessing!public! !
!DesktopView class categoriesFor: #icon!constants!public! !
!DesktopView class categoriesFor: #initialize!development!initializing!public! !
!DesktopView class categoriesFor: #stbConvertFromVersion9:!binary filing!private! !
!DesktopView class categoriesFor: #uninitialize!class hierarchy-removing!private! !

