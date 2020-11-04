//
//  ViewController.swift
//  Infinite_PaginationTableView
//
//  Created by trungnghia on 7/20/20.
//  Copyright © 2020 trungnghia. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ViewController: UIViewController {

    // MARK: - Properties
    private var data = [String]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    private let apiCaller = APICaller()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews...")
        tableView.frame = view.bounds
        
        apiCaller.fetchData(pagination: false) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.data.append(contentsOf: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    
    // MARK: - Helpers
    private func configureNavigationBar() {
        navigationItem.title = "Pagination"
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: view.frame.size.width,
                                              height: 100))
        let spinner = UIActivityIndicatorView()
        footerView.addSubview(spinner)
        spinner.center = footerView.center
        spinner.startAnimating()
        return footerView
    }
    
    
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 10 - scrollView.frame.size.height) {
            guard !apiCaller.isPaginating else {
                // We are already fetching more data
                return
            }
            print("Fetch more data")
            tableView.tableFooterView = createSpinnerFooter()
            apiCaller.fetchData(pagination: true) { [unowned self] (result) in
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                }
                switch result {
                    
                case .success(let moreData):
                    self.data.append(contentsOf: moreData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
}

