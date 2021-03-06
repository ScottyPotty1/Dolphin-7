"Filed out from Dolphin Smalltalk X6"!

Object subclass: #SerialNumberProtector
	instanceVariableNames: 'key'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SerialNumberProtector guid: (GUID fromString: '{2748FB4F-8D36-4F21-B51A-669A27545E43}')!
SerialNumberProtector comment: 'One of these handles the actual cryptography for a (subclass of) ProtectedProductSerialNumber.  The idea of factoring this code out is to allow cryptography (which is really a policy decision) to vary independently of the choice of what data is encoded in a serial number.

Note that instances only look after the cryptography for serial numbers, they are not responsible for the encryption used to protect the bytecodes of methods (which have different cryptographic requirements), see ProductProtector for that.'!
!SerialNumberProtector categoriesForClass!Unclassified! !
!SerialNumberProtector methodsFor!

dataFromString: aString
	"Private - Answer the raw encrypted data contained in the human-readable String."

	^ self subclassResponsibility.!

decrypt: anObject
	"Answer anObject decrypted according to the encryption policy the receiver represents."

	^ self subclassResponsibility.!

decryptFromString: aString
	"Answer aString decrypted according to the encryption policy the receiver represents."

	^ self decrypt: (self dataFromString: aString).
!

encrypt: anInteger
	"Answer anInteger encrypted according to the encryption policy the receiver represents.
	The kind of object answered depends on the concrete subclass."

	^ self subclassResponsibility.!

encryptToString: anInteger
	"Answer anInteger encrypted according to the encryption policy the receiver represents
	encoded as a human-readable String."
	
	^ self stringFromData: (self encrypt: anInteger).
!

key
	"Private -- answer the object (often a LargeInteger) that we use as our en/decryption key"

	^ key.!

key: anObject
	"Private -- set the Object (often a LargeInteger) that we use as our en/decryption key"

	key := anObject.!

stringFromData: anObject
	"Private - Answer a human-readable String representing the given raw encrypted data."
	
	^ self subclassResponsibility.! !
!SerialNumberProtector categoriesFor: #dataFromString:!helpers!private! !
!SerialNumberProtector categoriesFor: #decrypt:!operations!public! !
!SerialNumberProtector categoriesFor: #decryptFromString:!operations!public! !
!SerialNumberProtector categoriesFor: #encrypt:!operations!public! !
!SerialNumberProtector categoriesFor: #encryptToString:!operations!public! !
!SerialNumberProtector categoriesFor: #key!initializing!public! !
!SerialNumberProtector categoriesFor: #key:!initializing!private! !
!SerialNumberProtector categoriesFor: #stringFromData:!helpers!public! !

SerialNumberProtector methodProtocol: #SerialNumberProtector attributes: #() selectors: #(#decryptFromString: #encryptToString:)!

!SerialNumberProtector class methodsFor!

integerFromReadableString: aString
	"Private - Answers a LargeInteger arrived at by 'decoding' the given user-friendly string.
	This is the inverse of #readableStringFromBytes: except that we allow mixed case and
	O (oh) to be used instead of 0 (zero), and I (eye) instead of 1 (one) (lower case l (ell) is
	ambigous too, but we treat it as L not 1)"

	| stream raw |

	stream := String writeStream.
	aString asUppercase do:
		[:ch || code |
		code := ch codePoint.
		ch >= $P ifTrue: [code := code - 1].		"since P is mapped to O by the next line"
		ch >= $I ifTrue: [code := code - 1].
		ch = $O ifTrue: [code := $0 codePoint].
		ch = $I ifTrue: [code := $1 codePoint].
		ch = $- ifFalse:
			[stream nextPut: (Character codePoint: code)]].
	raw := stream contents.
	
	^ (Integer readFrom: raw readStream radix: 34).		"base 34 since two letters are not used"


"Little test:
	1e9 to: 1e9+10000 do:
		[:in || string out |
		string := self readableStringFromInteger: in.
		out := self integerFromReadableString: string.
		self assert: [out = in]].
"

!

isSafeToEncryptWithProductProtection
	"Answer whether it is save to encrypt the receiver's methods as part of the
	the deployment of a Protected Product application."

	^ false.!

readableStringFromInteger: aLargeInteger
	"Private - Answers aLargeInteger converted into a user-friendly string.
	The String is all upper case and does not include the characters O or I (which
	can be confused with 0 and 1).
	This is the inverse of #bytesFromReadableString: "

	| raw stream |

	raw := aLargeInteger
			printStringRadix: 34	"base 34 since two letters are not used"
			showRadix: false.

	stream := String writeStream.
	raw do:
		[:ch || code |
		code := ch codePoint.
		ch >= $I ifTrue: [code := code + 1].
		ch >= $N ifTrue: [code := code + 1].		"since N is mapped to O by the previous line"
		(stream position \\ 6) = 5 ifTrue: [stream nextPut: $-].
		stream nextPut: (Character codePoint: code)].

	^ stream contents.!

withKey: anInteger
	"Answer a new instance that is configured to en/decrypt serial number using the given key."

	^ (self new)
		key: anInteger;
		yourself.! !
!SerialNumberProtector class categoriesFor: #integerFromReadableString:!helpers!private! !
!SerialNumberProtector class categoriesFor: #isSafeToEncryptWithProductProtection!constants!public!testing! !
!SerialNumberProtector class categoriesFor: #readableStringFromInteger:!helpers!private! !
!SerialNumberProtector class categoriesFor: #withKey:!instance creation!public! !

