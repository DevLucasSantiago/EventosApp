//
//  ListEventsViewController.swift
//  EventosApp
//
//  Created by Lucas Santiago on 24/04/21.
//

import UIKit
import SnapKit

class ListEventsViewController: UIViewController {
    
    lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.register(EventCell.self, forCellReuseIdentifier: String(describing: EventCell.self))
        tableView.backgroundView = self.activity
        tableView.tableFooterView = UIView()
        return tableView
    }()

    var viewModel: ListEventsViewModel!
    
    init(viewModel: ListEventsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        self.title = self.viewModel.title
        loadData()
    }
    
    func configureViews() {
        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func loadData() {
        viewModel.loadEvents { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.tableView.reloadData()
                    self.activity.stopAnimating()
                case .failure(let error):
                    print(error)
                    
                    let alert = UIAlertController(title: "Ops, ocorreu um erro", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension ListEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventCell.self), for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
        
        guard let event = self.viewModel.event(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configure(event)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.navigateToDetail(id: indexPath.row)
    }
}

//MARK: - UITableViewDelegate

extension ListEventsViewController: UITableViewDelegate {
    
}
