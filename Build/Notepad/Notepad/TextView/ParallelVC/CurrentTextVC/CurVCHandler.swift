//
//  CurVCHandler.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/22.
//

import UIKit

extension CurrentTextVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mdDisplayVC.synchronizedProportion = textField.contentOffset.y/max(textField.contentSize.height, 30)
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        
        mdDisplayVC.synchronizedTitle = textField.titleView.text
        mdDisplayVC.synchronizedBody = textField.bodyView.text
    }
}
