//
//  Storage.swift
//  colledge
//
//  Created by Ромка Бережной on 17.03.2022.
//

import SwiftUI

let storage = Storage()

protocol StorageProtocol {
    func save<T: Codable>(sourceData: T, completion: @escaping(Data?) -> Void) -> Void
    func load<T: Codable>(sourceData: Data, completion: @escaping(T?) -> Void) -> Void
}

class Storage: StorageProtocol {
    func save<T: Codable>(sourceData: T, completion: @escaping(Data?) -> Void) -> Void {
        do {
            let data = try JSONEncoder().encode(sourceData)
            completion(data)
        } catch let error {
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    func load<T: Codable>(sourceData: Data, completion: @escaping(T?) -> Void) -> Void {
        do {
            let data = try JSONDecoder().decode(T.self, from: sourceData)
            completion(data)
        } catch let error {
            print (error.localizedDescription)
            completion(nil)
        }
    }
}
