//
//  ViewController.swift
//  MemeMe
//
//  Created by Johannes Eichler on 03.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var storedMemes: [Meme] {
        
        get{
            var object = UIApplication.sharedApplication().delegate as AppDelegate
            return object.memes
        }
        
    }
   
    @IBOutlet weak var memeEditorImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var activityButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!

    
    var memedImage: UIImage!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let memeTextAttributes: Dictionary = [NSStrokeColorAttributeName:UIColor.blackColor(),
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName:UIFont(name:"HelveticaNeue-CondensedBlack", size:35)!,
            NSStrokeWidthAttributeName:Float(-4.0)]
        
        
        self.topText.delegate = self
        self.topText.defaultTextAttributes = memeTextAttributes
        self.topText.textAlignment = NSTextAlignment.Center
        
        
        self.bottomText.delegate = self
        self.bottomText.defaultTextAttributes = memeTextAttributes
        self.bottomText.textAlignment = NSTextAlignment.Center        


    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //Disable Camera button if no camera is available
        
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        
        self.subscribeToKeyboardNotification()
        
        self.activityButton.enabled = self.memeEditorImage?.image != nil
        self.bottomText.text = "BOTTOM"
        self.topText.text = "TOP"
        
        
        
        
    
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.unsubscribeToKeyboardNotifiaction()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pickImageFromSource(imgSourceType: UIImagePickerControllerSourceType){
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = imgSourceType
        
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let currentImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.memeEditorImage!.image = currentImage
            self.memeEditorImage!.contentMode = UIViewContentMode.ScaleAspectFit
            
            self.dismissViewControllerAnimated(true, completion:nil)
            
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion:nil)
        
    }
    

    @IBAction func photoFromCamera(sender: UIBarButtonItem) {
        self.pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    
    @IBAction func photoFromAlbum(sender: UIBarButtonItem) {
        self.pickImageFromSource(UIImagePickerControllerSourceType.SavedPhotosAlbum)
    }
    
    
    @IBAction func openActivityCenter(sender: UIBarButtonItem) {
        
        var memeContext = memedImageContext(currentView:self.memeEditorImage!)
        self.memedImage = memeContext.generateMemedImage()
        
        let memeActivityObject = [memedImage!]
        
        
        //Initiate UIActivityView Controller
        
        let activityView = UIActivityViewController(activityItems: memeActivityObject, applicationActivities: nil)
        
        
        activityView.completionHandler = {activityType, completed in self.save()
            
            self.cancel()
            self.performSegueWithIdentifier("showSentMemes", sender: self)
        }
        
        self.presentViewController(activityView, animated: true, completion: nil)
            
    }
    
    @IBAction func cancelMemeEditor(sender: AnyObject) {
        
        self.cancel()
    }
    
    func save(){
        
        var newMeme = Meme(text: self.topText.text, bottomText: self.bottomText.text, originalImage: self.memeEditorImage!.image!, memedImage: self.memedImage!)
        
        // This is only an interim solution! Will be replaced by an actual persistent store later
        var object = UIApplication.sharedApplication().delegate as AppDelegate
        object.memes.append(newMeme)
        
        
    }
    
    
    func cancel(){
        
        self.memeEditorImage!.image = nil
        self.activityButton.enabled = false
        self.bottomText.text = "BOTTOM"
        self.topText.text = "TOP"
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Keyboard Handling
    
    func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        

        //frame should not move up, when the top text is edited
        
        if(bottomText.isFirstResponder()){
            self.view.frame.origin.y -= CGFloat(self.getKeyboardHeight(notification))
        }
        
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        
        if(bottomText.isFirstResponder()){
            self.view.frame.origin.y += CGFloat(self.getKeyboardHeight(notification))
        }
        
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        
        let userInfo:Dictionary = notification.userInfo as Dictionary!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue
        
        return keyboardSize.CGRectValue().height

    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()

    }
    
    func unsubscribeToKeyboardNotifiaction() {
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object:nil)
        
    }

    
}

