//
//  showNextView.swift
//  AR-VideoPlayer
//
//  Created by MacBook Pro on 8/25/23.
//

import UIKit
import ARKit
import SwiftUI


class SignUpView: UIViewController {
    
    var number = ""
    let companyId = "60efe1036a8e05066f8fcdb1"
    
    //Configuring the Play button.
    private lazy var playButton: UIButton = {
        var button = UIButton(type: .system)
        button.addTarget(self, action: #selector(apiButtonPressed), for: .touchUpInside)
        button.setTitle("ادامه", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.tintColor = .white
        return button
    }()
    
    
    //Configuring the Play button.
    private lazy var tFCode: UITextField = {
        var myText = UITextField()
        myText.placeholder = "کد را وارد نمایید"
        myText.backgroundColor = .systemBlue
        myText.layer.cornerRadius = 8
        myText.tintColor = .white
        myText.backgroundColor = .white
        myText.borderStyle = .roundedRect
        return myText
    }()
    
    
    //Configuring the Play button.
    private lazy var tFFirstName: UITextField = {
        var myText = UITextField()
        myText.placeholder = "نام را وارد نمایید"
        myText.backgroundColor = .systemBlue
        myText.layer.cornerRadius = 8
        myText.tintColor = .white
        myText.backgroundColor = .white
        myText.borderStyle = .roundedRect
        return myText
    }()
    
    
    //Configuring the Play button.
    private lazy var tFLasttName: UITextField = {
        var myText = UITextField()
        myText.placeholder = "نام خانوادگی را وارد نمایید"
        myText.backgroundColor = .systemBlue
        myText.layer.cornerRadius = 8
        myText.tintColor = .white
        myText.backgroundColor = .white
        myText.borderStyle = .roundedRect
        return myText
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI elements or other configurations if needed
        // To close the keyboard
        self.hideKeyboardWhenTappedAround()
        tFCode.delegate = self
        tFFirstName.delegate = self
        tFLasttName.delegate = self
        
//        view.addSubview(tFCode)
//        tFCode.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tFCode.heightAnchor.constraint(equalToConstant: 60),
//            tFCode.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            tFCode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            tFCode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            tFCode.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -420)
//        ])
        
        
        view.addSubview(tFFirstName)
        tFFirstName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tFFirstName.heightAnchor.constraint(equalToConstant: 60),
            tFFirstName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tFFirstName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tFFirstName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tFFirstName.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -350)
        ])
        
        view.addSubview(tFLasttName)
        tFLasttName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tFLasttName.heightAnchor.constraint(equalToConstant: 60),
            tFLasttName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tFLasttName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tFLasttName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tFLasttName.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -280)
        ])
        
        
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.heightAnchor.constraint(equalToConstant: 60),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -210)
        ])
        
    }


//
//    "body": {
//        "mode": "raw",
//        "raw": "{\r\n    \"username\": \"09125315524\",\r\n    \"code\":\"84090\",\r\n    \"physicalAddress\":\"28-10-7B-4C-B5-60\"\r\n}"
//    },
//    "url": {
//        "raw": "{{domain}}/api/User/verify",
    
    
    
    func showToast(message: String) {
        let toastView = ToastView(message: message)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toastView)

        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        UIView.animate(withDuration: 0.5, animations: {
            toastView.alpha = 1 // Animate alpha value from 0 to 1 over 0.5 seconds
        }, completion: { _ in
            UIView.animate(withDuration: 2.0, animations: {
                toastView.alpha = 0 // Animate alpha value from 1 to 0 over 2 seconds
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        })
    }
    
    private func verifyCode(code :String){
        if self.number != ""{
            // Use the number value here
            print("Number is: \(number)")
            
            let globUrl = "http://94.101.184.60:6060/"

            let strUrl = globUrl + "api/User/verify/"

            
            //number = "09198553651"

            let url = URL(string: strUrl)!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            let parameters: [String: Any] = [
                "username": number,
                "code":code,
                "physicalAddress":"28-10-7B-4C-B5-60"
            ]
            
            
            print("parameters:")
            print(parameters)

            request.httpBody = parameters.percentEncoded()

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
                                
                                if let jsonData = responseString.data(using: .utf8),
                                   let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                                   let result = json["result"] as? [String: Any],
                                   let token = result["token"] as? String {
                                    // Use the token value here
                                    print("Token is: \(token)")
                                    DispatchQueue.main.async {
                                    //alert:
                                        
                                        UserDefaults.standard.set(token, forKey: "bearerToken")

                                        
                                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ShowLogoViewStD") as! ShowLogoView
                                        newViewController.bearerToken = token
                                        
                                        // Set the modal presentation style to full screen
                                        newViewController.modalPresentationStyle = .fullScreen
                                        self.present(newViewController, animated: true, completion: nil)
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                                       
                            
                                print("result"+result)
                            
                            }
                            else{
                                
                                DispatchQueue.main.async {
                                    // Code that modifies the layout of a view
                                    self.showToast(message: "کد وارد شده صحیح نیست")
                                }
                               
                            }
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

        

    
    }

    

    @objc
    private func apiButtonPressed() {

        let globUrl = "http://94.101.184.60:6060/"

        let strUrl = globUrl + "api/User/"

        
        let code = tFCode.text ?? ""
        
        let firstName = tFFirstName.text ?? ""
        let lastName = tFLasttName.text ?? ""
        
        if(firstName != "" && lastName != ""){
            
            let url = URL(string: strUrl)!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            let parameters: [String: Any] = [
                "username": number,
                "firstName":firstName,
                "lastName":lastName,
                "company":companyId
            ]
            
            print("parameters:")
            print(parameters)


            
            request.httpBody = parameters.percentEncoded()

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
                                
//                                self.verifyCode(code: code)
                                DispatchQueue.main.async {
                                //alert:
                                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewStD") as! SignInView
                                    newViewController.number = self.number
                                    self.present(newViewController, animated: true, completion: nil)
                                }
                                
                            }
                            else{
                                DispatchQueue.main.async {
                                    // Code that modifies the layout of a view
                                    self.showToast(message: "مشکلی در ثبت نام پیش آمد")
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
            DispatchQueue.main.async {
                // Code that modifies the layout of a view
                self.showToast(message: "لطفا همه ی بخش ها را پر کنید")
            }
        }



    }


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "SignUpView"{
//
//
//            number = "09198553651"
//
//
//        }
//    }


}
