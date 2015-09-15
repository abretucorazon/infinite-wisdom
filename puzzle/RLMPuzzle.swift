//
//	RLMPuzzle.swift
//	Model file Generated using Realm Object Editor: https://github.com/Ahmed-Ali/RealmObjectEditor
import Foundation
import RealmSwift


class RLMPuzzle : Object{
	dynamic var quote : String = ""
	dynamic var author : String = ""
	dynamic var id : String = ""
	dynamic var category : String = ""
	dynamic var collection : String = ""

	override class func primaryKey() -> String
	{
		return "id"
	}

}