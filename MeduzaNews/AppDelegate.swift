//
//  AppDelegate.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 16/02/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import MagicalRecord
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        MagicalRecord.setupCoreDataStack()
        
        setupAppearance()
        
        return true
    }
    
    func setupAppearance() {
        Chameleon.setGlobalThemeUsingPrimaryColor(UIColor.AppBrownColor(), withSecondaryColor: UIColor.flatWhiteColor(), andContentStyle: .Dark)
    }

}

extension UIColor {
    
    class func AppBrownColor() -> UIColor {
        return UIColor(red: 194/255.0, green: 139/255.0, blue: 93/255.0, alpha: 1)
    }
}

