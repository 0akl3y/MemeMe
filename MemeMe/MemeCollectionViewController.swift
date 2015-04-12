//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Johannes Eichler on 10.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {    
    
    var storedMemes: [Meme] {
        
        get{
            var object = UIApplication.sharedApplication().delegate as AppDelegate
            return object.memes
        }
        
    }
    
    var selectedImageIdx: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfMemes = self.storedMemes.count
        
        return numberOfMemes
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as UICollectionViewCell
        
        var content: Meme = storedMemes[indexPath.row] as Meme
        var thumbNail: UIImage = content.memedImage
        

        var imageView: UIImageView = item.contentView.viewWithTag(100) as UIImageView
       
        imageView.image = thumbNail
        
        return item
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedImageIdx = indexPath.row
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
