//
//  GameViewController.swift
//  Infinite Wisdom
//
//  Created by Marvin N on 2015-02-20.
//  Copyright (c) 2015 Marvin Nguyen. All rights reserved.
//

import UIKit
import AVFoundation


class GameViewCell: UICollectionViewCell {
    
    @IBOutlet weak var wordLabel: UILabel!
    
}



class GameViewController: UICollectionViewController {

    struct constants {
        static let kCellIdString = "oneWordCell"
        static let kCellItemAnimationDuration = 0.5
        static let kNumberOfSections = 1
    }
    

    // Database
    var gameDatabase = Database()
    
    // Puzzle to be solved set to default value
    var wordPuzzle = Puzzle(withString:"to be or not to be")
    
    
    // Start a new game with a new puzzle and refreshing UI
    func startNewGame() {
        wordPuzzle = Puzzle(withString:gameDatabase.nextQuote())
        collectionView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // *** ONE TIME DEAL ***
        //Database.generateSeedBundle()
        
        // Load next puzzle from database
        wordPuzzle = Puzzle(withString:gameDatabase.nextQuote())
        
        
        // Add a panGestureRecognizer to CollectionView to allow user to repostion cell items using "Drag and Drop"
        self.collectionView?.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return constants.kNumberOfSections
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordPuzzle.wordCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(constants.kCellIdString,forIndexPath:indexPath)
                as! GameViewCell
        cell.wordLabel.text = wordPuzzle[indexPath.indexAtPosition(indexPath.length-1)]
        return cell
    }

/*
    override func collectionView(collectionView: UICollectionView,didSelectItemAtIndexPath indexPath: NSIndexPath) {
   
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GameViewCell
        cell.wordLabel.backgroundColor = UIColor.purpleColor()
    }
    
    
    override func collectionView(collectionView: UICollectionView,didDeselectItemAtIndexPath indexPath: NSIndexPath) {

        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GameViewCell
        cell.wordLabel.backgroundColor = UIColor.blackColor()

    }
*/
    
    // Hightlight a cell item in collection view on the screen
    func hightlightItemAtIndexPath(indexPath: NSIndexPath) {
        
        // Scroll collection view to show the cell item to be hightlighted
        collectionView!.scrollToItemAtIndexPath(indexPath,
                                                atScrollPosition: UICollectionViewScrollPosition.Bottom,
                                                animated: true)
        let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! GameViewCell
        cell.wordLabel.backgroundColor = UIColor.purpleColor()
    }
    
    // Remove hightlight for a cell itme in collection view on the screen
    func unHighlightItemAtIndexPath(indexPath: NSIndexPath) {
        let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! GameViewCell
        cell.wordLabel.backgroundColor = UIColor.blackColor()
    }
    
    // Unhightlight all cell items in collection view
    func unHighlightAllItems() {
        
        for index in 0..<wordPuzzle.wordCount {
            let indexPath = NSIndexPath(indexes:UnsafePointer([0,index]),length:2)
            unHighlightItemAtIndexPath(indexPath)
        }
    }
    
/*
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
        //let cell = self.collectionView(collectionView,cellForItemAtIndexPath:indexPath) as! GameViewCell
        //cell.wordLabel.text = wordPuzzle[indexPath]
        //let bound = CGRect(origin: CGPoint(x:0,y:0),size: CGSize(width:1000.0,height:1000.0))
        //let textRect = cell.wordLabel.textRectForBounds(bound, limitedToNumberOfLines:0)
                            
        let wordLabel = UILabel()
        wordLabel.text = wordPuzzle[indexPath]
        let bound = CGRect(origin: CGPoint(x:0,y:0),size: CGSize(width:1000.0,height:1000.0))
        let textRect = wordLabel.textRectForBounds(bound, limitedToNumberOfLines:0)
                            
        let viewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        var cellSize = viewFlowLayout.itemSize
        cellSize.width = max(cellSize.width,textRect.size.width)

                            
        print("sizeForItemAtIndexPath")
        print(cellSize)
    
        return cellSize
     
    }
*/
  
    
    @IBOutlet weak var panGestureRecognizer: UIPanGestureRecognizer!
    
    
    // To keep track of the cell during drag and drop
    var cellToMove : GameViewCell? = nil
    var itemOriginalIndexPath : NSIndexPath? = nil
    var itemOriginalPosition : CGPoint = CGPoint(x:0,y:0)
    
    // Reset cellItem displaced by user back to its original location in collectionView
    func restoreCellItemOriginalLocation () {
        
        // Animate moving cellItem back to its original location
        UIView.animateWithDuration(constants.kCellItemAnimationDuration, animations: {self.dragCellItemTo(self.itemOriginalPosition)})
        
        // Reset cellToMove to complete the repositioning of a cellItem
        cellToMove = nil
    }

    
    // User moved CellItem to new location in collectionView
    func dropCellItemToSelectedLocation(location: CGPoint) {
        let collectionView = self.collectionView!
        let indexPath = collectionView.indexPathForItemAtPoint(location)
        if indexPath != nil &&
           indexPath! != itemOriginalIndexPath! //>>> To restore its original location when cellItem was moved a few pixels
        {
            // Animate moving cellItem from itemOriginalIndexPath to new position at toIndexPath in collectionView
            collectionView.moveItemAtIndexPath(itemOriginalIndexPath!, toIndexPath:indexPath!)
            
            // Move the word in puzzle to relfect the new position of the displaced cellItem above in collectionView
            wordPuzzle.moveItemAtIndexPath(itemOriginalIndexPath!, toIndexPath:indexPath!)
            
        }
        else {
            restoreCellItemOriginalLocation()
        }
        cellToMove = nil
    }
    
