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

    // The general controller the drive the entire game
    let gameWorkFlow = (UIApplication.sharedApplication().delegate as! AppDelegate).gameWorkFlow
    
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return constants.kNumberOfSections
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameWorkFlow.wordPuzzle.wordCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(constants.kCellIdString,forIndexPath:indexPath)
            as! GameViewCell
        cell.wordLabel.text = gameWorkFlow.wordPuzzle[indexPath.indexAtPosition(indexPath.length-1)]
        return cell
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a panGestureRecognizer to CollectionView to allow user to repostion cell items using "Drag and Drop"
        self.collectionView?.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    
    
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
    func dropCellItemToSelectedLocation(location: CGPoint, completionBlock: ((Bool) -> Void)) {
        
        let collectionView = self.collectionView!
        
        collectionView.performBatchUpdates( {

                let indexPath = collectionView.indexPathForItemAtPoint(location)
                if indexPath != nil && indexPath! != self.itemOriginalIndexPath!   {
            
                // Animate moving cellItem from itemOriginalIndexPath to new position at toIndexPath in collectionView
                collectionView.moveItemAtIndexPath(self.itemOriginalIndexPath!, toIndexPath:indexPath!)
            
                // Move the word in puzzle to relfect the new position of the displaced cellItem above in collectionView
                let puzzle = self.gameWorkFlow.wordPuzzle
                puzzle.moveItemAtIndexPath(self.itemOriginalIndexPath!, toIndexPath:indexPath!)
            
            }
            else {  //>>> To restore its original location when cellItem was moved a few pixels

                    self.restoreCellItemOriginalLocation()
            }
            self.cellToMove = nil
        },
            
        completion: completionBlock)  // performBatchUpdates()
        
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
        let location = sender.locationInView(collectionView) 
        
        switch state {
            
        case .Began:    // Begin dragging cell
                        prepareMovingItem(location)
                        dragCellItemTo(location)
            
        case .Changed:  // Continue dragging
                        dragCellItemTo(location)
            
        case .Ended:    // Position cellItem to its new position and rearrange items in 
                        // collectionView accordingly
                        dropCellItemToSelectedLocation(location,
                            completionBlock: {_ in 
                                // Check wether the puzzle is solved                                
                                if (self.gameWorkFlow.isPuzzleSolved()) {
                                    // *** NEED TO DISABLE PAN GESTURE RECOGNIZER DURING SPEECH ****
                                    //let voice = PuzzleToSpeech(aPuzzle: wordPuzzle, collectionViewController:self)
                                    //voice.speak()
                            
                                    self.displayEndOfGameMessage()
                            }
                        })
            
        default:        // .cancelled or .failed
                        restoreCellItemOriginalLocation()
        }
        
    }
    
    
    
    // Display a congratulatory message in an alert box
    func displayEndOfGameMessage() {
        //var message: String = "\""
        //message.appendContentsOf(wordPuzzle.text)
        //message.appendContentsOf("\"")
        
        sleep(1)  // sleep 1 second before pop up message to avoid startling player
        
        let message = gameWorkFlow.endGameMessage()
        let popupMsg = UIAlertController(title: "Feeling wiser?",
                                         message: message,
                                         preferredStyle:.ActionSheet) //.Alert)
        
        // A completion handler will tart new game when congratulatory message is removed from the screen
        let alertAction = UIAlertAction(title: "Next",
                                        style: UIAlertActionStyle.Default,
                                        handler: {  _ in popupMsg.dismissViewControllerAnimated(true,completion:nil)
                                                    self.gameWorkFlow.nextGame()
                                                    self.collectionView!.reloadData()
                                                  })
        
        popupMsg.addAction(alertAction)
        
        // Show congratulatory message on the screen 
        presentViewController(popupMsg,animated: true,
                              completion: nil)
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
