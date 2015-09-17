//
//  GameWorkflow.swift
//  puzzle
//
//  Created by tenderly on 2015-09-15.
//  Copyright © 2015 Marvin Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

class GameWorkflow {
    
    // Game state
    struct GameState {
        var score : Int             // Current game score for this user
        var currentQuoteId: String    // The database id of the quote of the current puzzle
    }
    
    // Start gameWorkflow when app starts up
    func StarGameWorkflow() {
        // Load Game state from database
        
        // Start new game based on last saved game state
        nextGame()
    }
    
    // Start another game
    func nextGame() {
        // Load next quote from database
        
        // Make new puzzle from new quote
        
        // Update UI to display new puzzle
        
    }
    
    // Save game state before quiting app
    func exitGame() {
        
        // Save game state: player score, current quote, quotes already found
        
    }
    
    //
}
