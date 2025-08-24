//
//  ListItemState.swift
//  BeforeGoing
//
//  Created by APPLE on 8/12/25.
//

enum ListItemState {
    
    case today
    case normal
    case completed
    
    func createListItem(beforeState: ListItemState) -> ListItemProtocol {
        var listItem: ListItemProtocol
        
        switch self {
        case .normal: listItem = NormalListItem()
        case .today: listItem = TodayListItem()
        case .completed: listItem = CompletedListItem(beforeState: beforeState)
        }
        return listItem
    }
}
