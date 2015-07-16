//
//  Meme.swift
//  MemeMe
//
//  Created by Johannes Eichler on 01.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit
import CoreData

class Meme: NSManagedObject {
    
    @NSManaged var topText: String!
    @NSManaged var bottomText: String!
    @NSManaged var originalImage: UIImage!
    @NSManaged var memedImage: UIImage!
    
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(text:String, bottomText:String, originalImage:UIImage, memedImage:UIImage, context:NSManagedObjectContext) {
        
        var memeEntityDescription = NSEntityDescription.entityForName("Meme", inManagedObjectContext: context)

        super.init(entity:memeEntityDescription!, insertIntoManagedObjectContext: context)
        
        self.topText = text
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
        
    }
   
}
