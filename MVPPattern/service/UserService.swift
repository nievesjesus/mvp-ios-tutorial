//
//  UserService.swift
//  MVPPattern
//
//  Created by JESUS NIEVES on 05/12/2018.
//  Copyright © 2018 JESUS NIEVES. All rights reserved.
//

import Foundation

struct GetUsers: RequestType {
    typealias ResponseType = PagedUsers
    var data: RequestData {
        return RequestData(path: "https://reqres.in/api/users?page=1")
    }
}
