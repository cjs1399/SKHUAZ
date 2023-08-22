//
//  RecommendDetailDataModel.swift
//  SKHUAZ
//
//  Created by 박신영 on 2023/08/20.
//

import Foundation


struct RecommendDetailDataModel {
    var nickNameLabel: String
    var courseYearLabel: String
    var titleLabel: String
    var majorNameLabel: String
    var creationDateLabel: String
    var routeLabel: String
    var ContentLabel: String
}

let rdReview1 = RecommendDetailDataModel(nickNameLabel: "박신영", courseYearLabel: "2023-1", titleLabel: "드디어 공개한다 소프1", majorNameLabel: "소프트웨어공학과", creationDateLabel: "2023-08-19", routeLabel: "자바>웹입>등등", ContentLabel: "이렇게만 듣자!")

let rdReview2 = RecommendDetailDataModel(nickNameLabel: "천성우", courseYearLabel: "2023-1", titleLabel: "드디어 공개한다 소프2", majorNameLabel: "소프트웨어공학과", creationDateLabel: "2023-08-20", routeLabel: "자바>웹입>등등", ContentLabel: "요렇게만 듣자!")

let rdReview3 = RecommendDetailDataModel(nickNameLabel: "문인호", courseYearLabel: "2023-1", titleLabel: "드디어 공개한다 정통1", majorNameLabel: "정보통신공학과", creationDateLabel: "2023-08-19", routeLabel: "컴구, 데통>컴네>등등", ContentLabel: "고렇게만 듣자!")

let rdReivews: [RecommendDetailDataModel] = [rdReview1, rdReview2, rdReview3]
