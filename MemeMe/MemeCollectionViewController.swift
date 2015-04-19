//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Johannes Eichler on 10.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit


class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {    
    
    var sharedModel: AppDelegate {
        
        get{
            var object = UIApplication.sharedApplication().delegate as AppDelegate
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
        
        
        self.sentMemesCollectionView = self.view.viewWithTag(2) as UICollectionView
        self.sentMemesCollectionView.reloadData()
        
        
        //Add navbuttons
        
        
        self.addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action:"addMeme:")
        self.editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Bordered, target: self, action:"editMemes:")
        self.cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: self, action:"endEdit:")
        
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
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as UICollectionViewCell
        
        var content: Meme = self.sharedModel.memes[indexPath.row] as Meme
        var thumbNail: UIImage = content.memedImage
        

        var imageView: UIImageView = item.contentView.viewWithTag(100) as UIImageView
       
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
            println(self.sentMemesCollectionView.indexPathsForSelectedItems().count)
        
        }
        
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailFromCollection"){
            
            var detailView: DetailViewController = segue.destinationViewController as DetailViewController            
            detailView.currentImageIdx = self.selectedImageIdx!
            
            
        }
    }

//MARK: - Actions
    
    func addMeme(sender: UIBarButtonItem) {

        self.dismissViewControllerAnimated(true, completion:nil)
        
    }
    

    func editMemes(sender: UIBarButtonItem) {
        
        editMode = true        
        
        self.sentMemesCollectionView.allowsMultipleSelection = true
        self.displayCancelMultiselection()
        
        self.updateButtonsToMatchTableState()
    
    }




func endEdit(sender:UIBarButtonItem){
    
    //Reset edit button if cancel button is pressed
    
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
    }
    
    else {
        
            self.editButton!.title = "Edit"
            //self.editButton!.enabled = true
        
        }
    
        
        
    
    
    }


    
    
    

}


