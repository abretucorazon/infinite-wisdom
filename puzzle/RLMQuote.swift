//
//	RLMQuote.swift
//	Model file Generated using Realm Object Editor: https://github.com/Ahmed-Ali/RealmObjectEditor
import Foundation
import RealmSwift


class RLMQuote : Object{
	dynamic var words : String = ""
	dynamic var author : String = ""
	dynamic var id = 0
	dynamic var category : String = ""
	dynamic var collection : String = ""

    override class func primaryKey() -> String
	{
		return "id"
	}

    
}