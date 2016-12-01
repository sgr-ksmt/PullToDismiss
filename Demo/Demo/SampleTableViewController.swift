//
//  SampleTableViewController.swift
//  PullToDismiss
//
//  Created by Suguru Kishimoto on 11/13/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import UIKit
import PullToDismiss

class SampleTableViewController: UITableViewController {

    private lazy var dataSource: [String] = { () -> [String] in
        return (0..<100).map { "Item : \($0)" }
    }()
    
    private var pullToDismiss: PullToDismiss?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        let button = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismiss(_:)))
        navigationItem.rightBarButtonItem = button
        navigationItem.title = "Sample Table View"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.setValue(UIBarPosition.topAttached.rawValue, forKey: "barPosition")
        pullToDismiss = PullToDismiss(scrollView: tableView)
        Config.shared.adaptSetting(pullToDismiss: pullToDismiss)
        pullToDismiss?.dismissAction = { [weak self] in
            self?.dismiss(nil)
        }
        pullToDismiss?.delegateProxy = self
    }
    
    var disissBlock: (() -> Void)?

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    @objc func dismiss(_: AnyObject?) {
        dismiss(animated: true) { [weak self] in
            self?.disissBlock?()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "test", message: "\(indexPath.section)-\(indexPath.row) touch!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil) 
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("\(scrollView.contentOffset.y)")
    }
    
}
