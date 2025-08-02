//
//  CalendarViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 7/30/25.
//

import UIKit

final class CalendarViewController: BaseViewController {
    
    private static let dateFormat = "yyyy-MM-dd HH:mm:ss"
    private static let seoul = "Asia/Seoul"
    
    private let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }()
    public var currentDate = DateUtil.getCurrentDate()
    private var startOfMonth: Date {
        guard let date = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else {
            fatalError("Unable to calculate the start of the month.")
        }
        return date
    }
    private lazy var selectedDate = currentDate
    private var selectableStartDate: Date?
    private var selectableEndDate: Date?
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = TimeZone(identifier: seoul)
        return formatter
    }()
    private var days: [String?] = []
    
    private let calendarView = CalendarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setAction() {
        calendarView.headerView.previousButton
            .addTarget(self, action: #selector(previousButtonDidTap), for: .touchUpInside)
        
        calendarView.headerView.nextButton
            .addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    
    override func setDelegate() {
        calendarView.collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(DayCell.self, forCellWithReuseIdentifier: DayCell.reuseIdentifier)
        }
        reload()
        setSelectableDate()
    }
}

extension CalendarViewController {
    
    private func reload() {
        generateDays()
        calendarView.collectionView.reloadData()
        calendarView.headerView.bind(
            year: calendar.component(.year, from: currentDate),
            month: calendar.component(.month, from: currentDate)
        )
        
        let daysInMonth = calculateDaysInMonth()
        let offset = calculateOffset()
        let numberOfWeeks = calculateNumberOfWeeks(
            daysInMonth: daysInMonth,
            offset: offset
        )
        
        calendarView.configureCollectionView(weeks: numberOfWeeks)
    }
    
    private func generateDays() {
        days.removeAll()
        
        let daysInMonth = calculateDaysInMonth()
        let offset = calculateOffset()
        
        for _ in 0..<offset {
            days.append(nil)
        }
        
        daysInMonth.forEach {
            if let date = calendar.date(byAdding: .day, value: $0 - 1, to: startOfMonth) {
                days.append(formatter.string(from: date))
            }
        }
    }
    
    private func setSelectableDate() {
        selectableStartDate = calendar.date(byAdding: .day, value: -7, to: currentDate)
        selectableEndDate = calendar.date(byAdding: .day, value: 7, to: currentDate)
    }
    
    private func calculateDaysInMonth() -> Range<Int> {
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentDate)!
        return daysInMonth
    }
    
    private func calculateOffset() -> Int {
        let firstWeekday = calendar.firstWeekday
        let firstOfMonthWeekday = calendar.component(.weekday, from: startOfMonth)
        let offset = (firstOfMonthWeekday - firstWeekday + 7) % 7
        return offset
    }
    
    private func calculateNumberOfWeeks(daysInMonth: Range<Int>, offset: Int) -> Int {
        return Int(ceil(CGFloat(daysInMonth.count + offset) / 7.0))
    }
    
    private func isDateInSelectableRange(date: Date) -> Bool {
        guard let startDate =  selectableStartDate,
              let endDate = selectableEndDate else {
            return false
        }
        return date >= startDate && date <= endDate
    }
}

extension CalendarViewController {
    
    @objc
    private func previousButtonDidTap() {
        let date = DateUtil.getPreviousMonth(from: currentDate)
        currentDate = date
        reload()
    }
    
    @objc
    private func nextButtonDidTap() {
        let date = DateUtil.getNextMonth(from: currentDate)
        currentDate = date
        reload()
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dateString = days[indexPath.row] else { return }
        
        let date = formatter.date(from: dateString)!
        if isDateInSelectableRange(date: date) {
            selectedDate = date
            reload()
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DayCell.reuseIdentifier,
            for: indexPath
        ) as? DayCell else {
            return UICollectionViewCell()
        }
        
        guard let dateString = days[indexPath.row],
              let date = formatter.date(from: dateString) else {
            cell.bind(state: .notInMonth)
            return cell
        }
        
        let day = calendar.component(.day, from: date)
        
        guard isDateInSelectableRange(date: date) else {
            cell.bind(state: .notSelectable(day: day))
            return cell
        }
        
        let isSelected = calendar.isDate(selectedDate, inSameDayAs: date)
        let isToday = calendar.isDateInToday(date)
        
        cell.bind(state: .normal(day: day, isSelected: isSelected, isToday: isToday))
        return cell
    }
}
