//
//  ViewController.swift
//  RichTextEditor
//
//  Created by 张维熙 on 2022/7/7.
//

import UIKit
import SnapKit
import RegexBuilder

class ViewController: UIViewController {
    let editor = EditorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        layoutEditorView()
        configureEditorView()
    }
    
    func layoutEditorView() {
        
        view.addSubview(editor)
        
        editor.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }

    func configureEditorView() {
        let path = Bundle.main.path(forResource: "Editor", ofType: "html") ?? ""
        let request = URLRequest(url: URL(fileURLWithPath: path))
        editor.load(request)
    }
}

