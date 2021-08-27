//
//  DetailViewController.swift
//  Project19-21
//
//  Created by Eddie Jung on 8/27/21.
//

import UIKit

class DetailViewController: UIViewController {
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Detail note: \(note)")
    }

}
