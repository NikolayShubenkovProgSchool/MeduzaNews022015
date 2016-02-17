//
//  NewsViewController.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 17/02/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import CoreData

class NewsViewController: CoreDataTableViewController {

//    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        cellIdentifier = "NewsCell"
        super.viewDidLoad()
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        ContentRetriever.shared.getNews(.News, page: 0)
    }
    
    //Mark: - Super
    override func request()-> NSFetchRequest {
        
//        let oldWayRequest = NSFetchRequest(entityName: "NewsItem")
//        oldWayRequest.sortDescriptors = [ NSSortDescriptor(key: "date", ascending: false) ]
        
        let request = NewsItem.MR_requestAllSortedBy("date", ascending: false)
        request.fetchBatchSize = 100
        
        return request
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let item = itemAt(indexPath) as! NewsItem
        let aCell = cell as! NewsTableViewCell
        
        aCell.topRight.text = NSDate.timeIntervalToDate(item.date).description
        aCell.title.text    = item.title
    }
}



