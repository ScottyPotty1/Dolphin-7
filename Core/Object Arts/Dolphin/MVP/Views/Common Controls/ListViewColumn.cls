"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ListViewColumn
	instanceVariableNames: 'text width alignment getTextBlock getSortValueBlock getContentsBlock name parent getImageBlock flags getInfoTipBlock customDrawBlock'
	classVariableNames: 'AutoResizeMask SortInvertedMask'
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''!
ListViewColumn guid: (GUID fromString: '{87B4C499-026E-11D3-9FD7-00A0CC3E4A32}')!
ListViewColumn comment: 'ListViewColumn is a description of a column held by a <ListView>. Note that, columns are only displayed when a list is in #report mode.

Each column is configurable using a number of valuables (usually blocks) which determine how the item objects held by the list are mapped to information to be presented in the column.The first mapping is achieved by the getContentsBlock which, given the list item, determines the object that the column actually represents. How this contents object is then mapped to the displayed text is determined by the getTextBlock. Similarly, the getImageBlock is used to map a contents object to the index of an image to display in the column (the ImageManager that will be used to obtain the actual image is that of the ListView itself). In order to determine how a column will be sorted (an operation that is automatically perform when a column header is clicked) the getSortValueBlock can be set. This takes a contents object and maps it to an appropriate sort value. If it is necessary for a column to display "tip text" then a getInfoTipBlock can be used to specify the mapping between a contents object and this text. Lastly the customDrawBlock can be used to control the appearance for individual column entries. The above blocks are initialized to defaults with the following actions:

getContentsBlock	- use the list item itself (the primary column object).
getTextBlock		- use #displayString on the contents object.
getImageBlock		- do not display images.
getSortValueBlock	- use the contents object itself.
getTipText			- do not display tip text.
customDrawBlock	- nil, no custom draw.

Unlike the other blocks the customDrawBlock is not passed the column element calculated by the getContentsBlock, but instead receives a 
NMLVCUSTOMDRAW instance. This holds the item for the whole row, and can be updated with the foreground and background colours, and any change of font (such as italics or bold) that the ListView control should use to paint the column item.

One other ListViewColumn aspect worthy of note is #isAutoResize. Normally, columns have a fixed width (specified by the #width aspect) and they do not change size if the parent list is resized. This is the standard behaviour of the underlying Windows control. However, by setting #isAutoResize to true, the ListView will treat the column as dynamically re-sizeable. It will attempt to share the width remaining, after all fixed columns have been accounted for, between each of the auto-resizeable columns.

