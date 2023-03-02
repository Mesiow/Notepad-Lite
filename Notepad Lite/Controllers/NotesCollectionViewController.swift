//
//  ViewController.swift
//  Notepad Lite
//
//  Created by Mesiow on 2/25/23.
//

import Foundation
import UIKit
import CoreData;
import SwipeCellKit

class NotesCollectionViewController: SwipeTableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
   
    var notes : [Note] = [];
    var noteIndex : Int?;
    var selectedNewNote : Bool = false;

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self;
        initUi();
        initMiscFunctionality();
        loadNotesData();
    }
    
    
    func deleteAllRecords() {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }
        }
   
    
    override func viewWillAppear(_ animated: Bool) {
        loadNotesData();
    }
    
    func initMiscFunctionality() {
        //Setup tap detection to resign keyboard
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
    
    func initUi() {
        guard let navBar = navigationController?.navigationBar else{fatalError("Navigation Controller does not exist") }
        
        navBar.tintColor = UIColor.systemTeal;
        searchBar.backgroundImage = UIImage();
        
        //change cursor color
        searchBar.tintColor = .white
        searchBar.barTintColor = UIColor.systemTeal
        searchBar.tintColor = UIColor.systemTeal
        UIBarButtonItem.appearance().tintColor = UIColor.white;
    }
    
    
    //CoreData Methods
    func loadNotesData(with request: NSFetchRequest<Note> = Note.fetchRequest()){
        print("load notes");
        do {
            notes = try context.fetch(request);
        }catch{
            print("Error loading notes from core data \(error)");
        }
        tableView.reloadData();
    }
    
    func saveNotesData(){
        do {
            try context.save();
        }catch{
            print("Error saving notes to core data \(error)");
        }
        tableView.reloadData();
    }
    
    func reloadNotesData(){
        do{
            try context.save();
        }catch{
            print("Error saving category \(error)");
        }
         
        let request : NSFetchRequest<Note> = Note.fetchRequest();
        do {
            notes = try context.fetch(request);
        }catch{
            print("Error reloading notes from core data \(error)");
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        context.delete(notes[indexPath.row]);
        reloadNotesData();
    }
    
    
    //Core Functionality
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        selectedNewNote = true;
        let note = Note(context: self.context);
        note.title = "None";
        note.text = "";
        note.date = Date().formatted(date: .numeric, time: .omitted);
        notes.append(note);
        
        performSegue(withIdentifier: "goToNote", sender: self);
    }
    
    //function that runs right before a segue is performed successfully
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNote" {
            let destinationVC = segue.destination as! NoteViewController;
            if selectedNewNote{
                destinationVC.note = notes.last; //if we selected a new note, it will have been the last item added to the array
            } else{
                if let idx = noteIndex { //note index will have a value set if we are selecting existing row
                    destinationVC.note = notes[idx];
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count;
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! NoteCell;
        
        let note = notes[indexPath.row];
        let splitStr = note.text!.components(separatedBy: " ");
    
        //Parse note text
        var boldLabel : String = "";
        var subLabel: String = "";
        if splitStr.count == 1 { //creating a title requires at least 1 word
            boldLabel = splitStr[0] + " ";
        }
        else if splitStr.count == 2{
            boldLabel = splitStr[0] + " " + splitStr[1];
        }
        else if splitStr.count >= 3 {
            boldLabel = splitStr[0] + " " + splitStr[1];
            subLabel = splitStr[2] + " ";
            
            for i in 3..<splitStr.count {
                let str = splitStr[i] + " ";
                subLabel.append(str);
            }
        }
        cell.mainLabel.text = boldLabel;
        cell.subLabel.text = subLabel;
        cell.dateLabel.text = note.date;
       
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteIndex = indexPath.row;
        selectedNewNote = false;
        tableView.deselectRow(at: indexPath, animated: true);
        
        performSegue(withIdentifier: "goToNote", sender: self);
    }
}


//Search bar functionality
extension NotesCollectionViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true);
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            if text.count == 0 {
                loadNotesData();
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder(); //dismiss keyboard and search bar cursor
                }
            }else{
                liveUpdateSearch();
            }
        }
    }
    
    func liveUpdateSearch(){
        let request : NSFetchRequest<Note> = Note.fetchRequest();
        //filter for if body text contains what we are searching
        let textPredicate = NSPredicate(format: "text CONTAINS[cd] %@", searchBar.text!);
    
        request.predicate = textPredicate;
        
        //how the results will be sorted
        let sortDescriptor = NSSortDescriptor(key: "text", ascending: true);
        request.sortDescriptors = [sortDescriptor];
        
        loadNotesData(with: request);
    }
}

