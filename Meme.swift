//
//  Meme.swift
//  MemeMe
//
//  Created by Johannes Eichler on 01.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class Meme: NSObject {
    
    var topText: String!
    var bottomText: String!
    var originalImage: UIImage!
    var memedImage: UIImage!
    
    init(text:String, bottomText:String, originalImage:UIImage, memedImage:UIImage) {

        super.init()
        self.topText = text
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
        
    }
   
}
