//
//  UserModel.swift
//  MVPPattern
//
//  Created by JESUS NIEVES on 05/12/2018.
//  Copyright © 2018 JESUS NIEVES. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    let userID: Int
    let firstName: String
    let lastName: String
    let avatar: String

    private enum CodingKeys: String, CodingKey {
        case userID = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}

/*
 Aqui establecemos el modelo a usar en la consulta al servicio,
 el cual se compone de la paginacion y del array de usuarios.
 */
struct PagedUsers: Codable {
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data: [UserModel]

    /*
    Especificamos las llaves de los campos en el JSON a nuestros objetos personalizados,
    solo los que tengan un nombre diferente al objeto, como en el caso de totalPages, su indice es total_pages
    */
    private enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data
    }
}
