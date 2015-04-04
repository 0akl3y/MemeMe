//
//  ViewController.swift
//  MemeMe
//
//  Created by Johannes Eichler on 03.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var memeEditorImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The status bar should be hidden while in meme edit view to use the maximum available screen size for the image.
        
        self.hideStatusBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        self.subscribeToOrientationChangeNotification()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func subscribeToOrientationChangeNotification() {
        
        // To check if the statusBar is visible afte orientation change
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideStatusBar", name: UIDeviceOrientationDidChangeNotification, object: nil)
    
    }
    
    func hideStatusBar(){
        // Checks if the status bar is visible and adjusts the memeEditorImage height accordingly. 
        
        if (!UIApplication.sharedApplication().statusBarHidden){
            
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)

        }
        else {
            
            println("The Status Bar is visible")
        
        
        }
        
    
    
    }



    @IBAction func photoFromCamera(sender: UIBarButtonItem) {
    }
    
    
    @IBAction func photoFromAlbum(sender: UIBarButtonItem) {
    }
    
    
    @IBAction func openActivityCenter(sender: UIBarButtonItem) {
    }

    @IBAction func cancelMemeEditor(sender: UIBarButtonItem) {
    }
}

