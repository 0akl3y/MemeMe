//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Johannes Eichler on 07.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sharedObject: AppDelegate {
        
        get{
            var object = UIApplication.sharedApplication().delegate as AppDelegate
            return object
        }        
        
    }
    
    
    var addButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    var editButton: UIBarButtonItem?
    
    var selectedImageIdx: Int?
    var sentMemesTableView: UITableView!
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        //upate the data
        self.sentMemesTableView = self.view.viewWithTag(1) as UITableView
        self.sentMemesTableView.reloadData()
        
        
        // Set up the buttons programmatically because XCode only permits 1 button for each side
        
        self.addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action:"addMeme:")
        self.editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Bordered, target: self, action:"editMemes:")
        self.cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action:"endEdit:")
        
        var rightItems = [self.addButton!, self.cancelButton!,]
        
        self.navigationItem.rightBarButtonItems = rightItems
        self.navigationItem.leftBarButtonItem = self.editButton
        
    }
    
    
    func endEdit(sender:UIBarButtonItem){
        
        self.sentMemesTableView.setEditing(false, animated: true)
        updateEditButtonMode()
        
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        var numberOfMemes = self.sharedObject.memes.count
        
        return numberOfMemes
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as UITableViewCell
        
        var content: Meme = self.sharedObject.memes[indexPath.row] as Meme
        
        var customTextLabel:UILabel = cell.contentView.viewWithTag(101) as UILabel
        customTextLabel.text = content.topText + " " + content.bottomText

        var customImageView:UIImageView = cell.contentView.viewWithTag(100) as UIImageView
        var thumbNail: UIImage = content.memedImage
        customImageView.image = thumbNail

        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(!self.sentMemesTableView.editing) {
            
            self.selectedImageIdx = indexPath.row
            performSegueWithIdentifier("detailFromTable", sender: self)
            
        }
        
        else{
            
            println()
            
            self.updateButtonsToMatchTableState()
            
        }
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.updateButtonsToMatchTableState()
        self.updateEditButtonMode()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailFromTable"){
            
            var detailView: DetailViewController = segue.destinationViewController as DetailViewController
            detailView.currentImageIdx = self.selectedImageIdx!
            
            
        }
    }

    
    
    func addMeme(sender: AnyObject) {
        
        if(self.presentingViewController != nil){
        
            self.dismissViewControllerAnimated(true, completion:nil)
            
        }
        
        else {
            
            var startVC = self.storyboard!.instantiateInitialViewController() as MemeViewController
            
            var object = UIApplication.sharedApplication().delegate as AppDelegate
            object.window!.rootViewController = startVC

        }
        
        
    }
    
    func editMemes(sender: UIBarButtonItem) {
        
        
        // The edit meme button is also a delete button, if edit mode has already been activated
        
        
        if(!self.sentMemesTableView.editing){
        
            self.sentMemesTableView.setEditing(true, animated: true)
            self.updateButtonsToMatchTableState()
            
        }
            
        else if(self.sentMemesTableView.indexPathsForSelectedRows() == nil){
            
            self.updateButtonsToMatchTableState()
        
        
        }
            
        
        else {
            
            //TODO implement actual delete method
            
            var dialogTitle: String = "Delete Memes"
            var dialogMessage: String = "Are your sure, you want to delete the selected Meme(s)?"
            
            var dialog: UIAlertController = UIAlertController(title: dialogTitle, message: dialogMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var confirmDelete: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: { UIAlertAction in self.removeMemes(); })
            
            dialog.addAction(confirmDelete)
            presentViewController(dialog, animated: true, completion: nil)
        
        }
    
    }
    
    func removeMemes(){
        
        //iterate through all selected memes and delete them
        
        var memesToDelete  = self.sentMemesTableView.indexPathsForSelectedRows()!
        for indexPath in memesToDelete {
            
            println(self.sharedObject.memes.count)
            self.sharedObject.memes.removeAtIndex(indexPath.row)
            
            // update table view after memes have been removed

        }
        
        self.sentMemesTableView.deleteRowsAtIndexPaths(memesToDelete, withRowAnimation: UITableViewRowAnimation.Fade)
        
        self.updateButtonsToMatchTableState()
    
    }
    
    

    
    func updateButtonsToMatchTableState() {
        //In edit mode the edit button should switch to the title "Delete" followed by the number of rows selected
        
        
        if var selectedRows: Array  = self.sentMemesTableView.indexPathsForSelectedRows() {

            var numberOfRowsSelected: Int = selectedRows.count
        
            // Delete all option should appear if all or no rows in the table are selected
            var allOrNoRowsSelected: Bool = numberOfRowsSelected == 0 || numberOfRowsSelected == self.sharedObject.memes.count
            
            self.editButton!.title = allOrNoRowsSelected  ?  "Delete All" : "Delete(\(numberOfRowsSelected))"
            
            
        }
    
    }
    
    
    func updateEditButtonMode() {
        //when no longer in edit mode the edit button should be resetted to the title "EDIT"
        
        if (!self.sentMemesTableView.editing || self.sentMemesTableView.indexPathsForSelectedRows() == nil){
            
            self.editButton!.title = "Edit"
        
        }
    
    }
    





}
