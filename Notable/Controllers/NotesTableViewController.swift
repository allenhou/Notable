//
//  NotesTableViewController.swift
//  Notable
//
//  Created by Allen Hou on 8/11/18.
//  Copyright © 2018 nEmmY. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notesTableArray = [NotesTable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCells", for: indexPath)
        let notesTable = notesTableArray[indexPath.row]
        cell.textLabel?.text = notesTable.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesTableArray.count
    }
    
    //Mark: - TableView Delagate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToNotes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NotesViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedNote = notesTableArray[indexPath.row]
            destinationVC.noteTitle.title = notesTableArray[indexPath.row].name!
        }
    }

    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error loading data, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request : NSFetchRequest<NotesTable> = NotesTable.fetchRequest()) {
        do {
            notesTableArray = try context.fetch(request)
        } catch {
            print("Error fetching data, \(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Note Title"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Notes", style: .default) { (alert) in
            let newNote = NotesTable(context: self.context)
            if textField.text?.count != 0 { // <~~~~~this piece of code is not working
                newNote.name = textField.text
                self.notesTableArray.append(newNote)
                self.saveData()
            } else {
                print("Empty name not added")
            }
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
