//
//  DailyWellnessSurveyTask.swift
//  PlaidFitSurveys
//
//  Created by Evan Byrd on 11/7/18.
//  Copyright © 2018 Evan Byrd. All rights reserved.
//

import Foundation
import ResearchKit

public var PostPracticeSurveyTask: ORKOrderedTask {
    let surveyTitle = "Post-Practice Survey"
    
    //question 1
    let step1AnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 10, minimumValue: 0, defaultValue: 5, step: 1, vertical: true, maximumValueDescription: "Very Hard", minimumValueDescription: "Very Easy")
    let questionStep1 = ORKQuestionStep(identifier: "player_rpe_rating", title: surveyTitle, question: "Rate today's difficulty of practice", answer: step1AnswerFormat)
    
    //question 2
    let step2AnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 10, minimumValue: 0, defaultValue: 5, step: 1, vertical: true, maximumValueDescription: "Very Good", minimumValueDescription: "Very Bad")
    let questionStep2 = ORKQuestionStep(identifier: "player_personal_performance", title: surveyTitle, question: "Rate your personal performance today", answer: step2AnswerFormat)
    
    //question 3
    let step3AnswerFormat = ORKBooleanAnswerFormat()
    let questionStep3 = ORKQuestionStep.init(identifier: "participated_in_full_practice", title: surveyTitle, question: "Did you participate in the entire practice today?", answer: step3AnswerFormat)
    
    //question 4
    let step4AnswerFormatUnit = NSLocalizedString("Minutes", comment: "")
    let step4AnswerFormat = ORKAnswerFormat.decimalAnswerFormat(withUnit: step4AnswerFormatUnit)
    
    let questionStep4 = ORKQuestionStep(identifier: "minutes_participated", title: NSLocalizedString("Numeric", comment: ""), question: "How many minutes of practice did you participate in?", answer: step4AnswerFormat)
    
    //completion step
    let completionStep = ORKCompletionStep(identifier: "Completion Step")
    completionStep.title = "You have completed your Post-Practice Survey"
    
    return ORKOrderedTask(identifier: "Post-Practice Survey", steps: [
        questionStep1,
        questionStep2,
        questionStep3,
        questionStep4,
        completionStep
        ])
}
