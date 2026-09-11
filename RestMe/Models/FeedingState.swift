//
//  FeedingState.swift
//  RestMe
//
//  Created by Rahmandhika Putra Purwdi Wicaksono on 05/09/26.
//

enum FeedingState: Equatable {
    case appearing
    case waiting
    case hungry
    case celebrating
    case timedOut
    case cooldown
}

enum CreatureEmotion: Equatable {
    case waitingForFood
    case perfect
    case good
    case low
}
