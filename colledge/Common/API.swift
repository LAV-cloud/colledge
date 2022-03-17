//
//  API.swift
//  colledge
//
//  Created by Ромка Бережной on 16.03.2022.
//

import SwiftUI
import Alamofire

let api = API(
    host: "https://api.collegeschedule.ru:2096",
    token: "f14eed27-87ec-42e3-981f-a21c575fd85e"
)

protocol ApiProtocol {
    var host: String { get }
    var token: String { get }
    
    func getTeachers(completion: @escaping([Teacher]?) -> Void) -> Void
    func getGroups(completion: @escaping([Group]?) -> Void) -> Void
    func getSchedule(year: Int, week: Int, type: ScheduleType, id: Int, completion: @escaping([ScheduleItem]?) -> Void) -> Void
    func getNews(completion: @escaping([News]?) -> Void) -> Void
    func getAnnoncement(completion: @escaping([Annoncement]?) -> Void) -> Void
    
    func performRequest(
        url: String,
        method: HTTPMethod,
        params: Dictionary<String, Any>,
        headers: HTTPHeaders,
        encoding: ParameterEncoding
    ) -> DataRequest
}

class API: ApiProtocol {
    
    var host: String
    var token:String
    
    init(host: String, token: String) {
        self.host = host
        self.token = token
    }
    
