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
    var realm : Realm
    
    // Index of next quote to be returned by nextQuote()
    var nextItemIndex : Int
    
    // A collections of quotes returned by a query of Ream database
    let quotes : Results<RLMQuote>
    
   
    init() {
        
        
        //let path = "/Users/Tenderly/Desktop/wisdom.realm"
        
        // Open Realm database from app bundle with readonly access
        var path = NSBundle.mainBundle().pathForResource("wisdom", ofType:"realm")
        var readOnly = true
        
        // Cannot locate Realm database in app bundle...
        // generate a default Reaml database on disk with write access
        if (path == nil) {
            path = Database.generateSeedBundle()
            readOnly = false
        }
        
        let config = Realm.Configuration(
                                          // Get the path to the bundled file
                                          path: path,
                                          // Open the file in read-only mode as application bundles are not writeable
                                          readOnly: readOnly)
            
        // Open the Realm with the configuration
        realm = try! Realm(configuration: config)
            
        
        // Query Realm for all the quotes in the database
        quotes = realm.objects(RLMQuote)
        
        // The next quote in database to be returned by nextQuote() is at position 0
        nextItemIndex = 0
        

    }

    // Return the next quote in database
    func nextQuote() ->  (String,String) {
        
        // Return the quote in database at "nextItemIndex"
        let result = quotes[nextItemIndex]
        
        // Update index to point to the next quote in database to be returned 
        // the next time nextQuote() is called. Wrap around back to the first quote
        // after the last quote in the database has been accessed
        nextItemIndex = (nextItemIndex + 1) % quotes.count
        return (result.words,result.author)
    }
    
    
    // Class function to write seed data to the default Realm data bundle
    class func generateSeedBundle() -> String {
        
        let seedQuotes =
        [
            ["the Universe is made of stories, not of atoms.","Muriel Rukeyser",1,"Life","Seed"],
            ["those who cannot remember the past are condemned to repeat it.","George Santayana",2,"Life","Seed"],
            ["the greatest thing you ever learn is to love and be loved in return.","Nat Kingcole",3,"Love","Seed"],
            ["unless you love someone, nothing else make sense","E. E. Cumming",4,"Love","Seed"]
        ]
        
        // Write seed quotes to the default Realm data bundle
        let realm =  try! Realm()
        let path = realm.path
        
        if (realm.isEmpty == true) {
            try! realm.write {
                for quote in seedQuotes {
                    let quote = RLMQuote(value:quote)
                    realm.add(quote)
                }
            }
        }
        
        
        // Create a compacted & encrypted copy of database to a file path, must not already exsisted
        //try! realm.writeCopyToPath(realm.path)

        
        return path
    }
    

}