//
//  ViewController.swift
//  AR-VideoPlayer
//
//  Created by bogdan razvan on 26.01.2021.
//

import UIKit
import ARKit
import SwiftUI
import MapKit
import EventKit
import WebKit
import Contacts



extension UIViewController: UITextFieldDelegate {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
   }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}


struct ResponseObject<T: Decodable>: Decodable {
    let form: T    // often the top level key is `data`, but in the case of https://httpbin.org, it echos the submission under the key `form`
}

struct Foo: Decodable {
    let state: String
    let status: String
}

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var bearerToken = ""
//    let companyId = "64e05a8cca250804d7232147" //arabe
//    let companyId = "60efe1036a8e05066f8fcdb1" //kale
    let companyId = "65338c6085ff6330936e7593" //mapna
    
    
    var isTargetPictureVisible = false
    
    var targetUrls = [String]()
    var targetIds = [String]()
    var trackerUrls = [String]()
    
    var videoPlayer: AVPlayer!  // Declare the videoPlayer as a global variable
    var videoNode: SKVideoNode!

    var anchorVideoPlayerMap: [ARImageAnchor: AVPlayer] = [:]

    var lastPlayedTargetId = ""


    @IBOutlet var sceneView: ARSCNView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI elements or other configurations if needed
            
        
            sceneView.delegate = self
            sceneView.session.delegate = self             // ARSESSION DELEGATE

            // Setting up the play button.
        
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
        
            setupButton()
        
        
    }
    
    
    @IBOutlet weak var textField: UITextField!

    @IBAction func buttonClicked(_ sender: Any) {
        let text = textField.text ?? ""
        print("text:" + text)
        // Do something with the text value
    }
    
    
    
    @IBOutlet weak var startDownloadButton: UIButton!
    
    var isDownloading = false
    var alert: UIAlertController?
    
    
    @IBAction func startDownloadButtonTapped(_ sender: UIButton) {
        startDownload()
    }
    
    @objc func startDownload() {
        guard !isDownloading else { return }
        
        getTargets()
        
//        isDownloading = true
//        let stringUrls = [
//            "https://hamarehproducts.ir/panelMap/arios/1.mp4",
//            "https://hamarehproducts.ir/panelMap/arios/2.mp4",
//            "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/440px-Image_created_with_a_mobile_phone.png",
//            "https://saba.host/images/blog/16253157178.png",
//
//        ]
//
        
    }
    
    private func getTargets() {
        
        
        if(self.targetUrls.count > 0){
            
            
            UserDefaults.standard.set(self.trackerUrls, forKey: "trackerUrls")
            UserDefaults.standard.set(self.targetUrls, forKey: "targetUrls")
            UserDefaults.standard.set(self.targetIds, forKey: "targetIds")
            
            
//            DispatchQueue.main.async {
//                // Create and present the progress alert
//                self.alert = self.createProgressAlert()
//                self.present(self.alert!, animated: true) {
//                    DispatchQueue.global().async {
//                        self.downloadFiles(self.targetUrls)
//                    }
//                }
//            }
//
            
            
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
                                            
                                            
//                                            DispatchQueue.main.async {
//                                                // Create and present the progress alert
//                                                self.alert = self.createProgressAlert()
//                                                present(self.alert!, animated: true) {
//                                                    DispatchQueue.global().async {
//                                                        self.downloadFiles(self.targetUrls)
//                                                    }
//                                                }
//                                            }
                                            
                                            
                                            
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
    
    
    func addContactsFromString(_ inputString: String) {
        let components = inputString.components(separatedBy: "@")
        
        
        print("ooo")
        
        var i = 0
        
        for component in components {
            
            i += 1
            
            
            let subComponents = component.components(separatedBy: "#")
            
            print("eeee: \(subComponents)")

            if(i > 1){
            
                if subComponents.count == 2 {
                    let name = subComponents[0]
                    let phoneNumber = subComponents[1]
                    
                    print("eeee")
                    print("eeee: \(name), \(phoneNumber)")
                    
                    let contact = CNMutableContact()
                    contact.givenName = name
                    contact.phoneNumbers = [CNLabeledValue(
                        label: CNLabelPhoneNumberMain,
                        value: CNPhoneNumber(stringValue: phoneNumber)
                    )]
                    
                    let store = CNContactStore()
                    let saveRequest = CNSaveRequest()
                    saveRequest.add(contact, toContainerWithIdentifier: nil)
                    
                    
                    
                    do {
                        try store.execute(saveRequest)
                        print("Contact added successfully: \(name), \(phoneNumber)")
                    } catch {
                        print("Failed to add contact: \(name), \(phoneNumber), \(error)")
                    }
                }
            }
        }
    }
    
    func addContact(name: String, family: String, number: String) {
        let store = CNContactStore()
        let contact = CNMutableContact()
        
        // Name
        contact.givenName = name
        contact.familyName = family
        
        // Phone number
        let phoneNumber = CNPhoneNumber(stringValue: number)
        let phoneNumberLabel = CNLabeledValue(label: CNLabelPhoneNumberMain, value: phoneNumber)
        contact.phoneNumbers = [phoneNumberLabel]
        
        // Save contact
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
            print("Contact added successfully")
        } catch {
            print("Failed to add contact: \(error.localizedDescription)")
        }
    }

    
    
    func createProgressAlert() -> UIAlertController {
        
        let stringUrls = self.targetUrls
        
        let alertController = UIAlertController(title: "در حال دانلود", message: "\n\n", preferredStyle: .alert)
        
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.addSubview(progressView)
        
        let fileInfoStackView = UIStackView()
        fileInfoStackView.axis = .horizontal
        fileInfoStackView.alignment = .center
        fileInfoStackView.spacing = 8
        fileInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let fileCounterLabel = UILabel()
        fileCounterLabel.font = UIFont.systemFont(ofSize: 14)
        fileCounterLabel.text = "1 / 1"
        fileInfoStackView.addArrangedSubview(fileCounterLabel)
        
        let fileSizeLabel = UILabel()
        fileSizeLabel.font = UIFont.systemFont(ofSize: 14)
        fileSizeLabel.text = ""
        fileInfoStackView.addArrangedSubview(fileSizeLabel)
        
        alertController.view.addSubview(fileInfoStackView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20),
            progressView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 80),
            
            fileInfoStackView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20),
            fileInfoStackView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20),
            fileInfoStackView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -40)
        ])
        
        return alertController
    }
    
    
    func downloadFiles(_ urls: [String],targetId:String,trackerId:String,fileType:String) {
        for (index, urlString) in urls.enumerated() {
            if let url = URL(string: urlString){
                var currentProgress: Float = 0
                while currentProgress < 1 {
                    DispatchQueue.main.async {
                        if let progressView = self.alert?.view.subviews.compactMap({ $0 as? UIProgressView }).first {
                            progressView.progress = currentProgress
                        }
                    }
                    currentProgress += 0.01 // Simulate progress increment
                    usleep(50000) // Simulate delay
                }
                
                // Download the data from the URL
                if let urlData = NSData(contentsOf: url){
                    // Process the downloaded data here
                    
                    print("downloadingFile:")
                    print(urls[index])
                    
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                    let filePath="\(documentsPath)/tempFile." + fileType
                    
                    
                    DispatchQueue.main.async {
                        
                        urlData.write(toFile: filePath, atomically: true)
                        print("filePath")
                        print(filePath)
                        let savedIn = self.runFunction(nameOfYourFile: targetId,url: URL(fileURLWithPath: filePath),fileType: fileType)
                        print("savedIn")
                        print(savedIn.path)
                        let targetSavedPath = savedIn.path
                        let UserDefaultsTargetKey = "tracker_" + targetId
                        
                        
                        print("DownloadByKey"+UserDefaultsTargetKey)
                        
                        UserDefaults.standard.set(targetSavedPath, forKey: UserDefaultsTargetKey)
                        
                        if var storedMap = UserDefaults.standard.object(forKey: "downloadedTrackersMap") as? [String: String] {
                                       
                            storedMap[targetId] = trackerId
                            UserDefaults.standard.set(storedMap, forKey: "downloadedTrackersMap")
                        }
                        else{
                            var storedMap: [String: String] = [:]
                            storedMap[targetId] = trackerId
                            UserDefaults.standard.set(storedMap, forKey: "downloadedTrackersMap")

                        }
                        
                        
                        
                        // age tamom nashode
                        // chon lahze akhar yeki ezafe mishod
                        if((index + 2) <= urls.count){
                            
                            // change labels of alert
                            if let alertController = self.alert,
                               let fileCounterLabel = alertController.view.subviews.compactMap({ $0 as? UIStackView }).first?.arrangedSubviews.first as? UILabel {
                                fileCounterLabel.text = "\(index + 2) / \(urls.count)"
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
                self.showDownloadCompleteAlert()
                
//                self.setupButton()
                
            })
        }
    }
    
    func showDownloadCompleteAlert() {
//        let alertController = UIAlertController(title: "دانلود تمام شد", message: "تمامی فایل ها دانلود شدند.", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "تایید", style: .default, handler: nil))
//        present(alertController, animated: true, completion: nil)
        
        restartDetection()
    }
    
    func restartDetection() {
        
    
//        
//        self.sceneView.allowsCameraControl = false
//        
//        let configurationEmpty = ARWorldTrackingConfiguration()
//        configurationEmpty.planeDetection = [] // Empty array
//        self.sceneView.session.run(configurationEmpty)
//    
//        
//        self.sceneView.session.pause()
//        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
//            node.removeFromParentNode()
//        }
//        
//        
    
        var customReferenceSet = Set<ARReferenceImage>()
        
    
        for targetId in self.targetIds{
            
        
            
            let targetSavedPath = UserDefaults.standard.string(forKey: targetId)!
            
            print("targetSavedPath")
            print(targetSavedPath)
            
            if let image = UIImage(contentsOfFile: targetSavedPath){
               
                let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
                // Set the name of the ARReferenceImage to a unique identifier
                arImage.name = targetId
                // Add the ARReferenceImage to a set of custom reference images
                customReferenceSet.insert(arImage)
            }


            
            
        }
        
        
        // If so, we create an image tracking config.
        let configuration = ARImageTrackingConfiguration()
        // And set the tracked image (default value for the maximum number of tracked images is 1).
        
        configuration.maximumNumberOfTrackedImages = 2
        configuration.trackingImages = customReferenceSet
        self.sceneView.session.run(configuration)
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        
    
    }
    
    
    func showDownloadEventAdded() {
        let alertController = UIAlertController(title: "رویداد ثبت شد", message: "رویداد مورد نظر در تقویم ثبت شد", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "تایید", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
//    let stringUrls = [
//        "https://hamarehproducts.ir/panelMap/arios/1.mp4",
//        "https://hamarehproducts.ir/panelMap/arios/1.mp4",
//        "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/440px-Image_created_with_a_mobile_phone.png",
//        "https://saba.host/images/blog/16253157178.png",
//
//    ]

    override var prefersStatusBarHidden: Bool { return true }

    //Configuring the Play button.
    private lazy var playButton: UIButton = {
        var button = UIButton(type: .system)
        button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        button.setTitle("شروع", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.tintColor = .white
        return button
    }()
    
    
    //Configuring the Play button.
    private lazy var downloadButton: UIButton = {
        var button = UIButton(type: .system)
        button.addTarget(self, action: #selector(startDownload), for: .touchUpInside)
        button.setTitle("دانلود", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .medium)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.tintColor = .white
        return button
    }()


    // Setting up the play button's position and constraints.
    private func setupButton() {
        
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
            
            view.addSubview(playButton)
            playButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playButton.heightAnchor.constraint(equalToConstant: 60),
                playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                playButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
            ])
            
            downloadButton.isHidden = true
            playButton.isHidden = true
            
            let timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
                // Code to be executed after 1 second
                self.playButtonPressed()
            }
            
            
//            view.addSubview(apiButton)
//            apiButton.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                apiButton.heightAnchor.constraint(equalToConstant: 60),
//                apiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                apiButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//                apiButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//                apiButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
//            ])
        }
        else{
            
            view.addSubview(downloadButton)
            downloadButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                downloadButton.heightAnchor.constraint(equalToConstant: 60),
                downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                downloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                downloadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
            ])
                
        }
        
        
        
    }
    
    
    func addEventToCalendar(startDate: String, endDate: String, eventName: String) {
        let eventStore = EKEventStore()

        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && error == nil {
                let event = EKEvent(eventStore: eventStore)
                event.title = eventName
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                
                if let start = dateFormatter.date(from: startDate), let end = dateFormatter.date(from: endDate) {
                    event.startDate = start
                    event.endDate = end
                    
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    do {
                        try eventStore.save(event, span: .thisEvent)
                        print("Event added to calendar")
                        
                        DispatchQueue.main.async {
                            self.showDownloadEventAdded()
                        }
                        
                    } catch {
                        print("Error adding event to calendar: \(error.localizedDescription)")
                    }
                } else {
                    print("Invalid date format")
                }
            } else {
                print("Access to calendar not granted")
            }
        }
    }
    
