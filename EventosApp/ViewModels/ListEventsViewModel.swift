//
//  ListEventsViewModel.swift
//  EventosApp
//
//  Created by Lucas Santiago on 24/04/21.
//

import Foundation

protocol ListEventCoordinatorDelegate: AnyObject {
    func startDetail(event: Event)
}

class ListEventsViewModel {
    
    private let service: ListEventServiceProtocol
    private var eventos: [Event] = []
    weak var coordinatorDelegate: ListEventCoordinatorDelegate?
    
    var numberOfRows: Int {
        return self.eventos.count
    }
    
    var title: String {
        return "Lista de eventos"
    }

    init(service: ListEventServiceProtocol) {
        self.service = service
    }
    
    func event(at index: Int) -> Event? {
        if self.eventos.indices.contains(index) {
            return self.eventos[index]
        }
        return nil
    }
    
    func loadEvents(_ completion: @escaping (Result<[Event],ListEventServiceError>) -> Void) {
        service.fetchContacts { (result) in
            if case .success(let eventos) = result {
                self.eventos = eventos
            }
            completion(result)
        }
    }
    
    func navigateToDetail(id: Int) {
        if let evento = event(at: id) {
            coordinatorDelegate?.startDetail(event: evento)
        }
    }
}
