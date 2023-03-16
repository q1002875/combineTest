//
//  ViewController.swift
//  CombineTest
//
//  Created by Jeff on 2023/3/8.
//

import UIKit
import Combine
import Foundation

let dataSubject = PassthroughSubject<String, Never>()

/////////////MVVM
///
///
///
class ViewController: UIViewController{
private let tableView = UITableView()
private let viewModel = DataListViewModel<Todo>()
private var cancellable: AnyCancellable?
override func viewDidLoad() {
    super.viewDidLoad()
    
    subjectData()
    tableView.frame = view.bounds
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "Cell")
    view.addSubview(tableView)
    
    // 監聽資料有變動就改變
    
    viewModel.$price
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            //sink返回值會有強循環 用weak解掉
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
    self.viewModel.fetchDatas()
    loopCommand()
}
    
    func loopCommand(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.viewModel.fetchDatas()
            self.loopCommand()
        }
    }
    
    func subjectData(){
        cancellable = dataSubject
            .receive(on: RunLoop.main)
            .sink {[weak self] data in
                self?.updateUI(data: data)
            }
    }
    private func updateUI(data: String) {
            // 更新UI
        print(data)
        }
}

extension ViewController: UITableViewDataSource ,UITableViewDelegate{
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Todo.Currency.allCases.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//    cell.textLabel?.text = "name:\(viewModel.todos[indexPath.row].name)" + "Gender:\(viewModel.todos[indexPath.row].gender)"
    let currency = Todo.Currency.allCases[indexPath.row]
    
    var price: Double = 0.0
            
            switch currency {
            case .usd:
                price = viewModel.price?.USD ?? 0
            case .jpy:
                price = viewModel.price?.JPY ?? 0
            case .eur:
                price = viewModel.price?.EUR ?? 0
            }
            
            cell.textLabel?.text = "\(currency.rawValue): \(price)"
            return cell
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("sss")
        dataSubject.send("Hello World")
        navigationController?.pushViewController(SecondViewController(), animated: true)
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
class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        // 發送一個事件到全域的 PublishSubject
        dataSubject.send("Hello World")
    }
}
