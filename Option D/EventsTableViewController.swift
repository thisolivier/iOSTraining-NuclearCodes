//
//  ViewController.swift
//  Option D
//
//  Created by Olivier Butler on 20/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Send on add string
        performSegue(withIdentifier: "addEventSegue", sender: "add")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as! String) == "add" {
            print ("Adding")
        } else {
            print ("Default segue setup")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

