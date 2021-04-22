//
//  TaskListViewController.swift
//  GoodList
//
//  Created by Adriaan van Schalkwyk on 2021/04/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var task =  BehaviorRelay<[Task]>(value: [])
    private var filteredTask = [Task]()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
              let addTaskViewController = navigationController.viewControllers.first as? AddTaskViewController else {
            return
        }
        addTaskViewController.taskSubjectObservable.subscribe(onNext: { [unowned self] task in
            let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
            var existingTask = self.task.value
            existingTask.append(task)
            self.task.accept(existingTask)
            self.filterTask(by: priority)
        }).disposed(by: disposeBag)
    }
    
    private func filterTask(by priority: Priority?) {
        if priority == nil {
            self.filteredTask = self.task.value
            self.updateTableView()
        } else {
            self.task.map { task in
                return task.filter {$0.prioroty == priority}
            }.subscribe(onNext: { [weak self] task in
                self?.filteredTask = task
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTask(by: priority)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = self.filteredTask[indexPath.row].title
        return cell
    }
}
