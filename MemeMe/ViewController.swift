//
//  ViewController.swift
//  MemeMe
//
//  Created by Johannes Eichler on 03.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var sharedModel: AppDelegate {
        
        get{
            var object = UIApplication.sharedApplication().delegate as! AppDelegate
            return object
        }
        
    }
   
    @IBOutlet var memeEditorImage: UIImageView!
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
        
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        var error:NSError? = nil
        
        self.sharedModel.memes = CoreDataStack.sharedObject().managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as! [Meme]
        
        
        self.topText.delegate = self
        self.topText.defaultTextAttributes = memeTextAttributes
        self.topText.textAlignment = NSTextAlignment.Center
        
        
        self.bottomText.delegate = self
        self.bottomText.defaultTextAttributes = memeTextAttributes
        self.bottomText.textAlignment = NSTextAlignment.Center
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //Check if there is a meme to be edited and display this meme
        self.subscribeToKeyboardNotification()
        
        if var memeToEditIdx = self.sharedModel.currentlySelectedIdx {

            let memeToEdit = self.sharedModel.memes[memeToEditIdx]
            
            self.memedImage = memeToEdit.originalImage
            self.topText.text = memeToEdit.topText
            self.bottomText.text = memeToEdit.bottomText
            self.memeEditorImage!.image = memedImage
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //Disable Camera button if no camera is available
        
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.activityButton.enabled = self.memeEditorImage?.image != nil
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.unsubscribeToKeyboardNotifiaction()
        
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
        self.pickImageFromSource(UIImagePickerControllerSourceType.Camera)
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
        
        activityView.completionWithItemsHandler = {activityType, completed, returnedItems, activityError in
        
            if (completed){
                self.save()
                self.clearView()}
        }
        
        self.presentViewController(activityView, animated: true, completion: nil)
            
    }
    
    @IBAction func cancelMemeEditor(sender: AnyObject) {
        
        self.cancel()
    }
    
    func save(){
        
        var newMeme = Meme(text: self.topText.text, bottomText: self.bottomText.text, originalImage: self.memeEditorImage!.image!, memedImage: self.memedImage!, context: CoreDataStack.sharedObject().managedObjectContext!)
        
        // Check if an existing meme is edited
        
        if (sharedModel.currentlySelectedIdx == nil){
            
            self.sharedModel.memes.append(newMeme)
        }
            
        // Save the existing meme
        
        else {
            var currentIdx = self.sharedModel.currentlySelectedIdx!
            
            self.sharedModel.memes[currentIdx] = newMeme
        
        }
        
        CoreDataStack.sharedObject().saveContext()
        
        self.performSegueWithIdentifier("showSentMemes", sender: self)
        
    }
    
    func cancel(){
        
        self.clearView()
        
        // Reset currently selected index
        if (sharedModel.currentlySelectedIdx != nil){
            
            self.sharedModel.currentlySelectedIdx = nil
        }
        
        // display sent memes if there are already memes stored
        if (sharedModel.memes.count > 0){
            
            self.performSegueWithIdentifier("showSentMemes", sender: self)
        }
        
        else{
            
            self.dismissViewControllerAnimated(true, completion: nil)
        
        }
        
    }
    
    func clearView() {
        
        self.memeEditorImage!.image = nil
        self.activityButton.enabled = false
        self.bottomText.text = "BOTTOM"
        self.topText.text = "TOP"
    
    }
    
    //MARK: - Keyboard Handling
    
    func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //frame should not move up, when the top text is edited
        
        if(bottomText.isFirstResponder()){
            println(self.memeEditorImage.frame.origin.y)
            self.view.window!.frame.origin.y = -CGFloat(self.getKeyboardHeight(notification))
            println(self.memeEditorImage!.frame.origin.y)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if(bottomText.isFirstResponder()){
            self.view.window!.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        
        let userInfo:Dictionary = notification.userInfo as Dictionary!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(false)
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()

    }
    
    func unsubscribeToKeyboardNotifiaction() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object:nil)
        
    }
}