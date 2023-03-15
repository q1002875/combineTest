//
//  TodoListViewModel.swift
//  CombineTest
//
//  Created by Jeff on 2023/3/10.
//
////
import Foundation
import Combine
class TodoListViewModel {
private let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
    var cancellables = Set<AnyCancellable>()

@Published var todos: [Todo] = []
@Published var error: Error? = nil

func fetchTodos() {
    URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: [Todo].self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error
            }
        }, receiveValue: { todos in
            self.todos = todos
        })
        .store(in: &cancellables)
}
    
    
}
