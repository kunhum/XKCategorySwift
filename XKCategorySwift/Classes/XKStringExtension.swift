//
//  StringExtension_xk.swift
//  Pods
//
//  Created by Nicholas on 2020/5/26.
//

import Foundation
import CommonCrypto

//MARK: - 常用
extension String {
    
    public func xk_toInt() -> Int? {
        return Int(self)
    }
    public func xk_toFloat() -> Float? {
        return Float(self)
    }
    public func xk_toDouble() -> Double? {
        return Double(self)
    }
    public func xk_toCGFloat() -> CGFloat? {
        guard let float = xk_toFloat() else { return nil }
        return CGFloat(float)
    }
    
    //MARK: 截取 to index 包括index下的
    public func xk_subTo(index: Int) -> String {
        var toIndex = index + 1
        if toIndex < 0 {
            toIndex = 0
        }
        if toIndex > count {
            toIndex = count
        }
        return String(prefix(toIndex))
    }
    //MARK: 截取 from index
    public func xk_subFrom(index: Int) -> String {
        var fromIndex = index
        if fromIndex > count {
            fromIndex = count
        }
        fromIndex = count - fromIndex
        return String(suffix(fromIndex))
    }
    //MARK: 从后截取 length：长度
    public func xk_suffix(length: Int) -> String {
        var toLength = length
        if toLength < 0 {
            toLength = 0
        }
        if toLength > count {
            toLength = count
        }
        return String(suffix(toLength))
    }
    //MARK: 截取一段
    /// 截取一段
    /// - Parameters:
    ///   - from: 开始截取的下标
    ///   - to: 结束截取的下标
    /// - Returns: 截取结果
    public func xk_sub(from: Int, to: Int) -> String {
        var fromIndex = from
        if fromIndex < 0 {
            fromIndex = 0
        }
        if fromIndex > count {
            fromIndex = count
        }
        var toIndex = to
        if toIndex < 0 {
            toIndex = 0
        }
        if toIndex > count {
            toIndex = count
        }
        if toIndex < fromIndex {
            toIndex = fromIndex
        }
        
        let fromText = xk_subFrom(index: fromIndex)
        
        let toText   = fromText.xk_subTo(index: toIndex - fromIndex)
        
        return toText
    }
    //MARK: 去除两端的空白字符
    public func xk_trimBlank() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
    //MARK: 去除两端空白和多出的换行
    public func xk_trimBlankAndNewLines() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    //MARK: 格式化价格
    /// 格式化价格，当以x.00结尾时，显示x。以x.x0结尾时，显示x.x
    /// - Parameters:
    ///   - price: 价格
    ///   - mode: 模式 默认为plain： plain, 四舍五入，down, 只舍不入， up, 只入不舍， bankers 四舍六入, 中间值时, 取最近的,保持保留最后一位为偶数
    /// - Returns: 格式化后的价格
    public static func xk_formatterPrice(price: Double, mode: NSDecimalNumber.RoundingMode = .plain) -> String {
        var number    = NSDecimalNumber(floatLiteral: price)
        let handler   = NSDecimalNumberHandler(roundingMode: mode, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        number        = number.rounding(accordingToBehavior: handler)
        var priceText = number.stringValue
        if priceText.hasSuffix(".00") {
            priceText = priceText.replacingOccurrences(of: ".00", with: "")
        }
        else if priceText.hasSuffix("0") {
            priceText = priceText.xk_subTo(index: priceText.count-2)
        }
        
        return priceText
    }
    //MARK: 转换为拼音
    public func xk_convertToPinyin() -> String {

        let mutableName = NSMutableString(string: self) as CFMutableString

        var range = CFRangeMake(0, count)

        //汉字转换为拼音,并去除音调
        if (!CFStringTransform(mutableName, &range, kCFStringTransformMandarinLatin, false) ||
            !CFStringTransform(mutableName, &range, kCFStringTransformStripDiacritics, false)) {
            return "";
        }

        let pinyin = (mutableName as String).replacingOccurrences(of: " ", with: "")

        return pinyin
    }
    //MARK: 获取带声调拼音
    public func xk_convertToTonePinyin() -> String {
        let mutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformMandarinLatin, false)
        return mutableString as String
    }
    //MARK: 不带声调拼音，有空格
    public func xk_removeTone() -> String {
        
        let mutableName = NSMutableString(string: self) as CFMutableString
        var range = CFRangeMake(0, count)
        if (!CFStringTransform(mutableName, &range, kCFStringTransformMandarinLatin, false) ||
            !CFStringTransform(mutableName, &range, kCFStringTransformStripDiacritics, false)) {
            return "";
        }
        return mutableName as String
    }
    //MARK: 拼音首字母，默认大写
    public func xk_firstLetterOfPinyin(uppercased: Bool = true) -> String {
        
        guard count > 0 else {
            return ""
        }
        
        let mutableName = NSMutableString(string: self) as CFMutableString
        
        var range = CFRangeMake(0, 1)
        
        //汉字转换为拼音,并去除音调
        if (!CFStringTransform(mutableName, &range, kCFStringTransformMandarinLatin, false) ||
            !CFStringTransform(mutableName, &range, kCFStringTransformStripDiacritics, false)) {
            return "";
        }
        
        let letter = (mutableName as String).xk_subTo(index: 0)
        
        return uppercased ? letter.uppercased() : letter
    }
    //MARK: 是否为emoji
    public func xk_isEmoji() -> Bool {
        
        let text         = self as NSString
        let characterset = NSCharacterSet(range: NSRange(location: 0xFE00, length: 16)).inverted
        guard text.rangeOfCharacter(from: characterset).location == NSNotFound else {
            return true
        }
        
        let high: unichar = text.character(at: 0)
        if 0xD800 < high && high <= 0xDBFF {
            let low: unichar = text.character(at: 1)
            let codePoint = Int(((high - 0xD800) * 0x400) + (low - 0xDC00)) + 0x10000
            
            return (0x1D000 <= codePoint && codePoint <= 0x1F9FF)
        }
        
        return (0x2100 <= high && high <= 0x27BF)
    }
    //MARK: 是否包含emoji
    public func xk_containEmoji() -> Bool {
        
        for (_, element) in self.enumerated() {
            
            let text = String(element)
            
            guard text.xk_isEmoji() == false else {
                return true
            }
        }
        return false
    }
    //MARK: 移除emoji
    public func xk_removeEmoji() -> String {
        
        let text = self as NSString
        var resultText = ""
        text.enumerateSubstrings(in: NSRange(location: 0, length: text.length), options: .byComposedCharacterSequences) { (tmpString, substringRange, enclosingRange, stop) in
            
            if let subText = tmpString {
                resultText.append(subText.xk_isEmoji() ? "" : subText)
            }
        }
        return resultText
    }
    //MARK: 获取随机字符串
    public static func xk_randomText(length: Int) -> String {
        var text = ""
        for _ in 0..<length {
            let number = arc4random() % 10
            text.append(String(format: "%d", number))
        }
        
        return text
    }
    //MARK: h5转换为attributedText
    public func xk_convertH5ToAttributedString(width: CGFloat = UIScreen.main.bounds.width - 20.0) -> NSAttributedString {
        
        let text = String(format: "<head><style>img{max-width:%fpx;height:auto !important;}</style></head>", width)
        let tmpStr = text + self
        guard let data = tmpStr.data(using: .unicode) else { return NSAttributedString() }
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributedString
        }
        catch {
            
        }
        
