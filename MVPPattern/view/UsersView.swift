//
//  UsersView.swift
//  MVPPattern
//
//  Created by JESUS NIEVES on 05/12/2018.
//  Copyright © 2018 JESUS NIEVES. All rights reserved.
//

import Foundation

protocol UsersView: NSObjectProtocol {
    func startLoading()
    func stopLoading()
    func showData(_ users: [UserModel])
}
