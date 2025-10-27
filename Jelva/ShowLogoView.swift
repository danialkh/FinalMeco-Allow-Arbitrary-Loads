//
//  SignInView.swift
//  AR-VideoPlayer
//
//  Created by MacBook Pro on 8/26/23.
//


import UIKit
import ARKit
import SwiftUI


class ShowLogoView: UIViewController {
    
//    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let imageView = UIImageView()
    
//    let companyId = "64e05a8cca250804d7232147" //arabe
//    let companyId = "60efe1036a8e05066f8fcdb1" //kale
    let companyId = "65338c6085ff6330936e7593" //mapna
    
    
    
    
    var isDownloading = false
    var alert: UIAlertController?
    
    var targetUrls = [String]()
    var targetIds = [String]()
    var trackerUrls = [String]()
    
    var checkTargetIds = [String]()
    var checkTrackerUrls = [String]()
    var checkTargetUrls = [String]()
    
    
//    let companyId = "60efe1036a8e05066f8fcdb1"
    
    
    var number = ""
    var bearerToken = ""
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI elements or other configurations if needed
    
//
//        imageView.contentMode = .scaleAspectFit
//        imageView.layer.masksToBounds = false
//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowOpacity = 0.5
//        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
//        imageView.layer.shadowRadius = 4
//        imageView.layer.borderColor = UIColor.white.cgColor
//        imageView.translatesAutoresizingMaskIntoConstraints = false
////
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white.withAlphaComponent(1)
        containerView.layer.cornerRadius = 40
        containerView.layer.masksToBounds = true

        let padding: CGFloat = 10

        containerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding).isActive = true
//
//        containerView.layer.shadowColor = UIColor.black.cgColor
//        containerView.layer.shadowOpacity = 0.5
//        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        containerView.layer.shadowRadius = 4
//        containerView.layer.borderWidth = 2
//        containerView.layer.borderColor = UIColor.white.cgColor

        view.addSubview(containerView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGesture)

        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 200),
            containerView.heightAnchor.constraint(equalToConstant: 200),
        ])


        
        func animateImageView() {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse, .repeat], animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }) { (_) in
                self.imageView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                animateImageView()
            }
        }

        func animateLightingEffect() {
//            UIView.animate(withDuration: 2.0, delay: 0.0, options: [.autoreverse, .repeat], animations: {
//                self.imageView.layer.shadowOpacity = 0.0
//            }) { (_) in
//                self.imageView.layer.shadowOpacity = 0.5
//                animateLightingEffect()
//            }
        }
        
        animateImageView()
        animateLightingEffect()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        

        
