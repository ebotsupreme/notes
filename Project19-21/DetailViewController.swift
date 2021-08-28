//
//  DetailViewController.swift
//  Project19-21
//
//  Created by Eddie Jung on 8/27/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var noteTextView: UITextView!
    
    var note: Note?
    var notes: [Note] = [Note]()
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenterSettings()
        
        doneButtonSettings()
        
        load()
        
        print("VDL Detail note: \(note)")
        print("VDL Detail notes: \(notes)")
    }
    
    func notificationCenterSettings() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = .zero
        } else {
            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        noteTextView.scrollIndicatorInsets = noteTextView.contentInset
        
        let selectedRange = noteTextView.selectedRange
        noteTextView.scrollRangeToVisible(selectedRange)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
            print("Save success!")
            
            // go back to viewController and reload table
        }
    }
    
    func doneButtonSettings() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
    }
    
    @objc func done() {
        print(noteTextView.text)
        
        // return if noteTextView is empty & trigger alert
        if noteTextView.text == "" { return }
        
        // create new note
        let lines = noteTextView.text.split(whereSeparator: \.isNewline)
        let title = String(lines[0])
        let removeTitleFromDescription = lines.dropFirst(1)
        let description = removeTitleFromDescription.joined(separator: "\n")
        let timeStamp = formatDate()
        
        if note != nil {
            if let currentIndex = index {
                if notes[currentIndex] === note {
                    print("Match found for Note. Edit note")
                    
                    // edit
                    let note = notes[currentIndex]
                    note.title = title
                    note.description = description
                    note.timeStamp = timeStamp
                    print("editted note: \(note)")
//                    notes.append(currentNote)
                }
            }
                
            
        } else {
            print("currentNote is empty! \(note). Create note!")
//            // create
            let note = Note(title: title, description: description, timeStamp: timeStamp)
            print("created note: \(note.title), \(note.description), \(note.timeStamp)")
            notes.append(note)
            print("notes array: \(notes)")
        }
        print("saving")

        save()
        
    }
    
    func formatDate() -> String {
        //new date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MM/dd/yy h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let dateFromStr = dateFormatter.string(from: Date())
        
        print(dateFromStr)
        return dateFromStr
        
    }
    
    func load() {
        print("load note")
        // load in from tableviewcell
        if note != nil {
            let title = note?.title ?? ""
            let description = note?.description ?? ""
            let titleAndDescription = title + "\n" + description
            print("description loaded: \(titleAndDescription)")
            noteTextView.text = titleAndDescription
        }
    }
    
}
