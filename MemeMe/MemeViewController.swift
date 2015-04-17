//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Johannes Eichler on 07.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit



class MemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sharedModel: AppDelegate {
        
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
        self.cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: self, action:"endEdit:")
        
        self.navigationItem.leftBarButtonItem = self.editButton
        
        var rightItems = [self.cancelButton!,self.addButton!]
        
        self.navigationItem.rightBarButtonItems = rightItems

    }
    
    
//MARK: - UITableViewDelegate and DataSource handling
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        var numberOfMemes = self.sharedModel.memes.count
        
        return numberOfMemes
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as UITableViewCell
        
        var content: Meme = self.sharedModel.memes[indexPath.row] as Meme
        
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
            
            self.updateButtonsToMatchTableState()
            self.updateEditButtonMode()
            
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

//MARK: - action methods
    
    
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
            // activate edit mode
        
            self.sentMemesTableView.setEditing(true, animated: true)
            self.updateButtonsToMatchTableState()
            self.displayCancelMultiselection()
            self.updateEditButtonMode()
            
        }
            
        else if(self.sentMemesTableView.indexPathsForSelectedRows() == nil){
            // make sure the edit button is displayed with "Edit", if nothing is selected
            
            self.updateButtonsToMatchTableState()
            self.updateEditButtonMode()
            
        }
            
        
        else {
            
            // Display a dialog to confirm the delete action
            
            
            var dialogTitle: String = "Delete Memes"
            var dialogMessage: String = "Are your sure, you want to delete the selected Meme(s)?"
            
            var dialog: UIAlertController = UIAlertController(title: dialogTitle, message: dialogMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var confirmDelete: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: { UIAlertAction in self.removeMemes(); })
            
            var cancelDelete: UIAlertAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel, handler: nil)
            
            dialog.addAction(confirmDelete)
            dialog.addAction(cancelDelete)
            
            presentViewController(dialog, animated: true, completion: nil)
        
        }
    
    }
    
    
    
    func removeMemes(){
        
        //iterate through all selected memes and delete them in reverse order to avoid
        // index out of bounds errors
        
        var memesToDelete  = self.sentMemesTableView.indexPathsForSelectedRows()!
        

        for (var idx:Int = memesToDelete.count - 1; idx >= 0; idx--) {
            
            self.sharedModel.memes.removeAtIndex(memesToDelete[idx].row)
            
        }
        
        self.sentMemesTableView.deleteRowsAtIndexPaths(memesToDelete, withRowAnimation: UITableViewRowAnimation.Fade)
        
        self.updateButtonsToMatchTableState()
        self.updateEditButtonMode()
    
    }
    
    func endEdit(sender:UIBarButtonItem){
        
        //Reset edit button if cancel button is pressed
        
        self.sentMemesTableView.setEditing(false, animated: true)
        updateEditButtonMode()
        
        self.hideCancelMultiselection()
        
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
        
        
        if var selectedRows: Array  = self.sentMemesTableView.indexPathsForSelectedRows() {

            var numberOfRowsSelected: Int = selectedRows.count
        
            // Delete all option should appear if all or no rows in the table are selected
            var allOrNoRowsSelected: Bool = numberOfRowsSelected == 0 || numberOfRowsSelected == self.sharedModel.memes.count
            
            self.editButton!.title = allOrNoRowsSelected  ?  "Delete All" : "Delete(\(numberOfRowsSelected))"
            
            
        }
    
    }
    
    
    func updateEditButtonMode() {
        //when no longer in edit mode the edit button should be resetted to the title "EDIT"
        //in edit mode the editbutton should only be enabled as delete button as long something is selected
        
        
        if (!self.sentMemesTableView.editing){
            
            self.editButton!.title = "Edit"
            self.editButton!.enabled = true
            }
            
        else if (self.sentMemesTableView.indexPathsForSelectedRows() == nil){

            self.editButton!.title = "Edit"
        
        }
        
        
        
        if (self.sentMemesTableView.editing){
            
            self.editButton!.enabled = self.sentMemesTableView.indexPathsForSelectedRows() != nil
        
        
        }
        
    
    }
    





}
