"Filed out from Dolphin Smalltalk X6.1"!

Menu subclass: #MenuBar
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MenuBar guid: (GUID fromString: '{87B4C641-026E-11D3-9FD7-00A0CC3E4A32}')!
MenuBar comment: 'MenuBar represents the special class of menus drawn horizontally across the top of the client area of a top-level view, i.e. the menu bar.
'!
!MenuBar categoriesForClass!Graphics-Tools! !
!MenuBar methodsFor!

createHandle
	"Private - Answer an external handle to a new menu."

	^UserLibrary default createMenu!

isMenuBar
	"Answer whether the receiver is a menu bar rather
	than a popup menu."

	^true!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	aStream basicPrint: self
!

queryAlong: aCommandPolicy 
	"Answer a <CommandQuery> reflecting the current state of the receiver's command for the
	specified <commandPolicy>. We want top-level MenuBars to be enabled by default."

	| src |
	src := aCommandPolicy source.
	^(CommandQuery commandDescription: self commandDescription source: src)
		receiver: src topView;
		beEnabled;
		yourself!

showIn: aWindow position: aPos
	"Private - Show the receiver in aWindow at aPos."

	^self shouldNotImplement! !
!MenuBar categoriesFor: #createHandle!private!realizing/unrealizing! !
!MenuBar categoriesFor: #isMenuBar!public!testing! !
!MenuBar categoriesFor: #printOn:!printing!public! !
!MenuBar categoriesFor: #queryAlong:!operations!public! !
!MenuBar categoriesFor: #showIn:position:!drawing!private! !

