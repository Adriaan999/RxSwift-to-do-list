//
//  AddTaskViewController.swift
//  GoodList
//
//  Created by Adriaan van Schalkwyk on 2021/04/21.
//

import Foundation
import  UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var teaskTitleTextField: UITextField!
    
    @IBAction func save() {
        
        guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex),
              let title = self.teaskTitleTextField.text else {
            return
        }
        let task = Task(title: title, prioroty: priority)
    }
}
