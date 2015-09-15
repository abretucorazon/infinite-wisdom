//
//  Puzzle.swift
//  puzzle
//
//  Created by tenderly on 2015-09-01.
//  Copyright © 2015 Marvin Nguyen. All rights reserved.
//


import Foundation
import Swift

class Puzzle {
    
    struct constants {
        static let kShuffleMaxDivisor : Int = 4
        static let kShuffleMinDivisor : Int = 2
    }
 
    let wordList : [String]
    lazy var puzzleToSolve : [String] = Puzzle.shuffle(self.wordList)
    
    init(withString sentence: String) {
        // Break sentence into a list of words
        wordList = sentence.componentsSeparatedByString(" ")
    }
    
    // Return the word in puzzle at indexPath
    subscript(index: Int) -> String {
        return puzzleToSolve[index] 
    }
    
    // Return the number of words in puzzle
    var wordCount: Int { get{ return self.puzzleToSolve.count } }
    
    // Re-assemble all elements of wordlist back into a string
    var text : String { get {return (wordList as NSArray).componentsJoinedByString(" ")}}
    
    // Move word in puzzle from postion at fromIndexPath to position toIndexPath
    func moveItemAtIndexPath(fromIndexPath : NSIndexPath, toIndexPath: NSIndexPath) {
        let fromIndex = fromIndexPath.indexAtPosition(fromIndexPath.length-1)
        let toIndex = toIndexPath.indexAtPosition(toIndexPath.length-1)
        
        if (toIndex != fromIndex) {
            let item = puzzleToSolve.removeAtIndex(fromIndex)
            puzzleToSolve.insert(item, atIndex:toIndex)
        }
    }
    
    // Check wether puzzle is solved
    func isSolved() -> Bool {        
        return wordList == puzzleToSolve
    }

    // Shuffling a string into a puzzle
    private class func shuffle(wordList: [String]) -> [String] {
    
        // Random number generator
        func randomNumber() -> UInt {
            return UInt(arc4random())
        }

       /*       // Random number generator
       func randomNumber() -> UInt {
          let randomBytesPtr = UnsafeMutablePointer<UInt8>()
          let randomNumber : UInt
        
          // Call iOS cryptography api for a sequence random bytes
          if (SecRandomCopyBytes(kSecRandomDefault, sizeof(UInt),randomBytesPtr) == 0) {
             // Casting pointer to UInt8 -> a pointer to UInt then retrieve random number
             randomNumber = UnsafeMutablePointer<UInt>(randomBytesPtr).memory
          }
          else // API service failed - return pointer's hash value as random number
          {
             randomNumber = UInt(errno)
          }
        
          return randomNumber
       }
 */
        
       // Merge 2 sequences by interleaving their respective elements
       func merge(leftList leftList: [String],rightList: [String],assembleFunc: (Int,String,String) -> [String]) -> [String] {
        
        
            func merge_(shortList: [String],_ longList: [String]) -> [String] {
                
                var mergedList = [String]()
                for i in 0..<shortList.count {
                    // The order of merged elements of the two lists is determined by function 'assemble'
                    mergedList += assembleFunc(i,shortList[i],longList[i])
                }
                
                // Append the remaining elements of the longer 'List'
                mergedList += longList[shortList.count..<longList.count]
                
                return mergedList
            }
            
            return (leftList.count < rightList.count)
                ? merge_(leftList,rightList) : merge_(rightList,leftList)
        }
        
        
        // Compute an array of Range's that will subdivide 'array' into a number of sub-arrays specified by 'divisor'
        func splitInto(array: [String], divisor: Int) -> [Range<Int>] {
            
            if (divisor <= 0) { return [] }
            
            var result = [Range<Int>]()
            let splitSize = array.count / divisor
            
            
            // Compute the Range of a slice based on its order in the 'array'
            func slice(pos: Int) -> Range<Int> { return (pos * splitSize)..<(pos + 1) * splitSize}
            
            // Compute the Range of the last slice in the 'array'
            func lastSlice() -> Range<Int> { return (divisor - 1) * splitSize..<array.count}
            
            
            // Compute the index range of each slice of the array -- leave out the last slice
            for i in 0..<divisor - 1 {
                result.append(slice(i))
            }
            
            // The last slice need special care to include remainding elements from the division
            result.append(lastSlice())
            
            return result
        }
        
        // Determine order of the two elements to be merged
        func assemble(pos: Int, left: String, right: String) -> [String] {
            
            // Tossing a coin to determine the order of the 2 elements to be merged
            return  (randomNumber() % 2 == 0 ) ? [left,right] : [right,left]
        }
        
        // Compute a random divisor between kShuffleMinDivisor..kShuffleMaxDivisor to split up the list
        let randomDivisor = max((randomNumber() % UInt(constants.kShuffleMaxDivisor)) + 1, UInt(constants.kShuffleMinDivisor))
        
        // Reverse list then split the list into a number of sub-lists
        let sliceRanges = splitInto(wordList.reverse(),divisor:Int(randomDivisor))
        
        // Merge all slices back into one main list
        var result = [String]()
        for i in 0..<sliceRanges.count {
            result = merge(leftList:result,rightList:[] + wordList[sliceRanges[i]],assembleFunc:assemble)
        }
                
        return result
        
    }
    
}

