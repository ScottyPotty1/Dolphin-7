"Filed out from Dolphin Smalltalk X6.1"!

SmalltalkToolShell subclass: #IdbShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdbShell guid: (GUID fromString: '{D143E0F5-FB16-48B9-999E-C66F61C6FD3E}')!
IdbShell comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!IdbShell categoriesForClass!IDB Goodies! !
!IdbShell methodsFor!

idbAbout
	self subclassResponsibility!

idbAbout: aString
	self class idbAbout: aString!

idbHelp
	self subclassResponsibility!

idbHelp: aFileNameStem
	self class idbHelp: aFileNameStem! !
!IdbShell categoriesFor: #idbAbout!public! !
!IdbShell categoriesFor: #idbAbout:!operations!public! !
!IdbShell categoriesFor: #idbHelp!public! !
!IdbShell categoriesFor: #idbHelp:!operations!public! !

!IdbShell class methodsFor!

defaultIconName
	^self idbDefaultIconName!

idbAbout: aString
	(Splash
		bitmap:
			(Bitmap fromFile: (File composePath: SessionManager current idbResourcesFolder subPath: 'about.bmp'))
		overlayWith:
			[:canvas | 
			Processor sleep: 1000.
			canvas
				backgroundMode: TRANSPARENT;
				forecolor: Color blue;
				font: (Font name: 'Arial' pointSize: 11) beBold;
				formatText: aString
					in: ((0 @ 0 extent: 250 @ 180) insetBy: 8 @ 8)
					flags: DT_CENTER]) show!

idbHelp: aFileNameStem
	ShellLibrary default
		shellOpen:
			(File
				composePath: SessionManager current idbDocumentationFolder
				stem: aFileNameStem
				extension: 'html')! !
!IdbShell class categoriesFor: #defaultIconName!constants!public! !
!IdbShell class categoriesFor: #idbAbout:!operations!public! !
!IdbShell class categoriesFor: #idbHelp:!operations!public! !

