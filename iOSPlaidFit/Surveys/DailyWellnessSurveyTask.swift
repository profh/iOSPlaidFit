//
//  DailyWellnessSurveyTask.swift
//  PlaidFitSurveys
//
//  Created by Evan Byrd on 11/7/18.
//  Copyright © 2018 Evan Byrd. All rights reserved.
//

import Foundation
import ResearchKit

public var DailyWellnessSurveyTask: ORKOrderedTask {
    let surveyTitle = "Daily Wellness Survey"
    
    //question 1
    let step1AnswerFormat = ORKContinuousScaleAnswerFormat.init(maximumValue: 12, minimumValue: 0, defaultValue: 0, maximumFractionDigits: 0)
    let questionStep1 = ORKQuestionStep(identifier: "hours_of_sleep", title: surveyTitle, question: "How many hours of sleep did you get last night?", answer: step1AnswerFormat)
    
    //question 2
    let step2AnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false, maximumValueDescription: "Very Good", minimumValueDescription: "Very Bad")
    let questionStep2 = ORKQuestionStep(identifier: "quality_of_sleep", title: surveyTitle, question: "Please rate the quality of sleep you received last night", answer: step2AnswerFormat)
    
    //question 3
    let step3AnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false, maximumValueDescription: "Very Stressed", minimumValueDescription: "Not Stressed At All")
    let questionStep3 = ORKQuestionStep(identifier: "academic_stress", title: surveyTitle, question: "Please rate the level of academic stress you are experiencing today", answer: step3AnswerFormat)
    
    //question 4
    let step4AnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false, maximumValueDescription: "Very Stressed", minimumValueDescription: "Not Stressed At All")
    let questionStep4 = ORKQuestionStep(identifier: "life_stress", title: surveyTitle, question: "Please rate the level of general life stress you are experiencing today", answer: step4AnswerFormat)
    
    //question 5
    let step5AnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false, maximumValueDescription: "Very Sore", minimumValueDescription: "Not Sore At All")
    let questionStep5 = ORKQuestionStep(identifier: "soreness", title: surveyTitle, question: "Please rate the level of soreness you are experiencing today", answer: step5AnswerFormat)
    
    //question 6
    let step6AnswerFormat = ORKContinuousScaleAnswerFormat.init(maximumValue: 128, minimumValue: 0, defaultValue: 0, maximumFractionDigits: 0)
    let questionStep6 = ORKQuestionStep(identifier: "ounces of water consumed", title: surveyTitle, question: "Approximately how many ounces of water did you consume yesterday?", answer: step6AnswerFormat)
    
    //question 7
    let step7AnswerFormat = ORKBooleanAnswerFormat()
    let questionStep7 = ORKQuestionStep.init(identifier: "hydration_quality", title: surveyTitle, question: "Do you feel hydrated today?", answer: step7AnswerFormat)
    
    //completion step
    let completionStep = ORKCompletionStep(identifier: "Completion Step")
    completionStep.title = "You have completed your Daily Wellness Survey"
    
    // mark all questions as mandatory
    questionStep1.isOptional = false
    questionStep2.isOptional = false
    questionStep3.isOptional = false
    questionStep4.isOptional = false
    questionStep5.isOptional = false
    questionStep6.isOptional = false
    questionStep7.isOptional = false
    
    return ORKOrderedTask(identifier: "Daily Wellness Survey", steps: [
        questionStep1,
        questionStep2,
        questionStep3,
        questionStep4,
        questionStep5,
        questionStep6,
        questionStep7,
        completionStep
        ])
}
