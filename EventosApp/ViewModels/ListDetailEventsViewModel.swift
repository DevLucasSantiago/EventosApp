//
//  ListDetailEventsViewModel.swift
//  EventosApp
//
//  Created by Lucas Santiago on 25/04/21.
//

import Foundation

protocol ListDetailEventsViewDelegate: AnyObject {
    func showStringError(text: String)
    func showError(error: Error)
    func showSuccess()
}

class ListDetailEventsViewModel {
    
    private var detailEvents: [Event] = []
    weak var viewDelegate: ListDetailEventsViewDelegate?
    private let service: ListEventServiceProtocol
    
    var numberOfRows: Int {
        return self.detailEvents.count
    }
    
    init(event: Event, service: ListEventServiceProtocol) {
        self.detailEvents.append(event)
        self.service = service
    }
    
    func event(at index: Int) -> Event? {
        if self.detailEvents.indices.contains(index) {
            return self.detailEvents[index]
        }
        return nil
    }
    
    func checkIn(eventId: String?, name: String?, email: String?){
        guard let eventId = eventId, let name = name, let email = email else {
            return
        }
        if name.isEmpty, email.isEmpty {
            self.viewDelegate?.showStringError(text: "Nome e/ou E-mail em branco")
            return
        } else if !email.isValidEmail() {
            self.viewDelegate?.showStringError(text: "E-mail invalido")
            return
        }
        let checkIn = CheckIn(eventId: eventId, name: name, email: email)
        service.postCheckIn(checkIn){ result in
            switch result{
            case .success:
                self.viewDelegate?.showSuccess()
            case .failure(let error):
                self.viewDelegate?.showError(error: error)
            }
        }
    }
}
