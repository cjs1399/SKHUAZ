//
//  SaveEssentialViewController.swift
//  SKHUAZ
//
//  Created by 천성우 on 2023/09/25.
//

import UIKit

import Alamofire
import SnapKit
import Then

final class SaveEssentialViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let viewContainer = UIView()
    private let topSection = UIView()
    private let topSectionLabel = UILabel()
    let tableView = UITableView(frame:.zero, style:.plain)

    // MARK: - Properties
    var saveData: [adminPreLecture] = []

//        var data: [adminPreLecture] = [
//            adminPreLecture(subjectName: "과목1", subjectSemester: "2023-1"),
//            adminPreLecture(subjectName: "과목2", subjectSemester: "2023-1"),
//            adminPreLecture(subjectName: "과목3", subjectSemester: "2023-2"),
//            adminPreLecture(subjectName: "과목4", subjectSemester: "2023-2")
//        ]

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        openSaveAlert()
        setNavigationBar()
    }
}

extension SaveEssentialViewController {
    
    // MARK: - UI Components Property
    
    private func setUI() {
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        titleLabel.do {
            $0.text = "저장한 과목 루트 확인"
            $0.font = .systemFont(ofSize: 20)
            $0.textColor = UIColor(hex: "#000000")
        }
        
        subTitleLabel.do {
            $0.text = "루트 설정이 완료되었습니다"
            $0.font = .systemFont(ofSize: 11)
            $0.textColor = UIColor(hex: "#000000")
        }
        
        viewContainer.do {
            $0.layer.cornerRadius = 6
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(hex: "#EFEFEF").cgColor
        }
        
        topSection.do {
            $0.backgroundColor = UIColor(hex: "#9AC1D1")
            $0.roundCorners(cornerRadius: 6, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        
        topSectionLabel.do {
            $0.text = "저장한 과목 루트"
            $0.textColor = UIColor(hex: "#FFFFFF")
            $0.font = .systemFont(ofSize: 13)
            $0.textAlignment = .center
        }
        
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(EssentialTableViewCell.self, forCellReuseIdentifier: "Cell")
            $0.separatorStyle = .none
            $0.allowsSelection = false
            $0.showsVerticalScrollIndicator = false
        }

    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        view.addSubviews(titleLabel, subTitleLabel, viewContainer)
        viewContainer.addSubviews(topSection, tableView)
        topSection.addSubviews(topSectionLabel)
        
        topSectionLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        topSection.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(37)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topSection.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        viewContainer.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(650)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
        }

    }
    
    // MARK: - Methods
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "#9AC1D1")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: "#9AC1D1")]
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func openSaveAlert() {
        let customAlertVC = AlertViewController(alertType: .save)
            customAlertVC.modalPresentationStyle = .overFullScreen
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first,
           let rootViewController = keyWindow.rootViewController {
            rootViewController.present(customAlertVC, animated: false, completion: nil)
            self.postUserPreLecture()
        }
    }
}


extension SaveEssentialViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EssentialTableViewCell
        
        let item = saveData[indexPath.row]
        
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let cellID = saveData[indexPath.row]
        
        print("Selected Cell ID:",cellID)
        
    }
}

extension SaveEssentialViewController {
    func postUserPreLecture() {
        UserPreLectureAPI.shared.postUserPreLecture(token: UserDefaults.standard.string(forKey: "AuthToken") ?? "") { result in
            switch result {
            case .success(let data):
                if let data = data as? UserPreLectureDTO {
                    let serverData = data.data
                    var saveData = [adminPreLecture]() // 새로운 데이터를 저장할 배열

                    for preLectureData in serverData {
                        let adminPreLectureData = adminPreLecture(subjectName: preLectureData.lecNames[0], subjectSemester: preLectureData.semester)
                        saveData.append(adminPreLectureData)
                    }
                    self.saveData = saveData
                    self.tableView.reloadData()


                }
            case .requestErr(let message):
                print("Request error: \(message)")
            case .pathErr:
                print("Path error")
            case .serverErr:
                print("Server error")
            case .networkFail:
                print("Network failure")
            default:
                break
            }
        }
    }
}
