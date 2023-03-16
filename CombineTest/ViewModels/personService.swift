//
//  personService.swift
//  CombineTest
//
//  Created by Jeff on 2023/3/16.
//
import Foundation
import Combine

struct Person {
    let name: String
    let age: Int
}

//訂閱以及推送可以用來傳遞給不同頁面
class PersonService {
    static let shared = PersonService()
    
    private let personSubject = PassthroughSubject<Person, Never>()
    
    func publish(person: Person) {
        personSubject.send(person)
    }
    
    func subscribe() -> AnyPublisher<Person, Never> {
        return personSubject.eraseToAnyPublisher()
    }
}
