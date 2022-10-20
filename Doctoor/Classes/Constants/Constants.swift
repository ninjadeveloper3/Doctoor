//
//  LCConstants.swift
//  Doctoor
//
//  Created byDevBatch on 6/19/17.
//  Copyright © 2017DevBatch. All rights reserved.
//

import Foundation
import UIKit

enum LeftMenu: Int {
    case profile = 0
    case home
    case earning
    case backDetails
    case rating
    case identification
    case privacyPolicy
    case termsAndConditions
    case insurance
    case support
    case logOut
}

enum LCMessageType: Int {
    case error = 0
    case success
    case info
}

enum ProductType : String {
    case Medicine = "Medicines"
    case Equipment = "Equipments"
    case Test = "LabsTest"
    case Miscellenaous = "OtherMedicines"
}

enum WebViewType : String {
    case termsCondition = "Terms"
    case aboutUs = "About"
}

enum LCJobStatus: String {
    case Completed = "Completed"
    case InProgress = "In-progress"
    case onTheWay = "On The Way"
    case arrived = "On Location"
    case Finished = "Finished"
    case Open
    case Closed
    case Canceled = "Canceled"
    case Accepted
}


let kDeviceToken = "kDeviceToken"
let kIsUserLoggedIn = "kIsUserLoggedIn"
let kLiveBaseUrl = ""
let kLocalBaseUrl = "http://192.168.0.12:85/api/"
let kStagingBaseUrl = "https://mediq.com.pk:44380/api/"
let kImageDownloadBaseUrl = "https://mediq.com.pk/"
let kPrescriptionImageDownloadBaseUrl = "https://mediq.com.pk:44380/"
let kBannerImageDownloadBaseUrl = "https://mediq.com.pk:44380/"
let kImageDownloadProfileBaseUrl = "https://mediq.com.pk:44380/"
let kToken  = "kToken"
let kUserIsSocial = "kUserIsSocial"
let kUserAvatar = "kUserAvatar"
let kUserSocialAvatar = "kUserSocialAvatar"
let kUserFullName = "kUserFullName"
let kUserLastName = "kUserLastName"
let kUserEmail = "kUserEmail"
let kUserId = "kUserId"
let kUserMobile = "kUserMobile"
let kUserProfileImageUrl = "kUserProfileImageUrl"
let kBillingId = "kBillingId"
let kShippingId = "kShippingId"




//Billing Address
let kBillingFirstName = "kBillingFirstName"
let kBillingLastName = "kBillingLastName"
let kBillingMobile = "kBillingMobile"
let kBillingCity = "kBillingCity"
let kBillingAddress = "kBillingAddress"
let kBillingProvice = "kBillingProvice"

//Shipping Address
let kShippingFirstName = "kShippingFirstName"
let kShippingLastName = "kShippingLastName"
let kShippingMobile = "kShippingMobile"
let kShippingCity = "kShippingCity"
let kShippingAddress = "kShippingAddress"
let kShippingProvice = "kShippingProvice"

enum BadgePosition: String {
    case topRight
    case topLeft
    case right
    case left
}

// NSNotification
enum NotificationType: String {
    case jobChat = "jobChat"
    case jobOffer = "jobOffer"
    case jobRemove = "userRemovedJob"
    case jobCancelled = "userCancelledJob"
    case jobTimeOut = "spJobTimeOut"
    case accountBlock = "accountBlock"
    case accountUnblock = "accountUnblock"
    case accountRejected = "accountRejected"
    case accountAccepted = "accountAccepted"
    case SomeDummyIdentifier = "SomeDummyIdentifier"
}

let kLCDidTapHomeNotification = "kLCDidTapHomeNotification"
let kLCAppDidEnterForeground = "kLCAppDidEnterForeground"
let KLCReloadJobsNotification = "KLCReloadJobsNotification"
let kLCJobRejectedNotification = "kLCJobRejectedNotification"
let kLCLabourCompletedWorkNotification = "kLCLabourCompletedWorkNotification"
let kLCLabourOnWayNotification = "kLCLabourOnWayNotification"
let kLCJobCanceledNotification = "kLCJobCanceledNotification"
let kLCJobAcceptedNotification = "kLCJobAcceptedNotification"
let kLCJobClosedNotification = "kLCJobClosedNotification"
let kLCHomeJobRejectedNotification = "kLCHomeJobRejectedNotification"
let kLCHomeJobAcceptedNotification = "kLCHomeJobAcceptedNotification"
let kLCLabourStartedWorkNotification = "kLCLabourStartedWorkNotification"
let kLCLabourReachedNotification = "kLCLabourReachedNotification"
let kLCResetFiltersNotification = "kLCResetFiltersNotification"
let kLCNewMessageWhileChatingNotificaton = "kLCNewMessageWhileChatingNotificaton"
let kLCRefreshscheduledJobsNotification = "kLCRefreshscheduledJobsNotification"
let kLCUpdateBadgeValueNotification = "kLCUpdateBadgeValueNotification"

let kNewMessagePush = "Your received a message on "

let kNNotificationIdentifier = "kNotificationIdentifier"
let kUploadImageNotification = "kUploadImageNotification"

// MARK: - Images

let kHamburgerImage = "icon_menu"
let kDoneNavigationBarImage = "icon_done"
let kFilterNavigationBarImage = "filter"
let kMarkerImage = "labour_icon"
let kPointerImage = "pointer"
let kAddCardImage = "add_card"
let kNonActiveCardImage = "non_active_card"
let kActiveCardImage =  "active_card"
let kCancelImage = "cancel"
let kSendButtonImage = "message_send_btn"
let kCalendarImage = "icon_date_time"
let kLocationImage = "icon_location"
let kLocationImage1 = "icon_location_2"
let kLocationImage2 = "icon_location_3"
let kLocationImage3 = "icon_location_4"

let kNoJobsImage = "no_scheduled_jobs"
let kDefaultCard = "default_card"
let kNoMessageImage = "no_msg"

let kCornerRadius : CGFloat = 2.0
var kOffSet = 20
let kLocation = "location"
let kSavedCookies = "savedCookies"

let kNotificationLoadDoneJobs = "kNotificationLoadDoneJobs"
let kNotificationChangeBarButton = "kNotificationChangeBarButton"
let kNotificationUpdateProfileImage = "kNotificationUpdateProfileImage"
let kNotificationOpenPaymentiewController = "kNotificationOpenPaymentiewController"

let kIsChatThreadCreated = "kIsChatThreadCreated"
let kErrorSessionExpired = "User is not authenticated."

let kContactUsEmail = "info@labourchoice.com.au"
let kContactUsCCEmail = "info@labourchoice.au"

let kTimedOutDescription = "Your labour is unable to accept a job request within given time. Kindly book a labour again."
let kTimedOutTitle = "The job request timed out."
let kNoPaymentDescription = "We need your credit card information in order to have payments processed for every job."
let kNoPaymentTitel = "No credit card added"
let kJazzCashLimit = 50000.0
let kAdditionalDelieveryCharges = 200.0

