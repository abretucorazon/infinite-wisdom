//
//  Database.swift
//  puzzle
//
//  Created by tenderly on 2015-09-17.
//  Copyright © 2015 Marvin Nguyen. All rights reserved.
//

import Foundation
import RealmSwift


class Database {
    
 /*   // Temporary database of Quotes
    struct Database {
        static let quotes =
        [   "to be or not to be",
            "those who cannot remember the past are condemned to repeat it. (George Santayana)",
            "the greatest thing you ever learn is to love and be loved in return. (Nat Kingcole)",
            "The Universe is made of stories, not of atoms. (Muriel Rukeyser)"
        ]
        var currentItemIndex = 0
        
        mutating func nextQuote() ->  String {
            let result = Database.quotes[currentItemIndex]
            currentItemIndex = (currentItemIndex + 1) % Database.quotes.count
            return result
        }
        
        mutating func nextPuzzle() ->  Puzzle {
            return Puzzle(withString:nextQuote())
        }
        
    }
*/
    
    // Realm database object
    let realm : Realm
    
    // Index of next quote to be returned by nextQuote()
    var nextItemIndex : Int
    
    // A collections of quotes returned by a query of Ream database
    let quotes : Results<RLMQuote>
    
    // Failable init if can not initialize Realm object
    init() {
        
        //realm = try! Realm()
        let config = Realm.Configuration(
            // Get the path to the bundled file
            path: NSBundle.mainBundle().pathForResource("default", ofType:"realm"),
            // Open the file in read-only mode as application bundles are not writeable
            readOnly: true)
        
        // Open the Realm with the configuration
        realm = try! Realm(configuration: config)

        
        // Query Realm for all the quotes in the database
        quotes = realm.objects(RLMQuote)
        
        // The next quote in database to be returned by nextQuote() is at position 0
        nextItemIndex = 0
        
 /*       do {
            realm = try Realm()
        }
        catch {
            print("Initializing Realm failed")
            realm = nil
            return nil
        }
*/
    }

    // Return the next quote in database
    func nextQuote() ->  String {
        
        // Return the quote in database at "nextItemIndex"
        let result = quotes[nextItemIndex]
        
        // Update index to point to the next quote in database to be returned 
        // the next time nextQuote() is called. Wrap around back to the first quote
        // after the last quote in the database has been accessed
        nextItemIndex = (nextItemIndex + 1) % quotes.count
        return result.words + " " + result.author
    }
    
    
    // Class function to write seed data to the default Realm data bundle
    class func generateSeedBundle() {
        
        let seedQuotes =
        [   ["to be or not to be","(Shakespeare)",1,"Life","Seed"],
            ["those who cannot remember the past are condemned to repeat it.","(George Santayana)",2,"Life","Seed"],
            ["the greatest thing you ever learn is to love and be loved in return.","(Nat Kingcole)",3,"Love","Seed"],
            ["The Universe is made of stories, not of atoms.","(Muriel Rukeyser)",4,"Life","Seed"]
        ]
        
        // Write seed quotes to the default Realm data bundle
        do {
            let realm =  try Realm()
            realm.write {
                for quote in seedQuotes {
                    let quote = RLMQuote(value:quote)
                    realm.add(quote)
                }
            }
            
            // Write database to a file on disk at the current directory
            try! realm.writeCopyToPath(".")

        }
        catch {
            print("Error opening default Realm")
        }
    }
    

}