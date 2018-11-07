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
    questionStep1.text = "Amount of Sleep"
    
    //question 2
    let step2AnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: true, maximumValueDescription: "Very Good", minimumValueDescription: "Very Bad")
    let questionStep2 = ORKQuestionStep(identifier: "quality_of_sleep", title: surveyTitle, question: "Please rate the quality of sleep you received last night", answer: step2AnswerFormat)
    questionStep2.text = "Quality of Sleep"
    
    //question 3
    let step3AnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: true, maximumValueDescription: "Very Stressed", minimumValueDescription: "Not Stressed At All")
    let questionStep3 = ORKQuestionStep(identifier: "academic_stress", title: surveyTitle, question: "Please rate the level of academic stress you are experiencing today", answer: step3AnswerFormat)
    questionStep3.text = "Academic Stress"
    
    //question 4
    let step4AnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: true, maximumValueDescription: "Very Stressed", minimumValueDescription: "Not Stressed At All")
    let questionStep4 = ORKQuestionStep(identifier: "life_stress", title: surveyTitle, question: "Please rate the level of general life stress you are experiencing today", answer: step4AnswerFormat)
    questionStep4.text = "General Stress"
    
    //question 5
    let step5AnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: true, maximumValueDescription: "Very Sore", minimumValueDescription: "Not Sore At All")
    let questionStep5 = ORKQuestionStep(identifier: "soreness", title: surveyTitle, question: "Please rate the level of soreness you are experiencing today", answer: step5AnswerFormat)
    questionStep5.text = "Soreness"
    
    //question 6
    let step6AnswerFormat = ORKContinuousScaleAnswerFormat.init(maximumValue: 12, minimumValue: 0, defaultValue: 0, maximumFractionDigits: 0)
    let questionStep6 = ORKQuestionStep(identifier: "ounces of water consumed", title: surveyTitle, question: "Approximately how many cups of water did you consume yesterday?", answer: step6AnswerFormat)
    questionStep6.text = "Amount of Water"
    
    //question 7
    let step7AnswerFormat = ORKBooleanAnswerFormat()
    let questionStep7 = ORKQuestionStep.init(identifier: "hydration_quality", title: surveyTitle, question: "Do you feel hydrated today?", answer: step7AnswerFormat)
    questionStep7.text = "General Hydration"
    
    //completion step
    let completionStep = ORKCompletionStep(identifier: "Completion Step")
    completionStep.title = "You have completed your Daily Wellness Survey"
    
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
