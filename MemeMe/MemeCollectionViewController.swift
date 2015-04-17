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
    
    //TODO: - enable multiselect
    func editMemes(sender: UIBarButtonItem) {
        
        editMode = true
        
        self.sentMemesCollectionView.allowsSelection = true
        self.sentMemesCollectionView.allowsMultipleSelection = true
    
    }


}
