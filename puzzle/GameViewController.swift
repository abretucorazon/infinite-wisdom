//
//  GameViewController.swift
//  Infinite Wisdom
//
//  Created by Marvin N on 2015-02-20.
//  Copyright (c) 2015 Marvin Nguyen. All rights reserved.
//

import UIKit
//import QuartzCore
//import SceneKit
import AVFoundation


class GameViewCell: UICollectionViewCell {
    
    @IBOutlet weak var wordLabel: UILabel!
    
/*
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        // Set bit masks to enable cell to autoresize subview which in this case is a UILabel
        self.autoresizingMask.unionInPlace(UIViewAutoresizing.FlexibleWidth)
        self.autoresizingMask.unionInPlace(UIViewAutoresizing.FlexibleRightMargin)
        
        print("GameViewCell.init")

    }
*/
    
    
/*
    // ViewCell get a chance to specify or override its layoutAttributes before it is rendered
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        // Call super before applying additional changes to layoutAttributes
        let newLayoutAttributes = super.preferredLayoutAttributesFittingAttributes(layoutAttributes)
        
        let bound = CGRect(origin: CGPoint(x:0,y:0),size: CGSize(width:1000.0,height:1000.0))
        let textRect = wordLabel.textRectForBounds(bound, limitedToNumberOfLines:0)
        //let wordLabelSize = cell.wordLabel.sizeThatFits(textRect.size)
        //let cellSize = cell.sizeThatFits(wordLabelSize)
        //let collectionView = self.superview as? UICollectionView
        //let viewFlowLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        //var cellSize = newLayoutAttributes.size
        newLayoutAttributes.size = CGSize(width:50.0,height:20.0) //max(newLayoutAttributes.size.width,textRect.size.width)
        
        return newLayoutAttributes
        
    }
*/
    
}

/*

class CellFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> (UICollectionViewLayoutAttributes!) {
        let attribute = super.layoutAttributesForItemAtIndexPath(indexPath)
        attribute!.zIndex = 0
        return attribute!
    }
    
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElementsInRect(rect)
        
        if (attributes != nil) {
           for item in attributes! {
             item.zIndex = 0
             //item.bounds.size = CGSize(width:200.0,height:100.0)
           }
        }
        
        return attributes
    }
    
}


*/

//*** Implement AVSpeechSynthesizerDelegate protocol to coordinate the speaking out loud of a puzzle
/*class PuzzleTextToSpeech: NSObject, AVSpeechSynthesizerDelegate {
    
    let puzzle: Puzzle
    let viewController : GameViewController
    let synthesizer = AVSpeechSynthesizer()
    var indexOfWordInUtterance = 0      // Index of the word in puzzle currently being spoken outloud by synthersizer
    
    
    init(aPuzzle: Puzzle, collectionViewController aViewController: GameViewController) {
        puzzle = aPuzzle
        viewController = aViewController
    }
    
    
    // Call-back when synthesizer begins speaking a sentence
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
                           didStartSpeechUtterance utterance: AVSpeechUtterance) {
        
        // Tell viewController to highlight word being spoken
        //viewController.highlightWord(indexOfWordInUtterance)
                            
    }


    // Call-back when synthesizer finishes speaking a sentence
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
                           didFinishSpeechUtterance utterance: AVSpeechUtterance) {
            
        // Tell viewController to unhighlight word after it has been spoken
        //viewController.UnHighlightWord(indexOfWordInUtterance)
            
        // Queue the next word in puzzle to be uttered
        speakNextWord()
            
    }
    
    
    // Speak the next word in puzzle
    private func speakNextWord() {
        
        indexOfWordInUtterance++
        if (indexOfWordInUtterance < puzzle.wordCount) {
          speakWord(puzzle[indexOfWordInUtterance])

        }
        
    }

    
    // Queue a word to be spoken by speech synthersizer
    private func speakWord(word: String) {
        let speech = AVSpeechUtterance(string:word)
        //speech.rate = AVSpeechUtteranceMaximumSpeechRate
        synthesizer.speakUtterance(speech)
    }

    
    // Using speech synthesis to speak outloud a puzzle
    func speakPuzzle() {
        
        if (puzzle.wordCount > 0) {
            
            // Queue first word in puzzle to be said out loud
            indexOfWordInUtterance = 0
            synthesizer.delegate = self  // Acting a delegate to receive notifications from synthesizer
            speakWord(puzzle[indexOfWordInUtterance])
        }
    }
    
}

*/

class GameViewController: UICollectionViewController, AVSpeechSynthesizerDelegate {

    struct constants {
        static let kCellIdString = "oneWordCell"
        static let kCellItemAnimationDuration = 0.5
        static let kNumberOfSections = 1
    }
    
