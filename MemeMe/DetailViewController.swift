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
    
    
    var storedMemes: [Meme] {
        
        get{
            var object = UIApplication.sharedApplication().delegate as AppDelegate
            return object.memes as [Meme]
        }
        
    }
    
    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewDidAppear(animated: Bool) {
        self.detailImage.image = self.storedMemes[currentImageIdx].memedImage as UIImage
        self.detailImage.contentMode = UIViewContentMode.ScaleAspectFit

    
        self.editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme:")
        
        self.deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "removeMeme:")
        
        var butttons = [self.editButton!, self.deleteButton!]
                        
        self.navigationItem.rightBarButtonItems = butttons as NSArray
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func editMeme(sender: UIBarButtonItem) {        
        
        var mutableModel = UIApplication.sharedApplication().delegate as AppDelegate
        
        // store the idx of the image currently displayed in the shared model for later editing
        mutableModel.currentlySelectedIdx = self.currentImageIdx
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    @IBAction func removeMeme(sender: UIBarButtonItem) {
        
        var mutableObject = UIApplication.sharedApplication().delegate as AppDelegate
        mutableObject.memes.removeAtIndex(currentImageIdx)
        
        if(self.storedMemes.count > 0) {
            
            self.navigationController!.popViewControllerAnimated(true)
        }
        
        else {
            
            self.dismissViewControllerAnimated(true, completion: nil)
        
        }
        
    }

}
