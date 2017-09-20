//
//  ViewController.swift
//  Option D
//
//  Created by Olivier Butler on 20/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController, EditEventViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /******************/
    /* Segues and nav */
    /******************/
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Send on add string
        performSegue(withIdentifier: "addEventSegue", sender: "add")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditEventViewController{
            destination.delegate = self
            if (sender as! String) == "add" {
                print ("Adding")
            } else {
                print ("Default segue setup")
            }
        }
    }
    
    /**************/
    /* Delegation */
    /**************/
 
     func saveEvent() {
        print("saveEvent Triggered from stack, handled by delegate")
     }
 
     func cancelEditEvent() {
        print("The cancel edit event Triggered from stack, handled by delegate")
     }


}

