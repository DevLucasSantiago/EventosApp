//
//  ListEventServiceTests.swift
//  EventosAppTests
//
//  Created by Lucas Santiago on 27/04/21.
//

import XCTest
@testable import EventosApp

class ListEventServiceTests: XCTestCase {

    var sut: ListEventServiceProtocol?

    override func setUp() {

    }

    override func tearDown() {

    }

    func testLoadEvents(){
        let viewModel = ListEventsViewModel(service: ListEventServiceSucessMock())
        viewModel.loadEvents { (result) in
            switch result {
            case .success(let eventos):
                XCTAssertEqual(eventos.first?.date, eventos.first?.date)
                XCTAssertEqual(eventos.first?.description, "O Patas")
                XCTAssertEqual(eventos.first?.image, "http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png")
                XCTAssertEqual(eventos.first?.longitude, -51.2146267)
                XCTAssertEqual(eventos.first?.latitude, -30.0392981)
                XCTAssertEqual(eventos.first?.price, 29.99)
                XCTAssertEqual(eventos.first?.title, "Feira de adoção de animais na Redenção")
                XCTAssertEqual(eventos.first?.id, "1")
            case .failure(_):
                XCTFail("O teste falhou")
            }
        }
    }

    func testLoadEventsError(){
        let viewModel = ListEventsViewModel(service: ListEventServiceFailureMock())
        viewModel.loadEvents { (result) in
            switch result {
            case .success(_):
                XCTFail("O teste falhou")
            case .failure(let error):
                XCTAssertEqual(error, .badURL)
            }
        }
    }

    func test_empty_data(){
        let session = URLSessionMock(data: nil, response: URLResponse(), error: nil)

        let service = ListEventService(url: "any-url", session: session)

        let exp = expectation(description: "sei la")

        service.fetchEvents { (result) in
            switch result {
            case .success(_ ):
                XCTFail()
                exp.fulfill()
                return
            case .failure(let error):
                XCTAssertEqual(error, .emptyData)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func test_error_not_nil(){

        let session = URLSessionMock(data: Data(), response: URLResponse(), error: ListEventServiceError.emptyData)

        let service = ListEventService(url: "any-url", session: session)

        let exp = expectation(description: "sei la")

        service.fetchEvents { (result) in
            switch result {
            case .success(_ ):
                XCTFail()
                exp.fulfill()
                return
            case .failure(let error):
                XCTAssertEqual(error, .serverError)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func test_parse_error(){
        let json = "meu json".data(using: .utf8)
        let session = URLSessionMock(data: json, response: URLResponse(), error: nil)

        let service = ListEventService(url: "any-url", session: session)

        let exp = expectation(description: "sei la")

        service.fetchEvents { (result) in
            switch result {
            case .success(_ ):
                XCTFail()
                exp.fulfill()
                return
            case .failure(let error):
                XCTAssertEqual(error, .parseError)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }



    func test_success(){
        let session = URLSessionMock(data: mockData, response: URLResponse(), error: nil)

        let service = ListEventService(url: "any-url", session: session)

        let exp = expectation(description: "sei la")

        let mockEvent = Event(date: 1534784400, description: "O Patas", image: "http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png", longitude: -51.2146267, latitude: -30.0392981, price: 29.99, title: "Feira de adoção de animais na Redenção", id: "1")

        service.fetchEvents { (result) in
            switch result {
            case .success(let events):
                XCTAssertEqual(events[0],mockEvent)
                XCTAssertEqual(events.count,1)
                exp.fulfill()
                return
            case .failure:
                XCTFail()
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}

typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

class URLSessionMock: URLSession {

    var data: Data?
    var response: URLResponse?
    var error: Error?

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskMock(data: data, response: response, error: error, completion: completionHandler)
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {

    var dataMock: Data?
    var responseMock: URLResponse?
    var errorMock: Error?
    var completion: (Data?, URLResponse?, Error?) -> Void

    init(data: Data?, response: URLResponse?, error: Error?, completion: @escaping CompletionHandler) {
        self.dataMock = data
        self.responseMock = response
        self.errorMock = error
        self.completion = completion
    }

    override func resume() {
        self.completion(self.dataMock, self.responseMock, self.errorMock)
    }
}

var mockData: Data? {
    """
    [{
    "date":1534784400,
    "description":"O Patas",
    "image":"http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png",
    "longitude":-51.2146267,
    "latitude":-30.0392981,
    "price":29.99,
    "title":"Feira de adoção de animais na Redenção",
    "id":"1"
    }]
    """.data(using: .utf8)
}

class ListEventServiceSucessMock: ListEventServiceProtocol {
    func postCheckIn(_ checkIn: CheckIn, completion: @escaping (Result<CheckIn, ListEventServiceError>) -> Void) {
        completion(.success(checkIn))
    }
    
    func fetchEvents(completion: @escaping (Result<[Event], ListEventServiceError>) -> Void) {
        if let data = mockData, let model = try? JSONDecoder().decode([Event].self, from: data) as [Event] {
            completion(.success(model))
            return
        }
        completion(.failure(.parseError))
    }
}

class ListEventServiceFailureMock: ListEventServiceProtocol {
    func postCheckIn(_ checkIn: CheckIn, completion: @escaping (Result<CheckIn, ListEventServiceError>) -> Void) {
        completion(.failure(.badURL))
    }
    
    func fetchEvents(completion: @escaping (Result<[Event], ListEventServiceError>) -> Void) {
        completion(.failure(.badURL))
    }
}

