//
//  CalendarViewController.swift
//  BCG_Test
//
//  Created by Khanh Nguyen on 20/04/2016.
//  Copyright © 2016 knguyen. All rights reserved.
//

import UIKit

/**
 Allows picking a date
 */
class CalendarViewController: UIViewController {
    
    /**
     The delegate.
    */
    weak var delegate: CalendarViewControllerDelegate?
    
    /**
     Whatever you need to identify the view controller (e.g. if multiple instances are presented)
     */
    var tag: String? = ""
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    /**
     The selected date. This should be set before presenting the view controller, and read after dismissal.
     */
    var date: KNDate {
        get {
            return try! KNDate(fromNSDate: datePicker.date)
        }
        set {
            datePicker.date = newValue.toNSDate()
        }
    }
    
    convenience init() {
        self.init(nibName: "CalendarViewController", bundle: nil)
        
        loadViewIfNeeded()
    
        transitioningDelegate = AlertStyleTransitioningManager.defaultInstance
        modalPresentationStyle = .Custom
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 320, height: 285)
        }
        set {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerView.layer.cornerRadius = 4
        datePickerView.clipsToBounds = true
        
        datePicker.minimumDate = KNDate.minDate.toNSDate()
        datePicker.maximumDate = KNDate.maxDate.toNSDate()
        datePicker.datePickerMode = .Date
        
        for z in [cancelButton, doneButton] {
            z.layer.cornerRadius = 4
            z.clipsToBounds = true
        }
    }
    
    @IBAction func cancelTapped() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        delegate?.calendarViewControllerDidCancel(self)
    }
    
    @IBAction func doneTapped() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        delegate?.calendarViewControllerDidFinish(self)
    }
    
}

protocol CalendarViewControllerDelegate: class {
    /**
     Invoked when user taps "Done". The selected date can be retrieved from `date` property of the view controller.
     */
    func calendarViewControllerDidFinish(viewController: CalendarViewController)

    /**
     Invoked when user taps "Cancel".
     */
    func calendarViewControllerDidCancel(viewController: CalendarViewController)
}

// Conversions to/from NSDate

extension KNDate {
    /**
     Constructs an `NSDate` from the receiver.
     */
    func toNSDate() -> NSDate {
        let f = NSDateFormatter()
        f.dateFormat = "d/M/yyyy"
        return f.dateFromString(self.description)!
    }
    
    /**
     Constructs a `KNDate` from the an `NSDate`.
     */
    init(fromNSDate nsdate: NSDate) throws {
        let cal = NSCalendar.currentCalendar()
        let comps = cal.components([.Day, .Month, .Year], fromDate: nsdate)
        
        try self.init(day: comps.day, month: comps.month, year: comps.year)
    }
}