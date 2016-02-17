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
    
    func getNewsArticleWith(url:String, completion:(article:NewsItem?,error:NSError?)->Void) {
        
        Alamofire.request(.GET, Constants.urlWith(url)).responseJSON { response in
            
            
            
//            ["root"]["gallary"] - картинки
//            ["root"]["content"]["body"] - новость
            // Если джейсон придет
            if let JSON = response.result.value as? [String:AnyObject],
                let root = JSON["root"] as? [String:AnyObject],
                let content = root["content"] as? [String:AnyObject],
                let body = content["body"] as? String
            {
                
                // Сохраним данные в базу
                MagicalRecord.saveWithBlock({ context in
                    
                    let newsItem = NewsItem.MR_findFirstByAttribute("url", withValue: url, inContext: context)!
                    
                    newsItem.content = body
                    
                    }, completion: { (success, error) -> Void in
                        
                        let newsItem = NewsItem.MR_findFirstByAttribute("url", withValue: url,
                            inContext: NSManagedObjectContext.MR_context())!
                        
                        completion(article: newsItem , error: nil)
                })
                
                return
            }
            
            completion(article: nil, error: response.result.error)
            
        }
    }
    
    func getNews(type:NewsType, page:Int){
        
        let params:[String:AnyObject] = ["chrono":newsTypeToMethod(type),
            "page" : page,
            "per_page" : Constants.perPage,
            "locale" : "ru"
        ]
        
        Alamofire.request(.GET, Constants.urlWith("search"), parameters: params, encoding: .URLEncodedInURL, headers: nil).responseJSON { response in
            if let JSON = response.result.value as? [String:AnyObject] {
                
                MagicalRecord.saveWithBlock({ context in
                    
                    // сохраним описание новостей
                    var newsToParse = [[String:AnyObject]]()

                    for info in (JSON["documents"] as! [String : AnyObject]).values {
                        newsToParse.append(info as! [String:AnyObject])
                    }
                    
                    self.parser.parse(newsToParse, context: context)
                    }, completion: { success, error -> Void in
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