Instance Variables:
	text				<readableString> that is the heading text for the column.
	width			<integer> width of the column in pixels.
	alignment		<Symbol> describing the alignment  (#left, #center, #right) of the text in the column.
	getTextBlock	<monadicValuable> mapping a contents object to a <readableString> to be displayed.
	getSortValueBlock	<monadicValuable> mapping a contents object to an object that can be used as the sort basis for the column.
	getContentsBlock	<monadicValuable> mapping a list item to the column object presented by this column.
	compareBlock	<dyadicValuable> reserved for future use.
	parent			<ListView> holding this column.
	getImageBlock	<monadicValuable>or nil, mapping a contents object to an image index.
	isAutoResize	<boolean> indicating whether the column should dynamically resize to fill available space.
	getInfoTipBlock	<monadicValuable> mapping a content object to a <readableString> for the column''s tip text.
	customDrawBlock <monadicValuable> evaluated to customise the appearance of individual column entries.'!
!ListViewColumn categoriesForClass!MVP-Views-Support! !
!ListViewColumn methodsFor!

alignment
	"Answer a Symbol listing the alignment of text within this column;
	left, right, centre."

	^alignment!

alignment: aSymbol
	"Sets the alignment of the receiver to aSymbol.
	This can be one of #left, #center or #right."

	alignment := aSymbol.
	self update
!

alignmentCenter
	"Align contents and title to the center of the column."

	self alignment: #center.!

alignmentLeft
	"Align contents and title to the left of the column."

	self alignment: #left!

alignmentRight
	"Align contents and title to the right of the column."

	self alignment: #right.
!

basicWidth
	"Private - Answer the intended width of the column in pixels." 

	^width
!

basicWidth: widthPixels
	"Private - Set the intended width of the column in pixels." 

	width := widthPixels!

contentFromRow: item
	"Private - Answer the content of this column extracted from the <Object>, item,
	which is an element of the receiver's parent <ListView>.
	As of Dolphin 3.0 the content block is permitted to be nil for the common case
	where the columns content needs to be the entire item."

	^getContentsBlock isNil 
		ifTrue: [item]
		ifFalse: [getContentsBlock value: item]!

customDrawBlock 
	"Answer the <monadicValuable> used to set custom draw text attributes for this column 
	or nil if custom drawing is not employed specifically for this column."

	^customDrawBlock!

customDrawBlock: operation
	"Set the <monadicValuable> used for custom drawing.
	When evaluated the valuable is passed a <customDrawContext>, which provides methods for setting text 
	attributes such as the font and foreground and background colours. In cases where total control over the 
	visual appearance of the item is required the canvas associated with the custom drawing context can be used, 
	and the operation should answer true to inform the View that all default drawing should be disabled."

	customDrawBlock := operation!

defaultGetContentsBlock
	"Private - Answer a <monadicValuable> to be used as the default mechanism
	for extracting the content object for this column from the primary object for a 
	particular ListView row. If the answer is nil then the default is for the column's 
	contents to be the primary (row) object itself."

	^nil!

defaultGetImageBlock
	"Private - Answer a <monadicValuable>, or nil, to use to find out the image index of an object 
	that will be placed in the receiver. Nil is treated as implying the column has no associated images.
	Implementation Note: Answer nil as by default we do not have per-column images."

	^nil!

defaultGetTextBlock
	"Private - Answer a <monadicValuable> that can be used by default to
	get the text object for this column's contents. A sensible default is for 
	this valuable to answer the content's #displayString."

	^Message selector: #displayString!

defaultSortBlock
	"Private - Answer a <dyadicValuable> (e.g. a two argument block)
	that can be used to compare two contents objects in this column."

	^Message selector: #<=!

defaultWidth
	"Private - Answer the default width of a newly created column"

	^100!

getContentsBlock
	"Private - Answer a single argument Block which takes the primary object for 
	a ListView row and returns the content object for this column"

	^getContentsBlock!

getContentsBlock: aOneArgBlock
	"Set the receiver's getContentsBlock to aOneArgBlock. This takes the 
	primary object for a ListView row and returns the content object for this
	column"

	getContentsBlock := aOneArgBlock.
	self update!

getImageBlock
	"Answer the block to use to find out the image index of an object that will
	be placed in the receiver"

	^getImageBlock!

getImageBlock: aOneArgBlock
	"Set the block to use to find out the image index of an object that will
	be placed in the receiver"

	getImageBlock := aOneArgBlock.
	self update!

getInfoTipBlock
	"Answer the value of the receiver's 'getInfoTipBlock' instance variable."

	^getInfoTipBlock!

getInfoTipBlock: anObject
	"Set the value of the receiver's 'getInfoTipBlock' instance variable to the argument, anObject."

	getInfoTipBlock := anObject!

getTextBlock
	"Answer a single argument Block which takes an object and returns
	a string suitable for displaying in the column."

	^getTextBlock!

getTextBlock: aOneArgBlock
	"Set the receiver's getTextBlock; a single argument block which takes an object and returns
	a string suitable for displaying."

	getTextBlock := aOneArgBlock.
	self update!

headerIcon: aBoolean
	"Private - Answer the image to be displayed in the header for the receiver. The argument
	is true if the receiver is the selected column. Answer nil for no image."

	^aBoolean 
		ifTrue: 
			[self isSortOrderInverted 
				ifTrue: [Icon fromId: 'DownArrow.ico']
				ifFalse: [Icon fromId: 'UpArrow.ico']]!

imageFromRow: item
	"Private - Answer the image for this column extracted from the <Object>, item,
	which is an element of the receiver's parent <ListView>.
	As of Dolphin 3.0 the image block is permitted to be nil for the common case
	where the columns does not have images."

	KernelLibrary isWine ifTrue: [
		#wineFix.
		"Wine ListViews seem to expect image indices to always be set in ListView>>onDisplayDetailsRequired:, 
		even if we don't want images to appear. Normally, we answer nil here if no image is required. 
		In Wine we must answer an image index of 0"
		getImageBlock ifNil: [^0]].

	^getImageBlock isNil ifFalse: [
		getImageBlock value: (self contentFromRow: item)].
!

index
	"Answer the one based index of the receiver in its parent"

	^self parent allColumns indexOf: self!

infoTipFromRow: item withPrefix: prefixText
	"Private - Answer the info. tip for this column extracted from the <Object>, item,
	which is an element of the receiver's parent <ListView>, with the <readableString>
	prefix, prefixText, as supplied by the ListView (at the time of writing if the displayed 
	item text has been truncated with ellipsis, then prefixText will be the full item text, 
	otherwise it will be the empty string). If there is no info. tip block then answer the 
	empty string. The info. tip block can be a monadic or dynadic valuable, in either cases
	expected to evaluate to a <String>. If monadic then it is passed only the column
	content object, if dyadic it is passed the prefixText as its second argument.
	Info. Tip support is new for Dolphin 3.0.
	Note that this message is only sent to the column by the ListView when in report
	mode, as otherwise it handles this message itself. This allows for differing behaviour
	in a view dynamically switchable between modes."

	^getInfoTipBlock isNil 
		ifTrue: ['']
		ifFalse: [ | content |
			content := self contentFromRow: item.
			(getInfoTipBlock argumentCount > 1
				ifTrue: [getInfoTipBlock value: content value: prefixText]
				ifFalse: [getInfoTipBlock value: content]) displayString]
!

initialize
	"Private - Initialize the state of the receiever."

	self alignmentLeft.
	getContentsBlock := self defaultGetContentsBlock.
	getTextBlock := self defaultGetTextBlock.
	getSortValueBlock := self defaultSortBlock.
	text := ''.
	width := self defaultWidth.
	flags := 0!

isAlignmentCenter
	"Answer whether the text in this column is centered."

	^alignment = #center!

isAlignmentLeft
	"Answer whether the text in this column is aligned to the left."

	^alignment = #left!

isAlignmentRight
	"Answer whether the text in this column is aligned to the right."

	^alignment = #right!

isAutoResize
	"Answer true if the receiver will attempt to share the available width in it's parent with
	other auto-resize columns"

	^flags anyMask: AutoResizeMask!

isAutoResize: aBoolean 
	"Set the auto-resize feature of the receiver to aBoolean. If enabled, the receiver will 
	attempt to share the available width in it's parent with other auto-resize columns"

	flags := flags mask: AutoResizeMask set: aBoolean.
	self parent ifNotNil: [:list | list autoResizeColumns]!

isSortable
	^getSortValueBlock isNil not!

isSortOrderInverted
	^flags anyMask: SortInvertedMask!

isSortOrderInverted: aBoolean
	flags := flags mask: SortInvertedMask set: aBoolean!

name
	"Answer the symbolic name of the column, which can be nil.
	The name is used to identify the column when needed."

	^name!

name: aSymbolOrNil
	name := aSymbolOrNil isNil ifFalse: [aSymbolOrNil asSymbol]!

parent
	"Answers the ListView parent of the receiver"

	^parent!

parent: aListViewOrNil
	"Private - Sets the ListView parent of the receiver to aListViewOrNil"

	parent := aListViewOrNil!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; print: self text; nextPut: $)!

