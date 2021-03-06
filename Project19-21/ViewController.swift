//
//  ViewController.swift
//  Project19-21
//
//  Created by Eddie Jung on 8/26/21.
//

import UIKit

class ViewController: UITableViewController {
    var numberOfNotes: UILabel!
    var notes = [Note]()
    
    override func viewWillAppear(_ animated: Bool) {
        load()
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UserDefaults.standard.bool(forKey: "notes"))
//        deleteUserDefault()
        load()
        
        toolbarItems = barButtonItems()
        navigationController?.isToolbarHidden = false
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
            tableView.reloadData()
        }
    }
    
    func barButtonItems() -> [UIBarButtonItem] {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(create))
        numberOfNotes = UILabel()
        numberOfNotes.text = "\(notes.count) Notes"
        let toolbarNumberOfNotes = UIBarButtonItem(customView: numberOfNotes)
        return [spacer, toolbarNumberOfNotes, spacer, compose]
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
                // sort notes by time
                notes = notes.sorted(by: { $0.timeStamp.compare($1.timeStamp) == .orderedDescending })
            } catch {
                print("Failed to load notes.")
            }
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        }
    }
    
    func deleteUserDefault() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "notes")
        let isDeleted = defaults.bool(forKey: "notes")
        print("User default key notes deleted: \(isDeleted)")
    }
    
    /* Additional features to be worked on
        1. multi view button - on click show custom table view cells instead of a tableview list
        2. Hide seconds inside timestamp before displaying in tableview subtitle
        3. Add search feature
        4. when sharing, add custom title and subtitle.
    */
}

