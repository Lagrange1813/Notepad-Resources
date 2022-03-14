//
//  CurVCHandler.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/22.
//

import UIKit

extension CurrentTextVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mdDisplayVC.synchronizedContentOffset = articleField.contentOffset
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        
        mdDisplayVC.synchronizedTitle = articleField.titleView.text
        mdDisplayVC.synchronizedBody = articleField.bodyView.text
    }
}
