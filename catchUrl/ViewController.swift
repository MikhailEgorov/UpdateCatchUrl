//
//  ViewController.swift
//  catchUrl
//
//  Created by Егоров Михаил on 30.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var imageGifView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var btnGoAnsweView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        answerLabel.isHidden = true
        btnGoAnsweView.layer.cornerRadius = 10
        btnGoAnsweView.layer.borderWidth = 1
        btnGoAnsweView.layer.borderColor = UIColor.blue.cgColor
        btnGoAnsweView.setTitle("What do you think ?", for: .normal)
    }

    @IBAction func buttonGoAnswer() {
        
        setView()
        
        NetworkManager.shared.fetch(from: Link.LinkURL.rawValue) { result in
            switch result {
            case .success(let success):
                guard let urlImage1 = success.image else {return}
                guard let urlSay1 = success.answer else {return}
                self.fetchGif(with: urlImage1, and: urlSay1)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func setView() {
        btnGoAnsweView.layer.borderWidth = 0
        btnGoAnsweView.isEnabled = false
        btnGoAnsweView.setTitle("Well, i think is ... ", for: .normal)
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
    }
    private func fetchGif(with answer: String, and urlSay: String) {
        NetworkManager.shared.fetchImage(from: answer) { result in
            switch result {
            case .success(let success):
                self.imageGifView.image = UIImage.gifImageWithData(success)
                self.answerLabel.text = urlSay.uppercased()
                self.changeBackground()
                self.answerLabel.isHidden = false
                self.activityIndicator.stopAnimating()
                self.btnGoAnsweView.setTitle("What do you think ?", for: .normal)
                self.btnGoAnsweView.isEnabled = true
                self.btnGoAnsweView.layer.borderWidth = 1
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func changeBackground() {
            if self.answerLabel.text == "YES" {
                self.view.backgroundColor = .green
            } else {
                self.view.backgroundColor = .red
            }
    }
}

