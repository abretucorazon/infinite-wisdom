//
//  GameWorkflow.swift
//  puzzle
//
//  Created by tenderly on 2015-09-15.
//  Copyright © 2015 Marvin Nguyen. All rights reserved.
//

import Foundation

class GameWorkflow {
    
    // Database
    var gameDatabase = Database()

    // Game state
    struct GameState {
        var score : Int             // Current game score for this user
        var currentQuoteId: String    // The database id of the quote of the current puzzle
    }
    
    
    // Puzzle to be solved set to default value
    var wordPuzzle = Puzzle(withString:"to be or not to be, that is the question")
    var quote = ""
    var author = ""

    
    // Start gameWorkflow when app starts up
    init() {
        // Load Game state from database
        
        // Start new game based on last saved game state
        nextGame()
    }

    // Start another game
    func nextGame() {
        // Load next quote from database
        (quote,author) = gameDatabase.nextQuote()

        // Make new puzzle from new quote        
        wordPuzzle = Puzzle(withString:quote)
       
        // Update UI to display new puzzle
        
    }
    
    // Check whether puzzle is solved
    func isPuzzleSolved() -> Bool {
        return wordPuzzle.isSolved()
    }
    
    // Save game state before quiting app
    func exitGame() {
        
        // Save game state: player score, current quote, quotes already found
        
    }
    
    // Return a message when puzzle is solved
    func endGameMessage() -> String {
      return  "\"" + quote + "\"" + " - " + author
    }
}
