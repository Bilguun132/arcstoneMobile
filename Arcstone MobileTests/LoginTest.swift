//
//  LoginTest.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 1/3/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import Foundation
import KIF

class LoginTests: KIFTestCase {
    
    func testEmptyUserNamePassword() {
        clearFields()
        tapButton(buttonName: "Login")
        expectToSeeAlert(Alert: "Username or password field is empty")
        tapButton(buttonName: "OK")
        expectToSeeView(VCName: "Login Page")
    }
    func testEmptyPassword() {
        clearFields()
        fillText(Value: "Admin", Label: "password")
        tapButton(buttonName: "Login")
        expectToSeeAlert(Alert: "Username or password field is empty")
        tapButton(buttonName: "OK")
        expectToSeeView(VCName: "Login Page")
    }
    func testFilledFields() {
        clearFields()
        fillText(Value: "Admin", Label: "username")
        fillText(Value: "admin", Label: "password")
        tapButton(buttonName: "Login")
        tester().waitForAnimationsToFinish()
        expectToLogin()
    }
}

extension LoginTests {
    
    func fillText(Value: String, Label: String){
        tester().enterText(Value, intoViewWithAccessibilityLabel: Label)
    }
    
    func clearFields() {
        tester().clearTextFromView(withAccessibilityLabel: "username")
        tester().clearTextFromView(withAccessibilityLabel: "password")
    }
    
    func tapButton(buttonName: String) {
        tester().tapView(withAccessibilityLabel: buttonName)
    }
    
    func expectToSeeView(VCName: String) {
        tester().waitForView(withAccessibilityLabel: VCName)
    }
    
    func expectToLogin() {
        // expect login screen to disappear
        tester().waitForAbsenceOfView(withAccessibilityLabel: "username")
        tester().waitForAbsenceOfView(withAccessibilityLabel: "password")
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Login")
    }
    
    func expectToSeeAlert(Alert: String) {
        tester().waitForView(withAccessibilityLabel: Alert)
    }
}