//    func openMapAppWithMarker(latitude: Double, longitude: Double) {
//        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let placemark = MKPlacemark(coordinate: coordinates)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = "Tracker Location"
//
//        print("latitude")
//        print(latitude)
//        print("longitude")
//        print(longitude)
//
//
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        mapItem.openInMaps(launchOptions: launchOptions)
//    }
//
    func openMapAppWithMarker(latitude: Double, longitude: Double) {
        //let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let latitude: CLLocationDegrees = latitude
        let longitude: CLLocationDegrees = longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Place Name"
        mapItem.openInMaps(launchOptions: options)
    }
    
//    func openPdfLink(pdfUrl: String) {
//        guard let url = URL(string: pdfUrl) else {
//            return
//        }
//
//        let webView = WKWebView()
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
    
    
    func openPdfLinkInApp(pdfUrl: String, fromViewController viewController: UIViewController) {
        guard let url = URL(string: pdfUrl) else {
            return
        }
        
        let documentInteractionController = UIDocumentInteractionController(url: url)
        documentInteractionController.presentOptionsMenu(from: viewController.view.bounds, in: viewController.view, animated: true)
    }
    
    
    func openPdfLink(pdfUrl: String, fromViewController viewController: UIViewController) {
        guard let url = URL(string: pdfUrl) else {
            return
        }
//        
//        let previewController = QLPreviewController()
//        previewController.dataSource = viewController as? QLPreviewControllerDataSource
//        previewController.currentPreviewItemIndex = 0
//        viewController.present(previewController, animated: true, completion: nil)
    }
    
    
    func sharedopenPdfLink(pdfUrl: String) {
        guard let url = URL(string: pdfUrl) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func openPDFInWebView(fromPath path: String, webView: WKWebView) {
        let fileURL = URL(fileURLWithPath: path)
        let request = URLRequest(url: fileURL)
        webView.load(request)
    }
    
    // Associate an ARImageAnchor with a specific AVPlayer
    func associateVideoPlayer(withAnchor anchor: ARImageAnchor, player: AVPlayer) {
        anchorVideoPlayerMap[anchor] = player
    }

    
    private func getTrackerByTargetId(targetId: String,imageAnchor:ARImageAnchor,node: SCNNode){

        
        let globUrl = "http://94.101.184.60:6060/"

        let strUrl = globUrl + "api/AdsElement/Target3/" + targetId + "?os=ios"

        
        let url = URL(string: strUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        

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
                                    
                                    
                                    let type = object["type"] as? String
                                    
                                    print("type" + type!)
                                    
                                    
                                    //VIDEO
                                    if(type == "VIDEO" || type == "Transparent"){
                                        
                                        
                                        if let data = object["data"] as? [String: Any]{
                                        
                                            if let url = data["address"] as? String, let trackerId = data["_id"] as? String {

                                            
                                                print("url" + url)
                                                var fileFounded = false
                                                var UserDefaultsKey = "tracker_" + targetId
                                                print("LoadByKey" + UserDefaultsKey)
                                                
                                                
                                                self.lastPlayedTargetId = UserDefaultsKey
                                                
                                                
                                                
                                                
                                                if var storedMap = UserDefaults.standard.object(forKey: "downloadedTrackersMap") as? [String: String] {
                                                             
                                                    for (targetID, trackerID) in storedMap {
                                                        print("Target ID: \(targetID), Tracker ID: \(trackerID)")
                                                    }
                                                    
                                                    if trackerId == storedMap[targetId] {
                                                        print("Tracker ID for target ID \(targetId): \(trackerId)")
                                                    } else {
                                                        print("No tracker ID found for target ID \(targetId)")
                                                        
                                                        storedMap[targetId] = trackerId
                                                        UserDefaults.standard.set(storedMap, forKey: "downloadedTrackersMap")

                                                        
                                                        let trackerSavedPath = UserDefaults.standard.string(forKey: UserDefaultsKey)!
                                                        let urlFile = URL(fileURLWithPath: trackerSavedPath)

                                                        let filePath = urlFile.path
                                                        let fileManager = FileManager.default
                                                        if fileManager.fileExists(atPath: filePath) {
                                                            fileFounded = true
                                                            print("Tracker Video Founded")
                                                            print("filePath"+filePath)
                                                            do {
                                                                try fileManager.removeItem(atPath: filePath)
                                                                print("File removed successfully")
                                                            } catch {
                                                                print("Error removing file: \(error)")
                                                            }
                                                            
                                                        }
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                                
                                                
                                                
                                                if UserDefaults.standard.string(forKey: UserDefaultsKey) != nil {
                                                    
                                                    
                                                    print("inji")
                                                    
                                                    let trackerSavedPath = UserDefaults.standard.string(forKey: UserDefaultsKey)!
                                                    let urlFile = URL(fileURLWithPath: trackerSavedPath)

                                                    let filePath = urlFile.path
                                                    let fileManager = FileManager.default
                                                    if fileManager.fileExists(atPath: filePath) {
                                                        fileFounded = true
                                                        print("Tracker Video Founded")
                                                        print("filePath"+filePath)
                                                        let videoURL = URL(fileURLWithPath: filePath)
                                                        
                                                        
                                                        // Creating a player item and a player.
                                                        self.videoPlayer = AVPlayer(playerItem: AVPlayerItem(url: videoURL))
//                                                        let playerItem = AVPlayerItem(url: videoURL)
                                                        
                                                        

//
//                                                        // Check if there is a currentItem and replace it with nil
//                                                        if self.videoPlayer?.currentItem != nil {
//                                                            self.videoPlayer.replaceCurrentItem(with: nil)
////
////                                                            self.videoPlayer.replaceCurrentItem(with: playerItem)
////                                                            print("CurrentItem replaced with nil")
////
//
//                                                            self.videoPlayer = .init(playerItem: playerItem)
//                                                        } else {
//                                                            print("No CurrentItem to replace")
//                                                            self.videoPlayer = AVPlayer(playerItem: playerItem)
//                                                        }

                                                        
//                                                        var newVideoPlayer = AVPlayer(playerItem: playerItem)
                                                        
                                                        
                                                        
                                                        // Creating the video scene with a transparent background.
                                                        let videoScene = SKScene(size: CGSize(width: 480, height: 720))
                                                        videoScene.backgroundColor = .clear

                                                        
//                                                        self.videoPlayer  = nil
                                                        self.videoNode = SKVideoNode(avPlayer: self.videoPlayer)
//                                                        self.videoNode = .init(avPlayer: self.videoPlayer)
                                                        
                                                        self.videoNode.size = videoScene.size
                                                        self.videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
                                                        self.videoNode.yScale = -1.0
                                                        videoScene.removeAllChildren()
                                                        videoScene.addChild(self.videoNode)

                                                        // Creating a plane having the same dimensions as our image.
                                                        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                                                        // Setting the video scene to the plane.
                                                        plane.firstMaterial?.diffuse.contents = videoScene
                                                        // Initializing a node with the plane.
                                                        let planeNode = SCNNode(geometry: plane)
                                                        // Rotating the node to appear straight.
                                                        planeNode.eulerAngles.x = -.pi / 2
                                                        // Adding the plane node.
                                                        node.addChildNode(planeNode)
                                                        
//                                                        self.associateVideoPlayer(withAnchor: imageAnchor, player: newVideoPlayer)


                                                        // Playing the video.
                                                        self.videoPlayer.play()
                                                    }
                                                    else {
                                                        print("FILE NOT AVAILABLE")
                                                        DispatchQueue.main.async {
                                                            // Create and present the progress alerts
                                                            self.alert = self.createProgressAlert()
                                                            self.present(self.alert!, animated: true) {
                                                                DispatchQueue.global().async {
                                                                    self.downloadFiles([url],targetId: targetId,trackerId: trackerId, fileType: "mov")
                                                                }
                                                            }
                                                        }
                                                    
                                                    }
                                                
                                                }
                                                else {
                                                    print("FILE NOT AVAILABLE")
                                                    DispatchQueue.main.async {
                                                        // Create and present the progress alert
                                                        self.alert = self.createProgressAlert()
                                                        self.present(self.alert!, animated: true) {
                                                            DispatchQueue.global().async {
                                                                self.downloadFiles([url],targetId: targetId,trackerId: trackerId, fileType: "mov")
                                                            }
                                                        }
                                                    }
                                                
                                                }
                                            }
                                        }
                                    }
                                    
                                    //MUSIC
                                    if(type == "MUSIC"){
                                        
                                        
                                        if let data = object["data"] as? [String: Any]{
                                        
                                            if let url = data["address"] as? String, let trackerId = data["_id"] as? String {
                                                
                                            
                                                print("url" + url)
                                                
                                                print("url" + url)
                                                var fileFounded = false
                                                var UserDefaultsKey = "tracker_" + targetId
                                                print("LoadByKey" + UserDefaultsKey)
                                                
                                                
                                                if var storedMap = UserDefaults.standard.object(forKey: "downloadedTrackersMap") as? [String: String] {
                                                             
                                                    for (targetID, trackerID) in storedMap {
                                                        print("Target ID: \(targetID), Tracker ID: \(trackerID)")
                                                    }
                                                    
                                                    if trackerId == storedMap[targetId] {
                                                        print("Tracker ID for target ID \(targetId): \(trackerId)")
                                                    } else {
                                                        print("No tracker ID found for target ID \(targetId)")
                                                        
                                                        storedMap[targetId] = trackerId
                                                        UserDefaults.standard.set(storedMap, forKey: "downloadedTrackersMap")

                                                        
                                                        let trackerSavedPath = UserDefaults.standard.string(forKey: UserDefaultsKey)!
                                                        let urlFile = URL(fileURLWithPath: trackerSavedPath)

                                                        let filePath = urlFile.path
                                                        let fileManager = FileManager.default
                                                        if fileManager.fileExists(atPath: filePath) {
                                                            fileFounded = true
                                                            print("Tracker Video Founded")
                                                            print("filePath"+filePath)
                                                            do {
                                                                try fileManager.removeItem(atPath: filePath)
                                                                print("File removed successfully")
                                                            } catch {
                                                                print("Error removing file: \(error)")
                                                            }
                                                            
                                                        }
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                                
                                                if UserDefaults.standard.string(forKey: UserDefaultsKey) != nil {
                                                    
                                                    
                                                    print("inji")
                                                    
                                                    let trackerSavedPath = UserDefaults.standard.string(forKey: UserDefaultsKey)!
                                                    let urlFile = URL(fileURLWithPath: trackerSavedPath)

                                                    let filePath = urlFile.path
                                                    let fileManager = FileManager.default
                                                    if fileManager.fileExists(atPath: filePath) {
                                                        fileFounded = true
                                                        print("Tracker Music Founded")
                                                        print("filePath"+filePath)
                                                        

                                                        let videoURL = URL(fileURLWithPath: filePath)

                                                        // Creating a player item and a player.
//                                                        let videoPlayer = AVPlayer(playerItem: AVPlayerItem(url: videoURL))
                                                        let playerItem = AVPlayerItem(url: videoURL)
                                                        
                                                        
                                                        self.videoPlayer = AVPlayer(playerItem: playerItem)  // Assign the new AVPlayer
                                                        
                                                        self.videoNode = SKVideoNode(avPlayer: self.videoPlayer)
                                                        
                                                        
                                                        // Creating the video scene.
                                                        let scene = SKScene(size: CGSize(width: 480, height: 720))
                                                        // Setting the size and position of the video node.
                                                        self.videoNode.size = scene.size
                                                        self.videoNode.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
                                                        // Rotating the video.
                                                        self.videoNode.yScale = -1.0
                                                        scene.removeAllChildren()
                                                        scene.addChild(self.videoNode)

                                                        // Creating a plane having the same dimensions as our image.
                                                        let plane = SCNPlane(width: 0, height: 0)
                                                        // Setting the video scene to the plane.
                                                        plane.firstMaterial?.diffuse.contents = scene
                                                        // Initializing a node with the plane.
                                                        let planeNode = SCNNode(geometry: plane)
                                                        // Rotating the node to appear straight.
                                                        planeNode.eulerAngles.x = -Float.pi / 2
                                                        // Adding the plane node.
                                                        node.addChildNode(planeNode)

                                                        
                                                        self.videoPlayer.play()
                                                        
                                                    }
                                                    else {
                                                        print("FILE NOT AVAILABLE")
                                                        DispatchQueue.main.async {
                                                            // Create and present the progress alert
                                                            self.alert = self.createProgressAlert()
                                                            self.present(self.alert!, animated: true) {
                                                                DispatchQueue.global().async {
                                                                    self.downloadFiles([url],targetId: targetId, trackerId: trackerId, fileType: "mp3")
                                                                }
                                                            }
                                                        }
                                                    
                                                    }
                                                
                                                }
                                                else {
                                                    print("FILE NOT AVAILABLE")
                                                    DispatchQueue.main.async {
                                                        // Create and present the progress alert
                                                        self.alert = self.createProgressAlert()
                                                        self.present(self.alert!, animated: true) {
                                                            DispatchQueue.global().async {
                                                                self.downloadFiles([url],targetId: targetId, trackerId: trackerId, fileType: "mp3")
                                                            }
                                                        }
                                                    }
                                                
                                                }
                                            }
                                        }
                                    }
                                    
                                    
                                    // PDF
                                    if(type == "PDF"){
                                                          
                                        
                                        if let data = object["data"] as? [String: Any]{
                                        
                                            if let url = data["address"] as? String, let trackerId = data["_id"] as? String {
                                            
                                                print("url" + url)
                                                var fileFounded = false
                                                var UserDefaultsKey = "tracker_" + targetId
                                                print("LoadByKey" + UserDefaultsKey)
                                                
                                                
                                                if var storedMap = UserDefaults.standard.object(forKey: "downloadedTrackersMap") as? [String: String] {
                                                             
                                                    for (targetID, trackerID) in storedMap {
                                                        print("Target ID: \(targetID), Tracker ID: \(trackerID)")
                                                    }
                                                    
                                                    if trackerId == storedMap[targetId] {
                                                        print("Tracker ID for target ID \(targetId): \(trackerId)")
                                                    } else {
                                                        print("No tracker ID found for target ID \(targetId)")
                                                        
                                                        storedMap[targetId] = trackerId
                                                        UserDefaults.standard.set(storedMap, forKey: "downloadedTrackersMap")

                                                        
                                                        let trackerSavedPath = UserDefaults.standard.string(forKey: UserDefaultsKey)!
                                                        let urlFile = URL(fileURLWithPath: trackerSavedPath)

                                                        let filePath = urlFile.path
                                                        let fileManager = FileManager.default
                                                        if fileManager.fileExists(atPath: filePath) {
                                                            fileFounded = true
                                                            print("Tracker Video Founded")
                                                            print("filePath"+filePath)
                                                            do {
                                                                try fileManager.removeItem(atPath: filePath)
                                                                print("File removed successfully")
                                                            } catch {
                                                                print("Error removing file: \(error)")
                                                            }
                                                            
                                                        }
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                                
                                                if UserDefaults.standard.string(forKey: UserDefaultsKey) != nil {
                                                    
                                                    
                                                    print("inji")
                                                    
                                                    let trackerSavedPath = UserDefaults.standard.string(forKey: UserDefaultsKey)!
                                                    let urlFile = URL(fileURLWithPath: trackerSavedPath)

                                                    let filePath = urlFile.path
                                                    let fileManager = FileManager.default
                                                    if fileManager.fileExists(atPath: filePath) {
                                                        fileFounded = true
                                                        print("Tracker Video Founded")
                                                        print("filePath"+filePath)

                                                        DispatchQueue.main.async {
                                                            // Create and present the progress alert
//                                                            self.sharedopenPdfLink(pdfUrl: url)
                                                        
                                                            let webView = WKWebView(frame: self.view.bounds)
                                                            self.view.addSubview(webView)
                                                            self.openPDFInWebView(fromPath: filePath, webView: webView)
                                                            
                                                        }
                                                        
                                                        
                                                    }
                                                    else {
                                                        print("FILE NOT AVAILABLE")
                                                        DispatchQueue.main.async {
                                                            // Create and present the progress alert
                                                            self.alert = self.createProgressAlert()
                                                            self.present(self.alert!, animated: true) {
                                                                DispatchQueue.global().async {
                                                                    self.downloadFiles([url],targetId: targetId, trackerId: trackerId, fileType: "pdf")
                                                                }
                                                            }
                                                        }
                                                    
                                                    }
                                                
                                                }
                                                else {
                                                    print("FILE NOT AVAILABLE")
                                                    DispatchQueue.main.async {
                                                        // Create and present the progress alert
                                                        self.alert = self.createProgressAlert()
                                                        self.present(self.alert!, animated: true) {
                                                            DispatchQueue.global().async {
                                                                self.downloadFiles([url],targetId: targetId, trackerId: trackerId, fileType: "pdf")
                                                            }
                                                        }
                                                    }
                                                
                                                }
                                            }
                                        }
                                    }
                                    // CONTACT
                                    if(type == "CONTACT"){
                                        
                                        if let url = object["url"] as? String{
                                        
                                            print("url" + url)
                                            
                                            DispatchQueue.main.async {
                                                // Create and present the progress alert
                                                self.addContactsFromString(url)
                                            }
                                        }
                                        
                                    }
                                    // WEBSITE
                                    if(type == "WEBSITE"){
                                        
                                        
                                        if let url = object["url"] as? String{
                                        
                                            print("url" + url)
                                            
                                            DispatchQueue.main.async {
                                                // Create and present the progress alert
                                                if let url = URL(string: url) {
                                                    let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
                                                    self.present(vc, animated: true)
                                                }
                                            }
                                        }
                                    }
                                    // MAP
                                    if(type == "MAP"){
                                        
                                        if let lat = object["lat"] as? String{
                                        
                                            if let lng = object["lng"] as? String{
                                            
                                                
                                                DispatchQueue.main.async {
                                                    // Create and present the progress alert
                                                    
                                                    if let latitude = Double(lat), let longitude = Double(lng) {
                                                        // Use the latitude and longitude as double values
                                                        self.openMapAppWithMarker(latitude:latitude, longitude: longitude)
                                                    } else {
                                                        // Invalid latitude or longitude strings
                                                        print("Invalid latitude or longitude")
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                    // CALENDAR
                                    if(type == "CALENDAR"){
                                        
                                        if let str = object["url"] as? String{
                                        
                                            //let string = "2023/09/22 16:59:32#2023/09/22 16:59:40#sadasd"
                                            let components = str.components(separatedBy: "#")

                                            if components.count >= 3 {
                                                let startDate = components[0]
                                                let endDate = components[1]
                                                let nameDate = components[2]
                                                
                                                print("1) \(startDate)")
                                                print("2) \(endDate)")
                                                print("3) \(nameDate)")
                                                
                                                DispatchQueue.main.async {
                                                    // add to calendar
                                                    self.addEventToCalendar(startDate: startDate, endDate: endDate, eventName: nameDate)
                                                }
                                                
                                            } else {
                                                print("Invalid input string")
                                            }
                                        }
                                    }
    //
    //                                if let id = object["_id"] as? String, id == self.companyId {
    //                                    // Get the "address" value of the "avatar" dictionary
    //                                    if let avatar = object["avatar"] as? [String: Any], let address = avatar["address"] as? String {
    //                                        print(address) // This will print the address of the avatar
    //
    //
    //
    //                                        // Load the image from the URL
    //                                        if let url = URL(string: address) {
    //                                            URLSession.shared.dataTask(with: url) { data, response, error in
    //                                                if let data = data, let image = UIImage(data: data) {
    //                                                    DispatchQueue.main.async {
    //                                                        self.imageView.image = image
    //                                                    }
    //                                                }
    //                                            }.resume()
    //                                        }
    //
    //
    //
    //
    //                                    }
    //                                }
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
    
    



    @objc
    private func playButtonPressed() {
        // Hiding the Play button.
        playButton.isHidden = true
        
        

        // Here we check if the image that we want to track resides in the ARAssets folder.
//        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARAssets", bundle: Bundle.main) {
//            // If so, we create an image tracking config.
//            let configuration = ARImageTrackingConfiguration()
//            // And set the tracked image (default value for the maximum number of tracked images is 1).
//            configuration.trackingImages = trackedImages
//            sceneView.session.run(configuration)
//        }
        
        
    
        var customReferenceSet = Set<ARReferenceImage>()
        
    
        for targetId in self.targetIds{
            
        
            
            let targetSavedPath = UserDefaults.standard.string(forKey: targetId)!
            
            print("targetSavedPath")
            print(targetSavedPath)
            
            if let image = UIImage(contentsOfFile: targetSavedPath){
               
                let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
                // Set the name of the ARReferenceImage to a unique identifier
                arImage.name = targetId
                // Add the ARReferenceImage to a set of custom reference images
                customReferenceSet.insert(arImage)
            }


            
            
        }
        
        
        // If so, we create an image tracking config.
        let configuration = ARImageTrackingConfiguration()
        // And set the tracked image (default value for the maximum number of tracked images is 1).
        
        configuration.maximumNumberOfTrackedImages = 2
        configuration.trackingImages = customReferenceSet
        self.sceneView.session.run(configuration)
        
    

    
    }
    

}


extension UIImageView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}



extension ViewController:ARSessionDelegate {
    
    //self.sceneView.session.delegate = self
    
//
//    // Inside your session function:
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        for anchor in frame.anchors {
//            if let imageAnchor = anchor as? ARImageAnchor {
//                if imageAnchor.isTracked {
//                    if let videoPlayer = anchorVideoPlayerMap[imageAnchor] {
//                        videoPlayer.play()
//
//
//
//                    }
//                }
//            }
//        }
//    }
    

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        var anyTarget = false

        for anchor in frame.anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                if imageAnchor.isTracked {
                    anyTarget = true
                }
            }
        }
        if(anyTarget){
            print("targetDitected")
            if let videoNode = videoNode {
                if !videoNode.isHidden {
                    videoPlayer?.play()
                    print("Video is in view, playing")
                }
            }
        }
        else{
            print("target NOT Ditected")
            if let videoNode = videoNode {
                if !videoNode.isHidden {
//                    videoPlayer?.pause()
                    if(videoPlayer?.currentItem != nil){
                        videoPlayer.replaceCurrentItem(with: nil)
                        restartDetection()
                    }
                    print("Video is NOT in view")

                }
            }
        }
    }

    
    
    func runFunction(nameOfYourFile:String,url:URL,fileType:String) -> URL{
        
        guard let folderURL = URL.createFolder(folderName: "StoredVideos") else {
            print("Can't create url")
            return url
        }

        let permanentFileURL = folderURL.appendingPathComponent(nameOfYourFile).appendingPathExtension(fileType)
        let videoData = try! Data(contentsOf: url)
        try! videoData.write(to: permanentFileURL, options: .atomic)
        
        
        return permanentFileURL
    }
    

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
//        // Making sure that the generic type ARAchor is actually an ARImageAnchor, and that the video file is present.
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        
        print("targetId" + imageAnchor.referenceImage.name! )
        
        
        
        getTrackerByTargetId(targetId: imageAnchor.referenceImage.name ?? "none",imageAnchor: imageAnchor,node: node);
        
        
        
    }
    

    
//
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//            // Check if there are any image anchors in the frame
//            guard let imageAnchor = frame.anchors.first as? ARImageAnchor else { return }
//            self.imageAnchor = imageAnchor
//
//            // Get the distance between the camera and the image anchor
//            let cameraTransform = frame.camera.transform
//            let imageTransform = imageAnchor.transform
//            let distance = simd_distance(cameraTransform.columns.3, imageTransform.columns.3)
//
//
//
//            // Compare the distance to the threshold value
//            if distance > distanceThreshold {
//                // The camera has moved out from the target picture
//                // Do something here, e.g. pause the AVPlayer
//                print("kkkkkk")
//            } else {
//                // The camera is still within the target picture
//                // Do something here, e.g. resume the AVPlayer
//                print("oooo")
//            }
//        }
//

}

