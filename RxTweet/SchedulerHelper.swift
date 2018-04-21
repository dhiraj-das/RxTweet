//
//  SchedulerHelper.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/21/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import RxSwift

struct SchedulerHelper {
    static func backgroundWorkScheduler() -> ImmediateSchedulerType {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return OperationQueueScheduler(operationQueue: operationQueue)
    }
    
    static func mainScheduler() -> SerialDispatchQueueScheduler {
        return MainScheduler.instance
    }
}
