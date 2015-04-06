//
//  ViewController.swift
//  MemeMe
//
//  Created by Johannes Eichler on 03.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    @IBOutlet weak var memeEditorImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    var memedImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeTextAttributes: NSDictionary = [NSStrokeColorAttributeName:UIColor.blackColor(),
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName:UIFont(name:"HelveticaNeue-CondensedBlack", size:35)!,
            NSStrokeWidthAttributeName:Float(-4.0)]
        
        
        topText.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        
        
        bottomText.delegate = self
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.Center
        
        
        // The status bar should be hidden while in meme edit view to use the maximum available screen size for the image.

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        self.subscribeToKeyboardNotification()
    
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        
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
            
            self.memeEditorImage.image = currentImage
            self.memeEditorImage.contentMode = UIViewContentMode.ScaleAspectFit
            
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
        
        var memeContext = memedImageContext(currentView:self.memeEditorImage)
        self.memedImage = memeContext.generateMemedImage()
        
        let memeActivityObject = [memedImage]
        
        
        //Initiate UIActivityView Controller
        
        let activitView = UIActivityViewController(activityItems: memeActivityObject, applicationActivities: nil)
        self.presentViewController(activitView, animated: true, completion: {self.save()})
    }
    
    
    func save(){
        
        var newMeme = Meme(text: self.topText.text, bottomText: self.bottomText.text, originalImage: self.memeEditorImage.image!, memedImage: self.memedImage)
        
        // This is only an interim solution! Will be replaced by an actual persistent store later
        var object = UIApplication.sharedApplication().delegate as AppDelegate
        object.memes.append(newMeme)
        
    }

    @IBAction func cancelMemeEditor(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    
    // Keyboard Handling
    
    func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        

        self.view.frame.origin.y -= CGFloat(self.getKeyboardHeight(notification))
        
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y += CGFloat(self.getKeyboardHeight(notification))
        
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        

            
        let userInfo:Dictionary = notification.userInfo as Dictionary!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue
        
        return keyboardSize.CGRectValue().height

    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()

    }
    

    
    func unsubscribeToKeyboardNotifiaction() {
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object:nil)
        
    }

    
}

