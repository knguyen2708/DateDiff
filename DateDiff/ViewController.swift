//
//  ViewController.swift
//  BCG_Test
//
//  Created by Khanh Nguyen on 19/04/2016.
//  Copyright © 2016 knguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CalendarViewControllerDelegate {
    
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var fromLabel: UILabel!

    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var daysLabel: UILabel!
    
    private var fromDate: KNDate = try! KNDate(day: 27, month: 8, year: 1985)
    private var toDate: KNDate = try! KNDate(day: 20, month: 4, year: 2016)
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fromTapped)))
        toView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toTapped)))
        
        syncDates()
    }
    
    func fromTapped() {
        let cal = CalendarViewController()
        cal.date = fromDate
        cal.tag = "from"
        cal.delegate = self
        
        presentViewController(cal, animated: true, completion: nil)
    }
    
    func toTapped() {
        let cal = CalendarViewController()
        cal.date = toDate
        cal.tag = "to"
        cal.delegate = self
        
        presentViewController(cal, animated: true, completion: nil)
    }
    
    func calendarViewControllerDidFinish(cal: CalendarViewController) {
        // Update either from or to date
        
        switch cal.tag! {
        case "from":
            fromDate = cal.date
            syncDates()
            
        case "to":
            toDate = cal.date
            syncDates()
            
        default:
            fatalError()
        }
    }
    
    func calendarViewControllerDidCancel(cal: CalendarViewController) {
        // Do nothing
    }
    
    private func syncDates() {
        fromLabel.text = fromDate.description
        toLabel.text = toDate.description
        
        do {
            let days = try KNDate.differenceInDays(fromDate: fromDate, toDate: toDate)
            
            let noun = days != 1 ? "days" : "day"
            daysLabel.text = "\(days) \(noun)"
            daysLabel.font = UIFont.avenirNextMedimum(size: 30)
            
        } catch let error as KNError {
            daysLabel.text = "(error: \(error.info))"
            daysLabel.font = UIFont.avenirNextRegular(size: 20)
            
        } catch _ {
            daysLabel.text = "(error)"
            daysLabel.font = UIFont.avenirNextRegular(size: 20)
        }
    }

}
