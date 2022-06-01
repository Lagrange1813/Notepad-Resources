//
//  AttributesCommandTests.swift
//  ProtonTests
//
//  Created by Rajdeep Kwatra on 23/7/21.
//  Copyright © 2021 Rajdeep Kwatra. All rights reserved.
//

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import XCTest

import Proton

class AttributesCommandTests: XCTestCase {
    func testSetsTypingAttributesInEmptyEditor() throws {
        let editor = EditorView()
        let command = UnderlineCommand()

        command.execute(on: editor)
        let updatedStyle = try XCTUnwrap(editor.typingAttributes[.underlineStyle] as? Int)
        XCTAssertEqual(updatedStyle, NSUnderlineStyle.single.rawValue)
    }

    func testSetsToggledTypingAttributesInEmptySelectionInNonEmptyEditor() throws {
        let editor = EditorView()
        editor.replaceCharacters(in: .zero, with: "This is a test")
        editor.selectedRange = NSRange(location: 0, length: 4)
        let command = StrikethroughCommand()
        command.execute(on: editor)

        editor.selectedRange = NSRange(location: 4, length: 0)
        command.execute(on: editor)

        let updatedStyle = editor.typingAttributes[.strikethroughStyle] as? Int
        XCTAssertNil(updatedStyle)
    }
}
