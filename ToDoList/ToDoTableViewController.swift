//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Georgy Dyagilev on 23/10/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var todos = [ToDo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            todos = ToDo.loadSampleToDo()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier", for: indexPath)
        
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        if todo.isComplite {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditTask" {
            let navigationVC = segue.destination as! UINavigationController
            let addEditTVC = navigationVC.topViewController as! AddEditTableViewController
            let selectedToDoIndexPath = tableView.indexPathForSelectedRow!
            let todo = todos[selectedToDoIndexPath.row]
            addEditTVC.todo = todo
            addEditTVC.addFlag = false
        }
    }
    
    @IBAction func unwindToToDoList(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "SaveUnwind" {
            let addEditTVC = unwindSegue.source as! AddEditTableViewController
            if addEditTVC.addFlag {
                let title = addEditTVC.titleTextField.text
                let isComplete = addEditTVC.isCompleteButton.isSelected
                let dueDate = addEditTVC.dueDatePicker.date
                let notes = addEditTVC.notesTextView.text ?? ""
                
                let newToDo: ToDo = ToDo(title: title!, isComplite: isComplete, dueDate: dueDate, notes: notes)
                todos.append(newToDo)
                tableView.insertRows(at: [IndexPath(row: todos.count - 1, section: 0)], with: .automatic)
            } else {
                // TODO: Save edited task.
                let selectedRow = tableView.indexPathForSelectedRow
                todos[(selectedRow!.row)] = addEditTVC.todo
                tableView.reloadRows(at: [selectedRow!], with: .automatic)
            }
            tableView.reloadData()
            ToDo.saveToDos(todos)
        }
    }
}
