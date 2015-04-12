//
//  MemedImageContext.swift
//  MemeMe
//
//  Created by Johannes Eichler on 01.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//
/* This class gets the current context of a memed image and provides functionality to render it
*/

import UIKit

class memedImageContext: NSObject {
    
    var currentView: UIImageView!
    
    
    init(currentView: UIImageView) {
        
        super.init()
        self.currentView = currentView
    }
    
    func generateMemedImage() -> UIImage
    {
        //Generate a memed image fromt the context of self.currentView
        
        UIGraphicsBeginImageContext(self.currentView.superview!.frame.size)
        
        self.currentView.drawViewHierarchyInRect(self.currentView.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()        

        
        return memedImage
    }
   
}
