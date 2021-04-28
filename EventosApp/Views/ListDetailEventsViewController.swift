//
//  DetailEventViewController.swift
//  EventosApp
//
//  Created by Lucas Santiago on 25/04/21.
//

import UIKit

class ListDetailEventsViewController: UIViewController {
    
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
        tableView.register(DetailEventCell.self, forCellReuseIdentifier: String(describing: DetailEventCell.self))
        tableView.backgroundView = self.activity
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        return tableView
    }()
    
    var viewModel: ListDetailEventsViewModel!
    
    init(viewModel: ListDetailEventsViewModel) {
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
        self.activity.stopAnimating()
    }
}

//MARK: - DetailEventCellDelegate

extension ListDetailEventsViewController: DetailEventCellDelegate {
    func checkIn(eventId: String?, name: String?, email: String?) {
        viewModel.checkIn(eventId: eventId, name: name, email: email)
    }
    
    func share(share: Event?) {
        let items: [Any] = [share?.title, URL(string: share?.image ?? "")]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}

//MARK: - UITableViewDelegate

extension ListDetailEventsViewController: UITableViewDelegate {
}

//MARK: - UITableViewDataSource

extension ListDetailEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailEventCell.self), for: indexPath) as? DetailEventCell else {
            return UITableViewCell()
        }
        
        guard let contact = self.viewModel.event(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configure(contact)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - ListDetailEventsViewDelegate

extension ListDetailEventsViewController: ListDetailEventsViewDelegate {
    func showError(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Erro", message: "Deu erro", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func showSuccess() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Sucesso", message: "Check-in confirmado", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
