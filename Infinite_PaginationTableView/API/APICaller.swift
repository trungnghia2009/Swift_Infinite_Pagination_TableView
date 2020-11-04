//
//  APICaller.swift
//  Infinite_PaginationTableView
//
//  Created by trungnghia on 7/20/20.
//  Copyright © 2020 trungnghia. All rights reserved.
//

import Foundation

class APICaller {
    
    var isPaginating = false
    
    func fetchData(pagination: Bool = false, completion: @escaping( (Result<[String], Error>) -> Void )  ) {
        if pagination {
            isPaginating = true
        }
        DispatchQueue.global().asyncAfter(deadline: .now() +  (pagination ? 3: 2) ) {
            let originalData = [
                "Apple",
                "Google",
                "Facebook",
                "Amazon",
                "Tesla",
                "Snapchat",
                "Twitter",
                "Printest",
                "Tinder",
                "Reddit",
                "TikTok",
                "Apple",
                "Google",
                "Facebook",
                "Amazon",
                "Tesla",
                "Snapchat",
                "Twitter",
                "Printest",
                "Tinder",
                "Reddit",
                "TikTok",
                "Apple",
                "Google",
                "Facebook",
                "Amazon",
                "Tesla",
                "Snapchat",
                "Twitter",
                "Printest",
                "Tinder",
                "Reddit",
                "TikTok"
            ]
            
            let newData = [
                "banana", "oranges", "grapes", "Food"
            ]
            
            completion(.success(pagination ? newData : originalData))
            if pagination {
                self.isPaginating = false
            }
        }
    }
}
