//
//  Parser.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 17/02/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import CoreData

class Parser: NSObject {
    func parse(newsInfoes:[[String:AnyObject]], context:NSManagedObjectContext)->[NewsItem] {
        
        let newsItems = newsInfoes.map { info -> NewsItem in
            let id = info["url"] as! String
            var item = NewsItem.MR_findFirstWithPredicate(NSPredicate(format: "url = %@",id), inContext: context)
            if item == nil {
                item = NewsItem.MR_createEntityInContext(context)
                item?.url = id
            }
            
            if let title = info["title"] as? String{
                item?.title = title
            }
            
            if  let dateString = info["]pub_date"] as? String {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let date = formatter.dateFromString(dateString)!
                item?.date = NSDate.dateToTimeInterval(date)
            }
            
            return item!
        }
        return newsItems    
    }
}


extension NSDate {
    class func timeIntervalToDate(time:NSTimeInterval)->NSDate {
        return NSDate(timeIntervalSince1970: time)
    }
    class func dateToTimeInterval(date:NSDate)->NSTimeInterval {
        return date.timeIntervalSince1970
    }
}