//
//  DataModel+Dragging.swift
//  TableViewDragAndDrop
//
//  Created by Hiran on 2/23/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

import UIKit
import MobileCoreServices

extension DataModel {
    /**
     A helper function that serves as an interface to the data model,
     called by the implementation of the `tableView(_ canHandle:)` method.
     */
    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    /**
     A helper function that serves as an interface to the data mode, called
     by the `tableView(_:itemsForBeginning:at:)` method.
     */
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let placeName = placeNames[indexPath.row]
        let placeDescription = placeDescriptions[indexPath.row]
        let place = placeName+placeDescription
        let data = place.data(using: .utf8)
        
        let itemProvider = NSItemProvider()
        
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        
        
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
}

