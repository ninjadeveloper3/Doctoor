//
//  APIClient.swift
//  Doctoor
//
//  Created byDevBatch on 19/06/2017.
//  Copyright © 2017DevBatch. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

let APIClientDefaultTimeOut = 60.0

let APIClientBaseURL = kStagingBaseUrl

class APIClient: APIClientHandler {
    
    fileprivate var clientDateFormatter: DateFormatter
    var manager: NetworkReachabilityManager?
    
    static let sharedClient: APIClient = {
        let baseURL = URL(string: APIClientBaseURL)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIClientDefaultTimeOut
        
        let instance = APIClient(baseURL: baseURL!, configuration: configuration)
        
        return instance
    }()
    
    // MARK: - init methods
    
    override init(baseURL: URL, configuration: URLSessionConfiguration, delegate: SessionDelegate = SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {
        clientDateFormatter = DateFormatter()
        
        super.init(baseURL: baseURL, configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)
        
        //        clientDateFormatter.timeZone = NSTimeZone(name: "UTC")
        clientDateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    // MARK: Helper methods
    
    func apiClientDateFormatter() -> DateFormatter {
        return clientDateFormatter.copy() as! DateFormatter
    }
    
    fileprivate func normalizeString(_ value: AnyObject?) -> String {
        return value == nil ? "" : value as! String
    }
    
    fileprivate func normalizeDate(_ date: Date?) -> String {
        return date == nil ? "" : clientDateFormatter.string(from: date!)
    }
    
    @discardableResult
    func logInUser(phone: String, password: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "signin"
        let parameters = [
            
            "phone"     :   phone,
            "password"  :   password
            
            ] as [String:AnyObject]
        
        return sendRequest(serviceName, parameters: parameters
            , isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func signUpUser(fullName: String, email: String, phone: String, password: String, gender: String ,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "signup"
        
        let parameters = [
            
            "full_name" :   fullName,
            "email"     :   email,
            "phone"     :   phone,
            "password"  :   password,
            "gender"    :   gender
            
            ] as [String:AnyObject]
        
        return sendRequest(serviceName, parameters: parameters
            , isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getBanner(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "banner_images"
        
        return sendRequest(serviceName, parameters: nil
            , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getInDemandProduct(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "in_demand_products"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func checkApiVersion(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "about"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    @discardableResult
    func getLabReports(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_user_test_reports?page=\(-1)&limit=\(10000)"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getPrescriptionList(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "my_prescriptions"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getCities(province: String,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        var serviceName = ""
        if (province.isEmpty){
            serviceName = "get_cities"
        }
        else{
            serviceName = "get_cities?province=\(province)"
        }
        
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func signOut(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "logout"

        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func forgotPassword(phone: String,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "forgot_password"
        
        let parameters = [
            
            "phone"     :   phone,
            
            ] as [String:AnyObject]
        
        return sendRequest(serviceName, parameters: parameters
            , isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doSetNewPass(userId: Int, code: String, password: String,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "reset_password"
        
        let parameters = [
            
            "user_id"     :   userId,
            "reset_code"     :   code,
            "new_password"     :   password,
            
            ] as [String:AnyObject]
        
        return sendRequest(serviceName, parameters: parameters
            , isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getNotifications(pageNo: Int,limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_notifications?page=\(pageNo)&limit=\(limit)"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    
    @discardableResult
    func getUserProfile(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_profile"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func applyCuoponCode(cuoponCode: String,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "check_promotion?coupon_code=\(cuoponCode)"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func resendActivationCode(userId: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "resend_code"
        
        let parameters = [
            
            "user_id"     :   userId,
            
            ] as [String:AnyObject]
        
        return sendRequest(serviceName, parameters: parameters
            , isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getOrderHistroy(page: Int, limit: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "order_history_med?page=\(page)&limit=\(limit)"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getServiceHistroy(page: Int, limit: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "serviceOrderHistory?page=\(page)&limit=\(limit)"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    @discardableResult
    func getRentalServices(page: Int, limit: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "rental_history?page=\(page)&limit=\(limit)"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func rentalServiceOrder(cityId: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "get_all_rental?city_id=\(cityId)"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getLabCategories(labId: Int,pageNo: Int, limit: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "test_category_list?lab_id=\(labId)&page=\(-1)&limit=\(10000)"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getLabList(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "labs_list"
        
        return sendRequest(serviceName, parameters: nil
            , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func updateUserProfile(name : String, email : String, avatar: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "edit_profile"
        
        let parameters = [
            
            "full_name"     :   name,
            "email"         :   email
            
            ] as [String:AnyObject]
        
        return sendRequest(serviceName, parameters: parameters
            , isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func submitOrderService(cityId: Int,serviceId : Int, comments : String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "order_service"
        
        let parameters = [
            
            "service_id"    :   serviceId,
            "comment"       :   comments,
            "city_id"       :   cityId
            
            ] as [String:AnyObject]
        
        return sendRequest(serviceName, parameters: parameters
            , isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func submitRentalOrderService(cityId: Int,equipmentId : Int, comments : String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "order_rent"
        
        let parameters = [
            
            "equipment_id"    :   equipmentId,
            "comment"       :   comments,
            "city_id"       :   cityId
            
            ] as [String:AnyObject]
        
        return sendRequest(serviceName, parameters: parameters
            , isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    //Medical Equipment
    @discardableResult
    func getMedicalEquipments(pageNo: Int, limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "medical_equipment?page=\(pageNo)&limit=\(limit)"
        
        return sendRequest(serviceName, parameters: nil
            , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    //test_list
    
    @discardableResult
    func getTestList(page: Int, limit: Int, labId: Int, categroyId : Int,  _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "test_list?page=\(page)&limit=\(limit)&lab_id=\(labId)&category_id=\(categroyId)"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    //get_medicine_categories
    
    @discardableResult
    func getMedicineCategory (page: Int, limit: Int,  _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "get_medicine_categories?limit=\(limit)&page=\(page)"
        
        return sendRequest(serviceName, parameters: nil , isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    //Search Test
    @discardableResult
    func getMedicineList (categoryId: Int, page: Int, limit: Int,  _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "medicines_list?category_id=\(categoryId)&limit=\(limit)&page=\(page)"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func searchEquipmentList (searchItem: String,cityId: Int, page: Int, limit: Int,  _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "search_medical_equipment?equipment_name=\(searchItem)&city_id=\(cityId)&limit=\(limit)&page=\(page)"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    
    @discardableResult
    func searchFromPharmacy (searchItem: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "search_medicine?medicine_name=\(searchItem)"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func searchMedicineById (searchItem: String, categoryId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "search_medicine?medicine_name=\(searchItem)&cat_id=\(categoryId)"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func searchTests (searchItem: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "search_test?test_name=\(searchItem)"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func placeNewOrder(totalAmount: String, paymentMethod: String, deliveryType: String, billingModel: UserAddress, shippingModel: UserAddress , _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "new_order"
        
        let cartOrders = Utility.getCartItems()
        let cartOrdersArray = cartOrders.map({[
            "product_id": $0.productId,
            "product_type": $0.productType,
            "quantity": $0.quantity
            ]})
        
        let parameters = [
            
            "total_amount": totalAmount,
            "delivery_type_id": deliveryType,
            "payment_method_id": paymentMethod,
            "order": cartOrdersArray,
            "shipping": [
                "first_name": shippingModel.firstName,
                "last_name": shippingModel.lastName,
                "phone": shippingModel.mobileNumber,
                "email": shippingModel.email,
                "home_address": shippingModel.address,
                "province": shippingModel.province,
                "city": shippingModel.city
            ],
            "billing": [
                "first_name": billingModel.firstName,
                "last_name": billingModel.lastName,
                "phone": billingModel.mobileNumber,
                "email": billingModel.email,
                "home_address": billingModel.address,
                "province": billingModel.province,
                "city": billingModel.city,
            ]
            
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters, isPostRequest: true, headers: nil, completionBlock: completionBlock)
        
    }
    
    @discardableResult
    func cashOnDelivery(totalAmount: String, paymentMethod: String, deliveryType: String, billingModel: UserAddress, shippingModel: UserAddress , _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "new_order"
        
        let cartOrders = Utility.getCartItems()
        let cartOrdersArray = cartOrders.map({[
            "product_id": $0.productId,
            "product_type": $0.productType,
            "quantity": $0.quantity
            ]})
        
        let parameters = [
            
            "total_amount": totalAmount,
            "delivery_type_id": deliveryType,
            "payment_method_id": paymentMethod,
            "order": cartOrdersArray,
            "shipping": [
                "first_name": shippingModel.firstName,
                "last_name": shippingModel.lastName,
                "phone": shippingModel.mobileNumber,
                "email": shippingModel.email,
                "home_address": shippingModel.address,
                "province": shippingModel.province,
                "city": shippingModel.city
            ],
            "billing": [
                "first_name": billingModel.firstName,
                "last_name": billingModel.lastName,
                "phone": billingModel.mobileNumber,
                "email": billingModel.email,
                "home_address": billingModel.address,
                "province": billingModel.province,
                "city": billingModel.city,
            ]
            
            
            ] as [String : AnyObject]
        print(parameters)
        
        return sendRequest(serviceName, parameters: parameters, isPostRequest: true, headers: nil, completionBlock: completionBlock)

    }
    
    @discardableResult
    func setDeviceId(deviceID: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "set_player_id"
        
        let parameters = [
            
            "player_id": deviceID
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters, isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func addBillingInfo(firstName: String, lastName: String, phone: String, address: String, province: String, city: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "add_billing_details"
        
        let parameters = [
            "first_name" : firstName,
            "last_name" : lastName,
            "phone" : phone,
            "home_address" : address,
            "province" : province,
            "city" : city
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters, isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func addShippingInfo(firstName: String, lastName: String, phone: String, address: String, province: String, email: String, city: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "add_or_update_shipping_details"
        
        let parameters = [
            "first_name" : firstName,
            "last_name" : lastName,
            "phone" : phone,
            "email" : email,
            "home_address" : address,
            "province" : province,
            "city" : city
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters, isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getShippingDetails(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_shipping_details"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getBillingDetails(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_billing_details"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func paymentAuth(method: String, orderId: String, totalAmount: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "paymentauth?method=\(method)&total_amount=\(totalAmount)&order_id=\(orderId)"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func easyPaisaPaymentAuth(orderId: String, totalAmount: String,mobile: String,email: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "easyPaisaPayment"
        let parameters = [
            
            "orderId": orderId,
            "storeId" : "9752",
            "transactionAmount" : totalAmount,
            "transactionType" : "MA",
            "mobileAccountNo" : "\(mobile)",
            "emailAddress" : email
        ]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func serviceOrder(cityId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "home_medical_services_list?city_id=\(cityId)"
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doSignup(email: String, firstName: String, phoneNumber: String, gender: String, dob: String, password: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "signup"
        let parameters = [
            
            "email": email,
            "full_name": firstName,
            "phone" : phoneNumber,
            "gender": gender,
            "dob" : dob,
            "password" : password
        ]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    //SocialSignUp- Facebook
    @discardableResult
    func socialSignIn(email: String, full_name: String, social_access_token: String, social_id: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "social_signup"
        let parameters = [
            
            "email": email,
            "full_name" : full_name,
            "social_access_token" : social_access_token,
            "social_id" : social_id
        ]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func fbSignInWithCompleteInfo(userId: Int,phone: String,gender: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "socialPhoneVerification"
        let parameters = [
            
            "phone": phone,
            "id"   : userId,
            "gender" : gender
            
            ] as [String : Any]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    //Verify Account
    @discardableResult
    func accountVerify(userId: Int, code: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "user_activate"
        let parameters = [
            
            "user_id": userId,
            "code": code
            
            ] as [String : Any]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func confirmOrder(orderNumber: String, status: Int,paymentMethodId: Int, isService: Bool, isRental: Bool,  _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "confirmOrder"
        let parameters = [
        
            "order_number": orderNumber,
            "status" : status,
            "payment_method_id" : paymentMethodId,
            "rental" : isRental,
            "service" : isService
            
        ]  as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters, isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func confirmPromotion(code: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "confirm_promotion"
        let parameters = [
            
            "coupon_code": code
            
            ]  as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getPopularTest(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "in_demand_test_cat"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    @discardableResult
    func getPopularServices(page: Int, limit: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "home_medical_services_list?limit=\(limit)&page=\(page)"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    @discardableResult
    func getPopularEquip(page: Int, limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "in_demand_equipment?limit=\(limit)&page=\(page)"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getOtherMedicines( page: Int, limit: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "other_medicines?limit=\(limit)&page=\(page)"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getSearchOtherMedicine(medicineName: String,  _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "search_other_medicines?medicine_name=\(medicineName)"
        
        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }
    
    func uploadImage1(image: UIImage, _ completionBlock: @escaping (_ success: Bool,_ json: [String:Any]?) -> Void ) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "image.jpeg" , mimeType: "image/*")
        }, to: URL(string: "\(kStagingBaseUrl)upload_profile_picture")!) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                upload.responseJSON { response in
                    if let json = response.result.value as? [String:Any] {
                        print(json)
                        completionBlock(true, json)
                    }
                }
            case .failure(let encodingError):
                completionBlock(false, nil)
            }
        }
    }
    
    func uploadImage(image: UIImage, _ completionBlock: @escaping (_ success: Bool, _ response: AnyObject?) -> Void ) {
        
        guard let url = URL(string: "\(kStagingBaseUrl)upload_profile_picture") else {
            return
        }
        
        var token = ""
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            token = UserDefaults.standard.object(forKey: kToken) as! String
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "image.jpeg" , mimeType: "image/*")
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("proses", progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error {
                        print("upload:", err)
                        completionBlock(true, response.result.value! as AnyObject)
                        
                    }
                    
                    if let s = response.result.value {
                        print("RESULT:", s)
                        completionBlock(true, response.result.value as AnyObject?)
                        
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionBlock(false, error as AnyObject)
            }
        }
    }
    
    func uploadPerscription(fullName: String, phoneNumber: String, email: String, image: UIImage, prescriptionFor: String, _ completionBlock: @escaping (_ success: Bool) -> Void){
        guard let url = URL(string: "\(kStagingBaseUrl)upload_prescription") else {
            return
        }
        
        let parameters = [
            "prescription_for" : prescriptionFor,
            "name": fullName,
            "phone": phoneNumber,
            "email": email
            
            ] as [String:Any]
        
        var token = ""
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            token = UserDefaults.standard.object(forKey: kToken) as! String
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "image.jpeg" , mimeType: "image/*")
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("proses", progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error {
                        print("upload:", err)
                        completionBlock(true)
                        
                    }
                    
                    if let s = response.result.value  {
                        print("RESULT:", s)
                        completionBlock(true)
                        
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionBlock(false)
            }
        }
    }
}
