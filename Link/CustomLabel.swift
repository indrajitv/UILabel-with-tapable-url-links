//
//  CustomLabel.swift
//  Link
//
//  Created by sculpsoft-mac on 04/01/19.
//  Copyright © 2019 IND. All rights reserved.
//

import UIKit


extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}

@IBDesignable class CustomLabel:UILabel{
    
    
    typealias CompletionHanlder = (String)->Void
    var completionHanlder:CompletionHanlder?
    var urls = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setGesture()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setGesture()
    }
    
    
    
    func setGesture(){
        numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    func setTextWithLinks(textWithString:String,font:UIFont = UIFont.systemFont(ofSize: 16),completionHander:@escaping CompletionHanlder){
        
        self.completionHanlder = completionHander
        let attributedString = NSMutableAttributedString(string: textWithString, attributes: [NSAttributedString.Key.font : font])
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: textWithString, options: [], range: NSRange(location: 0, length: textWithString.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: textWithString) else { continue }
            let urlFound = textWithString[range]
            urls.append(String(urlFound))
            let linkRange = (textWithString as NSString).range(of: String(urlFound))
            let linkAttributes: [NSAttributedString.Key : AnyObject] = [
                NSAttributedString.Key.foregroundColor : UIColor.blue, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue as AnyObject,
                NSAttributedString.Key.link: urlFound as AnyObject,NSAttributedString.Key.font : font]
            attributedString.setAttributes(linkAttributes, range:linkRange)
        }
        self.attributedText = attributedString
    }
    
    @objc func tapLabel(tap: UITapGestureRecognizer) {
        
        for urlToCheck in urls{
            if let range = self.attributedText?.string.range(of: urlToCheck)?.nsRange {
                if tap.didTapAttributedTextInLabel(label: self, inRange: range) {
                    
                    
                    self.completionHanlder?(urlToCheck)
                }
            }
            
        }
    }
    
    
}


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