        return NSAttributedString()
    }
    //MARK: 转换H5以适应WKWebView
    public func xk_convertH5ToFitWKWebView(width: CGFloat = UIScreen.main.bounds.width - 20.0) -> String {
        let header = String(format: "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header><head><style>img{max-width:%fpx !important;}</style></head>", width)
        return header + self
    }
    //MARK: URLEncode
    public func xk_urlEncoded() -> String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'\"();:@&=+$,/?%#[]% ").inverted) ?? self
    }
    //MARK: 复制到剪切板
    public func xk_copyToPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
    //MARK: 将字符串转为日期
    public func xk_convertToDate(formatter: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.date(from: self)
    }
    //MARK: 正则判断
    public func xk_match(regex: String) -> Bool {
        //SELF MATCHES 一定是大写
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    //MARK: 验证字符串是否符合
    public func xk_validateWithCharacterSet(inString: String) -> Bool {
        
        let characterSet = CharacterSet(charactersIn: inString)
        var i = 0
        while i < count {
            let string = xk_sub(from: i, to: i)
            let range  = string.rangeOfCharacter(from: characterSet)
            if range == nil {
                return false
            }
            i += 1
        }
        return true
    }
    //MARK: 是否包含中文
    public func xk_containChinese() -> Bool {
        
        let text = self as NSString
        for i in 0..<text.length {
            let character = text.character(at: i)
            if character > 0x4e00 && character < 0x9fff {
                return true
            }
        }
        return false
    }
    //MARK: 处理字符串中的中文
    public func xk_encodeChinese() -> String {
        let hasChinese = xk_containChinese()
        guard hasChinese else {
            return self
        }
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "`#%^{}\"[]|\\<> ").inverted) ?? self
    }
    //MARK: 打电话
    public func xk_phone() {
        DispatchQueue.main.async {
            
            let phone = "telprompt://" + self
            guard let url = URL(string: phone) else { return }
            guard UIApplication.shared.canOpenURL(url) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    //MARK: 判断是否为数字
    public func xk_isNumber() -> Bool {
        guard count > 0 else {
            return false
        }
        let filtered = components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).joined(separator: "")
        if filtered != self {
            return false
        }
        
        return true
    }
    //MARK: 筛选字符串
    public func xk_fliterNumber() -> String {
        var text = ""
        for (_, element) in self.enumerated() {
            let letter = String(element)
            if letter.xk_isNumber() {
                text.append(letter)
            }
        }
        return text
    }
    
}
//MARK: - 加密
extension String {
    
