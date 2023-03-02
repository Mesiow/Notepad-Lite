//
//  SwipeTableViewController.swift
//  Notepad Lite
//
//  Created by Mesiow on 2/28/23.
//

import Foundation
import UIKit
import SwipeCellKit

class SwipeTableViewController : UITableViewController, SwipeTableViewCellDelegate {
    
    let cellIdentifier : String = "ReusableNoteCell";

    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.rowHeight = 70.0;
        tableView.alwaysBounceVertical = false;
        //register custom xib cell design file
        tableView.register(UINib(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: cellIdentifier);
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NoteCell;
        
        cell.delegate = self;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
                //handle deleting
            self.updateModel(at: indexPath);
        }
        
        deleteAction.image = UIImage(named: "delete-icon");
        
        return [deleteAction];
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions();
        options.expansionStyle = .destructive;
        
        return options;
    }
   
    func updateModel(at indexPath: IndexPath){
        //override to update where necessary
    }
}
