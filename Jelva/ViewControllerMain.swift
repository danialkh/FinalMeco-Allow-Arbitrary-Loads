//
//  ViewController.swift
//  AR-VideoPlayer
//
//  Created by bogdan razvan on 26.01.2021.
//
import UIKit
import ARKit
import SwiftUI

class ViewControllerMain: UIViewController {
    
    
    //Configuring the Play button.
    private lazy var playButton: UIButton = {
        var button = UIButton(type: .system)
        button.addTarget(self, action: #selector(apiButtonPressed), for: .touchUpInside)
        button.setTitle("دریافت کد", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.tintColor = .white
        return button
    }()
    
    
    //Configuring the Play button.
    private lazy var textField: UITextField = {
        var myText = UITextField()
        myText.placeholder = "شماره تلفن"
        myText.backgroundColor = .systemBlue
        myText.layer.cornerRadius = 8
        myText.tintColor = .white
        myText.backgroundColor = .white
        myText.borderStyle = .roundedRect
        return myText
    }()
    

    @objc
    private func apiButtonPressed() {

        let globUrl = "http://94.101.184.60:6060/"

        let strUrl = globUrl + "api/User/"

        var number = textField.text ?? ""
        
//        number = "09198553651"

        let url = URL(string: strUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "username": number
        ]

        request.httpBody = parameters.percentEncoded()
        
//        print("done")
//        DispatchQueue.main.async {
//        //alert:
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewStD") as! SignInView
//            newViewController.number = number
//            self.present(newViewController, animated: true, completion: nil)
//        }

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
                print("responseString = \(responseString)")
                
                guard let jsonData = responseString.data(using: .utf8) else {
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        let success = json["success"] as? Bool ?? false
                        let result = json["result"] as? String ?? ""
                        // Do something with the success and result values
                        
                        if(success){
                            print("done")
                            DispatchQueue.main.async {
                            //alert:
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewStD") as! SignInView
                                newViewController.number = number
                                self.present(newViewController, animated: true, completion: nil)
                            }

                        }
                        else{
                            DispatchQueue.main.async {
                            //alert:
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewStD") as! SignUpView
                                newViewController.number = number
                                self.present(newViewController, animated: true, completion: nil)
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
            

            

            
            

//            do {
//                let responseObject = try JSONDecoder().decode(ResponseObject<Foo>.self, from: data)
//                //print(responseObject)
//            } catch {
//                print(error) // parsing error
//
//                if let responseString = String(data: data, encoding: .utf8) {
//                    print("responseString = \(responseString)")
//                } else {
//                    print("unable to parse response as string")
//                }
//            }
        }

        task.resume()





    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI elements or other configurations if needed
        // To close the keyboard
        self.hideKeyboardWhenTappedAround()
        textField.delegate = self
        
    
        if UserDefaults.standard.string(forKey: "bearerToken") != nil {
            
            
            let token = UserDefaults.standard.string(forKey: "bearerToken")!
            
            print("Token is: \(token)")
            DispatchQueue.main.async {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //let lastViewController = storyboard.instantiateViewController(withIdentifier: "ViewControllerMainSTD") as! ViewControllerMain
                
                let newViewController = storyboard.instantiateViewController(withIdentifier: "ShowLogoViewStD") as! ShowLogoView
                newViewController.bearerToken = token
                
                // Set the modal presentation style to full screen
                newViewController.modalPresentationStyle = .fullScreen
                
                self.present(newViewController, animated: true)
                //self.view.removeFromSuperview()
                //self.view.window?.rootViewController = lastViewController
                   
            }
            
            
            
        
        }
        else{

            
            
            view.addSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.heightAnchor.constraint(equalToConstant: 60),
                textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -420)
            ])
            
            
            view.addSubview(playButton)
            playButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playButton.heightAnchor.constraint(equalToConstant: 60),
                playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                playButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -310)
            ])
        }
    }

}

