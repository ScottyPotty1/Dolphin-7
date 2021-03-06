"Filed out from Dolphin Smalltalk X6"!

CheckButton subclass: #CheckBox
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CheckBox guid: (GUID fromString: '{87B4C734-026E-11D3-9FD7-00A0CC3E4A32}')!
CheckBox comment: 'CheckBox is a <valueView> implementing the Windows "BUTTON" class in either BS_AUTOCHECKBOX or BS_AUTO3STATE style. The <valueModel> associated with a CheckBox must alway yield a <boolean> value once mapped through the installed type converter, although nil is also an acceptable value for a 3-state button where it indicates that the button is in an indeterminate state. A CheckBox will normally be used in conjunction with a <BooleanPresenter>.'!
!CheckBox categoriesForClass!MVP-Views! !
!CheckBox methodsFor!

basicWindowStyle
	"Private - Answer a basic default style to use when creating a checkbox."

	^BS_AUTOCHECKBOX!

is3State
	"Answer whether the receiver is a 3-state check box that can be 'dimmed' as well as checked
	and unchecked."

	^(self baseStyle bitAnd: BS_TYPEMASK) = BS_AUTO3STATE!

is3State: aBoolean 
	"Set whether the receiver is a 3-state check box that can be 'dimmed' as well as checked
	and unchecked."

	self baseStyle: (aBoolean ifTrue: [BS_AUTO3STATE] ifFalse: [self basicWindowStyle])
		maskedBy: BS_TYPEMASK!

paintTransparentBackgroundOn: aCanvas 
	self isThemed ifFalse: [^self].
	ThemeLibrary default 
		drawThemeParentBackground: self asParameter
		hdc: aCanvas asParameter
		prc: nil! !
!CheckBox categoriesFor: #basicWindowStyle!constants!private! !
!CheckBox categoriesFor: #is3State!accessing!public! !
!CheckBox categoriesFor: #is3State:!accessing!public! !
!CheckBox categoriesFor: #paintTransparentBackgroundOn:!private!updating! !

!CheckBox class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!CheckBox class categoriesFor: #icon!constants!public! !