resolutionScaledBy: scale
	"Private - The receiver is being loaded and it has been determined that the pixel resolution
	has changed since the point at which the view was saved. Scale any internal pixels by <Point>
	scale."

	width := (width * scale x) truncated


!

rowSortBlock
	"Private - Answer a two argument block that can be used to compare two rows based on this
	column, or nil if the column is not sortable."

	"Implementation Note: The first time the sort block is accessed, it is returned as
	originally set up. On the next access it is inverted, and on the next it is inverted again
	(i.e. back to the original). This effectively toggles the sort order between ascending (or
	whatever it was originally) and descending, each time the sort block is accessed."

	^self isSortable 
		ifTrue: 
			[
			| contentFromRow sortBlock |
			"Note that we avoid creating a self-reference from the block."
			contentFromRow := getContentsBlock isNil ifTrue: [[:each | each]] ifFalse: [getContentsBlock].
			sortBlock := getSortValueBlock.
			self isSortOrderInverted 
				ifTrue: [[:a :b | sortBlock value: (contentFromRow value: b) value: (contentFromRow value: a)]]
				ifFalse: 
					[[:a :b | sortBlock value: (contentFromRow value: a) value: (contentFromRow value: b)]]]!

sortBlock
	"Answer a single argument Block which takes a content object for 
	this column and answers a value which can be used as the sort basis
	for the column"

	^getSortValueBlock!

