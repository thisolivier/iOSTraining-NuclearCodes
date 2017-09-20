//
//  ViewController.swift
//  Option D
//
//  Created by Olivier Butler on 20/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit
import CoreData

class EventsTableViewController: UITableViewController, EditEventViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadEvents()
    }
    
    /*************/
    /* Core Data */
    /*************/
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sectionEvents = [[EventEntity]]()
    func loadEvents(){
        let eventRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntity")
        // let pastPredicate = NSPredicate(format: "completed == %@", true as CVarArg)
        let futurePredicate = NSPredicate(format: "completed == %@", false as CVarArg)
        let dateSortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        eventRequest.predicate = futurePredicate
        eventRequest.sortDescriptors = [dateSortDescriptor]
        do {
            let results = try (context.fetch(eventRequest) as! [EventEntity])
            sectionEvents.append(results)
        } catch {
            print("Failed to fetch events")
            print(error)
        }
    }
    
    /***************/
    /* Build table */
    /***************/
    
    // Set number of sections and title
    let sections = ["Coming Up","In The Past"]
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    // Set number of cells per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 3
    }
    
    // Make cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let newCell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell"){
            newCell.textLabel?.text = "At path \(indexPath)"
            return newCell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    // Make cells delete-able. Edit style set when making cells.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // We know all cells only have delete, so we can assume we should be deleting
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

