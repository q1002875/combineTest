//
//  TodoListViewModel.swift
//  CombineTest
//
//  Created by Jeff on 2023/3/10.
//
////

import Foundation
import Combine
class DataListViewModel<T: Decodable> {
    private let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
    var cancellables = Set<AnyCancellable>()

    @Published var todos: [T] = []
    @Published var error: Error? = nil

    func fetchDatas() {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [T].self, decoder: JSONDecoder())
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
//這樣，我們就可以在創建 dataListViewModel 時，指定任何實現了 Decodable 協議的型別，例如：
//swift
//Copy code
//let viewModel = TodoListViewModel<User>()
//viewModel.fetchTodos()
//這樣就可以獲取 User 型別的資料，並存儲在 viewModel 的 todos 屬性中。





