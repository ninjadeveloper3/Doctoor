//
//  Order.swift
//  Doctoor
//
//  Created by DevBatch on 16/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderHistory: Mappable {

    var id = 0
    var orderNumber = ""
    var totalAmount = 0.0
    var orderStatus = 0
    var createdAt = ""
    var paymentMethod = 0
    var orderDetails = [OrderDetails]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id             <-  map["id"]
        orderNumber     <-  map["order_number"]
        totalAmount     <-  map["total_amount"]
        orderStatus     <-  map["status"]
        orderDetails    <-  map["order_details"]
        createdAt       <-  map["created_at"]
        paymentMethod  <-  map["payment_method_id"]
    }
}

class OrderDetails: Mappable {
    
//    "id": 1569479160,
//    "order_number": "1281573645094",
//    "product_type": "Medicines",
//    "product_id": 35,
//    "quantity": 1,
//    "status": 2,
//    "created_at": "2019-11-13 11:38:14",
    var medicineDetails = Mapper<MedicineDetails>().map(JSON: [:])!
    var testDetails = Mapper<TestDetails>().map(JSON: [:])!
    var equipmentDetails = Mapper<EquipmentDetails>().map(JSON: [:])!
    var otherMedicineDetails = Mapper<MedicineDetails>().map(JSON: [:])!

    var id = 0
    var orderNumber = ""
    var productType = ""
    var productId = 0
    var quantity = 0
    var status = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                      <-  map["id"]
        orderNumber             <-  map["order_number"]
        productId               <-  map["product_id"]
        productType             <-  map["product_type"]
        quantity                <-  map["quantity"]
        status                  <-  map["status"]
        medicineDetails         <-  map["medicines"]
        equipmentDetails        <-  map["equipments"]
        testDetails             <-  map["labs_test"]
        otherMedicineDetails    <-  map["other_medicines"]
    }
    
}

class MedicineDetails: Mappable {
    
    var id = 0
    var medicineName = ""
    var availableQuantity = 0
    var brand = ""
    var brandLogo = ""
    var categoryId = 0
    var composition = ""
    var howToTake = ""
    var inDemand = 0
    var isPrescriptionRequired = 0
    var medicineImage = ""
    var price = 0.0
    var primaryUse = ""
    var status = 0
    var unit = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-  map["id"]
        medicineName        <-  map["medicine_name"]
        availableQuantity   <-  map["available_quantity"]
        brand               <-  map["brand"]
        brandLogo           <-  map["brand_logo"]
        categoryId          <-  map["category_id"]
        composition         <-  map["composition"]
        howToTake           <-  map["how_to_take"]
        inDemand            <-  map["in_demand"]
        isPrescriptionRequired     <-  map["is_prescription_req"]
        medicineImage       <-  map["medicine_image"]
        price               <-  map["price"]
        primaryUse          <-  map["primary_use"]
        status              <-  map["status"]
        unit                <-  map["status"]
    }
    
}

class EquipmentDetails: Mappable {
    
    var id = 0
    var brand = ""
    var description = ""
    var equipmentName = ""
    var image = ""
    var quantity = 0
    var inDemand = 0
    var price = 0.0
    var status = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-  map["id"]
        brand               <-  map["brand"]
        description         <-  map["description"]
        equipmentName       <-  map["equipment_name"]
        image               <-  map["image"]
        quantity            <-  map["quantity"]
        inDemand            <-  map["in_demand"]
        price               <-  map["price"]
        status              <-  map["status"]
        
    }
    
}

class TestDetails: Mappable {
    
    var id = 0
    var testName = ""
    var createdAt = ""
    var description = ""
    var isPrescriptionReq = 0
    var labId = 0
    var logo = ""
    var inDemand = 0
    var price = 0.0
    var testCategoryId = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-  map["id"]
        testName            <-  map["test_name"]
        createdAt           <-  map["created_at"]
        description         <-  map["description"]
        isPrescriptionReq   <-  map["is_prescription_req"]
        labId               <-  map["lab_id"]
        logo                <-  map["logo"]
        inDemand            <-  map["in_demand"]
        price               <-  map["price"]
        testCategoryId      <-  map["testcategory_id"]
        
    }
    
}

class OrderPlaced: Mappable {
    
//    "billing_id" = 157;
//    "created_at" = "2019-11-19 13:30:28";
//    id = 399;
//    "order_number" = 851574170228;
//    "payment_method_id" = 1;
//    "shipping_id" = 180;
//    status = 1;
//    "total_amount" = "1936.0";
//    "user_id" = 85;
    
    var id = 0
    var orderNumber = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        orderNumber <-  map["order_number"]
    }
    
}

class EasyPaisaModel: Mappable {
    
    var orderId = 0
    var respCode = ""
    var respDesc = ""
    var storeId = 0
    var time = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        orderId         <-  map["orderId"]
        respCode        <-  map["responseCode"]
        respDesc        <-  map["responseDesc"]
        storeId         <-  map["storeId"]
        time            <-  map["transactionDateTime"]
    }
    
}

