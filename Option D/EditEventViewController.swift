//
//  EditEventViewController.swift
//  Option D
//
//  Created by Olivier Butler on 20/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class EditEventViewController: UIViewController{
    var delegate: EventsTableViewController?
}

protocol EditEventViewDelegate {
    // still need to build this out
    func saveEvent()
    func cancelEditEvent()
}
