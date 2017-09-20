//
//  EditEventViewController.swift
//  Option D
//
//  Created by Olivier Butler on 20/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class EditEventViewController: UIViewController, UITextViewDelegate{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTextView.delegate = self
        if let original = originalEventEntity {
            self.title = original.name
            titleLabel.text = original.name
            datePicker.date = original.time!
            detailsTextView.text = original.info
            detailsTextView.textColor = UIColor.black
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.originalEventEntity == nil {
            detailsTextView.text = ""
            detailsTextView.textColor = UIColor.black
        }
    }
    
}

protocol EditEventViewDelegate {
    // still need to build this out
    func saveEvent(sender: EditEventViewController)
    func cancelEditEvent()
}