    func getGroups(completion: @escaping([Group]?) -> Void) -> Void {
        let parameters: Dictionary<String, Any> = [
            "offset": 0,
            "limit": 1000
        ]
        let headers: HTTPHeaders = HTTPHeaders(arrayLiteral:
                                                HTTPHeader(name: "Content-Type", value: "application/json"),
                                               HTTPHeader(name: "accessToken", value: self.token)
        )
        performRequest(
            url: "group",
            params: parameters,
            headers: headers,
            encoding: URLEncoding.queryString
        ).responseDecodable(of: ResponseGroups.self) {
            switch $0.result {
            case .success:
                completion($0.value!.data.items)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func getTeachers(completion: @escaping([Teacher]?) -> Void) -> Void {
        let parameters: Dictionary<String, Any> = [
            "offset": 0,
            "limit": 1000,
            "scope": "teacher"
        ]
        let headers: HTTPHeaders = HTTPHeaders(arrayLiteral:
                                                HTTPHeader(name: "Content-Type", value: "application/json"),
                                               HTTPHeader(name: "accessToken", value: self.token)
        )
        performRequest(
            url: "account",
            params: parameters,
            headers: headers,
            encoding: URLEncoding.queryString
        ).responseDecodable(of: ResponseTeachers.self) {
            switch $0.result {
            case .success:
                completion($0.value!.data.items)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func getSchedule(year: Int, week: Int, type: ScheduleType, id: Int, completion: @escaping([ScheduleItem]?) -> Void) -> Void {
        let headers: HTTPHeaders = HTTPHeaders(arrayLiteral:
                                                HTTPHeader(name: "Content-Type", value: "application/json"),
                                               HTTPHeader(name: "accessToken", value: self.token)
        )
        performRequest(
            url: "schedule/subject/\(year)/\(week)",
            params: ["\(type == .teacher ? "accountId" : "groupId")": id],
            headers: headers,
            encoding: URLEncoding.queryString
        ).responseDecodable(of: ResponseSchedule.self) {
            switch $0.result {
            case .success:
                completion($0.value!.data.items)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func getNews(completion: @escaping([News]?) -> Void) -> Void {
        let parameters: Dictionary<String, Any> = [
            "offset": 0,
            "limit": 1000
        ]
        let headers: HTTPHeaders = HTTPHeaders(arrayLiteral:
                                                HTTPHeader(name: "Content-Type", value: "application/json"),
                                               HTTPHeader(name: "accessToken", value: self.token)
        )
        performRequest(
            url: "news",
            params: parameters,
            headers: headers,
            encoding: URLEncoding.queryString
        ).responseDecodable(of: ResponseNews.self) {
            switch $0.result {
            case .success:
                completion($0.value!.data.items)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func getAnnoncement(completion: @escaping([Annoncement]?) -> Void) -> Void {
        let parameters: Dictionary<String, Any> = [
            "offset": 0,
            "limit": 1000
        ]
        let headers: HTTPHeaders = HTTPHeaders(arrayLiteral:
                                                HTTPHeader(name: "Content-Type", value: "application/json"),
                                               HTTPHeader(name: "accessToken", value: self.token)
        )
        performRequest(
            url: "announcement",
            params: parameters,
            headers: headers,
            encoding: URLEncoding.queryString
        ).responseDecodable(of: ResponseAnnoncement.self) {
            switch $0.result {
            case .success:
                completion($0.value!.data.items)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func performRequest(
        url: String,
        method: HTTPMethod = .get,
        params: Dictionary<String, Any> = [:],
        headers: HTTPHeaders = [:],
        encoding: ParameterEncoding = URLEncoding.default
    ) -> DataRequest {
        return AF.request(
            "\(host)/\(url)",
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headers
        )
    }
}

struct ResponseAnnoncement: Codable {
    var status: Bool
    var data: ResponseDataAnnoncement
}

struct ResponseDataAnnoncement: Codable {
    var meta: ResponseMeta
    var items: [Annoncement]
}

struct Annoncement: Codable {
    var id: Int
    var institutionId: Int
    var content: String
    var createdAt: Int
}

struct ResponseNews: Codable {
    var status: Bool
    var data: ResponseDataNews
}

struct ResponseDataNews: Codable {
    var meta: ResponseMeta
    var items: [News]
}

struct News: Codable {
    var id: Int
    var name: String
    var institutionId: Int
    var short: String
    var content: String
    var createdAt: Int
}

struct ResponseTeachers: Codable {
    var status: Bool
    var data: ResponseDataTeachers
}

struct ResponseDataTeachers: Codable {
    var meta: ResponseMeta
    var items: [Teacher]
}

struct ResponseGroups: Codable {
    var status: Bool
    var data: ResponseDataGroups
}

struct ResponseDataGroups: Codable {
    var meta: ResponseMeta
    var items: [Group]
}

struct ResponseSchedule: Codable {
    var status: Bool
    var data: ResponseDataSchedule
}

struct ResponseDataSchedule: Codable {
    var meta: ResponseScheduleMeta
    var items: [ScheduleItem]
}

struct ResponseScheduleMeta: Codable {
    var count: Int
    var breakTime: Int
    var lastUpdateTime: Int
}

struct ResponseMeta: Codable {
    var count: Int
    var totalCount: Int
}

struct Teacher: Codable {
    var id: Int
    var firstName: String
    var secondName: String
    var thirdName: String
    
    init(id: Int, firstName: String, secondName: String, thirdName: String) {
        self.id = id
        self.firstName = firstName
        self.secondName = secondName
        self.thirdName = thirdName
    }
    
    var print: String {
        return "\(self.secondName) \(self.firstName[self.firstName.startIndex]).\(self.thirdName[self.thirdName.startIndex])."
    }
}

struct Group: Codable {
    var id: Int
    var name: Int
    var educationLevel: String
    var course: Int
    var startYear: Int
    var commercial: Bool
    var specialtyId: Int
    var print: String
}

struct ScheduleItem: Codable {
    var id: Int
    var day: Int
    var sort: Int
    var time: Time
    var teacher: Teacher
    var subject: Subject
    var classroom: Classroom
    var group: ScheduleGroup
}

struct Classroom: Codable {
    var id: Int
    var floor: Int
    var name: String
}

struct Time: Codable {
    var start: Int
    var length: Int
    
    init(start: Int, lenght: Int) {
        self.start = start
        self.length = lenght
    }
    
    var end: Int {
        return self.start + self.length
    }
    
    func convertToTime(number: Int) -> String {
        let hours = number / 60
        let minute = number - (hours * 60)
        return "\(hours):\(minute > 9 ? "\(minute)" : "0\(minute)" )"
    }
    
    func getStart() -> String {
        return convertToTime(number: self.start)
    }
    
    func getEnd() -> String {
        return convertToTime(number: self.end)
    }
}

struct Subject: Codable {
    var id: Int
    var name: String
}

struct ScheduleGroup: Codable {
    var id: Int
    var name: Int
    var print: String
}
