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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        var collection = self.view.viewWithTag(2) as UICollectionView
        collection.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
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
        
        
        
        return item
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedImageIdx = indexPath.row
        println(self.selectedImageIdx)
        performSegueWithIdentifier("detailFromCollection", sender: self)
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailFromCollection"){
            
            var detailView: DetailViewController = segue.destinationViewController as DetailViewController            
            detailView.currentImageIdx = self.selectedImageIdx!
            
            
        }
    }
    
    
    @IBAction func addNewMeme(sender: UIBarButtonItem) {

        self.dismissViewControllerAnimated(true, completion:nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
