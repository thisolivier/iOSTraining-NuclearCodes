//
//  EditEventViewController.swift
//  Option D
//
//  Created by Olivier Butler on 20/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class EditEventViewController: UIViewController{
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let _ = delegate {
            delegate!.saveEvent(sender: self)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if let _ = delegate {
            delegate!.cancelEditEvent()
        }
    }
    
    var delegate: EventsTableViewController?
    var originalEventEntity: EventEntity?
}

protocol EditEventViewDelegate {
    // still need to build this out
    func saveEvent(sender: EditEventViewController)
    func cancelEditEvent()
}
