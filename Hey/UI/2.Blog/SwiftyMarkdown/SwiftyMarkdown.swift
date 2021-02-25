//
//  SwiftyMarkdown.swift
//  SwiftyMarkdown
//
//  Created by Simon Fairbairn on 05/03/2016.
//  Copyright © 2016 Voyage Travel Apps. All rights reserved.
//

public struct SwiftyLine : CustomStringConvertible {
    public var line : String
    public var lineStyle : MarkdownLineStyle
    public var description: String {
        return self.line
    }
    public var id = String(arc4random())
    
    init(_ style:MarkdownLineStyle,_ line:String = "") {
        self.lineStyle = style
        if style == .line{
            self.line = ""
        }else{
            self.line = line
        }
    }
    
    static func getStyle(_ str:String) -> SwiftyLine{
        print(str)
        if str.count == 0{
            return SwiftyLine(.blank, "")
        }
        if str.hasPrefix(MarkdownLineStyle.line.prefix){
            return SwiftyLine(.line, "") }
        if str.hasPrefix(MarkdownLineStyle.image.prefix){
            return SwiftyLine(.image, str) }
        
        var style:MarkdownLineStyle = .body
        if str.hasPrefix(MarkdownLineStyle.h5.prefix){
            style = .h5}
        if str.hasPrefix(MarkdownLineStyle.h4.prefix){
            style = .h4}
        if str.hasPrefix(MarkdownLineStyle.h3.prefix){
            style = .h3}
        if str.hasPrefix(MarkdownLineStyle.h2.prefix){
            style = .h2}
        if str.hasPrefix(MarkdownLineStyle.h1.prefix){
            style = .h1}
        if str.hasPrefix(MarkdownLineStyle.point.prefix){
            style = .point}
        if str.hasPrefix(MarkdownLineStyle.blockquote.prefix){
            style = .blockquote}
        
        var content = str.replacingOccurrences(of: style.prefix, with: "")
        content = content.trimmingCharacters(in: .whitespaces)
        return SwiftyLine(style, content)
    }
}

public enum MarkdownLineStyle {
    // 末尾4个空格表示换行
    static var lineBreak = "    "

    case blockquote //<开头的引言
    case h1,h2,h3,h4,h5
    case body,point //正文
    case line //---开头的横线
    case image
    case blank

    var prefix: String {
        switch self {
        case .h1: return "# "
        case .h2: return "## "
        case .h3: return "### "
        case .h4: return "#### "
        case .h5: return "##### "
        case .blockquote: return ">"
        case .point:return "- "
        case .line: return "---"
        case .image: return "<img "
        default: return ""
        }
    }
    
    var tag:Int{
        switch self {
        case .h1, .h2, .h3, .h4, .h5: return 700
        case .point: return 710
        case .blockquote: return 720
        default: return 799
        }
    }
    
    var textTineColor:UIColor{
        switch self {
            case .h1: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case .h2, .h3, .h4: return #colorLiteral(red: 0.2460927069, green: 0.2818101943, blue: 0.3550435305, alpha: 1)
            case .h5:   return #colorLiteral(red: 0.4361771941, green: 0.4703575969, blue: 0.5030658245, alpha: 1)
            case .point, .body: return #colorLiteral(red: 0.4287292957, green: 0.4555818439, blue: 0.5058395863, alpha: 1)
            case .blockquote:   return #colorLiteral(red: 0.623719275, green: 0.6563655138, blue: 0.6766352057, alpha: 1)
            case .line: return #colorLiteral(red: 0.9165264368, green: 0.9431640506, blue: 0.9248352647, alpha: 1)
            default:    return #colorLiteral(red: 0.2063571811, green: 0.2418213487, blue: 0.2459937334, alpha: 1)
        }
    }
    
    var font:UIFont{
        switch self {
        case .h1:
            return UIFont.systemFont(ofSize: 26, weight: .heavy)
        case .h2, .h3, .h4:
            return UIFont.systemFont(ofSize: 23, weight: .heavy)
        case .h5:
            return UIFont.systemFont(ofSize: 20, weight: .heavy)
        case .body, .point:
            return UIFont.systemFont(ofSize: 15)
        case .blockquote:
            return UIFont.systemFont(ofSize: 14)
        default:
            return UIFont.systemFont(ofSize: 17)
        }
    }
    
    // 打断上一个Style的样式
    var breakFrontLine: Bool{
        switch self {
            case .body:
                return false
            default:
                return true
        }
    }
    
    // 换行打断样式
    var breakNextLine: Bool{
        switch self {
            case .blockquote, .point, .body:
                return false
            default:
                return true
        }
    }
}


@objc open class SwiftyMarkdown: NSObject {
    
    static func getlines(_ string:String) -> [SwiftyLine] {
        var lines : [SwiftyLine] = []
        let arr = string.components(separatedBy: "\n")
        var lastLine:SwiftyLine? = nil
        for  line in arr {
            let nextLine = SwiftyLine.getStyle(line)
            if lastLine != nil{
                if nextLine.lineStyle.breakFrontLine{
                    // 移除末尾空格
                    lastLine!.line = lastLine!.line.replacingOccurrences(of: "    \n", with: "\n")
                    while lastLine!.line.contains(" \n") {
                        lastLine!.line = lastLine!.line.replacingOccurrences(of: " \n", with: "\n")
                    }
                    lastLine!.line = lastLine!.line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    // 打断上一行的样式
                    lines.append(lastLine!)
                    if line.count == 0{
                        lastLine = nil
                    }else{
                        lastLine = nextLine
                    }
                }else{
                    lastLine?.line.append("\n")
                    lastLine?.line.append(line)
                    continue
                }
            }else{
                if line.count == 0{
                    continue
                }else{
                    lastLine = nextLine
                }
            }
            if lastLine != nil && lastLine!.lineStyle.breakNextLine{
                lines.append(lastLine!)
                lastLine = nil
            }
        }
        if lastLine != nil{
            lines.append(lastLine!)
        }
        return lines
    }
    
}
