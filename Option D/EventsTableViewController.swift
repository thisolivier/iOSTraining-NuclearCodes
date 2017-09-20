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
        loadEvents()
    }
    
    /*************/
    /* Core Data */
    /*************/
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sectionEvents = [[EventEntity](),[EventEntity]()]
    func loadEvents(reload:Bool = true){
        let eventRequestFu = NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntity")
        let eventRequestPa = NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntity")
        let pastPredicate = NSPredicate(format: "completed == %@", true as CVarArg)
        let futurePredicate = NSPredicate(format: "completed == %@", false as CVarArg)
        let dateSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
        eventRequestFu.predicate = futurePredicate
        eventRequestFu.sortDescriptors = [dateSortDescriptor]
        eventRequestPa.predicate = pastPredicate
        eventRequestPa.sortDescriptors = [dateSortDescriptor]
        do {
            let resultsFu = try (context.fetch(eventRequestFu) as! [EventEntity])
            let resultsPa = try (context.fetch(eventRequestPa) as! [EventEntity])
            sectionEvents[0] = resultsFu
            sectionEvents[1] = resultsPa
            //print ("-----------")
            print ("Event entities have been reloaded")
            if reload {
                self.tableView.reloadData()
            }
            //print(sectionEvents)
            //print ("-----------")
        } catch {
            print("Failed to fetch events")
            print(error)
        }
    }
    func attemptSave(reload:Bool = true){
        if context.hasChanges{
            do{
                try context.save()
                print ("Saved successfully using attemptSave")
                if reload {
                    loadEvents()
                }
            } catch {
                print ("Failed to save using attemptSave")
                print (error)
            }
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
        return sectionEvents[section].count
    }
    
    // Make cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath[0] == 0 {
            if let newCell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell"){
                let currentEntity = sectionEvents[0][indexPath[1]]
                let timeString = helperMakeTime(from: currentEntity.time!)
                newCell.textLabel?.text = currentEntity.name
                newCell.detailTextLabel?.text = timeString
                return newCell
            }
        } else if indexPath[0] == 1 {
            if let newCell = self.tableView.dequeueReusableCell(withIdentifier: "completedEventCell"){
                let currentEntity = sectionEvents[1][indexPath[1]]
                let timeString = helperMakeTime(from: currentEntity.time!)
                newCell.textLabel?.text = currentEntity.name
                newCell.detailTextLabel?.text = timeString
                return newCell
            }
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func helperMakeTime(from date:Date) -> String{
        let formatObject = DateFormatter()
        formatObject.locale = Locale.current
        formatObject.setLocalizedDateFormatFromTemplate("HH:mm")
        return formatObject.string(from: date)
    }
    
    // Make cells delete-able. Edit style set when making cells.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Pretty formatting
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let theHeader = view as? UITableViewHeaderFooterView {
            theHeader.textLabel?.textColor = UIColor.white
            if section == 0 {
                theHeader.backgroundView?.backgroundColor = UIColor.orange
            } else {
                theHeader.backgroundView?.backgroundColor = UIColor.darkGray
            }
        }
    }
    
    /**********************/
    /* Table interactions */
    /**********************/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentEntity = sectionEvents[indexPath[0]][indexPath[1]]
        currentEntity.completed = currentEntity.completed ? false : true
        attemptSave()
        //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        //self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let currentEntity = sectionEvents[indexPath[0]].remove(at: indexPath[1])
        tableView.deleteRows(at: [indexPath], with: .right)
        self.context.delete(currentEntity)
        attemptSave(reload: false)
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
            if let _ = sender as? String {
                print ("Adding")
            } else if let originalEntity = sender as? EventEntity {
                destination.originalEventEntity = originalEntity
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("Accessory tapped")
        let currentEntity = sectionEvents[0][indexPath[1]]
        performSegue(withIdentifier: "addEventSegue", sender: currentEntity)
    }
    
    /**************/
    /* Delegation */
    /**************/
    func saveEvent(sender: EditEventViewController) {
        print("saveEvent Triggered from stack, handled by delegate")
        // If we had an original, we set current to that, if not, we make a new one
        var currentItem:EventEntity?
        if let _ = sender.originalEventEntity {
            currentItem = sender.originalEventEntity!
        } else {
            currentItem = (NSEntityDescription.insertNewObject(forEntityName: "EventEntity", into: self.context) as! EventEntity)
            currentItem?.completed = false
        }
        currentItem?.name = sender.titleLabel.text
        currentItem?.time = sender.datePicker.date
        currentItem?.info = sender.detailsTextView.text
        attemptSave()
        self.navigationController?.popViewController(animated: true)
    }
 
    func cancelEditEvent() {
        print("The cancel edit event Triggered from stack, handled by delegate")
        self.navigationController?.popViewController(animated: true)
    }
}

