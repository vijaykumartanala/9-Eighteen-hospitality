



import UIKit

class NineEighteenApis: NSObject {
    
 static let baseUrl = "https://qa.9-eighteen.com/api/v1/"
//static let baseUrl = "http://aa0c32962610.ngrok.io/"
 static let existApi = "\(baseUrl)" + "doesExist"
 static let loginApi = "\(baseUrl)" + "appuserlogin"
 static let otpApi = "\(baseUrl)" + "verifySMS"
 static let validateApi = "\(baseUrl)" + "validateappotp"
 static let forgotApi = "\(baseUrl)" + "forgotapppassword"
 static let homeApi = "\(baseUrl)" + "fetchHomeInfo"
 static let menuApi = "\(baseUrl)" + "getmenusections"
 static let catApi = "\(baseUrl)" + "getcategories"
 static let getAllItemsApi = "\(baseUrl)" + "getallitems"
 static let logoutApi = "\(baseUrl)" + "logout"
 static var itemcount = 1
 static var isShow = false
 static var isBackground = false
 static var isCourseSelected = false
 static var exits = false
 static var message = "   type message here..."
 static let memberApi = "\(baseUrl)" + "upgradetomember"
 static let password = "\(baseUrl)" + "resetPassword"
 static let submitOrder = "\(baseUrl)" + "submitOrder"
 static let token = "\(baseUrl)" + "generatebstoken"
 static let doPayment = "\(baseUrl)" + "doPayment"
 static let getProfile = "\(baseUrl)" + "getappuserinfo"
 static let updateProfile = "\(baseUrl)" + "updateappuserprofile"
 static let passwordApi = "\(baseUrl)" + "resetpassword"
 static let oneSignalApi = "\(baseUrl)" + "addOneSignalId"
 static let locationUpdateApi = "\(baseUrl)" + "locationUpdate"
 static let fetchOrders = "\(baseUrl)" + "fetchOrders"
 static let getMessages = "\(baseUrl)" + "getMessages"
 static let getNotifications = "\(baseUrl)" + "getNotifications"
 static let changeOrderStatus = "\(baseUrl)" + "changeOrderStatus"
 static let changePaymentStatus = "\(baseUrl)" + "changePaymentStatus"
 static var tip1 = 0.00
 static var tip2 = 0.00
 static var tip3 = 0.00
 static var tip4 = 0.00
 static var currencyCode = ""
 static var firstName = ""
 static var lastName = ""
 
}