    public func xk_MD5() -> String {
        
        let str       = cString(using: String.Encoding.utf8)
        let strLen    = CUnsignedInt(lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result    = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash      = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: count)
        
        return String(format: hash as String)
    }
    public func xk_base64() -> String? {
        let data = self.data(using: .utf8)
        return data?.base64EncodedString()
    }
    public static func xk_decode(base64: String) -> String? {
        guard let data = Data(base64Encoded: base64) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    public func xk_SHA1() -> String? {
        
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        var digest  = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        let newData = NSData.init(data: data)
        CC_SHA1(newData.bytes, CC_LONG(data.count), &digest)
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
}

//MARK: - 验证
extension String {
    //MARK: 是否电话（包含座机和手机）
    public func xk_isPhone() -> Bool {
        return xk_isMobileNumber() || xk_isTelphoneNumber()
    }
    /*
     手机号码
     移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     联通：130,131,132,152,155,156,185,186,1709
     电信：133,1349,153,180,189,1700
     NSString * MOBILE = "^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
     */
    
    //MARK: 是否为国内服务商
    public func xk_isChineseMobile() -> Bool {
        /**
        10         * 中国移动：China Mobile
        11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
        12         */
        let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$"
        /**
        15         * 中国联通：China Unicom
        16         * 130,131,132,152,155,156,185,186,1709
        17         */
        let CU = "^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$"
        /**
        20         * 中国电信：China Telecom
        21         * 133,1349,153,180,189,1700
        22         */
        let CT = "^1((33|53|8[09])\\d|349|700)\\d{7}$"
        /**
        25         * 大陆地区固话及小灵通
        26         * 区号：010,020,021,022,023,024,025,027,028,029
        27         * 号码：七位或八位
        28         */
        let PHS = "^0(10|2[0-5789]|\\d{3})\\d{7,8}$"
        
        return xk_match(regex: CM) || xk_match(regex: CU) || xk_match(regex: CT) || xk_match(regex: PHS)
    }
    //MARK: 是否有效电话
    public func xk_isMobileNumber() -> Bool {
        let mobile = "^(1)\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", mobile)
        return predicate.evaluate(with: self)
    }
    //MARK: 验证是否座机
    public func xk_isTelphoneNumber() -> Bool {
        let stringNumber  = "^(0\\d{2,3}-?\\d{7,8}$)"
        let predicate     = NSPredicate(format: "SELF MATCHES %@", stringNumber)
        let isPhone       = predicate.evaluate(with: self)
        let stringNumber1 = "^(\\d{7,8}$)"
        let predicate1    = NSPredicate(format: "SELF MATCHES %@", stringNumber1)
        let isPhone1      = predicate1.evaluate(with: self)
        return isPhone || isPhone1
    }
    //MARK: 是否邮箱
    public func xk_isEmailAddress() -> Bool {
        return xk_match(regex: "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    }
    //MARK: 是否mac address
    public func xk_isMacAddress() -> Bool {
        return xk_match(regex: "([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}")
    }
    //MARK: 是否有效URL
    public func xk_isValidURL() -> Bool {
        return xk_match(regex: "^((http)|(https))+:[^\\s]+\\.[^\\s]*$")
    }
    //MARK: 是否只是中文
    public func xk_justChinese() -> Bool {
        return xk_match(regex: "^[\\u4e00-\\u9fa5]+$")
    }
    //MARK: 是否有效邮政编码
    public func xk_isValidPostalCode() -> Bool {
        return xk_match(regex: "^[0-8]\\d{5}(?!\\d)$")
    }
    //MARK: 验证字符串
    public func xk_isValid(minLength: Int, maxLength: Int, containChinese: Bool, firstCanNotBeDigtal: Bool) -> Bool {
        let chinese = containChinese ? "\\u4e00-\\u9fa5" : ""
        let first   = firstCanNotBeDigtal ? "^[a-zA-Z_]" : ""
        let regex   = String(format: "%@[%@A-Za-z0-9_]{%d,%d}", first, chinese, minLength, maxLength)
        return xk_match(regex: regex)
    }
    
    /// 验证字符串
    /// - Parameters:
    ///   - minLength: 最小长度
    ///   - maxLength: 最大长度
    ///   - containChinese: 是否可以包含中文
    ///   - firstCanNotBeDigtal: 首字母是否可以为数字
    ///   - containDigtal: 是否可以有数字
    ///   - needContainLetter: 是否可以包含字母
    /// - Returns: 结果
    public func xk_isValid(minLength: Int, maxLength: Int, containChinese: Bool, firstCanNotBeDigtal: Bool, containDigtal: Bool, needContainLetter: Bool) -> Bool {
        let chinese = containChinese ? "\\u4e00-\\u9fa5" : ""
        let first   = firstCanNotBeDigtal ? "^[a-zA-Z_]" : ""
        let lengthRegex = String(format: "(?=^.{%d,%d}$)", minLength, maxLength)
        let digtalRegex = containDigtal ? "(?=(.*\\d.*){1})" : ""
        let letterRegex = needContainLetter ? "(?=(.*[a-zA-Z].*){1})" : ""
        let characterRegex = String(format: "(?:%@[%@A-Za-z0-9]+)", first, chinese)
        
        let regex = lengthRegex + digtalRegex + letterRegex + characterRegex
        
        return xk_match(regex: regex)
    }
    //MARK: 是否为ip地址
    public func xk_isIPAddress() -> Bool {
        let regex     = "^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result    = predicate.evaluate(with: self)
        if result {
            let componds = components(separatedBy: ",")
            for element in componds {
                if element.xk_toInt() ?? 0 > 255 {
                    return false
                }
            }
            return true
        }
        return false
    }
    //MARK: 是否身份证
    public func xk_isIDCard() -> Bool {
        return xk_match(regex: "^(\\d{14}|\\d{17})(\\d|[xX])$")
    }
    //MARK: 精确验证身份证
    public func xk_verifyIDCard() -> Bool {
        
        var value  = xk_trimBlankAndNewLines()
        value      = value.replacingOccurrences(of: " ", with: "")
        
        let length = value.count
        guard length == 15 || length == 18 else {
            return false
        }
        //省份
        let areasArray = ["11","12", "13","14", "15","21", "22","23", "31","32", "33","34", "35","36", "37","41", "42","43", "44","45", "46","50", "51","52", "53","54", "61","62", "63","64", "65","71", "81","82", "91"]
        
        let valueStart = value.xk_subTo(index: 1)
        
        var areaFlag = false
        for areaCode in areasArray {
            if areaCode == valueStart {
                areaFlag = true
                break
            }
        }
        
        guard areaFlag else {
            return false
        }
        
        var regularExpression = NSRegularExpression()
        var numberOfMatch = 0
        
        var year = 0
        
        if length == 15 {
            
            year = value.xk_sub(from: 6, to: 7).xk_toInt()! + 1900
            
            let pattern = year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) ? "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" : "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
            
            //检查出生日期的合法性
            do {
                regularExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            }
            catch {
                
            }
            
            numberOfMatch = regularExpression.numberOfMatches(in: value, options: .reportProgress, range: NSRange(location: 0, length: value.count))
            
            return numberOfMatch > 0
            
        }
        //length == 18
        year = value.xk_sub(from: 6, to: 9).xk_toInt()!
         
        let pattern = year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) ? "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" : "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
        
        //检查出生日期的合法性
        do {
            regularExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        }
        catch {
            
        }
        
        numberOfMatch = regularExpression.numberOfMatches(in: value, options: .reportProgress, range: NSRange(location: 0, length: value.count))
        
        guard numberOfMatch > 0 else {
            return false
        }
        var s = (value.xk_sub(from: 0, to: 0).xk_toInt()! + value.xk_sub(from: 10, to: 10).xk_toInt()!) * 7
        s += (value.xk_sub(from: 1, to: 1).xk_toInt()! + value.xk_sub(from: 11, to: 11).xk_toInt()!) * 9
        s += (value.xk_sub(from: 2, to: 2).xk_toInt()! + value.xk_sub(from: 12, to: 12).xk_toInt()!) * 10
        s += (value.xk_sub(from: 3, to: 3).xk_toInt()! + value.xk_sub(from: 13, to: 13).xk_toInt()!) * 5
        s += (value.xk_sub(from: 4, to: 4).xk_toInt()! + value.xk_sub(from: 14, to: 14).xk_toInt()!) * 8
        s += (value.xk_sub(from: 5, to: 5).xk_toInt()! + value.xk_sub(from: 15, to: 15).xk_toInt()!) * 4
        s += (value.xk_sub(from: 6, to: 6).xk_toInt()! + value.xk_sub(from: 16, to: 16).xk_toInt()!) * 2
        s += value.xk_sub(from: 7, to: 7).xk_toInt()!
        s += value.xk_sub(from: 8, to: 8).xk_toInt()! * 6
        s += value.xk_sub(from: 9, to: 9).xk_toInt()! * 3
        
        let y   = s % 11
        var m   = "F"
        let jym = "10X98765432"
        m       = jym.xk_sub(from: y, to: y)
        return m == value.xk_sub(from: 17, to: 17)
    }
    
    //MARK: 检查银行卡是否有效
    public func xk_isValidBankCard() -> Bool {
        
        let cardNumber = replacingOccurrences(of: " ", with: "")
        
        let lastNum = cardNumber.xk_subFrom(index: count - 2)
        let forwardNum = cardNumber.xk_subTo(index: count - 3)
        
        var forwardArr = [String]()
        for (_, element) in cardNumber.enumerated() {
            forwardArr.append(String(element))
        }
        var forwardDescArr = [String]()
        for i in 0..<forwardArr.count-1 {
            forwardDescArr.append(forwardArr[(forwardArr.count-2) - i])
        }
        
        var arrOddNum  = [Int]()
        var arrOddNum2 = [Int]()
        var arrEvenNum = [Int]()
        
        for (index, element) in forwardDescArr.enumerated() {
            let number = element.xk_toInt()!
            if index % 2 != 0 {
                arrEvenNum.append(number)
            }
            else {
                
                if number * 2 < 9 {
                    arrOddNum.append(number * 2)
                }
                else {
                    let decadeNum = number * 2 / 10
                    let unitNum   = number * 2 % 10
                    arrOddNum2.append(unitNum)
                    arrOddNum2.append(decadeNum)
                }
            }
        }
        
        var sumOddNumTotal = 0
        for (_, element) in arrOddNum.enumerated() {
            sumOddNumTotal += element
        }
        var sumOddNum2Total = 0
        for (_, element) in arrOddNum2.enumerated() {
            sumOddNum2Total += element
        }
        var sumEvenNumTotal = 0
        for (_, element) in arrEvenNum.enumerated() {
            sumEvenNumTotal += element
        }
        let lastNumber = lastNum.xk_toInt()!
        let luhmTotal  = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal
        
        return luhmTotal % 10 == 0
    }
}

