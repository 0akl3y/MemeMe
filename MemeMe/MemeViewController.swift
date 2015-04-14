//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Johannes Eichler on 07.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var storedMemes: [Meme] {
        
        get{
            var object = UIApplication.sharedApplication().delegate as AppDelegate
            return object.memes
        }        
        
    }
    
    var selectedImageIdx: Int?
    
    
    override func viewWillAppear(animated: Bool) {
        
        //upate the data
        var table = self.view.viewWithTag(1) as UITableView
        table.reloadData()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        var numberOfMemes = self.storedMemes.count
        
        return numberOfMemes
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as UITableViewCell
        
        var content: Meme = storedMemes[indexPath.row] as Meme
        
        var customTextLabel:UILabel = cell.contentView.viewWithTag(101) as UILabel
        customTextLabel.text = content.topText + " " + content.bottomText

        var customImageView:UIImageView = cell.contentView.viewWithTag(100) as UIImageView
        var thumbNail: UIImage = content.memedImage
        customImageView.image = thumbNail

        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedImageIdx = indexPath.row
        performSegueWithIdentifier("detailFromTable", sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
