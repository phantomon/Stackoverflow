//
//  WebService.swift
//  MyTableView
//
//  Created by admin on 8/24/16.
//  Copyright © 2016 Edder Nunez. All rights reserved.
//

import UIKit

class CongressClass:NSObject {
    let name: String
    let lastName: String
    let title: String
    let party: String
    let position: String
    let bioID: String
    
    init(name: String, lastName: String, title: String, party: String, position: String, bioID: String) {
        self.name = name
        self.lastName = lastName
        self.title = title
        self.party = party
        self.position = position
        self.bioID = bioID
        
    }
}

class WebServiceManager: NSObject {
    
    private let apiURL = "https://congress.api.sunlightfoundation.com/legislators?apikey=1f4393dfee044bb18bb580ef0beb9437&fields=bioguide_id,first_name,last_name,state,title,party&per_page=50&page="
    
    //API Array
    var legislatorArray = [CongressClass]()
    private var session:NSURLSession!
    
    //Singleton
    static let sharedInstance : WebServiceManager = WebServiceManager()
    private override init(){
        super.init()
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: sessionConfig)
    }
    
    //get legislators
    func getLegislators (completion:()->Void) {
        
        //Calling url
        if let jsonData = NSURL(string: apiURL) {
            
            // Requesting url
            let task = session.dataTaskWithURL(jsonData) {(data, response, error) -> Void in
                //Check for errors
                if let error = error {print(error)
                } else {
                    if let http = response as? NSHTTPURLResponse {
                        if http.statusCode == 200 {
                            
                            //Getting data
                            if let data = data {
                                
                                do {
                                    
                                    let legislatorData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                                   
                                    //Get API data
                                    if let getData = legislatorData as? [NSObject:AnyObject],
                                        findObject = getData["results"] as? [AnyObject]{
                                        
                                        //Return data
                                        for cellFound in findObject{
                                            if let nextCell = cellFound as? [String:AnyObject],
                                                
                                                name = nextCell["first_name"] as? String,
                                                lastName = nextCell["last_name"] as? String,
                                                title = nextCell["title"] as? String,
                                                partyRep = nextCell["party"] as? String,
                                                position = nextCell ["title"] as? String,
                                                id = nextCell ["bioguide_id"] as? String
                                                
                                            {
                                                
                                                //Add data to array
                                                let addData = CongressClass(name: name, lastName: lastName, title: title, party: partyRep, position: position, bioID: id)
                                                self.legislatorArray.append(addData)
                                            }
                                        }//end cellFound
                                        
                                        //Adding data to table
                                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                            completion()
                                        }
                                    }
                                }
                                    
                                    //end do
                                catch {print(error)}
                                
                            }//end data
                            
                        }//end statusCode
                        
                    }//end http
                    
                }//else
                
            }//end task
            
            //Run code
            task.resume()
            
        }//end jsonData
        
        
    }
}