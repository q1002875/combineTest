//
//  ViewController.swift
//  CombineTest
//
//  Created by Jeff on 2023/3/8.
//

import UIKit
import Combine
import Foundation


//class ViewController: UIViewController {
//    private let tableView = UITableView()
//    private var cancellables = Set<AnyCancellable>()
//    private var data = [Todo]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // 設置表格
//        tableView.frame = view.bounds
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        view.addSubview(tableView)
//
//
//        // 串接API
//        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
//
//        fetchTodos(from: url) { result in
//            switch result {
//            case .success(let todos):
//                self.data = todos
//                self.tableView.reloadData()
//                print("Fetched \(todos.count) todos")
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
//
//    }
//
//    func fetchTodos(from url: URL, completion: @escaping (Result<[Todo], Error>) -> Void) {
//        URLSession.shared.dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: [Todo].self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { result in
//                switch result {
//                case .finished:
//                    break
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }, receiveValue: { todos in
//                completion(.success(todos))
//            })
//            .store(in: &cancellables)
//    }
//
//}
//
//extension ViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = "Title:\(data[indexPath.row].title)" + "ID:\(data[indexPath.row].id)"
//
//        return cell
//    }
//}
//
//struct Todo: Codable {
//    let userId: Int
//    let id: Int
//    let title: String
//    let completed: Bool
//}





/////////////MVVM


class ViewController: UIViewController {
private let tableView = UITableView()
private let viewModel = TodoListViewModel()

override func viewDidLoad() {
    super.viewDidLoad()
    
    // 設置表格
    tableView.frame = view.bounds
    tableView.dataSource = self
    tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "Cell")
    view.addSubview(tableView)
    
    // 監聽資料有變動就改變
    
    viewModel.$todos
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            self?.tableView.reloadData()
        }
        .store(in: &viewModel.cancellables)
    
    viewModel.$error
        .receive(on: DispatchQueue.main)
        .sink { [weak self] error in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        .store(in: &viewModel.cancellables)
    
    // 獲取資料
    viewModel.fetchTodos()
}
}

extension ViewController: UITableViewDataSource {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.todos.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "Title:\(viewModel.todos[indexPath.row].title)" + "ID:\(viewModel.todos[indexPath.row].id)"
     
    return cell
}
    

    
}
class MyTableViewCell: UITableViewCell {
    // ...
    override func prepareForReuse() {
        super.prepareForReuse()
//        當在 tableView 中重複顯示資料時，通常是因為使用了 dequeueReusableCell(withIdentifier:) 方法而導致的。這個方法是用來從 tableView 的佇列中取出可重複使用的 UITableViewCell，而且當某一個 UITableViewCell 被滾出可視區域時，它會被重新放回佇列中，等待下一次使用。
//        因此，為了避免重複顯示資料，可以在 UITableViewCell 的子類中實作 prepareForReuse 方法，這個方法會在 UITableViewCell 被回收之前被呼叫。在這個方法中，可以重設 UITableViewCell 中的所有屬性，以保證下一次使用時是一個全新的狀態。
        // 重設所有屬性
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
        self.imageView?.image = nil
    }
    // ...
}

//在此範例中，創建了一個 TodoListViewModel，該 ViewModel 負責處理從 API 獲取 Todo 對象列表的業務邏輯。在 ViewController 中，只需要在 ViewDidLoad 方法中創建一個實例，然後設置表格和訂閱 TodoListViewModel 的 $todos 和 $error 屬性即可。
//
//當 TodoListViewModel 中的 todos 屬性更改時，會通過 Combine 的 @Published 屬性發出通知，這將導致 ViewController 的表格
