//
//  ViewController.swift
//  TableViewDragAndDrop
//
//  Created by Hiran on 2/23/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

import UIKit

class ViewController: UITableViewController  {

    // MARK: - Properties
    
    var model = DataModel()
    
    // MARK: - View Life Cycle
    
    // Specify the table as its own drag source and drop delegate.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let place = Place()
                place.image = model.placeImages[indexPath.row]
                place.title = model.placeNames[indexPath.row]
                place.placeDescription = model.placeDescriptions[indexPath.row]
                let vc = segue.destination as! DetailViewController
                vc.place = place;
                
                
            }
        }
    }
    
}

