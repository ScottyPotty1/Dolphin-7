"Filed out from Dolphin Smalltalk X6.2"!

ODBChange subclass: #ODBDictionaryChanged
	instanceVariableNames: 'dataBaseObject'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDictionaryChanged guid: (GUID fromString: '{8162EDFD-0FB8-11D4-B091-000000000000}')!
ODBDictionaryChanged comment: '"Nonpersistent change. "'!
!ODBDictionaryChanged categoriesForClass!No category! !
!ODBDictionaryChanged methodsFor!

committed
	"Changes have been committed, update transaction object."

	dataBaseObject isNil ifFalse: [transactionObject setDataBaseObject: dataBaseObject].
	transactionObject objectCommitted!

dataBaseObject: anObject 
	dataBaseObject := anObject! !
!ODBDictionaryChanged categoriesFor: #committed!public! !
!ODBDictionaryChanged categoriesFor: #dataBaseObject:!public! !