sortBlock: aDyadicValuableOrNil
	"Set the receiver's getSortValueBlock to aOneArgBlock. This takes the 
	content object for a column and returns a sort value to use as the basis
	for sorting the column"

	getSortValueBlock := aDyadicValuableOrNil.
	self update!

text
	"Answer the title for this column in the list view header."

	^text!

text: aString
	"Set the title for this column in the list view header."

	text := aString.
	self update!

textFromRow: item
	"Private - Answer the text for this column extracted from the <Object>, item,
	which is a row element of the receiver's parent <ListView>.
	As of Dolphin 3.0 the text block is permitted to be nil for the unusual case
	where the column has only images.
	As of Dolphin 4.0 #displayString is always sent to the result of the getTextBlock,
	which is useful in those cases where one forgets to answer a String. 
	#displayString on String is a very fast nop, so the extra safety costs little."

	^getTextBlock isNil 
		ifTrue: ['']
		ifFalse: [(getTextBlock value: (self contentFromRow: item)) displayString]
!

toggleSortOrder
	^self isSortOrderInverted: self isSortOrderInverted not!

update
	"Private - Update the associated ListView column if we have one"

	self parent notNil ifTrue: [
		self parent updateColumn: self ]!

width
	"Answer the real width of the column in pixels."

	| view |
	view := self parent.
	^(view notNil and: [view isOpen and: [view isReportMode]]) 
		ifTrue: [view lvmGetColumnWidth: self index - 1]
		ifFalse: [self basicWidth]!

width: anInteger 
	"Set the width of the column to the specified <integer> number of pixels.
	N.B. This may cause the width of other (auto-resizable) columns to change."

	self basicWidth: anInteger.
	self parent ifNotNil: [:view | view setWidthOfColumn: self index to: anInteger]! !
