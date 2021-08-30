//
//  ViewController.swift
//  Project19-21
//
//  Created by Eddie Jung on 8/26/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbarItems = barButtonItems()
        navigationController?.isToolbarHidden = false
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        print(UserDefaults.standard.bool(forKey: "notes"))
        load()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        
        // not working
        cell.detailTextLabel?.text = "\(note.timeStamp)    \(note.description)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let note = notes[indexPath.row]
            vc.notes = notes
            vc.index = indexPath.row
            vc.note = note
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func barButtonItems() -> [UIBarButtonItem] {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(create))
        return [spacer, compose]
    }
    
    @objc func create() {
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetail") {
            if let dvc = segue.destination as? DetailViewController {
                dvc.notes = notes
            }
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedData)
                print("User Default notes loaded: \(notes)")
            } catch {
                print("Failed to load notes.")
            }
        }
    }
    
    func deleteUserDefault() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "notes")
        let isDeleted = defaults.bool(forKey: "notes")
        print("User default key notes deleted: \(isDeleted)")
    }

}

