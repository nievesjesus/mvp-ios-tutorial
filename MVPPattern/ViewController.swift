//
//  ViewController.swift
//  MVPPattern
//
//  Created by JESUS NIEVES on 05/12/2018.
//  Copyright © 2018 JESUS NIEVES. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var viewProgress: UIActivityIndicatorView!
    private var tbView: UITableView!
    private var users = [UserModel]()
    private var presenter = UsersPresenter(getUserService: GetUsers())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.presenter.attachView(view: self)
        self.presenter.getUsersList()
    }

}

extension ViewController {

    func setupView() {
        self.setupTableView()
        self.setupProgressView()

    }

    func setupProgressView() {
        self.viewProgress = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        self.viewProgress.center = self.view.center
        self.viewProgress.isHidden = true
        self.view.addSubview(self.viewProgress)
    }

    func setupTableView() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        self.tbView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        self.tbView.dataSource = self
        self.view.addSubview(self.tbView)
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "identifier")
        let user = users[indexPath.row]
        cell.textLabel?.text = user.firstName + " " + user.lastName
        return cell
    }

}

extension ViewController: UsersView {

    func startLoading() {
        viewProgress.startAnimating()
        viewProgress.isHidden = false
    }

    func stopLoading() {
        viewProgress.stopAnimating()
        viewProgress.isHidden = true
    }

    func showData(_ users: [UserModel]) {
        self.users = users
        self.tbView.reloadData()
    }

}
