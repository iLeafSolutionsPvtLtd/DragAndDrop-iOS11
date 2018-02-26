//
//  ViewController+Drag.swift
//  TableViewDragAndDrop
//
//  Created by Hiran on 2/23/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDragDelegate {
    // MARK: - UITableViewDragDelegate
    
    /**
     The `tableView(_:itemsForBeginning:at:)` method is the essential method
     to implement for allowing dragging from a table.
     */
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return model.dragItems(for: indexPath)
    }
}

