//
//  ViewController.swift
//  Regex-Test
//
//  Created by 张维熙 on 2022/6/1.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let displayTextView = DisplayTextView()
    let regexTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        configureTextView()
        configureTextField()
    }
    
    func configureTextView() {
        displayTextView.backgroundColor = .systemGray2
        view.addSubview(displayTextView)
        
        displayTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(400)
        }
        
        // ^(\#[^\#](.*))$
        // ^(\#{2}(.*))$
        // ^(\#{3}(.*))$
 
        displayTextView.text = """
# Header1
## Header2
### Header3
- list1
* list2
*emphasis*
_italistic_
# Header1 ## Header2
## Header2
### Header3
- list1
* list2
*emphasis*
_italistic_
# Header1
## Header2
### Header3 # Header1
- list1
* list2
*emphasis*
_italistic_
# Header1
## Header2
### Header3
- list1
* list2
*emphasis*
_italistic_
"""
    }
    
    func configureTextField() {
        regexTextField.backgroundColor = .systemGray3
        regexTextField.returnKeyType = .done
        regexTextField.delegate = self
        view.addSubview(regexTextField)
        
        regexTextField.snp.makeConstraints { make in
            make.top.equalTo(displayTextView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
        
        displayTextView.refreshStyle(with: textField.text ?? "")
    
    }
}

