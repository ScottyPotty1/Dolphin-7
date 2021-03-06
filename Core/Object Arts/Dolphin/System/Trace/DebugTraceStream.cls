"Filed out from Dolphin Smalltalk X6"!

Stream subclass: #DebugTraceStream
	instanceVariableNames: 'buffer bufferProtect'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DebugTraceStream guid: (GUID fromString: '{42675A9E-7EF6-4E38-8FF1-C6CD5D1563CC}')!
DebugTraceStream comment: 'DebugTraceStream is a singleton class that implements the <puttableStream> protocol (and some) on top of the Win32 OutputDebugString() API. Like the Transcript the output is buffered until either an end of line is emitted (i.e. #cr is sent) or the the stream is explicitly flushed (i.e. #flush is sent). For convenience the singleton instance is assigned to the global named ''Trace''.

Instance Variables:
	buffer		<WriteStream> on <String>. Stream used to buffer output until flushed.
	bufferProtect	<Mutex> protecting the stream buffer.

Class Variables:
	Current 	<DebugTraceStream>. Singleton instance.'!
!DebugTraceStream categoriesForClass!Collections-Streams! !
!DebugTraceStream methodsFor!

atEnd
	"Answer whether the receiver cannot access any more objects"

	^self shouldNotImplement!

basicPrint: printee
	"Private - Ask the <Object>, printee, to append its basic textual description
	to the receiver."

	bufferProtect critical: [printee basicPrintOn: buffer]
!

close
	self flush!

cr
	"Append a line delimiter to the receiver (N.B. For Windows this is a CR-LF sequence)."

	self nextPutAll: String lineDelimiter; flush!

crtab
	"Append a new line to the receiver followed by a tab"

	self crtab: 1!

crtab: count
	"Append a new line to the receiver followed by <integer>, count, tabs."

	self cr.
	count timesRepeat: [self tab]!

display: anObject
	"Ask anObject to append its end-user textual description to the receiver."

	bufferProtect critical: [anObject displayOn: buffer]!

flush
	"Flush the buffered output to the display."

	buffer position == 0 
		ifFalse: 
			[bufferProtect critical: 
					[KernelLibrary default outputDebugString: buffer contents.
					buffer reset]]!

initialize
	"Private - Initialize the receiver."

	buffer := String writeStream.
	bufferProtect := Mutex new.!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the 
	puttableStream protocol)."

	^true!

next
	"Answer the next object accessible by the receiver."

	^self shouldNotImplement!

next: anInteger put: anObject
	"Store the argument, anObject, as the next anInteger number of elements accessible by the receiver. 
	Answer anObject."

	anInteger timesRepeat: [self nextPut: anObject].
	^anObject!

next: size putAll: aSequenceableCollection startingAt: start
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	self nextPutAll: (aSequenceableCollection copyFrom: start to: start+size-1).
	^aSequenceableCollection!

nextPut: newElem
	"Append the <character>, newElem, to the receiver."

	self nextPutAll: newElem asString.
	^newElem!

nextPutAll: insertString
	"Append the <readableString>, insertString, to the text of the receiver."

	bufferProtect critical: [buffer nextPutAll: insertString].
	^insertString!

print: anObject
	"Prints anObject at the end of the receiver."

	bufferProtect critical: [anObject printOn: buffer]!

space
	"Append a space to the receiver."

	self nextPutAll: ' '!

tab
	"Store a tab character as the next element of the receiver."

	self nextPutAll: String tab!

tab: tabCount
	"Append the specified number of tabs to the receiver."

	tabCount timesRepeat: [self tab]! !
!DebugTraceStream categoriesFor: #atEnd!public!testing! !
!DebugTraceStream categoriesFor: #basicPrint:!printing!private! !
!DebugTraceStream categoriesFor: #close!operations!public! !
!DebugTraceStream categoriesFor: #cr!adding!public! !
!DebugTraceStream categoriesFor: #crtab!adding!public! !
!DebugTraceStream categoriesFor: #crtab:!adding!public! !
!DebugTraceStream categoriesFor: #display:!printing!public! !
!DebugTraceStream categoriesFor: #flush!accessing!public! !
!DebugTraceStream categoriesFor: #initialize!initializing!private! !
!DebugTraceStream categoriesFor: #isWriteable!public!testing! !
!DebugTraceStream categoriesFor: #next!accessing!public! !
!DebugTraceStream categoriesFor: #next:put:!operations!public! !
!DebugTraceStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!DebugTraceStream categoriesFor: #nextPut:!adding!public! !
!DebugTraceStream categoriesFor: #nextPutAll:!adding!public! !
!DebugTraceStream categoriesFor: #print:!printing!public! !
!DebugTraceStream categoriesFor: #space!adding!public! !
!DebugTraceStream categoriesFor: #tab!accessing!public! !
!DebugTraceStream categoriesFor: #tab:!accessing!public! !

!DebugTraceStream class methodsFor!

current
	^Trace!

initialize
	Trace := self basicNew initialize!

uninitialize
	Trace := nil.! !
!DebugTraceStream class categoriesFor: #current!instance creation!public! !
!DebugTraceStream class categoriesFor: #initialize!initializing!public! !
!DebugTraceStream class categoriesFor: #uninitialize!class hierarchy-removing!public! !

