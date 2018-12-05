//
//  UsersPresenter.swift
//  MVPPattern
//
//  Created by JESUS NIEVES on 05/12/2018.
//  Copyright © 2018 JESUS NIEVES. All rights reserved.
//

import Foundation

class UsersPresenter: NSObject {

    private let getUserService: GetUsers
    weak private var usersView: UsersView?

    init(getUserService: GetUsers) {
        self.getUserService = getUserService
    }

    func attachView(view: UsersView) {
        self.usersView = view
    }

    func detachView() {
        usersView = nil
    }

    func getUsersList() {
        usersView?.startLoading()
        getUserService.execute(
            onSuccess: { (pagedUsers: PagedUsers) in
                self.usersView?.stopLoading()
                self.usersView?.showData(pagedUsers.data)
            },
            onError: { (error: Error) in
               print(error)
            }
        )
    }

}
