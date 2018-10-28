//
//  AddEditTableViewController.swift
//  ToDoList
//
//  Created by Georgy Dyagilev on 24/10/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import UIKit

class AddEditTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let dueDatePickerIndexPath = IndexPath(row: 2, section: 0)
    var todo = ToDo(title: "", isComplite: false, dueDate: Date(), notes: "")
    var addFlag = true
    
    var isDueDatePickerShown = false {
        didSet {
            dueDatePicker.isHidden = !isDueDatePickerShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        dueDatePicker.minimumDate = midnightToday
        dueDatePicker.date = midnightToday
        
        updateUI()
        
        titleTextField.delegate = self
        notesTextField.delegate = self
        
        updateSaveButtonState()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         navigationItem.rightBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case dueDatePickerIndexPath:
            if isDueDatePickerShown {
                return 216
            } else {
                return 0
            }
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if titleTextField.isEditing {
            titleTextField.resignFirstResponder()
        }
        if notesTextField.isEditing {
            titleTextField.resignFirstResponder()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (dueDatePickerIndexPath.section, dueDatePickerIndexPath.row - 1):
            isDueDatePickerShown.toggle()
        default:
            isDueDatePickerShown = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "SaveUnwind" else { return }
        
        todo = ToDo(title: titleTextField.text!, isComplite: isCompleteButton.isSelected, dueDate: dueDatePicker.date, notes: notesTextField.text)
    }
    
    @IBAction func dueDatePickerValueChanged(_ sender: UIDatePicker) {
        updateDueDateView()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    func updateUI() {
        titleTextField.text = todo.title
        isCompleteButton.isSelected = todo.isComplite
        dueDatePicker.date = todo.dueDate
        notesTextField.text = todo.notes
        updateDueDateView()
    }
    
    func updateDueDateView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        dueDateLabel.text = dateFormatter.string(from: dueDatePicker.date)
    }
    
    func updateSaveButtonState() {
        let titleText = titleTextField.text ?? ""
        saveButton.isEnabled = !titleText.isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isDueDatePickerShown = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
}
