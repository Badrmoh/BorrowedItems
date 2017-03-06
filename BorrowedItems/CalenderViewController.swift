//
//  ViewController.swift
//  BorrowedItems
//
//  Created by Badr  on 22/01/2017.
//  Copyright © 2017 Badr. All rights reserved.
//

import UIKit

protocol TimeFrameDelegate {
    func didSelectDateRange(range: GLCalendarDateRange)
}

class CalenderViewController: UIViewController, GLCalendarViewDelegate{

    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var calenderView: GLCalendarView!
    
    var timeFrameDelegate: TimeFrameDelegate? = nil
    var timeframe: GLCalendarDateRange? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderView.delegate = self
        //Customize Calender appearance
        GLCalendarView.appearance().padding = 6
        GLCalendarView.appearance().rowHeight = 54
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Create range
        let today = Date()
        let beginDate = GLDateUtils.date(byAddingDays: 0, to: today)
        let endDate = GLDateUtils.date(byAddingDays: 7, to: today)
        
        let range = GLCalendarDateRange(begin: beginDate, end: endDate)
        range?.backgroundColor = UIColor.lightGray
        range?.editable = true
        calenderView.ranges = [range]
        calenderView.reload()
        
        DispatchQueue.main.async {
            self.calenderView.scroll(to: self.calenderView.lastDate, animated: false)
        }
    }
    
    //MARK: Buttons Actions
    @IBAction func donePressed(_ sender: Any) {
        if let selectedRange = timeframe {
            if timeFrameDelegate != nil {
                timeFrameDelegate?.didSelectDateRange(range: selectedRange)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: GLCalender methods 
    
    func calenderView(_ calendarView: GLCalendarView!, canAddRangeWithBegin beginDate: Date!) -> Bool {
        return true
    }
    
    func calenderView(_ calendarView: GLCalendarView!, rangeToAddWithBegin beginDate: Date!) -> GLCalendarDateRange! {
        let endDate = GLDateUtils.date(byAddingDays: 0, to: beginDate)
        let range = GLCalendarDateRange(begin: beginDate, end: endDate)
        range?.editable = true
        range?.backgroundColor = UIColor.lightGray
        
        return range
    }
    
    func calenderView(_ calendarView: GLCalendarView!, canUpdate range: GLCalendarDateRange!, toBegin beginDate: Date!, end endDate: Date!) -> Bool {
        return true
    }
    
    func calenderView(_ calendarView: GLCalendarView!, beginToEdit range: GLCalendarDateRange!) {
        
    }
    
    func calenderView(_ calendarView: GLCalendarView!, finishEdit range: GLCalendarDateRange!, continueEditing: Bool) {
        
    }
    
    func calenderView(_ calendarView: GLCalendarView!, didUpdate range: GLCalendarDateRange!, toBegin beginDate: Date!, end endDate: Date!) {
        timeframe = range
    }
}
