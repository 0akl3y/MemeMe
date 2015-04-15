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
    
    var selectedImageIdx: Int?
    var sentMemesTableView: UITableView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        
        //upate the data
        self.sentMemesTableView = self.view.viewWithTag(1) as UITableView
        self.sentMemesTableView.reloadData()
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            self.updateButtonsToMatchTableState()
            
        }
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailFromTable"){
            
            var detailView: DetailViewController = segue.destinationViewController as DetailViewController
            detailView.currentImageIdx = self.selectedImageIdx!
            
            
        }
    }

    
    
    @IBAction func addMemeButton(sender: AnyObject) {
        
        if(self.presentingViewController != nil){
        
            self.dismissViewControllerAnimated(true, completion:nil)
            
        }
        
        else {
            
            var startVC = self.storyboard!.instantiateInitialViewController() as MemeViewController
            
            var object = UIApplication.sharedApplication().delegate as AppDelegate
            object.window!.rootViewController = startVC

        }
        
        
    }
    
    @IBAction func editMemes(sender: UIBarButtonItem) {
        
        
        // The edit meme button is also a delete button, if edit mode has already been activated
        
        
        if(!self.sentMemesTableView.editing){
        
            self.sentMemesTableView.setEditing(true, animated: true)
            self.updateButtonsToMatchTableState()
            
        }
        
        else {
            
            //TODO implement actual delete method
        
        }
    
    }
    
    
    func updateButtonsToMatchTableState() {
        
        
        if var selectedRows: Array  = self.sentMemesTableView.indexPathsForSelectedRows() {

            var numberOfRowsSelected: Int = selectedRows.count
        
            // Delete all option should appear if all or no rows in the table are selected
            var allOrNoRowsSelected: Bool = numberOfRowsSelected == 0 || numberOfRowsSelected == self.sharedObject.memes.count
            
            self.editButton.title = allOrNoRowsSelected  ?  "Delete All" : "Delete(\(numberOfRowsSelected))"
            
        }
    
    }




}
