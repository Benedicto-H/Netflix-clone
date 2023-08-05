//
//  SceneDelegate.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit

// MARK: - (Class) SceneDelegate: UI의 Life Cycle을 관리하는 Class
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - UI Structure
    /// UIScreen (Hardware-based Display) -> UIWindowScene -> UIWindow -> UIView
    ///
    /// ** ! Notice **
    /// (Sub-Class) UIWindow: (Super-Class) UIView
    /// (Sub-Class) UIWindowScene: (Super-Class) UIScene

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene: UIWindowScene = (scene as? UIWindowScene) else { return }    //  UIWindowScene 타입으로 Downcasting
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)    //  UIWindow의 크기와 위치를 scene과 일치
        window?.windowScene = windowScene   //  UIWindow와 UIWindowScene을 연결
        window?.rootViewController = MainTabBarViewController()   //  ViewContoller를 App이 실행될 때 표시되는 최상위 VC로 설정
        window?.makeKeyAndVisible() //  keyWindow로 설정
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