//        // Add a tap gesture recognizer to the image view
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(tapGesture)
//
        
        // Add constraints to center the image view
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        
        
        showLogo()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        
        let logoImage = UIImageView(image: UIImage(named: "logo"))
        logoImage.contentMode = .scaleAspectFit
        logoImage.frame = CGRect(x: 0, y: 0, width: 160, height: 80)
        logoImage.center = CGPoint(x: view.frame.width / 2, y: view.frame.height - 50)
        view.addSubview(logoImage)
        
        
        
    
        if let targetIds = UserDefaults.standard.array(forKey: "targetIds") as? [String] {
            // Assign the array to the global variable
            self.targetIds = targetIds
        }
    
        if let targetUrls = UserDefaults.standard.array(forKey: "targetUrls") as? [String] {
            // Assign the array to the global variable
            self.targetUrls = targetUrls
        }
    
        if let trackerUrls = UserDefaults.standard.array(forKey: "trackerUrls") as? [String] {
            // Assign the array to the global variable
            self.trackerUrls = trackerUrls
        }
        
        
        
        
        print("targetIds")
        print(targetIds)
        
        print("trackerUrls")
        print(trackerUrls)
        
        print("targetUrls")
        print(targetUrls)
        
        
        
        var fileFounded = false
        
        
        print("inji")
        
        print(self.targetIds)
    
        for targetId in self.targetIds{
            
            if UserDefaults.standard.string(forKey: targetId) != nil {
                
                let targetSavedPath = UserDefaults.standard.string(forKey: targetId)!
                let url = URL(fileURLWithPath: targetSavedPath)

                let filePath = url.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    fileFounded = true
                    print("FILE Founded")
                } else {
                    print("FILE NOT AVAILABLE")
                }
                
            }
            
        }
        
        
        
    
        
        
        
        if(fileFounded){
            checkCahnges()
        }
        else{
            getTargets()
        }
        
        
        
    
    
        
        
    }
    
    
    // Function to run when the image view is tapped
    @objc func imageViewTapped() {
        // Add your code here to run when the image view is tapped
        print("Image view tapped!")
        DispatchQueue.main.async {
        //alert:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewControllerSTD") as! ViewController
            newViewController.bearerToken = self.bearerToken
            
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    private func checkCahnges(){
    
        self.checkTargetUrls = []
        self.checkTargetIds = []
        self.checkTrackerUrls = []
        
        if(self.bearerToken != ""){
            
            print("bearerToken:" + self.bearerToken)
            let globUrl = "http://94.101.184.60:6060/"
            let strUrl = globUrl + "api/AdsElement/" + self.companyId + "?os=ios"

            
            let url = URL(string: strUrl)!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            
            
            // Add the bearer token to the Authorization header
            request.setValue("Bearer \(self.bearerToken)", forHTTPHeaderField: "Authorization")
            
            // Set the parameters in the body of the request
            let parameters = ["os": "ios"]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            request.httpBody = httpBody
            


            let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                guard
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil


                else {                                                               // check for fundamental networking error
                    print("error", error ?? URLError(.badServerResponse))
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }

                // do whatever you want with the `data`, e.g.:

                if let responseString = String(data: data, encoding: .utf8) {
//                    print("responseString = \(responseString)")
                    
                    guard let jsonData = responseString.data(using: .utf8) else {
                        return
                    }

                    do {
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            let success = json["success"] as? Bool ?? false
                            let result = json["result"] as? String ?? ""
                            // Do something with the success and result values
                            
                            if(success){
                                
                                if let result = json["result"] as? [[String: Any]] {
                                    // Loop through each object in the "result" array
                                    for object in result {
                                        // Check if the "_id" key matches the desired id
                                        if let ARItems = object["ARItems"] as? [[String: Any]]{
                                            
//                                            print("ARItems2")
//                                            print(ARItems)
                                            for ARItem in ARItems {
                                                
                                                if let targetId = ARItem["_id"] as? String{
                                                    
//                                                    print("target")
//                                                    print(target)
                                                    self.checkTargetIds.append(targetId)
                                                    
                                                }
                                                
                                                
                                                if let tracker = ARItem["data"] as? [String: Any]{
                                                    
//                                                    print("target")
//                                                    print(target)
                                                    
                                                    
                                                    if let address = tracker["address"] as? String {
//                                                        print("address")
//                                                        print(address)
                                                        
                                                        self.checkTrackerUrls.append(address)
                                                    }
                                                    
                                                }
                                                
                                                
                                                if let target = ARItem["target"] as? [String: Any]{
                                                    
//                                                    print("target")
//                                                    print(target)
                                                    
                                                    
                                                    if let address = target["address"] as? String {
//                                                        print("address")
//                                                        print(address)
                                                        
                                                        self.checkTargetUrls.append(address)
                                                    }
                                                    
                                                }
                                            }
                                            
                                            
                                        }
                                    
                                    }
                                    
                                    print("targetUrls")
                                    print(self.targetUrls)
                                    
                                    print("trackerUrls")
                                    print(self.trackerUrls)
                                    
                                    print("targetIds")
                                    print(self.targetIds)
                                    
                                    if self.targetUrls != self.checkTargetUrls || self.targetIds != self.checkTargetIds || self.trackerUrls != self.checkTrackerUrls {


//                                        UserDefaults.standard.removeObject(forKey: "trackerUrls")
//                                        UserDefaults.standard.removeObject(forKey: "targetUrls")
//                                        UserDefaults.standard.removeObject(forKey: "targetIds")
//                                        self.targetUrls = []
//                                        self.targetIds = []
//                                        self.trackerUrls = []

                                        self.targetUrls = self.checkTargetUrls
                                        self.targetIds = self.checkTargetIds
                                        self.trackerUrls = self.checkTrackerUrls
                                        
                                        UserDefaults.standard.set(self.trackerUrls, forKey: "trackerUrls")
                                        UserDefaults.standard.set(self.targetUrls, forKey: "targetUrls")
                                        UserDefaults.standard.set(self.targetIds, forKey: "targetIds")
                                        
                                        getTargets()
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                                                
                                                
                                            
                                
                            }
                            
                            print("result"+result)
                            
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                    
                    
                    
                    
                } else {
                    print("unable to parse response as string")
                }
                

            }

            task.resume()





        }
        else{
            print("token yaft nashod")
        }
    
        
    }

    private func showLogo() {
        
        if(self.bearerToken != ""){
            
            print("bearerToken:" + self.bearerToken)

            let globUrl = "http://94.101.184.60:6060/"

            let strUrl = globUrl + "api/Platform/"

            
            let url = URL(string: strUrl)!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
            
            
            // Add the bearer token to the Authorization header
            request.setValue("Bearer \(self.bearerToken)", forHTTPHeaderField: "Authorization")


            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil


                else {                                                               // check for fundamental networking error
                    print("error", error ?? URLError(.badServerResponse))
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }

                // do whatever you want with the `data`, e.g.:

                if let responseString = String(data: data, encoding: .utf8) {
                    //print("responseString = \(responseString)")
                    
                    guard let jsonData = responseString.data(using: .utf8) else {
                        return
                    }

                    do {
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            let success = json["success"] as? Bool ?? false
                            let result = json["result"] as? String ?? ""
                            // Do something with the success and result values
                            
                            if(success){
                                
                                if let result = json["result"] as? [[String: Any]] {
                                    // Loop through each object in the "result" array
                                    for object in result {
                                        // Check if the "_id" key matches the desired id
                                        if let id = object["_id"] as? String, id == self.companyId {
                                            // Get the "address" value of the "avatar" dictionary
                                            if let avatar = object["avatar"] as? [String: Any], let address = avatar["address"] as? String {
                                                print("avatar:")
                                                print(address) // This will print the address of the avatar
                                                
                                                

                                                // Load the image from the URL
                                                if let url = URL(string: address) {
                                                    URLSession.shared.dataTask(with: url) { data, response, error in
                                                        if let data = data, let image = UIImage(data: data) {
                                                            DispatchQueue.main.async {
                                                                self.imageView.image = image
                                                            }
                                                        }
                                                    }.resume()
                                                }
                                                
                                                
                                                
                                                
                                            }
                                        }
                                    }
                                }
                                                
                                                
                                            
                                
                            }
                            
                            print("result"+result)
                            
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                    
                    
                    
                    
                } else {
                    print("unable to parse response as string")
                }
                

            }

            task.resume()





        }
        else{
            print("token yaft nashod")
        }
    }
    
    
    
    
    
    
    
    
    // download targets
    
    
    private func getTargets() {
        
        
        if(self.targetUrls.count > 0){
            
            
            UserDefaults.standard.set(self.trackerUrls, forKey: "trackerUrls")
            UserDefaults.standard.set(self.targetUrls, forKey: "targetUrls")
            UserDefaults.standard.set(self.targetIds, forKey: "targetIds")
            
            
            DispatchQueue.main.async {
                // Create and present the progress alert
                self.alert = self.createProgressAlert()
                self.present(self.alert!, animated: true) {
                    DispatchQueue.global().async {
                        self.downloadFiles(self.targetUrls)
                    }
                }
            }
            
            
            
        }
        else{
        
            
            
            
            if(self.bearerToken != ""){
                
                print("bearerToken:" + self.bearerToken)
                let globUrl = "http://94.101.184.60:6060/"
                let strUrl = globUrl + "api/AdsElement/" + self.companyId

                
                let url = URL(string: strUrl)!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.httpMethod = "POST"
                
                
                // Add the bearer token to the Authorization header
                request.setValue("Bearer \(self.bearerToken)", forHTTPHeaderField: "Authorization")


                let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                    guard
                        let data = data,
                        let response = response as? HTTPURLResponse,
                        error == nil


                    else {                                                               // check for fundamental networking error
                        print("error", error ?? URLError(.badServerResponse))
                        return
                    }

                    guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                        print("statusCode should be 2xx, but is \(response.statusCode)")
                        print("response = \(response)")
                        return
                    }

                    // do whatever you want with the `data`, e.g.:

                    if let responseString = String(data: data, encoding: .utf8) {
    //                    print("responseString = \(responseString)")
                        
                        guard let jsonData = responseString.data(using: .utf8) else {
                            return
                        }

                        do {
                            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                                let success = json["success"] as? Bool ?? false
                                let result = json["result"] as? String ?? ""
                                // Do something with the success and result values
                                
                                if(success){
                                    
                                    if let result = json["result"] as? [[String: Any]] {
                                        // Loop through each object in the "result" array
                                        for object in result {
                                            // Check if the "_id" key matches the desired id
                                            if let ARItems = object["ARItems"] as? [[String: Any]]{
                                                
    //                                            print("ARItems2")
    //                                            print(ARItems)
                                                for ARItem in ARItems {
                                                    
                                                    if let targetId = ARItem["_id"] as? String{
                                                        
    //                                                    print("target")
    //                                                    print(target)
                                                        self.targetIds.append(targetId)
                                                        
                                                    }
                                                    
                                                    
                                                    if let tracker = ARItem["data"] as? [String: Any]{
                                                        
    //                                                    print("target")
    //                                                    print(target)
                                                        
                                                        
                                                        if let address = tracker["address"] as? String {
    //                                                        print("address")
    //                                                        print(address)
                                                            
                                                            self.trackerUrls.append(address)
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                    if let target = ARItem["target"] as? [String: Any]{
                                                        
    //                                                    print("target")
    //                                                    print(target)
                                                        
                                                        
                                                        if let address = target["address"] as? String {
    //                                                        print("address")
    //                                                        print(address)
                                                            
                                                            self.targetUrls.append(address)
                                                        }
                                                        
                                                    }
                                                }
                                                
                                                
                                            }
                                        
                                        }
                                        
                                        print("targetUrls")
                                        print(self.targetUrls)
                                        
                                        print("trackerUrls")
                                        print(self.trackerUrls)
                                        
                                        print("targetIds")
                                        print(self.targetIds)
                                        
                                        
                                        if(self.targetUrls.count > 0){
                                            
                                            
                                            UserDefaults.standard.set(self.trackerUrls, forKey: "trackerUrls")
                                            UserDefaults.standard.set(self.targetUrls, forKey: "targetUrls")
                                            UserDefaults.standard.set(self.targetIds, forKey: "targetIds")
                                            
                                            
                                            DispatchQueue.main.async {
                                                // Create and present the progress alert
                                                self.alert = self.createProgressAlert()
                                                present(self.alert!, animated: true) {
                                                    DispatchQueue.global().async {
                                                        self.downloadFiles(self.targetUrls)
                                                    }
                                                }
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                    }
                                                    
                                                    
                                                
                                    
                                }
                                
                                print("result"+result)
                                
                            }
                        } catch {
                            print("Error parsing JSON: \(error.localizedDescription)")
                        }
                        
                        
                        
                        
                    } else {
                        print("unable to parse response as string")
                    }
                    

                }

                task.resume()





            }
            else{
                print("token yaft nashod")
            }
        }
    }

    
    
    

    
    func createProgressAlert() -> UIAlertController {
        
        let stringUrls = self.targetUrls
        
        let alertController = UIAlertController(title: "در حال دانلود", message: "\n\n", preferredStyle: .alert)
        
        
        let fileInfoStackView = UIStackView()
        fileInfoStackView.axis = .horizontal
        fileInfoStackView.alignment = .center
        fileInfoStackView.spacing = 8
        fileInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let fileCounterLabel = UILabel()
        fileCounterLabel.font = UIFont.systemFont(ofSize: 14)
        fileCounterLabel.text = "1"
        fileInfoStackView.addArrangedSubview(fileCounterLabel)
        
        let fileSizeLabel = UILabel()
        fileSizeLabel.font = UIFont.systemFont(ofSize: 14)
        fileSizeLabel.text = "لطفا منتظر بمانید"
        fileInfoStackView.addArrangedSubview(fileSizeLabel)
        
        alertController.view.addSubview(fileInfoStackView)
        
        NSLayoutConstraint.activate([
            fileInfoStackView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 30),
            fileInfoStackView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -30),
            fileInfoStackView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -30)
        ])
        
        return alertController
    }
    
    func downloadFiles(_ urls: [String]) {
        for (index, urlString) in urls.enumerated() {
            
            var fileFounded = false
            
            let targetId = targetIds[index]


            print("targetId"+targetId)

            if UserDefaults.standard.string(forKey: targetId) != nil {

                let targetSavedPath = UserDefaults.standard.string(forKey: targetId)!
                let url = URL(fileURLWithPath: targetSavedPath)

                let filePath = url.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    fileFounded = true
                    print("FILE Founded")
                } else {
                    print("FILE NOT AVAILABLE")
                }

            }
            
            
            
            
            
            if(!fileFounded){
                if let url = URL(string: urlString){
    //                var currentProgress: Float = 0
    //                while currentProgress < 1 {
    //                    DispatchQueue.main.async {
    //                        if let progressView = self.alert?.view.subviews.compactMap({ $0 as? UIProgressView }).first {
    //                            progressView.progress = currentProgress
    //                        }
    //                    }
    //                    currentProgress += 0.01 // Simulate progress increment
    //                    usleep(50000) // Simulate delay
    //                }
    //
                    // Download the data from the URL
                    if let urlData = NSData(contentsOf: url){
                        // Process the downloaded data here
                        
                        print("downloadingFile:")
                        print(urls[index])
                        
                        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                        let filePath="\(documentsPath)/tempFile.jpg"
                        
                        
                        DispatchQueue.main.async {
                            
                            urlData.write(toFile: filePath, atomically: true)
                            print("filePath")
                            print(filePath)
                            let savedIn = self.runFunction(nameOfYourFile: self.targetIds[index],url: URL(fileURLWithPath: filePath))
                            print("savedIn")
                            print(savedIn.path)
                            let targetSavedPath = savedIn.path
                            let UserDefaultsTargetKey = self.targetIds[index]
                            UserDefaults.standard.set(targetSavedPath, forKey: UserDefaultsTargetKey)
                            
                            
                            
                            // age tamom nashode
                            // chon lahze akhar yeki ezafe mishod
                            if((index + 2) <= urls.count){
                                
                                print("ini:/ \(index)")
                                
                                
                                
                                
                                if let alertController = self.alert {
                                    if let stackView = alertController.view.subviews.compactMap({ $0 as? UIStackView }).first {
                                        guard let fileCounterLabel = stackView.arrangedSubviews.first as? UILabel else {
                                            return
                                        }

                                        print("oni:/ \(index)")

                                        var current = index + 2
                                        
                                        // Finish downloading
                                        DispatchQueue.main.async {
                                            fileCounterLabel.text = "\(current)"
                                        }

                                    } else {
                                        print("Stack view not found")
                                    }
                                } else {
                                    print("Alert controller is nil")
                                }
                                
                                
                                
                            }
                        }
                    }
                }
            }
        }
        
        // Finish downloading
        DispatchQueue.main.async {
            self.alert?.dismiss(animated: true, completion: {
                self.isDownloading = false
                
            })
        }
    }
    
    
    func runFunction(nameOfYourFile:String,url:URL) -> URL{
        
        guard let folderURL = URL.createFolder(folderName: "StoredVideos") else {
            print("Can't create url")
            return url
        }

        let permanentFileURL = folderURL.appendingPathComponent(nameOfYourFile).appendingPathExtension("jpg")
        let videoData = try! Data(contentsOf: url)
        try! videoData.write(to: permanentFileURL, options: .atomic)
        
        
        return permanentFileURL
    }
    
}
