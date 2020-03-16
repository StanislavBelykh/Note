//
//  NotesViewController.swift
//  Note
//
//  Created by Полина on 16.03.2020.
//  Copyright © 2020 Станислав Белых. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    var notes = [Note]()
    let tableView = UITableView.init(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
        view.addSubview(tableView)
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "NoteViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        updateLayout(with: self.view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (contex) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    private func updateLayout(with size: CGSize){
        self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        let editNavigationBarItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(editNotes))
        navigationItem.rightBarButtonItem = editNavigationBarItem
    }
    
    @objc func editNotes(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Выбрать заметки...", style: .default, handler: { (action) in
            print("Выбрать заметки...")
        }))
        actionSheet.addAction(UIAlertAction(title: "Посмотреть вложения", style: .default, handler: { (action) in
            print("Посмотреть вложения")
        }))
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        actionSheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(actionSheet, animated: true)
        
    }
}

//MARK: - DateSourse
extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NoteViewCell", for: indexPath) as! NoteTableViewCell
        cell.textLabel?.text = self.notes[indexPath.row].title
        return cell
    }
}
extension NotesViewController: UITableViewDelegate {
    
}
