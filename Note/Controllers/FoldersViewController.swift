//
//  FoldersViewController.swift
//  Note
//
//  Created by Полина on 13.03.2020.
//  Copyright © 2020 Станислав Белых. All rights reserved.

import UIKit

class FoldersViewController: UIViewController {

    @IBOutlet weak var foldersTableView: UITableView!
    
    
    var folders:[Folder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foldersTableView.delegate = self
        foldersTableView.dataSource = self
        
        setNavigationBar()

    }

    @IBAction func createNewFolder(_ sender: Any) {
        let alert = UIAlertController(title: "Новая папка", message: "Введите название для этой папки.", preferredStyle: .alert)
        let  cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        let action = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            let text = alert.textFields?.first?.text
            
            if let text = text{
                var folder = Folder(title: text, notes: [Note]())
                //Заглушка при создании заметки для проверки отображения ячейки в Notes
                folder.notes = [Note(title: "Title", body: nil, createDate: nil, editDate: nil)]
                self.folders.append(folder)
            }
            self.foldersTableView.reloadData()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Имя"
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        let editNavigationBarItem = UIBarButtonItem(title: "Править",
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(editTableOfFolders))
        navigationItem.rightBarButtonItem = editNavigationBarItem
    }
    
    @objc func editTableOfFolders(){
        print("Нажата кнопка править")
    }
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueNotes" {
            if let indexPath = self.foldersTableView.indexPathForSelectedRow {
                let controller = segue.destination as! NotesViewController
                controller.notes = folders[indexPath.row].notes
                controller.title = folders[indexPath.row].title
            }
        }
    }
}
//MARK: - DateSourse
extension FoldersViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdentifierFolderCell", for: indexPath) as! FoldersTableViewCell
        let folder = folders[indexPath.row]
        cell.folderNameLabel.text = folder.title
        cell.countOfNoteInFolderLable.text = String(folder.notes.count)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
}
//MARK: - Delegate
extension FoldersViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addUser = addUserAction(at: indexPath)
        let swichFolder = swichFolderAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, swichFolder, addUser])
    }
    
    func addUserAction(at indexPath: IndexPath) -> UIContextualAction{
        let folder = folders[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Add User") { (action, view, completion) in
            print(folder)
            completion(true)
        }
        action.backgroundColor = UIColor.blue
        action.image = UIImage(systemName: "person.crop.circle.badge.plus")
        
        return action
    }
    func swichFolderAction(at indexPath: IndexPath) -> UIContextualAction{
        let folder = folders[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Move Folder") { (action, view, completion) in
            print("Move Folder \(folder)")
        }
        action.backgroundColor = .purple
        action.image = UIImage(systemName: "folder.fill")
        
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.folders.remove(at: indexPath.row)
            self.foldersTableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .red
        action.image = UIImage(systemName: "trash.fill")
        
        return action
    }
}
