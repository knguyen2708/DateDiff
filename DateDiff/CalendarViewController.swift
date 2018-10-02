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
            return try! KNDate(fromSwiftDate: datePicker.date)
        }
        set {
            datePicker.date = newValue.toSwiftDate()
        }
    }
    
    convenience init() {
        self.init(nibName: "CalendarViewController", bundle: nil)
        
        loadViewIfNeeded()
    
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = AlertStyleTransitioningManager.defaultInstance
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        
        datePicker.minimumDate = KNDate.minDate.toSwiftDate()
        datePicker.maximumDate = KNDate.maxDate.toSwiftDate()
        datePicker.datePickerMode = .date
        
        for z in [cancelButton!, doneButton!] {
            z.layer.cornerRadius = 4
            z.clipsToBounds = true
        }
    }
    
    @IBAction func cancelTapped() {
        presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.calendarViewControllerDidCancel(self)
    }
    
    @IBAction func doneTapped() {
        presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.calendarViewControllerDidFinish(self)
    }
    
}

protocol CalendarViewControllerDelegate: class {
    /**
     Invoked when user taps "Done". The selected date can be retrieved from `date` property of the view controller.
     */
    func calendarViewControllerDidFinish(_ viewController: CalendarViewController)

    /**
     Invoked when user taps "Cancel".
     */
    func calendarViewControllerDidCancel(_ viewController: CalendarViewController)
}

// Conversions to/from NSDate

extension KNDate {
    /**
     Constructs an `NSDate` from the receiver.
     */
    func toSwiftDate() -> Date {
        let f = DateFormatter()
        f.dateFormat = "d/M/yyyy"
        return f.date(from: self.description)!
    }
    
    /**
     Constructs a `KNDate` from the an `NSDate`.
     */
    init(fromSwiftDate date: Date) throws {
        let cal = Calendar.current
        let comps = cal.dateComponents([.day, .month, .year], from: date)
        
        try self.init(day: comps.day!, month: comps.month!, year: comps.year!)
    }
}
