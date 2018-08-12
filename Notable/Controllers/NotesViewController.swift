//
//  ViewController.swift
//  Notable
//
//  Created by Allen Hou on 8/11/18.
//  Copyright © 2018 nEmmY. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var noteTitle: UINavigationItem!
    @IBOutlet weak var textView: UITextView!
    var notesArray = [Notes]()
    var selectedNote : NotesTable? {
        didSet{
            loadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //loadData()

        //this code only loads up the array at index 0
//        if notesArray.count > 0 {
//            textView.text = notesArray[0].noteBody
//            print("Array : \(notesArray[0].noteBody)")
//        } else {
//            print("empty")
//        }

//        for index in notesArray.indices {
//            if let tempText = notesArray[index].noteBody {
//                textView.text = tempText
//            }
//        }
        
        for Notes in notesArray {
            textView.text = Notes.noteBody
        }
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let newData = Notes(context: context)
        newData.noteBody = textView.text
        newData.parentNotesTable = selectedNote
        notesArray.append(newData)
        
        saveData()
        
    }
    
    func loadData() {
        
        let notesPredicate = NSPredicate(format: "parentNotesTable.name MATCHES %@", selectedNote!.name!)
        let request : NSFetchRequest<Notes> = Notes.fetchRequest()
        
        request.predicate = notesPredicate

        do {
            notesArray = try context.fetch(request)
        } catch {
            print("Error in fetching data, \(error)")
        }
        
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error context saving data, \(error) ")
        }
        
    }
    
    
}

