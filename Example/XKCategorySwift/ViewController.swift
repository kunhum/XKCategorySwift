//
//  ViewController.swift
//  XKCategorySwift
//
//  Created by kunhum on 05/26/2020.
//  Copyright (c) 2020 kunhum. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let text = "123456"
        print(text.xk_subTo(index: 1))
        print(text.xk_subFrom(index: 1))
        print(text.xk_sub(from: 1, to: 4))
        print(text.xk_suffix(length: 2))
        
        print(text.xk_toInt())
        print(text.xk_toFloat())
        print(text.xk_toCGFloat())
        
        print(String.xk_formatterPrice(price: 57.00))
        
        print(" 23 ")
        print(" 23 ".xk_trimBlank())
        print(" 23 \n")
        print(" 23 \n".xk_trimBlankAndNewLines())
        print("23\n".xk_trimBlankAndNewLines())
        print("--------")
        
        print("嘻哈哈".xk_convertToPinyin())
        print("嘻哈哈".xk_firstLetterOfPinyin())
        
        print("123😭".xk_isEmoji())
        print("123👍".xk_containEmoji())
        print("123🐔".xk_removeEmoji())
        
        print("你好".xk_convertToTonePinyin())
        print("你好".xk_removeTone())
        
        print("你好".xk_urlEncoded())
        print("你好".xk_urlEncoded().removingPercentEncoding)
        
        "大黄鸭".xk_copyToPasteboard()
        print("2019-10-01 22:03:34".xk_convertToDate(formatter: "yyyy-MM-dd HH:mm:ss"))
        
        print(text.xk_sub(from: 0, to: 0))
        
        print("啊哈".xk_validateWithCharacterSet(inString: "0123456789."))
        
        print("1243".xk_containChinese())
        
        print("啊啊1234".xk_encodeChinese())
        
//        "13268376712".xk_phone()
        
        print("1235".xk_isNumber())
        print("2熬4片9".xk_fliterNumber())
        
        print("1234".xk_MD5().uppercased())
        print("1234".xk_base64())
        print(String.xk_decode(base64: "1234".xk_base64()!))
        print("1234".xk_SHA1()!)
        
        print("13268376712".xk_isChineseMobile())
        print("19968376712".xk_isMobileNumber())
        
        print("440111200008249872".xk_isIDCard())
        print("842222367@qq.com".xk_isEmailAddress())
        print("https://www.baidu.com".xk_isValidURL())
        
        print("啪啪啪".xk_justChinese())
        
        print("510445".xk_isValidPostalCode())
        
        print("5中1044578".xk_isValid(minLength: 6, maxLength: 9, containChinese: true, firstCanNotBeDigtal: false))
        
        print("5中1044570".xk_isValid(minLength: 6, maxLength: 9, containChinese: true, firstCanNotBeDigtal: false, containDigtal: true, needContainLetter: true))
        
        print("192.168.1.1".xk_isIPAddress())
        
        print("-------------------")
        print("440111200008249872".xk_verifyIDCard())
        print("440111000824987".xk_verifyIDCard())
        print("-------------------")
        print("621233 7011119374611".xk_isValidBankCard())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(String.xk_randomText(length: 4))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

