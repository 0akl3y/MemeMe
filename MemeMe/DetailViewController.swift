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
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func editMeme(sender: UIBarButtonItem) {

        
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
