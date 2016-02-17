//
//  ContentRetriever.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 17/02/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import Alamofire
import MagicalRecord

enum NewsType:Int {
    case News
    case Cards
    case Articles
    case Shapito
    case Polygon
}

class ContentRetriever: NSObject {
    let parser = Parser()
    static  let shared = ContentRetriever()
    
    func getNews(type:NewsType, page:Int){
        
        let params:[String:AnyObject] = ["chrono":newsTypeToMethod(type),
            "page" : page,
            "per_page" : Constants.perPage,
            "locale" : "ru"
        ]
        
        Alamofire.request(.GET, Constants.urlWith("search"), parameters: params, encoding: .URLEncodedInURL, headers: nil).responseJSON { response in
            if let JSON = response.result.value as? [String:AnyObject] {
                print("JSON: \(JSON)")
                
                MagicalRecord.saveWithBlock({ context in
                    var newsToParse = [[String:AnyObject]]()

                    for info in (JSON["documents"] as! [String : AnyObject]).values {
                        newsToParse.append(info as! [String:AnyObject])
                    }
                    
                    let items = self.parser.parse(newsToParse, context: context)
                    }, completion: { success, error -> Void in
//                        print(NewsItem.MR_findAll())
                })
            }
        }
        
    }
    
    private func newsTypeToMethod(type:NewsType)->String{
        switch type {
        case .News: return "news"
        case .Cards: return "cards"
        case .Articles: return "articles"
        case .Polygon: return "poligon"
        default: return "news"
        }
    }
    
    struct Constants {
        static let perPage = 5
        static let baseURL = "https://meduza.io/api/v3/"
        static func urlWith(path:String)->String {
            return Constants.baseURL.stringByAppendingString(path)
        }
    }
}