  //  let sentence = "the greatest thing you ever learn is to love and be loved in return"
    let wordPuzzle = Puzzle(withString:"to be or not to be")
        //"the greatest thing you ever learn is to love and be loved in return")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a panGestureRecognizer to CollectionView to allow user to repostion cell items using "Drag and Drop"
        self.collectionView?.addGestureRecognizer(panGestureRecognizer)
        
        // Set the value of the "estimatedItemSize" property of the UICollectionViewFlowLayout to a non-CGSizeZero value
        // will cause the collection view to query each cell for its actual size using the cell’s
        // preferredLayoutAttributesFittingAttributes: method.
        //let viewFlowLayout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        //viewFlowLayout.estimatedItemSize = viewFlowLayout.itemSize
        
        //print("viewDidLoad")
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
        
        

  /*
        // Resize cellItem UI according the length of the word it contains
        let bound = CGRect(origin: CGPoint(x:0,y:0),size: CGSize(width:1000.0,height:1000.0))
        let textRect = cell.wordLabel.textRectForBounds(bound, limitedToNumberOfLines:0)
        //let wordLabelSize = cell.wordLabel.sizeThatFits(textRect.size)
        //let cellSize = cell.sizeThatFits(wordLabelSize)
        let viewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        var cellSize = viewFlowLayout.itemSize
        cellSize.width = max(cellSize.width,textRect.size.width)
        viewFlowLayout.itemSize = cellSize
*/
        
        //print("cellForItemAtIndexPath")
        
        return cell
    }
        
    override func collectionView(collectionView: UICollectionView,didSelectItemAtIndexPath indexPath: NSIndexPath) {
   
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GameViewCell
        cell.wordLabel.backgroundColor = UIColor.purpleColor()
    }
    
    
    override func collectionView(collectionView: UICollectionView,didDeselectItemAtIndexPath indexPath: NSIndexPath) {

        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GameViewCell
        cell.wordLabel.backgroundColor = UIColor.blackColor()

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
                            let voice = PuzzleToSpeech(aPuzzle: wordPuzzle, collectionViewController:self)
                            voice.speak()
                        }
            
        default:        // .cancelled or .failed
                        restoreCellItemOriginalLocation()
        }
        
    }
    
    
    // Highlight a cell in collection view
    func highlightCellItemAt(indexPath: NSIndexPath) {
        
        self.collectionView!.selectItemAtIndexPath(indexPath,animated: true,
            scrollPosition:UICollectionViewScrollPosition.Bottom)
        self.collectionView(collectionView!,didSelectItemAtIndexPath: indexPath)
        
    }
    
    // Display a congratulatory message in an alert box
    func displayEndOfGameMessage() {
        
        let popupMsg = UIAlertController(title: "You did it!",
                                         message: "Feeling smarter yet?",
                                         preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "YES!",
                                        style: UIAlertActionStyle.Default,
                                        handler: {_ in popupMsg.dismissViewControllerAnimated(true,completion: nil)})
        popupMsg.addAction(alertAction)
        presentViewController(popupMsg,animated: true,completion: nil)
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
    
    
        // Call-back when synthesizer begins speaking a sentence
        func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
                               didStartSpeechUtterance utterance: AVSpeechUtterance) {
    
            // Tell viewController to highlight word being spoken
            //viewController.highlightWord(indexOfWordInUtterance)
    
        }
    
    
        // Call-back when synthesizer finishes speaking a sentence
        func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
            didFinishSpeechUtterance utterance: AVSpeechUtterance) {
                
                // Display a congratulatory message
                viewController.displayEndOfGameMessage()
                
        }
        
    
        // Using speech synthesis to speak outloud a puzzle
        func speak() {
    
            if (puzzle.wordCount > 0) {
                
                indexOfWordUttered = 0  // Index of first word in puzzle to be uttered
                let speech = AVSpeechUtterance(string: puzzle.text)
                speech.rate = AVSpeechUtteranceMinimumSpeechRate
                speech.volume = 0.5
                synthesizer.delegate = self  // Self is acting as a delegate to receive notifications from synthesizer
                synthesizer.speakUtterance(speech)
            }
    
        }
    
        // Notification at the start of each word to be uttered
        func speechSynthesizer(synthesizer: AVSpeechSynthesizer,
                               willSpeakRangeOfSpeechString characterRange: NSRange,
                               utterance: AVSpeechUtterance) {
                                
            let indexPath = NSIndexPath(indexes:UnsafePointer([0,indexOfWordUttered]),length:2)
            viewController.highlightCellItemAt(indexPath)
            indexOfWordUttered++
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
