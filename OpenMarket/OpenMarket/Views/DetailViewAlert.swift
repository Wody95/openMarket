import UIKit

class Alerts {
    static let shared = Alerts()

    private let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

    func editAndDeleteAlert(present viewController: UIViewController,
                            editHandler: @escaping (() -> Void),
                            deleteHandler: @escaping (() -> Void)) {
        let alert = UIAlertController(title: "수정 및 삭제",
                                      message: nil,
                                      preferredStyle: .alert)

        let editAction = UIAlertAction(title: "수정", style: .default) { action in
            editHandler()
        }

        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { action in
            deleteHandler()
        }

        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    func editPasswordAlert(present viewController: UIViewController,
                           passwordHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "상품 비밀번호 입력",
                                      message: nil,
                                      preferredStyle: .alert)

        let doneAction = UIAlertAction(title: "수정", style: .default) { action in
            guard let textField = alert.textFields,
                  let password = textField[0].text else { return }
            passwordHandler(password)
        }

        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        alert.addTextField {
            $0.placeholder = "비밀번호를 입력해주세요"
        }

        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    func deletePasswordAlert(present viewController: UIViewController,
                             passwordHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "비밀번호를 입력해주세요",
                                      message: nil,
                                      preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { action in
            guard let textField = alert.textFields,
                  let password = textField[0].text else { return }
            passwordHandler(password)
        }

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        alert.addTextField {
            $0.placeholder = "비밀번호를 입력해주세요"
        }

        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    func completePatchAlert(present viewController: UIViewController,
                            completeHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "수정 성공",
                                      message: nil,
                                      preferredStyle: .alert)

        let editCompleAlert = UIAlertAction(title: "확인", style: .default) { action in
            completeHandler()
        }

        alert.addAction(editCompleAlert)

        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    func completeDeleteAlert(present viewController: UIViewController,
                            completeHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "삭제 성공",
                                      message: nil,
                                      preferredStyle: .alert)

        let deleteCompleAlert = UIAlertAction(title: "확인", style: .default) { action in
            completeHandler()
        }

        alert.addAction(deleteCompleAlert)

        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    func failPassword(present viewController: UIViewController) {
        let alert = UIAlertController(title: "비밀번호가 틀렸습니다", message: "다시 한번 확인해주세요", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)

        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

}