!ListViewColumn categoriesFor: #alignment!alignment!public! !
!ListViewColumn categoriesFor: #alignment:!alignment!public! !
!ListViewColumn categoriesFor: #alignmentCenter!alignment!public! !
!ListViewColumn categoriesFor: #alignmentLeft!alignment!public! !
!ListViewColumn categoriesFor: #alignmentRight!alignment!public! !
!ListViewColumn categoriesFor: #basicWidth!accessing!private! !
!ListViewColumn categoriesFor: #basicWidth:!accessing!private! !
!ListViewColumn categoriesFor: #contentFromRow:!adapters!private! !
!ListViewColumn categoriesFor: #customDrawBlock!accessing!public! !
!ListViewColumn categoriesFor: #customDrawBlock:!accessing!public! !
!ListViewColumn categoriesFor: #defaultGetContentsBlock!adapters!constants!private! !
!ListViewColumn categoriesFor: #defaultGetImageBlock!adapters!constants!private! !
!ListViewColumn categoriesFor: #defaultGetTextBlock!adapters!constants!private! !
!ListViewColumn categoriesFor: #defaultSortBlock!adapters!constants!private!sorting! !
!ListViewColumn categoriesFor: #defaultWidth!constants!private! !
!ListViewColumn categoriesFor: #getContentsBlock!adapters!private! !
!ListViewColumn categoriesFor: #getContentsBlock:!adapters!public! !
!ListViewColumn categoriesFor: #getImageBlock!adapters!public! !
!ListViewColumn categoriesFor: #getImageBlock:!adapters!public! !
!ListViewColumn categoriesFor: #getInfoTipBlock!accessing!public! !
!ListViewColumn categoriesFor: #getInfoTipBlock:!accessing!public! !
!ListViewColumn categoriesFor: #getTextBlock!adapters!public! !
!ListViewColumn categoriesFor: #getTextBlock:!adapters!public! !
!ListViewColumn categoriesFor: #headerIcon:!helpers!private! !
!ListViewColumn categoriesFor: #imageFromRow:!adapters!private!wine fix! !
!ListViewColumn categoriesFor: #index!accessing!public! !
!ListViewColumn categoriesFor: #infoTipFromRow:withPrefix:!adapters!private! !
!ListViewColumn categoriesFor: #initialize!initializing!private! !
!ListViewColumn categoriesFor: #isAlignmentCenter!alignment!public! !
!ListViewColumn categoriesFor: #isAlignmentLeft!alignment!public! !
!ListViewColumn categoriesFor: #isAlignmentRight!alignment!public! !
!ListViewColumn categoriesFor: #isAutoResize!public!testing! !
!ListViewColumn categoriesFor: #isAutoResize:!accessing!public! !
!ListViewColumn categoriesFor: #isSortable!adapters!private! !
!ListViewColumn categoriesFor: #isSortOrderInverted!private!testing! !
!ListViewColumn categoriesFor: #isSortOrderInverted:!accessing!private! !
!ListViewColumn categoriesFor: #name!accessing!public! !
!ListViewColumn categoriesFor: #name:!accessing!public! !
!ListViewColumn categoriesFor: #parent!accessing!public! !
!ListViewColumn categoriesFor: #parent:!accessing!private! !
!ListViewColumn categoriesFor: #printOn:!printing!public! !
!ListViewColumn categoriesFor: #resolutionScaledBy:!geometry!private! !
!ListViewColumn categoriesFor: #rowSortBlock!adapters!private! !
!ListViewColumn categoriesFor: #sortBlock!adapters!public!sorting! !
!ListViewColumn categoriesFor: #sortBlock:!adapters!public!sorting! !
!ListViewColumn categoriesFor: #text!accessing!public! !
!ListViewColumn categoriesFor: #text:!accessing!public! !
!ListViewColumn categoriesFor: #textFromRow:!adapters!private! !
!ListViewColumn categoriesFor: #toggleSortOrder!helpers!private! !
!ListViewColumn categoriesFor: #update!accessing!private! !
!ListViewColumn categoriesFor: #width!accessing!public! !
!ListViewColumn categoriesFor: #width:!accessing!public! !

!ListViewColumn class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the class variables of the receiver:
		self initialize
	"

	AutoResizeMask := 1.
	SortInvertedMask := 2.!

new
	"Answer a new instance of the receiver."

	^super new initialize!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier version resource. 
	Version changes:
		1: Add a getImageBlock instance variable.
		2: Addsan isAutoResize instance variable.
		3: Add getInfoTipBlock instance variable.
		4: Add customDrawBlock instance variable.
		5: Old isAutoResize variable becomes flags variable."

	^
	[:data | 
	| newInstance ver |
	newInstance := self basicNew.
	1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
	ver := anSTBClassFormat version.
	ver < 1 
		ifTrue: 
			["Leave the new getImageBlock inst. var. nilled"

			].
	ver < 2 ifTrue: [newInstance instVarAt: 10 put: false].
	ver < 3 
		ifTrue: 
			["Leave the getInfoTipBlock inst. var. nilled"

			].
	ver < 4 
		ifTrue: 
			["Leave the new customDrawBlock inst. var. nilled"

			].
	ver < 5 
		ifTrue: 
			[| wasAutoResize |
			wasAutoResize := newInstance instVarAt: 10.
			newInstance instVarAt: 10 put: (wasAutoResize ifTrue: [AutoResizeMask] ifFalse: [0])].
	newInstance]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^5!

text: titleString
	"Answer a new instance of the receiver."

	^(self new)
		text: titleString;
		yourself!

text: titleString width: widthPixels
	"Answer a new instance of the receiver."

	^(self new)
		text: titleString;
		width: widthPixels;
		yourself! !
!ListViewColumn class categoriesFor: #icon!constants!public! !
!ListViewColumn class categoriesFor: #initialize!development!initializing!private! !
!ListViewColumn class categoriesFor: #new!instance creation!public! !
!ListViewColumn class categoriesFor: #stbConvertFrom:!binary filing!public! !
!ListViewColumn class categoriesFor: #stbVersion!binary filing!public! !
!ListViewColumn class categoriesFor: #text:!instance creation!public! !
!ListViewColumn class categoriesFor: #text:width:!instance creation!public! !