    // Gesture Recogniser move cellItem to new locatino
    func dragCellItemTo(location : CGPoint) {
        cellToMove?.center.x = location.x
        cellToMove?.center.y = location.y
        cellToMove?.setNeedsDisplay()
    }
    
    // Prepare to move cellItem in synch with user's gesture 
    func prepareMovingItem(location : CGPoint) {
        
        let collectionView = self.collectionView!
        
        // Deternmine the cell being dragged based on the CGPoint where the pan gesture begin
        if let indexPath = collectionView.indexPathForItemAtPoint(location) {
            itemOriginalIndexPath = indexPath
            cellToMove = collectionView.cellForItemAtIndexPath(itemOriginalIndexPath!) as? GameViewCell
            itemOriginalPosition = cellToMove!.center
            
            // Move cellToMove to the front of all the other cells in collectionView so that when dragging over
            // another stationary cell it won't appear to go behind that cell
            cellToMove?.superview?.bringSubviewToFront(cellToMove!)
        }

    }
    
    
    @IBAction func panGestureAction(sender: UIPanGestureRecognizer) {

        let state = sender.state
        let location = sender.locationInView(collectionView) //sender.translationInView(collectionView)
        
        switch state {
            
        case .Began:    // Begin dragging cell
                        prepareMovingItem(location)
                        dragCellItemTo(location)
            
        case .Changed:  // Continue dragging
                        dragCellItemTo(location)
            
        case .Ended:    // Position cellItem to its new position and rearrange items in 
                        // collectionView accordingly
                        dropCellItemToSelectedLocation(location)
                        
                        // Check wether the puzzle is solved
                        if (wordPuzzle.isSolved()) {
                            
                            // *** NEED TO DISABLE PAN GESTURE RECOGNIZER DURING SPEECH ****
                            
                            let voice = PuzzleToSpeech(aPuzzle: wordPuzzle, collectionViewController:self)
                            voice.speak()
                        }
            
        default:        // .cancelled or .failed
                        restoreCellItemOriginalLocation()
        }
        
    }
    
    
    
    // Display a congratulatory message in an alert box
    func displayEndOfGameMessage() {
        //var message: String = "\""
        //message.appendContentsOf(wordPuzzle.text)
        //message.appendContentsOf("\"")
        let popupMsg = UIAlertController(title: "You did it!",
                                         message: wordPuzzle.text, //message,
                                         preferredStyle: .Alert)
        
        // A completion handler will tart new game when congratulatory message is removed from the screen
        let alertAction = UIAlertAction(title: "OK",
                                        style: UIAlertActionStyle.Default,
                                        handler: {  _ in popupMsg.dismissViewControllerAnimated(true,completion:nil)
                                                    self.unHighlightAllItems()
                                                    self.startNewGame()
                                                  })
        
        popupMsg.addAction(alertAction)
        
        // Show congratulatory message on the screen 
        presentViewController(popupMsg,animated: true,
                              completion: nil)
    }
    
    
    //*** Implement AVSpeechSynthesizerDelegate protocol to coordinate the speaking out loud of a puzzle
    class PuzzleToSpeech: NSObject, AVSpeechSynthesizerDelegate {
    
        let puzzle: Puzzle
        let viewController : GameViewController
        let synthesizer = AVSpeechSynthesizer()
        var indexOfWordUttered = 0 // Index of the word in puzzle currently being uttered by synthesizer
        
        init(aPuzzle: Puzzle, collectionViewController aViewController: GameViewController) {
            puzzle = aPuzzle
            viewController = aViewController
        }
    
/*
        // Call-back when synthesizer begins speaking a sentence
        func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
                               didStartSpeechUtterance utterance: AVSpeechUtterance) {
    
            // Tell viewController to highlight word being spoken
            //viewController.highlightWord(indexOfWordInUtterance)
    
        }
*/

        // Call-back when synthesizer finishes speaking a sentence
        func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
            didFinishSpeechUtterance utterance: AVSpeechUtterance) {
                
                // *** NEED TO PAUSE FOR A MOMENT BETWEEN THE END OF SPEECH AND THE NEXT UI UPDATE
                sleep(1)  // sleep in seconds
                
                // Display a congratulatory message
                viewController.displayEndOfGameMessage()
                
        }

        // Notification at the start of each word to be uttered
        func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
            willSpeakRangeOfSpeechString characterRange: NSRange,
            utterance: AVSpeechUtterance) {
                
                let indexPath = NSIndexPath(indexes:UnsafePointer([0,indexOfWordUttered]),length:2)
                viewController.hightlightItemAtIndexPath(indexPath)
                indexOfWordUttered++
        }
        
    
        // Using speech synthesis to speak outloud a puzzle
        func speak() {
    
            if (puzzle.wordCount > 0) {
                
                indexOfWordUttered = 0  // Index of first word in puzzle to be uttered
                let speech = AVSpeechUtterance(string: puzzle.text)
                speech.rate = (AVSpeechUtteranceMinimumSpeechRate + AVSpeechUtteranceMaximumSpeechRate) / 4.0
                speech.volume = 0.5
                speech.preUtteranceDelay =  0.5
                speech.postUtteranceDelay = 1.0
                synthesizer.delegate = self  // Self is acting as a delegate to receive notifications from synthesizer
                synthesizer.speakUtterance(speech)
            }
    
        }
    
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    


}
