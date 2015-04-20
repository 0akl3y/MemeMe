//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Johannes Eichler on 12.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var currentImageIdx:Int!
    var editButton: UIBarButtonItem?
    var deleteButton: UIBarButtonItem?
    
    
    var sharedObject: AppDelegate {
        
        get{
            var object = UIApplication.sharedApplication().delegate as! AppDelegate
            
            return object
        }
        
    }
    
    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        self.detailImage.image = self.sharedObject.memes[currentImageIdx].memedImage as UIImage
        self.detailImage.contentMode = UIViewContentMode.ScaleAspectFit
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme:")
        
        self.deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "removeMeme:")
        
        var butttons = [self.deleteButton!, self.editButton!]
        
        self.navigationItem.rightBarButtonItems = butttons as [AnyObject]
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        
        // store the idx of the image currently displayed in the shared model for later editing        

        self.sharedObject.currentlySelectedIdx = self.currentImageIdx
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    @IBAction func removeMeme(sender: UIBarButtonItem) {
        

        self.sharedObject.memes.removeAtIndex(self.currentImageIdx)
        
        if(self.sharedObject.memes.count > 0) {
            
            self.navigationController!.popViewControllerAnimated(true)
        }
        
        else {
            
            self.dismissViewControllerAnimated(true, completion: nil)
        
        }
        
    }

}
