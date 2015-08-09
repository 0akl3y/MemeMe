//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Johannes Eichler on 10.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit
import CoreData


class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {    
    
    var sharedModel: AppDelegate {
        
        get{
            var object = UIApplication.sharedApplication().delegate as! AppDelegate
            return object
        }
        
    }
    
    var selectedImageIdx: Int?
    
    var addButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    var editButton: UIBarButtonItem?
    
    var sentMemesCollectionView: UICollectionView!
    var editMode: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        self.sentMemesCollectionView = self.view.viewWithTag(2) as! UICollectionView
        self.sentMemesCollectionView.reloadData()
        
        //Add navbuttons
        
        self.addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action:"addMeme:")
        self.editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action:"editMemes:")
        self.cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action:"endEdit:")
        
        self.navigationItem.leftBarButtonItem = self.editButton
        var rightItems = [self.cancelButton!,self.addButton!]
        self.navigationItem.rightBarButtonItems = rightItems
        

    }
    
    //MARK: - CollectionView and DataSource handling
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfMemes = self.sharedModel.memes.count
        
        return numberOfMemes
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        var content: Meme = self.sharedModel.memes[indexPath.row] as Meme
        var thumbNail: UIImage = content.memedImage
        

        var imageView: UIImageView = item.contentView.viewWithTag(100) as! UIImageView
       
        imageView.image = thumbNail
        
        
        //set background image when item is selected
        

        var selectionFrame: CGRect = CGRectMake( 0.0, 0.0, item.frame.width, item.frame.height)
        var selectionIndicator: UIImageView = UIImageView(frame: selectionFrame)
        
        selectionIndicator.backgroundColor = UIColor.blueColor()
        item.selectedBackgroundView =  selectionIndicator
        
        return item
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        if(!editMode) {
            
            self.selectedImageIdx = indexPath.row
            performSegueWithIdentifier("detailFromCollection", sender: self)
            
        }
        
        else {
            
            self.updateButtonsToMatchTableState()
        
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(editMode){

            self.updateButtonsToMatchTableState()
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailFromCollection"){
            
            var detailView: DetailViewController = segue.destinationViewController as! DetailViewController
            detailView.currentImageIdx = self.selectedImageIdx!
            
            
        }
    }

//MARK: - Actions
    
    
    func addMeme(sender: UIBarButtonItem) {

        self.dismissViewControllerAnimated(true, completion:nil)
        
    }
    
    
    func removeMemes(){
        
        // reset selected image idx to avoid index out of bounds crash when all memes are deleted and the view goes back to the meme editor
        self.selectedImageIdx = nil
        
        //iterate through all selected memes and delete them in reverse order to avoid
        // index out of bounds errors
        
        var memesToDelete  = self.sentMemesCollectionView.indexPathsForSelectedItems().sorted { (idxPathA, idxPathB) -> Bool in
                idxPathA.row < idxPathB.row
            }
        
        if(memesToDelete.count > 0) {
            
            for (var idx:Int = memesToDelete.count - 1; idx >= 0; idx--) {
                
                CoreDataStack.sharedObject().managedObjectContext?.deleteObject(self.sharedModel.memes[idx])
                self.sharedModel.memes.removeAtIndex(memesToDelete[idx].row)
                
            }
        }
        
            
        // if deleteAll is tapped, but no row was selected all should be removed
        else {
            
            for (var idx:Int = self.sharedModel.memes.count - 1; idx >= 0; idx--) {
                
                var currentIdxPath: NSIndexPath = NSIndexPath(indexes: [0, idx], length: 2)
                memesToDelete.append(currentIdxPath)
                
                CoreDataStack.sharedObject().managedObjectContext?.deleteObject(self.sharedModel.memes[idx])
                self.sharedModel.memes.removeAtIndex(idx)
                
            }
        }
        
        self.sentMemesCollectionView.deleteItemsAtIndexPaths(memesToDelete)        
        self.updateButtonsToMatchTableState()
        
        // if
        
        if(self.sharedModel.memes.count == 0){
            
            // If all memes were deleted the app should return to the meme editor
            
            self.editMode = false
            self.sentMemesCollectionView.allowsMultipleSelection = false
            
            self.dismissViewControllerAnimated(false, completion: nil)

        }
        
        CoreDataStack.sharedObject().saveContext()
        
    }
    

    func editMemes(sender: UIBarButtonItem) {
        
        if(!self.editMode) {
        
            self.editMode = true
            
            self.sentMemesCollectionView.allowsMultipleSelection = true
            self.displayCancelMultiselection()
            
            
            self.updateButtonsToMatchTableState()
        
        }
        
        else {
            
            
            // Display a contextual dialog with the number of the memes to be deleted to confirm the delete action
            
            var numberOfSelectedMemes = self.sentMemesCollectionView.indexPathsForSelectedItems().count
            var memeString = "\(numberOfSelectedMemes) Memes"
            
            
            if(numberOfSelectedMemes == 1){
                
                memeString = "the selected Meme"
                
            }
                
            else if (self.sharedModel.memes.count == numberOfSelectedMemes ||  numberOfSelectedMemes == 0) {
                
                 memeString = "ALL Memes?!"
            }
            
            var dialogTitle: String = "Delete Memes"
            var dialogMessage: String = "Are your sure that you want to delete \(memeString)"
            
            var dialog: UIAlertController = UIAlertController(title: dialogTitle, message: dialogMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var confirmDelete: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: { UIAlertAction in self.removeMemes(); })

            
            var cancelDelete: UIAlertAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel, handler: nil)
            
            dialog.addAction(confirmDelete)
            dialog.addAction(cancelDelete)
            
            presentViewController(dialog, animated: true, completion: nil)
            
        }
        
    }


func endEdit(sender:UIBarButtonItem){
    
    //Reset edit mode if cancel button is pressed and remove all selections
    
    self.editMode = false

    self.updateButtonsToMatchTableState()
    self.hideCancelMultiselection()

    self.sentMemesCollectionView.reloadData()
    self.sentMemesCollectionView.allowsMultipleSelection = false
    
}



//MARK: - button handling

func displayCancelMultiselection(){
    
    //Only display cancel button for multi selection if in multi selection mode
    
    self.cancelButton!.enabled = true
    self.cancelButton!.title = "Cancel"
    
}

func hideCancelMultiselection(){
    
    self.cancelButton!.enabled = false
    self.cancelButton!.title = ""
    
}

    
func updateButtonsToMatchTableState() {
    //In edit mode the edit button should switch to the title "Delete" followed by the number of rows selected
    
        var selectedRows = self.sentMemesCollectionView.indexPathsForSelectedItems().count
        
        // Delete all option should appear if all or no rows in the table are selected
        var allOrNoRowsSelected: Bool = selectedRows == 0 || selectedRows == self.sharedModel.memes.count
    
    
    if (self.editMode) {
        
            self.editButton!.title = allOrNoRowsSelected  ?  "Delete All" : "Delete(\(selectedRows))"
            self.navigationItem.title = "Select Memes"
    }
    
    else {
        
            self.editButton!.title = "Edit"
            self.navigationItem.title = "Sent Memes"
        
        }
    
    }
    

}


