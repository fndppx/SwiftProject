
//
//  ModelTest.swift
//  SwiftProject
//
//  Created by SXJH on 2017/6/27.
//  Copyright © 2017年 SXJH. All rights reserved.
//

import UIKit

@objc class ModelTest: NSObject {
    var productID:String?
    var title:String?
    var subtitle:String?
    var price:Double = 0
    var content:String?
    var imageURL:String?
    var publicTime:AnyObject?
    func getPropertieNames(){
        
        
        var count: UInt32 = 0
        let ivars = class_copyPropertyList(ModelTest.self, &count)
        
        for i in 0 ..< count {
            let ivar = ivars![Int(i)]
            let name = property_getName(ivar)
            print(String(cString: name!))
        }
        free(ivars)
        
        
    }
    
    
}


