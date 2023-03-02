//
//  NoteViewController.swift
//  Notepad Lite
//
//  Created by Mesiow on 2/25/23.
//

import Foundation
import UIKit
import CoreData

class NoteViewController : UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    var note : Note? //reference to note in the note array in NotesCollectionViewController
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad(){
        super.viewDidLoad();
        UITextView.appearance().tintColor = UIColor.systemTeal;
        
        if let n = note {
            textView.text = n.text;
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            if let n = note { //moving back to notes table, save what we have in this note
                n.text = textView.text;
                if n.text != "" { //save note only if we actually wrote something
                    saveNote();
                }else{
                    removeNote();
                }
            }
        }
    }
    
    func saveNote() {
        do {
            try context.save();
        }catch{
            print("Error saving note \(error)");
        }
    }
    
    func removeNote(){
        if let n = note {
            context.delete(n);
        }
    }
}
