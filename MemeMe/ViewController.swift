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

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

