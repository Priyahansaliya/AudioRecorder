//import SwiftUI
//import WebKit
//
//struct DynamicWebView: UIViewRepresentable {
//    let htmlContent: String
//    var fontSize: CGFloat = 16.0 // Default font size
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        webView.navigationDelegate = context.coordinator
//        webView.scrollView.isScrollEnabled = false // Disable scrolling in the webview to manage dynamic height
//        return webView
//    }
//    
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        let htmlWithFontSize = """
//        <html>
//        <head>
//        <style>
//        body { font-size: \(fontSize)px; }
//        </style>
//        </head>
//        <body>
//        \(htmlContent)
//        </body>
//        </html>
//        """
//        webView.loadHTMLString(htmlWithCSS(strContent: htmlWithFontSize), baseURL: nil)
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var parent: DynamicWebView
//        
//        init(_ parent: DynamicWebView) {
//            self.parent = parent
//        }
//        
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            webView.evaluateJavaScript("document.body.scrollHeight") { (result, error) in
//                if let height = result as? CGFloat {
//                    webView.frame.size.height = height
//                }
//            }
//        }
//    }
//    
//    //MARK:- CSS
//    func htmlWithCSS(strContent: String) -> String {
//        let strCSS: String = """
//        <header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>
//<html>
//<style>
//    @font-face
//    {
//        font-family: 'Open Sans';
//        font-weight: normal;
//        src: url(ProximaNova-Regular.otf);
//    }
//    @font-face
//    {
//        font-family: 'Open Sans';
//        font-weight: bold;
//        src: url(ProximaNova-Semibold.otf);
//    }
//    @font-face
//    {
//        font-family: 'Open Sans';
//        font-weight: 500;
//        src: url(ProximaNova-Semibold.otf);
//    }
//    @font-face
//    {
//        font-family: 'Open Sans';
//        font-weight: 900;
//        src: url(ProximaNova-Extrabold.otf);
//    }
//</style>
//<body style="font-family: 'Open Sans'; img{width:100%;};">\(strContent)</body>
//</html>
//"""
//        return strCSS
//    }
//}
//
//struct DContentView: View {
//    @State private var fontSize: CGFloat = 16.0
//    let htmlContent = "<p>Minister of State for Home Affairs, Ajay Kumar Mishra today chaired a meeting with Sikkim chief secretary, departments, Army, ITBP, BRO, NHIDCL and NHPC at Tashiling Secretariat in Gangtok.<br/>\n <br/>\nAddressing the meeting, Mr Mishra said that the central government is closely monitoring the situation in Sikkim and all necessary assistance for the state is being provided. He said that the Prime Minister and the Union Home Minister are in constant touch with Sikkim Chief Minster.<br/>\n <br/>\nHe informed that the central government has constituted an inter-ministerial committee comprising senior officers from five ministries, agriculture, road transport & highways, Jal Shakti, energy, and finance. The committee will visit Sikkim from tomorrow to take stock of the ground situation, assess damages, and provide assistance.<br/>\n <br/>\nMr Mishra informed that the central government has granted an advance sanction of the allocated budget for NDRF and SDRF for 2023-24 to enable the state to carry out immediate rescue, relief, and restoration.<br/>\n <br/>\nHe assured that the central government will leave no stone unturned to restore normalcy in Sikkim. He urged state government officials to prepare short-term and long-term plans to effectively rebuild infrastructure.<br/>\n <br/>\nEarlier, Sikkim chief secretary VB Pathak briefed Mr Mishra about the sequence of events leading to the disaster, consequent damages and relief work.<br/>\n <br/>\nMr Mishra earlier met Sikkim Governor Lakshman Prasad Acharya at Raj Bhavan, Gangtok and assured all support from the central government to overcome the crisis./p>\n"
//    
//    var body: some View {
//        VStack {
//            Slider(value: $fontSize, in: 10...120, step: 1) {
//                Text("Font Size")
//            }
//            .padding()
//            
//            DynamicWebView(htmlContent: htmlContent, fontSize: fontSize)
//                .frame(height: 300) // Adjust the frame height as needed
//        }
//    }
//}

#Preview{
    DContentView()
}
import SwiftUI
import WebKit

struct DynamicWebView: UIViewRepresentable {
    let htmlContent: String
    @Binding var fontSize: CGFloat
    @Binding var webViewHeight: CGFloat

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false // Disable scrolling in the webview to manage dynamic height
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let htmlWithFontSize = """
        <html>
        <head>
        <style>
        body { font-size: \(fontSize)px; }
        </style>
        </head>
        <body>
        \(htmlContent)
        </body>
        </html>
        """
        webView.loadHTMLString(htmlWithFontSize, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: DynamicWebView

        init(_ parent: DynamicWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.scrollHeight") { (height, error) in
                if let height = height as? CGFloat {
                    DispatchQueue.main.async {
                        self.parent.webViewHeight = height
                    }
                }
            }
        }
    }
}

import SwiftUI
import WebKit

struct DContentView: View {
    @State private var fontSize: CGFloat = 50
    @State private var webViewHeight: CGFloat = .zero
    let htmlContent = """
    <p>Minister of State for Home Affairs... (repeated content) ...Minister of State for Home Affairs... (repeated content) ...Minister of State for Home Affairs... (repeated content) ...Minister of State for Home Affairs... (repeated content) ...Minister of State for Home Affairs... (repeated content)</p>
    """

    var body: some View {
        ScrollView {
            VStack {
                DynamicWebView(htmlContent: htmlContent, fontSize: $fontSize, webViewHeight: $webViewHeight)
                    .frame(height: webViewHeight)
            }
        }
    }
}
